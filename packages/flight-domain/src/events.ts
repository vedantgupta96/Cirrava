/**
 * Flight Event generation (§14).
 *
 * A Flight Event is "an immutable record of a meaningful normalized change
 * derived from one or more Flight Snapshots" (CONTEXT.md). This module owns
 * the calculate-meaningful-changes and create-immutable-events stages of
 * the §14 pipeline. It is pure: no clock, no I/O, no provider knowledge.
 * The same snapshot pair always yields the same events in the same order,
 * which is what makes reprocessing safe.
 *
 * Two decisions here depart from the §14 event-type list, both on the
 * authority of later ADRs:
 *
 * - ADR-0004 supersedes the planning baseline that listed ALTITUDE_UPDATED
 *   and ROUTE_UPDATED as event types. Position, altitude, speed and route
 *   points are Flight Telemetry, not Flight Events, so movement alone
 *   generates nothing here.
 * - ADR-0005 keeps notification policy out of the event layer. CONTEXT.md's
 *   Material Delay rule about re-notifying "after notification" belongs to
 *   the Notification Decision, not to history. This module only decides
 *   whether a change is meaningful enough to record.
 *
 * There is deliberately no DELAYED event type: a delay is recorded as
 * DEPARTURE_DELAY_CHANGED or ARRIVAL_DELAY_CHANGED carrying the delay in
 * minutes. CANCELLED, DIVERTED and RETURNED_TO_GATE are events because they
 * are discrete disruptions with no magnitude.
 */
import { createHash } from "node:crypto";
import { hashSnapshotPayload, stableStringify } from "./snapshot.ts";
import type { FlightSnapshot } from "./snapshot.ts";
import type { FlightPhase } from "./types.ts";

/** The meaningful event types Cirrava derives from snapshot comparison. */
export type FlightEventType =
  | "FLIGHT_CREATED"
  | "SCHEDULE_CHANGED"
  | "DEPARTURE_DELAY_CHANGED"
  | "ARRIVAL_DELAY_CHANGED"
  | "ESTIMATED_ARRIVAL_CHANGED"
  | "TERMINAL_CHANGED"
  | "GATE_ASSIGNED"
  | "GATE_CHANGED"
  | "ARRIVAL_GATE_CHANGED"
  | "BAGGAGE_BELT_ASSIGNED"
  | "AIRCRAFT_CHANGED"
  | "TAIL_NUMBER_ASSIGNED"
  | "BOARDING_STARTED"
  | "GATE_CLOSED"
  | "DEPARTED"
  | "LANDED"
  | "ARRIVED_AT_GATE"
  | "CANCELLED"
  | "DIVERTED"
  | "RETURNED_TO_GATE";

/**
 * An immutable record of one meaningful change. `dedupeKey` is the §14 key
 * `{flightInstanceId}:{eventType}:{normalizedValueHash}:{effectiveTimestamp}`.
 */
export interface FlightEvent {
  readonly flightInstanceId: string;
  readonly type: FlightEventType;
  readonly effectiveAtUtc: string;
  readonly previousValue: string | null;
  readonly currentValue: string | null;
  readonly normalizedValueHash: string;
  readonly dedupeKey: string;
}

/** Tuning for meaningful-change detection. */
export interface GenerateFlightEventsOptions {
  /**
   * Minutes a delay or arrival estimate must move, or the threshold it must
   * cross, before the change is recorded. Defaults to 15 — CONTEXT.md's
   * Material Delay.
   */
  readonly delayThresholdMinutes?: number;
}

const DEFAULT_DELAY_THRESHOLD_MINUTES = 15;

/**
 * Phase transitions that are meaningful in their own right. Only forward
 * progress through the operation generates an event; a phase moving
 * backwards (for example DEPARTED back to SCHEDULED after a return to gate)
 * is recorded by the corresponding Disruption Condition instead, so the
 * history does not claim the flight was re-scheduled.
 */
const PHASE_EVENTS: Partial<Record<FlightPhase, FlightEventType>> = {
  BOARDING: "BOARDING_STARTED",
  GATE_CLOSED: "GATE_CLOSED",
  DEPARTED: "DEPARTED",
  LANDED: "LANDED",
  ARRIVED_AT_GATE: "ARRIVED_AT_GATE",
};

const PHASE_ORDER: readonly FlightPhase[] = [
  "SCHEDULED",
  "CHECK_IN_OPEN",
  "BOARDING",
  "GATE_CLOSED",
  "DEPARTED",
  "EN_ROUTE",
  "LANDED",
  "ARRIVED_AT_GATE",
];

function phaseRank(phase: FlightPhase): number {
  return PHASE_ORDER.indexOf(phase);
}

