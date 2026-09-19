/**
 * Status normalization (§9, §14, §32): map raw normalized-observation
 * values into {@link NormalizedFlightStatus}. Never expose provider-specific
 * status strings — this module does not know about any provider; it only
 * normalizes already-generic string tokens (e.g. "boarding", "delayed") of
 * the kind carried on a Flight Snapshot. Undocumented/unknown values degrade
 * to UNKNOWN rather than throwing or leaking the raw string (§14: "never
 * trust undocumented enum values").
 */
import type { DisruptionCondition, FlightPhase, NormalizedFlightStatus } from "./types.ts";

const PHASE_LOOKUP: Record<string, FlightPhase> = {
  UNKNOWN: "UNKNOWN",
  SCHEDULED: "SCHEDULED",
  CHECK_IN_OPEN: "CHECK_IN_OPEN",
  BOARDING: "BOARDING",
  GATE_CLOSED: "GATE_CLOSED",
  DEPARTED: "DEPARTED",
  EN_ROUTE: "EN_ROUTE",
  LANDED: "LANDED",
  ARRIVED_AT_GATE: "ARRIVED_AT_GATE",
};

const DISRUPTION_LOOKUP: Record<string, DisruptionCondition> = {
  DELAYED: "DELAYED",
  CANCELLED: "CANCELLED",
  DIVERTED: "DIVERTED",
  RETURNED_TO_GATE: "RETURNED_TO_GATE",
};

/** Case-insensitively normalizes a raw phase token, degrading to UNKNOWN. */
export function normalizePhase(raw: string | null | undefined): FlightPhase {
  if (!raw) {
    return "UNKNOWN";
  }
  const key = raw.trim().toUpperCase();
  return PHASE_LOOKUP[key] ?? "UNKNOWN";
}

/**
 * Case-insensitively normalizes raw disruption tokens into the closed set
 * of {@link DisruptionCondition} values. Unrecognized tokens are dropped
 * rather than thrown (§14), since a disruption's absence is a safe default.
 */
export function normalizeDisruptions(
  raw: ReadonlyArray<string | null | undefined> | null | undefined,
): DisruptionCondition[] {
  if (!raw) {
    return [];
  }
  const result = new Set<DisruptionCondition>();
  for (const value of raw) {
    if (!value) {
      continue;
    }
    const mapped = DISRUPTION_LOOKUP[value.trim().toUpperCase()];
    if (mapped) {
      result.add(mapped);
    }
  }
  return Array.from(result);
}

/** A pair of scheduled/estimated UTC timestamps for one flight leg. */
export interface DelayInput {
  readonly scheduledUtc: string | null | undefined;
  readonly estimatedUtc: string | null | undefined;
}

/**
 * Derives delay minutes from scheduled vs. estimated UTC times. Returns null
 * when either timestamp is absent — an unknown delay must not be reported
 * as zero.
 */
export function computeDelayMinutes(input: DelayInput | null | undefined): number | null {
  if (!input?.scheduledUtc || !input.estimatedUtc) {
    return null;
  }
  const scheduledMs = Date.parse(input.scheduledUtc);
  const estimatedMs = Date.parse(input.estimatedUtc);
  if (Number.isNaN(scheduledMs) || Number.isNaN(estimatedMs)) {
    return null;
  }
  return Math.round((estimatedMs - scheduledMs) / 60000);
}

/** Raw inputs for building a {@link NormalizedFlightStatus}. */
export interface NormalizeStatusInput {
  readonly rawPhase: string | null | undefined;
  readonly rawDisruptions: ReadonlyArray<string | null | undefined> | null | undefined;
  readonly departure?: DelayInput | null;
  readonly arrival?: DelayInput | null;
}

/**
 * Builds the normalized status object. Phase and disruptions are computed
 * independently of one another by construction (§9: "do not rely exclusively
 * on one status enum") — a BOARDING phase and an active DELAYED disruption
 * are not mutually exclusive.
 */
export function normalizeStatus(input: NormalizeStatusInput): NormalizedFlightStatus {
  const disruptions = normalizeDisruptions(input.rawDisruptions);
  return {
    phase: normalizePhase(input.rawPhase),
    isDelayed: disruptions.includes("DELAYED"),
    isCancelled: disruptions.includes("CANCELLED"),
    isDiverted: disruptions.includes("DIVERTED"),
    isReturnedToGate: disruptions.includes("RETURNED_TO_GATE"),
    departureDelayMinutes: computeDelayMinutes(input.departure),
    arrivalDelayMinutes: computeDelayMinutes(input.arrival),
  };
}
