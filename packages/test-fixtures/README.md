# Deterministic flight fixtures

`flights.json` provides provider-neutral data for the first Cirrava vertical
slice. The flights and carriers are fictional; airport metadata is realistic.
No record was copied from a live flight-data provider, and no provider
identifier or provider-native status appears in the file.

## Scenarios

| Cirrava Flight Instance | Search designator | Scenario |
| --- | --- | --- |
| `10000000-0000-4000-8000-000000000001` | `ND 410` | On-time SFO–SEA flight currently boarding |
| `10000000-0000-4000-8000-000000000002` | `QL 217` or alias `MW 8217` | JFK–LHR codeshare with a 75-minute Material Delay |
| `10000000-0000-4000-8000-000000000003` | `PN 604` | Cancelled ORD–MIA flight with a distinct Replacement Flight link |

All searches use the origin-local departure date `2026-09-15`.

## Deterministic use

- Reset an in-memory or test database from the file before each test suite.
- Freeze the test clock to a scenario's `currentSnapshot.freshness.evaluatedAt`.
  Each scenario has its own observation window, so freshness assertions never
  depend on the real wall clock.
- Index each fixture by `flight.flightInstanceId`, its operating
  `displayDesignator`, and every Codeshare Alias `displayDesignator`.
- Return each array item directly as a `FlightDetail` response. Search returns
  matching items under `{ "items": [...] }`.
- Recalculate freshness from `currentSnapshot.observedAt` when deliberately
  advancing a test clock; do not mutate the original fixture.
- Generate Follow identifiers and timestamps inside the test harness. The
  fixture describes flights, not user intent, so it can test anonymous and
  Account Holder limits independently.

The public schemas are defined in `../contracts/openapi.yaml`. Keep fixture
changes deterministic and review contract changes before updating consumers.
