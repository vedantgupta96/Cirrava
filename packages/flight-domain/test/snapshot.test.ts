import { test } from "node:test";
import assert from "node:assert/strict";
import {
  canonicalizeSnapshot,
  hashSnapshotPayload,
  isDuplicateSnapshot,
} from "../src/snapshot.ts";

const baseInput = {
  flightInstanceId: "fi_01",
  observedAtUtc: "2026-09-15T18:00:00Z",
  rawPhase: "scheduled",
  rawDisruptions: [],
  scheduledDepartureUtc: "2026-09-15T22:00:00Z",
  scheduledArrivalUtc: "2026-09-16T01:30:00Z",
};

test("canonicalizes a sparse provider observation into a full snapshot", () => {
  const snapshot = canonicalizeSnapshot(baseInput);

  assert.equal(snapshot.flightInstanceId, "fi_01");
  assert.equal(snapshot.observedAtUtc, "2026-09-15T18:00:00.000Z");
  assert.equal(snapshot.status.phase, "SCHEDULED");
  assert.equal(snapshot.status.isDelayed, false);
  assert.equal(snapshot.scheduledDepartureUtc, "2026-09-15T22:00:00.000Z");
  assert.equal(snapshot.originGate, null);
  assert.equal(snapshot.destinationGate, null);
  assert.equal(snapshot.tailNumber, null);
});

test("missing fields become null rather than empty strings or undefined", () => {
  const snapshot = canonicalizeSnapshot({
    ...baseInput,
    originGate: "   ",
    originTerminal: undefined,
    tailNumber: null,
  });

  assert.equal(snapshot.originGate, null);
  assert.equal(snapshot.originTerminal, null);
  assert.equal(snapshot.tailNumber, null);
});

test("gate, terminal, belt and tail values are trimmed and upper-cased", () => {
  const snapshot = canonicalizeSnapshot({
    ...baseInput,
    originTerminal: " b ",
    originGate: " c12 ",
    destinationTerminal: "4",
    destinationGate: "a3",
    baggageBelt: " 7 ",
    tailNumber: " n123nd ",
    aircraftType: " b738 ",
  });

  assert.equal(snapshot.originTerminal, "B");
  assert.equal(snapshot.originGate, "C12");
  assert.equal(snapshot.destinationTerminal, "4");
  assert.equal(snapshot.destinationGate, "A3");
  assert.equal(snapshot.baggageBelt, "7");
  assert.equal(snapshot.tailNumber, "N123ND");
  assert.equal(snapshot.aircraftType, "B738");
});

test("an unknown provider phase degrades to UNKNOWN without leaking the raw string", () => {
  const snapshot = canonicalizeSnapshot({
    ...baseInput,
    rawPhase: "TAXIING_TO_STAND",
  });

  assert.equal(snapshot.status.phase, "UNKNOWN");
  assert.equal(JSON.stringify(snapshot).includes("TAXIING_TO_STAND"), false);
});

test("equivalent observations hash identically regardless of key order", () => {
  const first = canonicalizeSnapshot({
    ...baseInput,
    originGate: "C12",
    tailNumber: "N123ND",
  });
  const second = canonicalizeSnapshot({
    tailNumber: "N123ND",
    originGate: "C12",
    scheduledArrivalUtc: baseInput.scheduledArrivalUtc,
    scheduledDepartureUtc: baseInput.scheduledDepartureUtc,
    rawDisruptions: [],
    rawPhase: "scheduled",
    observedAtUtc: baseInput.observedAtUtc,
    flightInstanceId: baseInput.flightInstanceId,
  });

  assert.equal(hashSnapshotPayload(first), hashSnapshotPayload(second));
});

test("observation time is excluded from the payload hash, so a re-poll of unchanged data is a duplicate", () => {
  const earlier = canonicalizeSnapshot(baseInput);
  const later = canonicalizeSnapshot({
    ...baseInput,
    observedAtUtc: "2026-09-15T18:05:00Z",
  });

  assert.equal(hashSnapshotPayload(earlier), hashSnapshotPayload(later));
  assert.equal(isDuplicateSnapshot(earlier, later), true);
});

test("a changed gate produces a different hash and is not a duplicate", () => {
  const earlier = canonicalizeSnapshot({ ...baseInput, originGate: "C12" });
  const later = canonicalizeSnapshot({ ...baseInput, originGate: "C14" });

  assert.notEqual(hashSnapshotPayload(earlier), hashSnapshotPayload(later));
  assert.equal(isDuplicateSnapshot(earlier, later), false);
});

test("snapshots of different Flight Instances are never duplicates of one another", () => {
  const first = canonicalizeSnapshot(baseInput);
  const second = canonicalizeSnapshot({ ...baseInput, flightInstanceId: "fi_02" });

  assert.equal(isDuplicateSnapshot(first, second), false);
});

test("the payload hash is stable across runs for a fixed observation", () => {
  const snapshot = canonicalizeSnapshot(baseInput);

  assert.equal(hashSnapshotPayload(snapshot), hashSnapshotPayload(snapshot));
  assert.match(hashSnapshotPayload(snapshot), /^[0-9a-f]{64}$/);
});

test("provider timestamps in a non-UTC offset canonicalize to the same instant", () => {
  const offsetForm = canonicalizeSnapshot({
    ...baseInput,
    scheduledDepartureUtc: "2026-09-15T17:00:00-05:00",
  });

  assert.equal(offsetForm.scheduledDepartureUtc, "2026-09-15T22:00:00.000Z");
  assert.equal(hashSnapshotPayload(offsetForm), hashSnapshotPayload(canonicalizeSnapshot(baseInput)));
});

test("an unparseable timestamp becomes null rather than an Invalid Date", () => {
  const snapshot = canonicalizeSnapshot({
    ...baseInput,
    estimatedDepartureUtc: "not-a-timestamp",
  });

  assert.equal(snapshot.estimatedDepartureUtc, null);
});
