/**
 * Canonical flight identity (§8.1).
 *
 * The canonical key is for lookup only. Per §8.1: "This key is useful for
 * lookup but must not replace a generated immutable database ID." Nothing
 * in this module generates, mints, or stands in for a database id — callers
 * own that separately.
 */
import type {
  CodeshareAlias,
  FlightInstanceIdentity,
  OperatingFlightInstance,
} from "./types.ts";

/** Uppercases and trims an IATA airport or carrier code. */
export function normalizeIataCode(raw: string): string {
  return raw.trim().toUpperCase();
}

/** Alias of {@link normalizeIataCode} for marketing carrier designators. */
export function normalizeCarrierCode(raw: string): string {
  return normalizeIataCode(raw);
}

/**
 * Normalizes a marketing flight number supplied in any of the forms seen
 * across providers and user input: with or without an embedded carrier
 * prefix ("ND410"), with or without leading zeros ("0410"), and with
 * incidental whitespace/case. The result is the flight number's digits with
 * leading zeros stripped (a lone "0" is preserved).
 */
export function normalizeFlightNumber(raw: string): string {
  const cleaned = raw.trim().toUpperCase().replace(/\s+/g, "");
  const match = cleaned.match(/(\d+)$/);
  const digits = match ? match[1] : cleaned;
  const stripped = digits.replace(/^0+(?=\d)/, "");
  return stripped;
}

/**
 * Builds the canonical lookup key from §8.1:
 * `{marketingCarrier}:{marketingFlightNumber}:{originIata}:{destinationIata}:{scheduledDepartureLocalDate}`
 */
export function buildCanonicalFlightKey(
  identity: FlightInstanceIdentity,
): string {
  const carrier = normalizeCarrierCode(identity.marketingCarrier);
  const flightNumber = normalizeFlightNumber(identity.marketingFlightNumber);
  const origin = normalizeIataCode(identity.originIata);
  const destination = normalizeIataCode(identity.destinationIata);
  const date = identity.scheduledLocalDepartureDate.trim();
  return `${carrier}:${flightNumber}:${origin}:${destination}:${date}`;
}

/**
 * Resolves a codeshare marketing carrier/number to the one operating
 * Flight Instance it refers to. Aliases refer to the operating instance;
 * they do not define it (CONTEXT.md: "Codeshare Alias"). Returns undefined
 * if no operating instance declares this alias.
 */
export function resolveCodeshare(
  alias: CodeshareAlias,
  instances: readonly OperatingFlightInstance[],
): OperatingFlightInstance | undefined {
  const carrier = normalizeCarrierCode(alias.marketingCarrier);
  const flightNumber = normalizeFlightNumber(alias.marketingFlightNumber);
  return instances.find((instance) =>
    instance.codeshareAliases.some(
      (candidate) =>
        normalizeCarrierCode(candidate.marketingCarrier) === carrier &&
        normalizeFlightNumber(candidate.marketingFlightNumber) === flightNumber,
    ),
  );
}
