/**
 * Public API surface for `@cirrava/flight-domain`: provider-independent
 * flight identity, time handling, and normalized status. See package README
 * of the spec (packages/flight-domain) for scope — snapshot diffing and
 * event generation (§14) are a follow-up slice, not included here.
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
