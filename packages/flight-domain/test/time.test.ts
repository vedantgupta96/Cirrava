import { test } from "node:test";
import assert from "node:assert/strict";
import {
  deriveScheduledLocalDepartureDate,
  fromAirportLocal,
  toAirportLocal,
} from "../src/time.ts";

test("UTC to airport-local conversion", () => {
  // 2026-09-15T15:30:00Z in America/Los_Angeles (PDT, UTC-7 in September).
  const moment = toAirportLocal("2026-09-15T15:30:00Z", "America/Los_Angeles");
  assert.equal(moment.localDate, "2026-09-15");
  assert.equal(moment.localTime, "08:30:00");
  assert.equal(moment.utcOffsetMinutes, -420);
});

test("airport-local to UTC conversion round-trips", () => {
  const utcIso = "2026-09-15T15:30:00Z";
  const moment = toAirportLocal(utcIso, "America/Los_Angeles");
  const roundTripped = fromAirportLocal(moment.local, "America/Los_Angeles");
  assert.equal(roundTripped, new Date(utcIso).toISOString());
});

test("scheduled local departure date differs from the UTC calendar date", () => {
  // 23:30 local in Los Angeles (UTC-7) on 2026-06-10 is 06:30 UTC on 2026-06-11.
  const scheduledDepartureUtc = "2026-06-11T06:30:00Z";
  const localDate = deriveScheduledLocalDepartureDate(
    scheduledDepartureUtc,
    "America/Los_Angeles",
  );
  assert.equal(localDate, "2026-06-10");
  // Sanity check: the naive UTC date component would have been wrong.
  assert.notEqual(localDate, scheduledDepartureUtc.slice(0, 10));
});

test("handles a US spring-forward DST transition (2026-03-08)", () => {
  // At 2026-03-08T06:59:00Z it is 01:59 EST (UTC-5); one minute later it is
  // 03:00 EDT (UTC-4) because 02:00-02:59 local does not exist that day.
  const beforeTransition = toAirportLocal("2026-03-08T06:59:00Z", "America/New_York");
  assert.equal(beforeTransition.localTime, "01:59:00");
  assert.equal(beforeTransition.utcOffsetMinutes, -300);

  const afterTransition = toAirportLocal("2026-03-08T07:00:00Z", "America/New_York");
  assert.equal(afterTransition.localTime, "03:00:00");
  assert.equal(afterTransition.utcOffsetMinutes, -240);
});

test("handles a US fall-back DST transition (2026-11-01)", () => {
  // At 2026-11-01T05:59:00Z it is 01:59 EDT (UTC-4); one minute later the
  // clock repeats 01:00 as EST (UTC-5).
  const beforeTransition = toAirportLocal("2026-11-01T05:59:00Z", "America/New_York");
  assert.equal(beforeTransition.localTime, "01:59:00");
  assert.equal(beforeTransition.utcOffsetMinutes, -240);

  const afterTransition = toAirportLocal("2026-11-01T06:00:00Z", "America/New_York");
  assert.equal(afterTransition.localTime, "01:00:00");
  assert.equal(afterTransition.utcOffsetMinutes, -300);
});

test("overnight/red-eye flight: departure and arrival local dates span midnight in different zones", () => {
  // JFK -> LHR red-eye: departs 22:00 local New York, arrives 09:30 local
  // London the next day.
  const departureUtc = "2026-09-16T02:00:00Z";
  const arrivalUtc = "2026-09-16T08:30:00Z";
  const departure = toAirportLocal(departureUtc, "America/New_York");
  const arrival = toAirportLocal(arrivalUtc, "Europe/London");

  assert.equal(departure.localDate, "2026-09-15");
  assert.equal(departure.localTime, "22:00:00");
  assert.equal(arrival.localDate, "2026-09-16");
  assert.equal(arrival.localTime, "09:30:00");
});