/** Builds one event, deriving the value hash and §14 dedup key. */
function buildEvent(
  snapshot: FlightSnapshot,
  type: FlightEventType,
  previousValue: string | null,
  currentValue: string | null,
): FlightEvent {
  const normalizedValueHash = createHash("sha256")
    .update(stableStringify({ type, previousValue, currentValue }))
    .digest("hex");
  const effectiveAtUtc = snapshot.observedAtUtc;
  return {
    flightInstanceId: snapshot.flightInstanceId,
    type,
    effectiveAtUtc,
    previousValue,
    currentValue,
    normalizedValueHash,
    dedupeKey: `${snapshot.flightInstanceId}:${type}:${normalizedValueHash}:${effectiveAtUtc}`,
  };
}

/**
 * True when a delay moved enough to matter: it crossed the threshold in
 * either direction, or both readings are already material and the estimate
 * moved by at least another threshold. Sub-threshold wobble around an
 * on-time flight is provider noise and is not history.
 */
function delayChangedMeaningfully(
  previous: number | null,
  current: number | null,
  thresholdMinutes: number,
): boolean {
  if (previous === null && current === null) {
    return false;
  }
  if (previous === null || current === null) {
    // A delay becoming known, or becoming unknown, only matters once the
    // known side is material — otherwise an on-time flight whose estimate
    // merely appeared would generate an event.
    const known = previous ?? current ?? 0;
    return Math.abs(known) >= thresholdMinutes;
  }
  const wasMaterial = Math.abs(previous) >= thresholdMinutes;
  const isMaterial = Math.abs(current) >= thresholdMinutes;
  if (wasMaterial !== isMaterial) {
    return true;
  }
  if (!isMaterial) {
    return false;
  }
  return Math.abs(current - previous) >= thresholdMinutes;
}

function minutesBetween(fromUtc: string, toUtc: string): number {
  return Math.round((Date.parse(toUtc) - Date.parse(fromUtc)) / 60000);
}

function asValue(value: number | null): string | null {
  return value === null ? null : String(value);
}

/**
 * Derives the Flight Events implied by moving from `previous` to `current`.
 *
 * Pass `null` as `previous` for the first accepted observation of a Flight
 * Instance. Callers should drop duplicate snapshots (see
 * {@link import("./snapshot.ts").isDuplicateSnapshot}) before diffing, so
 * `previous` is the last snapshot whose content actually differed.
 *
 * Events come back in a fixed order — schedule, delays, location, aircraft,
 * phase, disruptions — so that a caller persisting them, or a test
 * asserting on them, sees the same sequence every time.
 */
