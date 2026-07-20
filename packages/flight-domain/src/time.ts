/**
 * Time handling (§10): persist/represent instants in UTC, always paired with
 * the relevant airport's IANA timezone; derive display-local time from
 * UTC + airport timezone, never from device timezone; the scheduled local
 * departure date is part of flight identity and must be derived from
 * UTC + origin timezone.
 *
 * Per the spec's timezone note, we resolve IANA zone offsets with the
 * platform `Intl` API rather than a date/timezone library or hand-rolled
 * offset tables. All functions are pure and take timestamps as parameters —
 * none read the system clock.
 */

/** Wall-clock components in a specific IANA timezone. */
export interface AirportLocalDateTime {
  readonly year: number;
  readonly month: number; // 1-12
  readonly day: number;
  readonly hour: number;
  readonly minute: number;
  readonly second: number;
}

/** A UTC instant expressed alongside its airport-local wall-clock reading. */
export interface AirportLocalMoment {
  readonly localDate: string; // YYYY-MM-DD
  readonly localTime: string; // HH:mm:ss
  readonly local: AirportLocalDateTime;
  readonly utcOffsetMinutes: number;
}

const PART_FORMATTER_CACHE = new Map<string, Intl.DateTimeFormat>();

function getFormatter(timeZone: string): Intl.DateTimeFormat {
  let formatter = PART_FORMATTER_CACHE.get(timeZone);
  if (!formatter) {
    formatter = new Intl.DateTimeFormat("en-US", {
      timeZone,
      hour12: false,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
    });
    PART_FORMATTER_CACHE.set(timeZone, formatter);
  }
  return formatter;
}

/** Reads the wall-clock components an IANA timezone shows for a UTC instant. */
function readLocalParts(epochMs: number, timeZone: string): AirportLocalDateTime {
  const parts = getFormatter(timeZone).formatToParts(new Date(epochMs));
  const map: Record<string, string> = {};
  for (const part of parts) {
    map[part.type] = part.value;
  }
  // Some locales render midnight as "24" under hour12:false; normalize to 0.
  const hour = map.hour === "24" ? 0 : Number(map.hour);
  return {
    year: Number(map.year),
    month: Number(map.month),
    day: Number(map.day),
    hour,
    minute: Number(map.minute),
    second: Number(map.second),
  };
}

function pad(value: number, width = 2): string {
  return String(value).padStart(width, "0");
}

/**
 * Converts a UTC instant to the airport-local wall-clock reading, including
 * the resolved UTC offset at that instant (handles DST transitions because
 * the offset is derived per-instant from IANA tzdata via `Intl`).
 */
export function toAirportLocal(
  utcIso: string,
  timeZone: string,
): AirportLocalMoment {
  const epochMs = Date.parse(utcIso);
  const local = readLocalParts(epochMs, timeZone);
  const localAsUtcMs = Date.UTC(
    local.year,
    local.month - 1,
    local.day,
    local.hour,
    local.minute,
    local.second,
  );
  const utcOffsetMinutes = Math.round((localAsUtcMs - epochMs) / 60000);
  return {
    localDate: `${pad(local.year, 4)}-${pad(local.month)}-${pad(local.day)}`,
    localTime: `${pad(local.hour)}:${pad(local.minute)}:${pad(local.second)}`,
    local,
    utcOffsetMinutes,
  };
}

/**
 * Converts an airport-local wall-clock reading to its UTC instant. Uses a
 * fixed-point iteration over the offset (the standard technique for
 * timezone-aware local-to-UTC conversion): the offset itself depends on the
 * UTC instant we're solving for near a DST transition, so we refine the
 * guess a few times until it stabilizes.
 */
export function fromAirportLocal(
  local: AirportLocalDateTime,
  timeZone: string,
): string {
  let guessMs = Date.UTC(
    local.year,
    local.month - 1,
    local.day,
    local.hour,
    local.minute,
    local.second,
  );
  for (let i = 0; i < 3; i++) {
    const localAtGuess = readLocalParts(guessMs, timeZone);
    const localAsUtcMs = Date.UTC(
      localAtGuess.year,
      localAtGuess.month - 1,
      localAtGuess.day,
      localAtGuess.hour,
      localAtGuess.minute,
      localAtGuess.second,
    );
    const offsetMinutes = Math.round((localAsUtcMs - guessMs) / 60000);
    const targetAsUtcMs = Date.UTC(
      local.year,
      local.month - 1,
      local.day,
      local.hour,
      local.minute,
      local.second,
    );
    const nextGuessMs = targetAsUtcMs - offsetMinutes * 60000;
    if (nextGuessMs === guessMs) {
      break;
    }
    guessMs = nextGuessMs;
  }
  return new Date(guessMs).toISOString();
}

/**
 * Derives the scheduled local departure date (part of flight identity per
 * §8.1/§10) from the scheduled departure UTC instant and the origin
 * airport's IANA timezone. Never derive this from the UTC calendar date —
 * an evening departure can already be the next day in UTC.
 */
export function deriveScheduledLocalDepartureDate(
  scheduledDepartureUtc: string,
  originTimeZone: string,
): string {
  return toAirportLocal(scheduledDepartureUtc, originTimeZone).localDate;
}
