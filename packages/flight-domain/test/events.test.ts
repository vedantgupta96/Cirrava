import { test } from "node:test";
import assert from "node:assert/strict";
import { canonicalizeSnapshot } from "../src/snapshot.ts";
import type { FlightSnapshotInput } from "../src/snapshot.ts";
import { dedupeEvents, generateFlightEvents } from "../src/events.ts";
import type { FlightEvent, FlightEventType } from "../src/events.ts";

const baseInput: FlightSnapshotInput = {
  flightInstanceId: "fi_01",
  observedAtUtc: "2026-09-15T18:00:00Z",
  rawPhase: "scheduled",
  rawDisruptions: [],
  scheduledDepartureUtc: "2026-09-15T22:00:00Z",
  scheduledArrivalUtc: "2026-09-16T01:30:00Z",
  estimatedDepartureUtc: "2026-09-15T22:00:00Z",
  estimatedArrivalUtc: "2026-09-16T01:30:00Z",
  originTerminal: "B",
  originGate: "C12",
};

const snapshot = (overrides: Partial<FlightSnapshotInput> = {}) =>
  canonicalizeSnapshot({ ...baseInput, ...overrides });

const typesOf = (events: readonly FlightEvent[]): FlightEventType[] =>
  events.map((event) => event.type);

test("the first observation of a Flight Instance produces FLIGHT_CREATED", () => {
  const events = generateFlightEvents(null, snapshot());

  assert.deepEqual(typesOf(events), ["FLIGHT_CREATED"]);
  assert.equal(events[0]?.flightInstanceId, "fi_01");
  assert.equal(events[0]?.effectiveAtUtc, "2026-09-15T18:00:00.000Z");
});

test("FLIGHT_CREATED is emitted once, not again on the next observation", () => {
  const first = snapshot();
  const second = snapshot({ observedAtUtc: "2026-09-15T18:05:00Z", originGate: "C14" });

  assert.equal(typesOf(generateFlightEvents(first, second)).includes("FLIGHT_CREATED"), false);
});

test("an unchanged snapshot produces no events", () => {
  const previous = snapshot();
  const current = snapshot({ observedAtUtc: "2026-09-15T18:05:00Z" });

  assert.deepEqual(generateFlightEvents(previous, current), []);
});

test("a gate assignment and a later gate change are distinct event types", () => {
  const unassigned = snapshot({ originGate: null });
  const assigned = snapshot({ originGate: "C12", observedAtUtc: "2026-09-15T18:05:00Z" });
  const changed = snapshot({ originGate: "C14", observedAtUtc: "2026-09-15T18:10:00Z" });

  assert.deepEqual(typesOf(generateFlightEvents(unassigned, assigned)), ["GATE_ASSIGNED"]);

  const changeEvents = generateFlightEvents(assigned, changed);
  assert.deepEqual(typesOf(changeEvents), ["GATE_CHANGED"]);
  assert.equal(changeEvents[0]?.previousValue, "C12");
  assert.equal(changeEvents[0]?.currentValue, "C14");
});

test("a terminal change is reported separately from a gate change", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({ originTerminal: "D", originGate: "D1", observedAtUtc: "2026-09-15T18:05:00Z" }),
  );

  assert.deepEqual(typesOf(events), ["TERMINAL_CHANGED", "GATE_CHANGED"]);
});

test("an arrival gate change is distinct from a departure gate change", () => {
  const events = generateFlightEvents(
    snapshot({ destinationGate: "A3" }),
    snapshot({ destinationGate: "A7", observedAtUtc: "2026-09-15T18:05:00Z" }),
  );

  assert.deepEqual(typesOf(events), ["ARRIVAL_GATE_CHANGED"]);
});

test("a departure delay reaching the material threshold produces one event", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      estimatedDepartureUtc: "2026-09-15T22:20:00Z",
      rawDisruptions: ["delayed"],
      observedAtUtc: "2026-09-15T18:05:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["DEPARTURE_DELAY_CHANGED"]);
  assert.equal(events[0]?.previousValue, "0");
  assert.equal(events[0]?.currentValue, "20");
});

test("a sub-threshold estimate wobble produces no delay event", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      estimatedDepartureUtc: "2026-09-15T22:06:00Z",
      observedAtUtc: "2026-09-15T18:05:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), []);
});

test("a material delay that grows by a further threshold produces another event", () => {
  const delayed = snapshot({ estimatedDepartureUtc: "2026-09-15T22:20:00Z" });
  const worse = snapshot({
    estimatedDepartureUtc: "2026-09-15T22:40:00Z",
    observedAtUtc: "2026-09-15T18:10:00Z",
  });

  assert.deepEqual(typesOf(generateFlightEvents(delayed, worse)), ["DEPARTURE_DELAY_CHANGED"]);
});

test("a material delay that recovers below the threshold produces an event", () => {
  const delayed = snapshot({ estimatedDepartureUtc: "2026-09-15T22:20:00Z" });
  const recovered = snapshot({
    estimatedDepartureUtc: "2026-09-15T22:05:00Z",
    observedAtUtc: "2026-09-15T18:10:00Z",
  });

  assert.deepEqual(typesOf(generateFlightEvents(delayed, recovered)), [
    "DEPARTURE_DELAY_CHANGED",
  ]);
});

