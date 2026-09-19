/**
 * Public API surface for `@cirrava/flight-domain`: provider-independent
 * flight identity, time handling, normalized status, canonical Flight
 * Snapshots, and Flight Event generation (§8, §9, §10, §14).
 */
export type {
  FlightPhase,
  DisruptionCondition,
  NormalizedFlightStatus,
  FlightInstanceIdentity,
  CodeshareAlias,
  OperatingFlightInstance,
} from "./types.ts";

export {
  normalizeIataCode,
  normalizeCarrierCode,
  normalizeFlightNumber,
  buildCanonicalFlightKey,
  resolveCodeshare,
} from "./identity.ts";

export type { AirportLocalDateTime, AirportLocalMoment } from "./time.ts";
export {
  toAirportLocal,
  fromAirportLocal,
  deriveScheduledLocalDepartureDate,
} from "./time.ts";

export type { DelayInput, NormalizeStatusInput } from "./status.ts";
export {
  normalizePhase,
  normalizeDisruptions,
  computeDelayMinutes,
  normalizeStatus,
} from "./status.ts";

export type { FlightSnapshot, FlightSnapshotInput } from "./snapshot.ts";
export {
  canonicalizeSnapshot,
  stableStringify,
  hashSnapshotPayload,
  isDuplicateSnapshot,
} from "./snapshot.ts";

export type {
  FlightEvent,
  FlightEventType,
  GenerateFlightEventsOptions,
} from "./events.ts";
export { generateFlightEvents, dedupeEvents } from "./events.ts";