export function generateFlightEvents(
  previous: FlightSnapshot | null | undefined,
  current: FlightSnapshot,
  options: GenerateFlightEventsOptions = {},
): FlightEvent[] {
  const threshold = options.delayThresholdMinutes ?? DEFAULT_DELAY_THRESHOLD_MINUTES;

  if (!previous) {
    return [buildEvent(current, "FLIGHT_CREATED", null, hashSnapshotPayload(current))];
  }

  const events: FlightEvent[] = [];

  // Schedule — a change to the published time itself, not to an estimate.
  if (
    previous.scheduledDepartureUtc !== current.scheduledDepartureUtc ||
    previous.scheduledArrivalUtc !== current.scheduledArrivalUtc
  ) {
    events.push(
      buildEvent(
        current,
        "SCHEDULE_CHANGED",
        `${previous.scheduledDepartureUtc}/${previous.scheduledArrivalUtc}`,
        `${current.scheduledDepartureUtc}/${current.scheduledArrivalUtc}`,
      ),
    );
  }

  // Delays, measured against the scheduled times on each snapshot.
  if (
    delayChangedMeaningfully(
      previous.status.departureDelayMinutes,
      current.status.departureDelayMinutes,
      threshold,
    )
  ) {
    events.push(
      buildEvent(
        current,
        "DEPARTURE_DELAY_CHANGED",
        asValue(previous.status.departureDelayMinutes),
        asValue(current.status.departureDelayMinutes),
      ),
    );
  }

  if (
    delayChangedMeaningfully(
      previous.status.arrivalDelayMinutes,
      current.status.arrivalDelayMinutes,
      threshold,
    )
  ) {
    events.push(
      buildEvent(
        current,
        "ARRIVAL_DELAY_CHANGED",
        asValue(previous.status.arrivalDelayMinutes),
        asValue(current.status.arrivalDelayMinutes),
      ),
    );
  } else if (
    current.status.arrivalDelayMinutes === null &&
    previous.estimatedArrivalUtc !== null &&
    current.estimatedArrivalUtc !== null &&
    Math.abs(minutesBetween(previous.estimatedArrivalUtc, current.estimatedArrivalUtc)) >= threshold
  ) {
    // No scheduled arrival to measure against, so the moving estimate is
    // the only arrival fact there is. Reported once, never alongside
    // ARRIVAL_DELAY_CHANGED, which would state the same thing twice.
    events.push(
      buildEvent(
        current,
        "ESTIMATED_ARRIVAL_CHANGED",
        previous.estimatedArrivalUtc,
        current.estimatedArrivalUtc,
      ),
    );
  }

  // Location on the ground. A value disappearing is provider gap-filling,
  // not a real change, so only an assignment or a substitution is recorded.
  events.push(
    ...diffAssignable(current, {
      previousValue: previous.originTerminal,
      currentValue: current.originTerminal,
      assigned: "TERMINAL_CHANGED",
      changed: "TERMINAL_CHANGED",
    }),
    ...diffAssignable(current, {
      previousValue: previous.originGate,
      currentValue: current.originGate,
      assigned: "GATE_ASSIGNED",
      changed: "GATE_CHANGED",
    }),
    ...diffAssignable(current, {
      previousValue: previous.destinationTerminal,
      currentValue: current.destinationTerminal,
      assigned: "TERMINAL_CHANGED",
      changed: "TERMINAL_CHANGED",
    }),
    ...diffAssignable(current, {
      previousValue: previous.destinationGate,
      currentValue: current.destinationGate,
      assigned: "ARRIVAL_GATE_CHANGED",
      changed: "ARRIVAL_GATE_CHANGED",
    }),
    ...diffAssignable(current, {
      previousValue: previous.baggageBelt,
      currentValue: current.baggageBelt,
      assigned: "BAGGAGE_BELT_ASSIGNED",
      changed: "BAGGAGE_BELT_ASSIGNED",
    }),
    ...diffAssignable(current, {
      previousValue: previous.aircraftType,
      currentValue: current.aircraftType,
      assigned: "AIRCRAFT_CHANGED",
      changed: "AIRCRAFT_CHANGED",
    }),
    ...diffAssignable(current, {
      previousValue: previous.tailNumber,
      currentValue: current.tailNumber,
      assigned: "TAIL_NUMBER_ASSIGNED",
      changed: "AIRCRAFT_CHANGED",
    }),
  );

  // Phase, forward progress only. UNKNOWN never generates an event: an
  // unrecognised provider value must not read as the flight regressing.
  if (
    previous.status.phase !== current.status.phase &&
    current.status.phase !== "UNKNOWN" &&
    phaseRank(current.status.phase) > phaseRank(previous.status.phase)
  ) {
    const phaseEvent = PHASE_EVENTS[current.status.phase];
    if (phaseEvent) {
      events.push(buildEvent(current, phaseEvent, previous.status.phase, current.status.phase));
    }
  }

  // Disruptions, on the rising edge only — a condition that clears does not
  // re-announce itself.
  if (!previous.status.isCancelled && current.status.isCancelled) {
    events.push(buildEvent(current, "CANCELLED", null, "CANCELLED"));
  }
  if (!previous.status.isDiverted && current.status.isDiverted) {
    events.push(
      buildEvent(current, "DIVERTED", null, current.diversionAirportIata ?? "DIVERTED"),
    );
  }
  if (!previous.status.isReturnedToGate && current.status.isReturnedToGate) {
    events.push(buildEvent(current, "RETURNED_TO_GATE", null, "RETURNED_TO_GATE"));
  }

  return events;
}

/** One assignable operational field and the event types its change implies. */
interface AssignableField {
  readonly previousValue: string | null;
  readonly currentValue: string | null;
  readonly assigned: FlightEventType;
  readonly changed: FlightEventType;
}

/**
 * Diffs a field that can be assigned (null to value) or substituted (value
 * to a different value). A value going missing produces nothing: providers
 * routinely drop fields they previously reported, and treating that as a
 * change would write fiction into an immutable history.
 */
function diffAssignable(current: FlightSnapshot, field: AssignableField): FlightEvent[] {
  if (field.currentValue === null || field.previousValue === field.currentValue) {
    return [];
  }
  const type = field.previousValue === null ? field.assigned : field.changed;
  return [buildEvent(current, type, field.previousValue, field.currentValue)];
}

/**
 * Removes events already present by §14 dedup key, preserving first-seen
 * order. Reprocessing a snapshot pair and merging the result into an
 * existing history must leave that history unchanged.
 */
export function dedupeEvents(events: readonly FlightEvent[]): FlightEvent[] {
  const seen = new Set<string>();
  const result: FlightEvent[] = [];
  for (const event of events) {
    if (seen.has(event.dedupeKey)) {
      continue;
    }
    seen.add(event.dedupeKey);
    result.push(event);
  }
  return result;
}
