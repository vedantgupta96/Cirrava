/**
 * Terminology-faithful domain types for Cirrava flight identity and status.
 *
 * Names in this file must match CONTEXT.md's ubiquitous language exactly.
 * See `docs/architecture/technical-architecture.md` §8 (Core Domain Model)
 * and §9 (Normalized Flight Status).
 */

/**
 * The single current stage of a Flight Instance's operation (CONTEXT.md:
 * "Flight Phase"). Deliberately excludes DELAYED, CANCELLED, DIVERTED, and
 * RETURNED_TO_GATE — those are Disruption Conditions, not phases, and may
 * coexist with any phase (e.g. a flight can be BOARDING while DELAYED).
 */
export type FlightPhase =
  | "UNKNOWN"
  | "SCHEDULED"
  | "CHECK_IN_OPEN"
  | "BOARDING"
  | "GATE_CLOSED"
  | "DEPARTED"
  | "EN_ROUTE"
  | "LANDED"
  | "ARRIVED_AT_GATE";

/**
 * An independent condition affecting a Flight Instance (CONTEXT.md:
 * "Disruption Condition"). A disruption may coexist with a Flight Phase and
 * must never be folded into the phase enum.
 */
export type DisruptionCondition =
  | "DELAYED"
  | "CANCELLED"
  | "DIVERTED"
  | "RETURNED_TO_GATE";

/**
 * Normalized flight status. Mirrors the §9 example shape (phase plus
 * independent disruption booleans and delay minutes). Extended with
 * `isReturnedToGate` because CONTEXT.md's Disruption Condition list includes
 * "returned to gate" alongside delayed/cancelled/diverted; the §9 example
 * only illustrated three of the four.
 *
 * Disruption fields are independent of `phase` by construction — nothing in
 * this package derives a disruption from a phase value or vice versa.
 */
export interface NormalizedFlightStatus {
  readonly phase: FlightPhase;
  readonly isDelayed: boolean;
  readonly isCancelled: boolean;
  readonly isDiverted: boolean;
  readonly isReturnedToGate: boolean;
  readonly departureDelayMinutes: number | null;
  readonly arrivalDelayMinutes: number | null;
}

/**
 * Identity fields for a Flight Instance (§8.1). This is the minimal set of
 * fields needed to derive the canonical lookup key — it is NOT the full
 * FlightInstance database entity and must not be used to generate or
 * substitute for a database id.
 */
export interface FlightInstanceIdentity {
  readonly marketingCarrier: string;
  readonly marketingFlightNumber: string;
  readonly originIata: string;
  readonly destinationIata: string;
  /** YYYY-MM-DD, derived from UTC + origin timezone — see src/time.ts. */
  readonly scheduledLocalDepartureDate: string;
}

/**
 * A marketing carrier and flight number that refers to a Flight Instance
 * operated under another carrier or flight number (CONTEXT.md: "Codeshare
 * Alias"). Aliases refer to the operating Flight Instance; they do not
 * define it.
 */
export interface CodeshareAlias {
  readonly marketingCarrier: string;
  readonly marketingFlightNumber: string;
}

/**
 * A Flight Instance as operated, together with the codeshare aliases that
 * refer to it. Used for codeshare resolution only — not a full domain
 * entity.
 */
export interface OperatingFlightInstance {
  readonly identity: FlightInstanceIdentity;
  readonly codeshareAliases: readonly CodeshareAlias[];
}