test("the delay threshold is configurable without changing the default", () => {
  const previous = snapshot();
  const current = snapshot({
    estimatedDepartureUtc: "2026-09-15T22:06:00Z",
    observedAtUtc: "2026-09-15T18:05:00Z",
  });

  assert.deepEqual(typesOf(generateFlightEvents(previous, current)), []);
  assert.deepEqual(
    typesOf(generateFlightEvents(previous, current, { delayThresholdMinutes: 5 })),
    ["DEPARTURE_DELAY_CHANGED"],
  );
});

test("a scheduled time change is a schedule change, not a delay", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      scheduledDepartureUtc: "2026-09-15T23:00:00Z",
      estimatedDepartureUtc: "2026-09-15T23:00:00Z",
      observedAtUtc: "2026-09-15T18:05:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["SCHEDULE_CHANGED"]);
});

test("phase transitions produce their own events", () => {
  const cases: ReadonlyArray<readonly [string, string, FlightEventType]> = [
    ["scheduled", "boarding", "BOARDING_STARTED"],
    ["boarding", "gate_closed", "GATE_CLOSED"],
    ["gate_closed", "departed", "DEPARTED"],
    ["en_route", "landed", "LANDED"],
    ["landed", "arrived_at_gate", "ARRIVED_AT_GATE"],
  ];

  for (const [from, to, expected] of cases) {
    const events = generateFlightEvents(
      snapshot({ rawPhase: from }),
      snapshot({ rawPhase: to, observedAtUtc: "2026-09-15T18:05:00Z" }),
    );
    assert.deepEqual(typesOf(events), [expected], `${from} -> ${to}`);
  }
});

test("cancellation produces an event and is independent of the phase", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({ rawDisruptions: ["cancelled"], observedAtUtc: "2026-09-15T18:05:00Z" }),
  );

  assert.deepEqual(typesOf(events), ["CANCELLED"]);
});

test("a flight cancelled while boarding reports both the phase change and the cancellation", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      rawPhase: "boarding",
      rawDisruptions: ["cancelled"],
      observedAtUtc: "2026-09-15T18:05:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["BOARDING_STARTED", "CANCELLED"]);
});

