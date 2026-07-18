# Flight Data Provider Evaluation

**Last verified:** 2026-07-17
**Question:** Which provider is the best initial fit for Cirrava's v1 coverage of scheduled commercial flights with at least one U.S. airport?

## Recommendation

Use **FlightAware AeroAPI Standard for the technical prototype**, while keeping the production-provider decision provisional.

FlightAware is the clearest public fit for Cirrava's immediate needs: its Standard tier explicitly permits business and business-to-consumer use, includes alerts and history, publishes usage-based pricing, and starts at a $100 monthly minimum. Its public materials also describe global flight data and a push-alert capability. See the [AeroAPI plans and pricing](https://www.flightaware.com/commercial/aeroapi/) and [API pricing reference](https://www.flightaware.com/commercial/aeroapi/pricing/).

Do not treat that as production approval yet. Before Cirrava ships or stores provider-derived data, FlightAware should confirm in writing that the intended normalization, event derivation, device caching, retention, and user-facing display comply with the current Standard license. The publicly available Premium terms impose meaningful restrictions on raw-data retention and combining real-time providers; the Standard agreement should be reviewed for equivalent clauses. See the [AeroAPI Premium license](https://www.flightaware.com/commercial/aeroapi/AeroAPI_Premium_License_Jan2025.pdf) and [Standard license](https://www.flightaware.com/commercial/aeroapi/AeroAPI_Standard_License.pdf).

In parallel, request a Cirium trial, quote, and contract terms. Cirium is the strongest enterprise comparison because it offers traveler-facing status APIs, broad global commercial-flight coverage, and contract-tier push alerts, but it does not publish enough pricing or licensing detail to select it from public information alone. See the [Cirium Sky API overview](https://developer.cirium.com/apis), [flight-data overview](https://www.cirium.com/thoughtcloud/flight-data-api/), and [Flight Alerts API](https://developer.cirium.com/apis/cirium-sky-api/flight-alerts).

## Fit Summary

| Provider | Status and coverage fit | Push alerts | Public commercial terms | Initial assessment |
| --- | --- | --- | --- | --- |
| FlightAware AeroAPI | Strong; global status, history, and tracking data | Included from Standard | Most transparent of the candidates; Standard starts at $100/month plus usage | Best prototype candidate; production license confirmation required |
| Cirium Sky | Strong; positioned for traveler-facing apps with broad commercial coverage | Contract plan only | Quote and contract required | Best enterprise benchmark and possible production alternative |
| Amadeus Self-Service | Moderate; useful on-demand status fields | No push-alert product identified in reviewed official material | Published pay-as-you-go structure, but production legal terms are supplied separately | Useful secondary prototype option; weaker fit for notification-led architecture |
| Flightradar24 API | Strong tracking data | Not established for Cirrava's event needs in reviewed material | Published plans, but storage, redistribution, attribution, and provider-mixing restrictions are material | Do not adopt without written confirmation that Cirrava's core product is permitted |

## Verified Findings

### FlightAware AeroAPI

- The Personal tier is limited to personal or academic derivative work and is not suitable for a distributed B2C product. It also excludes alerts and history.
- The Standard tier explicitly lists business and B2C commercialization, alerts, and history. It has a $100 monthly minimum and a published rate limit of five result sets per second.
- The Premium tier adds enterprise features such as Foresight, Aireon satellite data, and an SLA, with a $1,000 monthly minimum.
- Pricing is usage-based by endpoint and result set. For example, the published reference lists relatively low per-result-set prices for direct flight lookups and a higher price for search, so Cirrava's actual cost will depend heavily on polling frequency, alert volume, search behavior, and caching.
- The public Premium license permits B2C flight-tracking applications, but restricts raw AeroAPI data storage beyond 30 days and restricts using another real-time provider to supplement or backfill the service without written permission. Those Premium clauses do not prove the exact Standard rights, but they reveal issues that must be resolved before production.

Sources: [AeroAPI plans](https://www.flightaware.com/commercial/aeroapi/), [endpoint pricing](https://www.flightaware.com/commercial/aeroapi/pricing/), [Standard license](https://www.flightaware.com/commercial/aeroapi/AeroAPI_Standard_License.pdf), and [Premium license](https://www.flightaware.com/commercial/aeroapi/AeroAPI_Premium_License_Jan2025.pdf).

### Cirium Sky

- Cirium positions FlightStats APIs for traveler-facing applications and offers schedules, flight status, tracking, and alerts.
- Its flight-data material claims coverage of more than 35 million flights per year and more than 97% of global commercial flights, including scheduled and actual gate/runway times, delays, and cancellations.
- Flight Alerts can push changes including delays, cancellations, departures, arrivals, gates, equipment, and tail numbers, but alerts are limited to a Contract plan.
- Public material does not provide a production price or enough license detail for Cirrava's persistence and redistribution model. A sales and legal review is therefore part of the technical evaluation, not a later procurement formality.

Sources: [Cirium Sky API overview](https://developer.cirium.com/apis), [flight-data overview](https://www.cirium.com/thoughtcloud/flight-data-api/), and [Flight Alerts API](https://developer.cirium.com/apis/cirium-sky-api/flight-alerts).

### Amadeus Self-Service APIs

- The On-Demand Flight Status API exposes schedule, departure and arrival information, terminals, gates, duration, and delay data.
- The test environment provides a free quota against a limited data set. Production uses live data, retains a free monthly quota, and then charges per request.
- Amadeus supplies production legal terms separately. The public materials reviewed do not establish the rights Cirrava needs for durable normalized history, offline device caching, or later public sharing.
- **Inference:** Because no push-alert product was identified in the reviewed official Self-Service material, Cirrava should model this option as polling-based unless Amadeus confirms otherwise. That makes it less attractive for a notification-led v1 even if its request pricing is favorable.

Sources: [Amadeus API pricing](https://developers.amadeus.com/pricing), [On-Demand Flight Status](https://developers.amadeus.com/self-service/category/flights/api-doc/on-demand-flight-status), and [terms and conditions](https://developers.amadeus.com/support/faq/about-self-service-apis/what-are-the-terms-and-conditions-for-using-self-service-apis).

### Flightradar24 API

- Flightradar24 publishes commercial API tiers ranging from Essential at $90 per month to Advanced at $900 per month, with a lower Explorer tier and credit-based consumption.
- Its terms permit API use and derivative works according to the purchased tier, but prohibit redistributing raw data, constrain persistent storage by endpoint, require attribution, and restrict supplementing or backfilling with another real-time flight-data provider.
- The terms also condition derivative use on adding significant value and on Flightradar24 data not being the derivative work's main selling point. Because live flight information is central to Cirrava, this creates a material product-fit risk rather than a minor implementation detail.

Sources: [Flightradar24 API plans](https://fr24api.flightradar24.com/plans) and [terms of service](https://www.flightradar24.com/terms-of-service).

## Production Licensing Questions

Obtain written answers from any finalist before launch:

1. May Cirrava store normalized Flight Snapshots, derive and retain Flight Events, and keep aggregate operational metrics? Which of those are considered raw data or derivative works?
2. May a device retain the latest normalized flight state for offline use and retain an anonymous completed follow for 24 hours?
3. May Cirrava display provider-derived data in a paid or free B2C mobile app, notifications, Live Activities or Android live updates, widgets, and later public sharing links?
4. What attribution, airline-logo, airport-data, map, and screenshot or marketing requirements apply?
5. What historical retention limits apply to server data, device caches, logs, backups, analytics, and customer-support records?
6. May Cirrava fail over to, compare against, or backfill from another real-time provider? If so, under what restrictions?
7. Are webhooks or alerts billed per followed flight, delivered event, endpoint request, or some combination? What are the retry, latency, and delivery guarantees?
8. What coverage and latency commitments apply to U.S.-linked scheduled commercial flights, including diversions, replacements, codeshares, gate changes, and international arrivals or departures?

## Prototype Decision Gate

The FlightAware prototype should prove:

- canonical operating-flight and codeshare resolution;
- provider continuity through reschedules across local midnight;
- cancellation and replacement-flight linkage;
- snapshot normalization and meaningful event derivation;
- polling plus alert reconciliation without duplicate notifications;
- actual request and alert cost for a representative follow lifecycle;
- quality and latency across a sample of domestic and international U.S.-linked flights.

Production selection should occur only after those results are compared with a Cirium trial and the winning provider's written terms cover Cirrava's data model and user experience.
