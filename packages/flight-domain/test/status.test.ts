import { test } from "node:test";
import assert from "node:assert/strict";
import { computeDelayMinutes, normalizePhase, normalizeStatus } from "../src/status.ts";

test("maps known phase tokens", () => {
  assert.equal(normalizePhase("scheduled"), "SCHEDULED");
  assert.equal(normalizePhase("CHECK_IN_OPEN"), "CHECK_IN_OPEN");
  assert.equal(normalizePhase("boarding"), "BOARDING");
  assert.equal(normalizePhase("gate_closed"), "GATE_CLOSED");
  assert.equal(normalizePhase("departed"), "DEPARTED");
  assert.equal(normalizePhase("en_route"), "EN_ROUTE");
  assert.equal(normalizePhase("landed"), "LANDED");
  assert.equal(normalizePhase("arrived_at_gate"), "ARRIVED_AT_GATE");
});

test("a flight may be BOARDING while delayed: phase and disruption are independent", () => {
  const status = normalizeStatus({
    rawPhase: "boarding",
    rawDisruptions: ["delayed"],
    departure: {
      scheduledUtc: "2026-09-15T22:00:00Z",
      estimatedUtc: "2026-09-15T23:15:00Z",
    },
  });
  assert.equal(status.phase, "BOARDING");
  assert.equal(status.isDelayed, true);
  assert.equal(status.departureDelayMinutes, 75);
});

test("cancellation is a disruption independent of phase", () => {
  const status = normalizeStatus({
    rawPhase: "scheduled",
    rawDisruptions: ["cancelled"],
  });
  assert.equal(status.phase, "SCHEDULED");
  assert.equal(status.isCancelled, true);
  assert.equal(status.isDelayed, false);
});

test("diversion is a disruption independent of phase", () => {
  const status = normalizeStatus({
    rawPhase: "en_route",
    rawDisruptions: ["diverted"],
  });
  assert.equal(status.phase, "EN_ROUTE");
  assert.equal(status.isDiverted, true);
});

test("returned to gate is a disruption independent of phase", () => {
  const status = normalizeStatus({
    rawPhase: "gate_closed",
    rawDisruptions: ["returned_to_gate"],
  });
  assert.equal(status.phase, "GATE_CLOSED");
  assert.equal(status.isReturnedToGate, true);
});

test("an unknown provider phase value degrades to UNKNOWN rather than throwing", () => {
  assert.equal(normalizePhase("some_new_provider_value_v2"), "UNKNOWN");
  const status = normalizeStatus({
    rawPhase: "some_new_provider_value_v2",
    rawDisruptions: ["not_a_real_disruption"],
  });
  assert.equal(status.phase, "UNKNOWN");
  assert.equal(status.isDelayed, false);
  assert.equal(status.isCancelled, false);
  assert.equal(status.isDiverted, false);
  assert.equal(status.isReturnedToGate, false);
});

test("missing or absent fields degrade safely", () => {
  assert.equal(normalizePhase(null), "UNKNOWN");
  assert.equal(normalizePhase(undefined), "UNKNOWN");
  const status = normalizeStatus({ rawPhase: undefined, rawDisruptions: undefined });
  assert.equal(status.phase, "UNKNOWN");
  assert.equal(status.isDelayed, false);
  assert.equal(status.departureDelayMinutes, null);
  assert.equal(status.arrivalDelayMinutes, null);
});

test("delay minutes are null when scheduled or estimated time is missing", () => {
  assert.equal(computeDelayMinutes(null), null);
  assert.equal(
    computeDelayMinutes({ scheduledUtc: "2026-09-15T22:00:00Z", estimatedUtc: null }),
    null,
  );
  assert.equal(
    computeDelayMinutes({ scheduledUtc: null, estimatedUtc: "2026-09-15T22:00:00Z" }),
    null,
  );
});

test("delay minutes derive from scheduled vs estimated time, not from phase", () => {
  assert.equal(
    computeDelayMinutes({
      scheduledUtc: "2026-09-15T22:00:00Z",
      estimatedUtc: "2026-09-15T22:00:00Z",
    }),
    0,
  );
  assert.equal(
    computeDelayMinutes({
      scheduledUtc: "2026-09-15T22:00:00Z",
      estimatedUtc: "2026-09-15T21:45:00Z",
    }),
    -15,
  );
});
