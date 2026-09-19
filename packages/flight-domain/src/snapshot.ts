/**
 * Canonical Flight Snapshots and duplicate detection (§14).
 *
 * A Flight Snapshot is "a normalized observation of a Flight Instance's
 * current state at a point in time" (CONTEXT.md). This module owns the
 * canonical-snapshot and hash-and-duplicate-check stages of the §14
 * pipeline; it knows nothing about any provider and performs no I/O.
 *
 * Canonicalization exists so that two observations describing the same
 * world state produce byte-identical payloads: timestamps collapse to a
 * single UTC representation, codes are trimmed and upper-cased, and every
 * absent value becomes `null` rather than `undefined` or `""`. Without
 * that, provider formatting churn would masquerade as domain change and
 * generate Flight Events for nothing.
 *
 * The payload hash deliberately excludes `observedAtUtc`: every poll has a
 * new observation time, so including it would make every poll unique and
 * defeat the duplicate check §14 requires.
 */
import { createHash } from "node:crypto";
import { normalizeStatus } from "./status.ts";
import type { NormalizedFlightStatus } from "./types.ts";

/**
 * A raw, already provider-normalized observation. Fields are optional
 * because providers omit what they do not know; canonicalization decides
 * what absence means.
 */
export interface FlightSnapshotInput {
  readonly flightInstanceId: string;
  readonly observedAtUtc: string;
  readonly rawPhase?: string | null;
  readonly rawDisruptions?: ReadonlyArray<string | null | undefined> | null;
  readonly scheduledDepartureUtc?: string | null;
  readonly scheduledArrivalUtc?: string | null;
  readonly estimatedDepartureUtc?: string | null;
  readonly estimatedArrivalUtc?: string | null;
  readonly actualDepartureUtc?: string | null;
  readonly actualArrivalUtc?: string | null;
  readonly originTerminal?: string | null;
  readonly originGate?: string | null;
  readonly destinationTerminal?: string | null;
  readonly destinationGate?: string | null;
  readonly baggageBelt?: string | null;
  readonly aircraftType?: string | null;
  readonly tailNumber?: string | null;
  readonly diversionAirportIata?: string | null;
}

/** A canonical Flight Snapshot: every field present, every absence `null`. */
export interface FlightSnapshot {
  readonly flightInstanceId: string;
  readonly observedAtUtc: string;
  readonly status: NormalizedFlightStatus;
  readonly scheduledDepartureUtc: string | null;
  readonly scheduledArrivalUtc: string | null;
  readonly estimatedDepartureUtc: string | null;
  readonly estimatedArrivalUtc: string | null;
  readonly actualDepartureUtc: string | null;
  readonly actualArrivalUtc: string | null;
  readonly originTerminal: string | null;
  readonly originGate: string | null;
  readonly destinationTerminal: string | null;
  readonly destinationGate: string | null;
  readonly baggageBelt: string | null;
  readonly aircraftType: string | null;
  readonly tailNumber: string | null;
  readonly diversionAirportIata: string | null;
}

/**
 * Collapses any parseable timestamp to a single UTC ISO-8601 spelling, so
 * that `2026-09-15T17:00:00-05:00` and `2026-09-15T22:00:00Z` — the same
 * instant — cannot look like a schedule change. Unparseable input becomes
 * null rather than an Invalid Date, which would poison every comparison.
 */
function canonicalizeInstant(raw: string | null | undefined): string | null {
  if (!raw || !raw.trim()) {
    return null;
  }
  const epochMs = Date.parse(raw);
  if (Number.isNaN(epochMs)) {
    return null;
  }
  return new Date(epochMs).toISOString();
}

/** Trims and upper-cases a short operational code, treating blank as absent. */
function canonicalizeCode(raw: string | null | undefined): string | null {
  if (!raw) {
    return null;
  }
  const trimmed = raw.trim().toUpperCase();
  return trimmed === "" ? null : trimmed;
}

/** Builds the canonical Flight Snapshot for one normalized observation. */
export function canonicalizeSnapshot(input: FlightSnapshotInput): FlightSnapshot {
  const scheduledDepartureUtc = canonicalizeInstant(input.scheduledDepartureUtc);
  const scheduledArrivalUtc = canonicalizeInstant(input.scheduledArrivalUtc);
  const estimatedDepartureUtc = canonicalizeInstant(input.estimatedDepartureUtc);
  const estimatedArrivalUtc = canonicalizeInstant(input.estimatedArrivalUtc);

  const status = normalizeStatus({
    rawPhase: input.rawPhase,
    rawDisruptions: input.rawDisruptions,
    departure: { scheduledUtc: scheduledDepartureUtc, estimatedUtc: estimatedDepartureUtc },
    arrival: { scheduledUtc: scheduledArrivalUtc, estimatedUtc: estimatedArrivalUtc },
  });

  return {
    flightInstanceId: input.flightInstanceId,
    observedAtUtc: canonicalizeInstant(input.observedAtUtc) ?? input.observedAtUtc,
    status,
    scheduledDepartureUtc,
    scheduledArrivalUtc,
    estimatedDepartureUtc,
    estimatedArrivalUtc,
    actualDepartureUtc: canonicalizeInstant(input.actualDepartureUtc),
    actualArrivalUtc: canonicalizeInstant(input.actualArrivalUtc),
    originTerminal: canonicalizeCode(input.originTerminal),
    originGate: canonicalizeCode(input.originGate),
    destinationTerminal: canonicalizeCode(input.destinationTerminal),
    destinationGate: canonicalizeCode(input.destinationGate),
    baggageBelt: canonicalizeCode(input.baggageBelt),
    aircraftType: canonicalizeCode(input.aircraftType),
    tailNumber: canonicalizeCode(input.tailNumber),
    diversionAirportIata: canonicalizeCode(input.diversionAirportIata),
  };
}

/**
 * Serializes a value with object keys in sorted order, so that two
 * structurally equal payloads always serialize identically regardless of
 * the key order a provider or caller happened to use.
 */
export function stableStringify(value: unknown): string {
  if (value === null || typeof value !== "object") {
    return JSON.stringify(value) ?? "null";
  }
  if (Array.isArray(value)) {
    return `[${value.map(stableStringify).join(",")}]`;
  }
  const entries = Object.entries(value as Record<string, unknown>)
    .filter(([, entryValue]) => entryValue !== undefined)
    .sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))
    .map(([key, entryValue]) => `${JSON.stringify(key)}:${stableStringify(entryValue)}`);
  return `{${entries.join(",")}}`;
}

/**
 * The stable content hash used for §14 duplicate detection. Covers the
 * Flight Instance and every observed field, but not the observation time:
 * an unchanged re-poll must hash equal to the observation before it.
 */
export function hashSnapshotPayload(snapshot: FlightSnapshot): string {
  const { observedAtUtc: _observedAtUtc, ...payload } = snapshot;
  return createHash("sha256").update(stableStringify(payload)).digest("hex");
}

/**
 * True when a newly observed snapshot carries no content change from the
 * previous one and should therefore not be persisted or diffed.
 */
export function isDuplicateSnapshot(
  previous: FlightSnapshot | null | undefined,
  current: FlightSnapshot,
): boolean {
  if (!previous) {
    return false;
  }
  return hashSnapshotPayload(previous) === hashSnapshotPayload(current);
}
