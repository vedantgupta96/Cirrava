import { test } from "node:test";
import assert from "node:assert/strict";
import {
  buildCanonicalFlightKey,
  normalizeFlightNumber,
  resolveCodeshare,
} from "../src/identity.ts";
import type { FlightInstanceIdentity, OperatingFlightInstance } from "../src/types.ts";

const baseIdentity: FlightInstanceIdentity = {
  marketingCarrier: "ND",
  marketingFlightNumber: "410",
  originIata: "SFO",
  destinationIata: "SEA",
  scheduledLocalDepartureDate: "2026-09-15",
};

test("builds the canonical key exactly per §8.1", () => {
  assert.equal(
    buildCanonicalFlightKey(baseIdentity),
    "ND:410:SFO:SEA:2026-09-15",
  );
});

test("normalizes case and whitespace", () => {
  const key = buildCanonicalFlightKey({
    marketingCarrier: " nd ",
    marketingFlightNumber: " 410 ",
    originIata: "sfo",
    destinationIata: "sea",
    scheduledLocalDepartureDate: "2026-09-15",
  });
  assert.equal(key, "ND:410:SFO:SEA:2026-09-15");
});

test("normalizes leading zeros in flight numbers", () => {
  assert.equal(normalizeFlightNumber("0410"), "410");
  assert.equal(normalizeFlightNumber("00007"), "7");
  assert.equal(normalizeFlightNumber("0"), "0");
});

test("normalizes an embedded carrier prefix in flight numbers", () => {
  assert.equal(normalizeFlightNumber("ND410"), "410");
  assert.equal(normalizeFlightNumber("nd 0410"), "410");
});

test("two different routes sharing a flight number produce different keys", () => {
  const keyA = buildCanonicalFlightKey(baseIdentity);
  const keyB = buildCanonicalFlightKey({
    ...baseIdentity,
    originIata: "LAX",
    destinationIata: "ORD",
  });
  assert.notEqual(keyA, keyB);
});

test("same operating flight reached via two codeshare aliases resolves to one Flight Instance", () => {
  const operating: OperatingFlightInstance = {
    identity: {
      marketingCarrier: "QL",
      marketingFlightNumber: "217",
      originIata: "JFK",
      destinationIata: "LHR",
      scheduledLocalDepartureDate: "2026-09-15",
    },
    codeshareAliases: [
      { marketingCarrier: "MW", marketingFlightNumber: "8217" },
      { marketingCarrier: "AX", marketingFlightNumber: "0099" },
    ],
  };
  const instances = [operating];

  const viaFirstAlias = resolveCodeshare(
    { marketingCarrier: "mw", marketingFlightNumber: "8217" },
    instances,
  );
  const viaSecondAlias = resolveCodeshare(
    { marketingCarrier: "ax", marketingFlightNumber: "99" },
    instances,
  );

  assert.equal(viaFirstAlias, operating);
  assert.equal(viaSecondAlias, operating);
  assert.equal(
    buildCanonicalFlightKey(viaFirstAlias!.identity),
    buildCanonicalFlightKey(viaSecondAlias!.identity),
  );
});

test("resolveCodeshare returns undefined for an alias with no operating instance", () => {
  const instances: OperatingFlightInstance[] = [];
  assert.equal(
    resolveCodeshare({ marketingCarrier: "MW", marketingFlightNumber: "8217" }, instances),
    undefined,
  );
});