test("a diversion produces an event carrying the diversion airport", () => {
  const events = generateFlightEvents(
    snapshot({ rawPhase: "en_route" }),
    snapshot({
      rawPhase: "en_route",
      rawDisruptions: ["diverted"],
      diversionAirportIata: "sea",
      observedAtUtc: "2026-09-15T23:30:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["DIVERTED"]);
  assert.equal(events[0]?.currentValue, "SEA");
});

test("a return to gate produces an event", () => {
  const events = generateFlightEvents(
    snapshot({ rawPhase: "departed" }),
    snapshot({
      rawPhase: "scheduled",
      rawDisruptions: ["returned_to_gate"],
      observedAtUtc: "2026-09-15T22:40:00Z",
    }),
  );

  assert.equal(typesOf(events).includes("RETURNED_TO_GATE"), true);
});

test("a disruption that clears does not re-emit the disruption event", () => {
  const diverted = snapshot({ rawDisruptions: ["diverted"] });
  const cleared = snapshot({ rawDisruptions: [], observedAtUtc: "2026-09-15T18:05:00Z" });

  assert.equal(typesOf(generateFlightEvents(diverted, cleared)).includes("DIVERTED"), false);
});

test("aircraft type and tail number changes are reported", () => {
  const assigned = generateFlightEvents(
    snapshot({ tailNumber: null }),
    snapshot({ tailNumber: "N123ND", observedAtUtc: "2026-09-15T18:05:00Z" }),
  );
  assert.deepEqual(typesOf(assigned), ["TAIL_NUMBER_ASSIGNED"]);

  const swapped = generateFlightEvents(
    snapshot({ aircraftType: "B738" }),
    snapshot({ aircraftType: "A320", observedAtUtc: "2026-09-15T18:05:00Z" }),
  );
  assert.deepEqual(typesOf(swapped), ["AIRCRAFT_CHANGED"]);
});

test("a baggage belt assignment is reported", () => {
  const events = generateFlightEvents(
    snapshot({ baggageBelt: null }),
    snapshot({ baggageBelt: "7", observedAtUtc: "2026-09-16T01:35:00Z" }),
  );

  assert.deepEqual(typesOf(events), ["BAGGAGE_BELT_ASSIGNED"]);
});

test("a later arrival estimate against a known schedule is an arrival delay, reported once", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      estimatedArrivalUtc: "2026-09-16T02:00:00Z",
      observedAtUtc: "2026-09-15T23:00:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["ARRIVAL_DELAY_CHANGED"]);
  assert.equal(events[0]?.currentValue, "30");
});

test("without a scheduled arrival the estimate move is reported as ESTIMATED_ARRIVAL_CHANGED", () => {
  const events = generateFlightEvents(
    snapshot({ scheduledArrivalUtc: null }),
    snapshot({
      scheduledArrivalUtc: null,
      estimatedArrivalUtc: "2026-09-16T02:00:00Z",
      observedAtUtc: "2026-09-15T23:00:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["ESTIMATED_ARRIVAL_CHANGED"]);
});

test("telemetry-only movement produces no Flight Event (ADR-0004)", () => {
  const events = generateFlightEvents(
    snapshot({ rawPhase: "en_route" }),
    snapshot({ rawPhase: "en_route", observedAtUtc: "2026-09-15T23:30:00Z" }),
  );

  assert.deepEqual(events, []);
});

test("a field going missing does not fabricate a change event", () => {
  const events = generateFlightEvents(
    snapshot({ originGate: "C12" }),
    snapshot({ originGate: null, observedAtUtc: "2026-09-15T18:05:00Z" }),
  );

  assert.deepEqual(typesOf(events), []);
});

test("an unknown provider phase does not produce a phase event", () => {
  const events = generateFlightEvents(
    snapshot({ rawPhase: "boarding" }),
    snapshot({ rawPhase: "wandering_the_apron", observedAtUtc: "2026-09-15T18:05:00Z" }),
  );

  assert.deepEqual(typesOf(events), []);
});

test("an overnight flight crossing midnight UTC produces ordinary events", () => {
  const events = generateFlightEvents(
    snapshot({ rawPhase: "en_route", scheduledArrivalUtc: "2026-09-16T01:30:00Z" }),
    snapshot({
      rawPhase: "landed",
      scheduledArrivalUtc: "2026-09-16T01:30:00Z",
      actualArrivalUtc: "2026-09-16T01:25:00Z",
      observedAtUtc: "2026-09-16T01:25:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["LANDED"]);
  assert.equal(events[0]?.effectiveAtUtc, "2026-09-16T01:25:00.000Z");
});

test("every event carries the §14 dedup key shape", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({ originGate: "C14", observedAtUtc: "2026-09-15T18:05:00Z" }),
  );
  const event = events[0];

  assert.ok(event);
  assert.equal(
    event.dedupeKey,
    `${event.flightInstanceId}:${event.type}:${event.normalizedValueHash}:${event.effectiveAtUtc}`,
  );
  assert.match(event.normalizedValueHash, /^[0-9a-f]{64}$/);
});

test("reprocessing the same snapshot pair yields identical events", () => {
  const previous = snapshot();
  const current = snapshot({
    originGate: "C14",
    rawPhase: "boarding",
    observedAtUtc: "2026-09-15T18:05:00Z",
  });

  assert.deepEqual(
    generateFlightEvents(previous, current),
    generateFlightEvents(previous, current),
  );
});

test("reprocessing does not add duplicates to an already-recorded history", () => {
  const previous = snapshot();
  const current = snapshot({ originGate: "C14", observedAtUtc: "2026-09-15T18:05:00Z" });

  const firstPass = generateFlightEvents(previous, current);
  const secondPass = generateFlightEvents(previous, current);

  assert.deepEqual(dedupeEvents([...firstPass, ...secondPass]), firstPass);
});

test("dedupeEvents keeps genuinely distinct events and preserves order", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      originTerminal: "D",
      originGate: "D1",
      observedAtUtc: "2026-09-15T18:05:00Z",
    }),
  );

  assert.equal(events.length, 2);
  assert.deepEqual(dedupeEvents([...events, ...events]), events);
});

test("the same change observed at a later time is a distinct event, not a duplicate", () => {
  const previous = snapshot();
  const early = generateFlightEvents(
    previous,
    snapshot({ originGate: "C14", observedAtUtc: "2026-09-15T18:05:00Z" }),
  );
  const late = generateFlightEvents(
    previous,
    snapshot({ originGate: "C14", observedAtUtc: "2026-09-15T19:05:00Z" }),
  );

  assert.notEqual(early[0]?.dedupeKey, late[0]?.dedupeKey);
  assert.equal(early[0]?.normalizedValueHash, late[0]?.normalizedValueHash);
});

test("event order is deterministic regardless of how many fields changed at once", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      rawPhase: "boarding",
      rawDisruptions: ["delayed"],
      originTerminal: "D",
      originGate: "D1",
      estimatedDepartureUtc: "2026-09-15T22:45:00Z",
      tailNumber: "N123ND",
      observedAtUtc: "2026-09-15T18:05:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), [
    "DEPARTURE_DELAY_CHANGED",
    "TERMINAL_CHANGED",
    "GATE_CHANGED",
    "TAIL_NUMBER_ASSIGNED",
    "BOARDING_STARTED",
  ]);
});

test("a delay is reported as a delay event only - there is no DELAYED event type", () => {
  const events = generateFlightEvents(
    snapshot(),
    snapshot({
      rawDisruptions: ["delayed"],
      estimatedDepartureUtc: "2026-09-15T22:30:00Z",
      observedAtUtc: "2026-09-15T18:05:00Z",
    }),
  );

  assert.deepEqual(typesOf(events), ["DEPARTURE_DELAY_CHANGED"]);
});
