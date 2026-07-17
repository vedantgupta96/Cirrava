# Cirrava — Complete Technical Architecture and Engineering Handoff

> Imported from `Cirrava Technical Architecture.docx` on 2026-07-17. This is the planning baseline; accepted ADRs supersede it when they conflict.
Working project name: Cirrava
Product category: Consumer flight-tracking and travel companion application
Target platforms: Android, iOS, and iPadOS
Product inspiration: Flighty-quality flight tracking, presented through an original product identity and design system
Design source: Screens, flows, components, and visual direction are being developed separately using Claude Design
Primary development environment: VS Code with Claude Code and Codex
Document purpose: Give an autonomous coding agent enough architectural, product, data, and implementation context to build the application without inventing core technical decisions.

## 1. Product Objective
Build a polished, reliable flight-tracking application that allows a user to:
- Search for and add an upcoming flight.
- Organize flights into trips.
- See flight status, terminals, gates, delays, aircraft, departure, and arrival information.
- Receive timely notifications when relevant information changes.
- Follow an active flight from the lock screen or other system surfaces.
- Use previously loaded trip information without an internet connection.
- Synchronize trips across the user’s devices.
- Share a flight or trip with another person.
- Eventually view historical trips and personal travel statistics.
The application must feel purpose-built rather than like a generic cross-platform app. Animations, typography, transitions, hierarchy, loading states, and system integrations are part of the product, not optional polish.
The application must not directly copy Flighty’s protected branding, exact layouts, illustrations, wording, animations, or other distinctive visual assets. Flighty should be treated as a quality benchmark, not a design specification.

## 2. Executive Architecture Recommendation
Recommended production architecture
Mobile
- Flutter
- Dart
- Riverpod for state and dependency management
- GoRouter for navigation
- Drift with SQLite for offline storage
- Dio or an equivalent typed HTTP client
- OpenAPI-generated API models and clients
- Native Swift extensions for ActivityKit and iOS widgets
- Native Kotlin components for Android Live Updates, notifications, and widgets
Backend
- TypeScript modular monolith
- NestJS using the Fastify adapter, or a similarly structured Fastify application
- PostgreSQL hosted through Supabase
- Supabase Auth
- Redis for caching, locks, rate limits, and asynchronous queues
- BullMQ or an equivalent Redis-backed job queue
- One API process and one or more worker processes
- Firebase Cloud Messaging for push delivery
- Provider adapters for FlightAware, Cirium, Amadeus, or another contracted flight-data source
Infrastructure
- API and worker deployed as containers
- Managed PostgreSQL and Redis
- Object storage for user-uploaded assets only if required
- GitHub Actions for CI
- Sentry or equivalent error monitoring
- OpenTelemetry-compatible structured logging and tracing
- Staging and production environments from the beginning
Architectural style
- Offline-first mobile application
- REST API with OpenAPI contracts
- Event-driven processing internally
- Provider-independent flight domain
- Server-authoritative flight data
- Local-first presentation and trip access
- Native platform extensions only where system integration requires them
Flutter is designed for code reuse across mobile platforms while still allowing platform-specific integrations, and its official architecture guidance supports layered applications with repositories and view models.
Why this is the recommended choice
The application’s main differentiator will be interface quality, motion, timeline visualization, and information density rather than heavy native computation. Flutter offers strong control over rendering and makes it practical for one primary developer to maintain Android, iPhone, and iPad interfaces.
Native code will still be necessary for:
- iOS Live Activities and Dynamic Island.
- iOS widgets.
- Android Live Update notifications.
- Android widgets.
- Platform-specific notification behavior.
- Background execution and deep-link edge cases.
- Store billing if subscriptions are added.
The architecture deliberately isolates native code behind narrow interfaces rather than pretending that every feature can remain purely cross-platform.

## 3. Mobile Architecture Options
The coding agent should not change the mobile framework casually. The following options are valid, but only one should be selected before implementation begins.
Option A — Flutter
Recommended for this project
Architecture:
- One Flutter application for Android, iOS, and iPadOS.
- Shared UI, domain, networking, persistence, and feature logic.
- Small Swift and Kotlin integration layers.
- Native extensions for lock-screen experiences.
Advantages
- Strong visual consistency.
- Precise custom animations and transitions.
- A single primary UI implementation.
- Good fit for a solo developer.
- Strong responsive layout capabilities.
- Straightforward creation of custom charts, timelines, maps, cards, and status indicators.
- Native plugins can be implemented in Swift and Kotlin when needed.
Flutter supports platform channels and plugins for calling Android and Apple platform APIs from Dart.
Disadvantages
- Some native Apple and Android features require handwritten native bridges.
- The interface will not automatically inherit every new native platform appearance.
- Developers must intentionally implement platform-appropriate navigation, gestures, typography, and controls.
- Dart must be learned.
Use Flutter when
- One team should own all mobile platforms.
- The visual identity is highly custom.
- Rapid cross-platform iteration matters.
- Native features are important but represent a limited percentage of the application.

Option B — Kotlin Multiplatform with Compose Multiplatform
Native-first alternative
Architecture:
- Kotlin Multiplatform for domain logic, networking, persistence, and synchronization.
- Compose Multiplatform for most shared UI.
- Native SwiftUI application shell on iOS.
- Native Android shell using Jetpack Compose.
- Platform-specific navigation and lock-screen integrations.
Kotlin Multiplatform can share business logic while retaining native UI, and Compose Multiplatform is currently stable for Android and iOS.
Advantages
- Excellent Android integration.
- Native Kotlin domain layer.
- Strong access to platform SDKs.
- Can selectively use SwiftUI for iOS-specific screens.
- Shared UI is possible without forcing every screen to be shared.
- Good long-term option for native-heavy products.
Disadvantages
- More complex project structure.
- iOS integration, build tooling, and interoperability require more expertise.
- Fewer developers have production KMP experience than Flutter or React Native experience.
- Autonomous coding agents may create fragile Gradle or Xcode configurations unless tightly constrained.
- The developer must understand Kotlin, Compose, Swift, SwiftUI, Gradle, and Xcode integration.
Native SwiftUI navigation can be retained around Compose-rendered screen content when a system-level Apple appearance or feature is required. JetBrains documents this pattern for native iOS navigation and platform visual features.
Use KMP when
- Native integration is the highest priority.
- The developer accepts a steeper learning curve.
- Long-term platform specialization is expected.
- Android is strategically more important but iOS must remain excellent.

Option C — React Native with Expo Development Builds
Best TypeScript-first alternative
Architecture:
- React Native application using the current New Architecture.
- Expo development builds, not Expo Go as the production development environment.
- TypeScript throughout the mobile and backend layers.
- Native modules and app extensions for platform-specific features.
Modern React Native uses its New Architecture and Hermes runtime rather than the older bridge-dependent model. Expo development builds allow native libraries and native configuration instead of restricting the project to Expo Go.
Advantages
- Existing React and TypeScript experience transfers directly.
- Shared TypeScript contracts can be used across mobile and backend.
- Large package ecosystem.
- Expo simplifies builds, signing, updates, and release automation.
- Native modules remain possible through development builds.
Disadvantages
- Dependency compatibility must be monitored carefully.
- Complex animations and information-dense interfaces require disciplined performance work.
- Native app extensions still require Swift and Kotlin.
- Expo abstractions can become confusing when the project crosses into native configuration.
- Package quality varies significantly.
Use React Native when
- TypeScript productivity is more important than framework purity.
- The team already has strong React expertise.
- Expo’s build and release tooling is attractive.
- The team is willing to profile rendering and animation performance.
React Native should not be rejected merely because of its historical reputation for being slow. Its architecture has changed materially. However, it should also not be chosen solely because the developer knows React.

Option D — Separate SwiftUI and Jetpack Compose Applications
Maximum native control
Architecture:
- SwiftUI iPhone and iPad application.
- Jetpack Compose Android application.
- Shared backend only.
- Optional generated API clients.
- No shared mobile UI or domain code.
Advantages
- Immediate access to every platform feature.
- Maximum platform-specific polish.
- Minimal bridging.
- Best fit for deeply platform-specific product behavior.
Disadvantages
- Approximately two mobile applications must be designed, implemented, tested, and maintained.
- Features can diverge.
- Development velocity is substantially lower for a solo developer.
- Every bug may require two fixes.
- Design system consistency requires deliberate enforcement.
Use fully native applications when
- Separate platform teams exist.
- Native lock-screen, wearable, tablet, and system integrations are the core product.
- Budget and time are secondary to platform perfection.

## 4. Mobile Framework Decision Matrix
Scores are relative to this project. Five is strongest.
Criterion
Flutter
KMP + Compose
React Native + Expo
Separate Native
Solo-development velocity
5
3
5
1
Custom visual fidelity
5
5
4
5
Native system integration
3
5
4
5
Android quality
5
5
4
5
iPhone quality
4
5
4
5
iPad adaptability
5
4
4
5
Existing user skill transfer
3
2
5
2
Long-term operational simplicity
5
3
4
2
Autonomous-agent friendliness
5
3
4
3
Final recommendation
Use Flutter unless the developer explicitly decides to accept KMP’s additional complexity.
Do not switch frameworks after building more than one production feature unless a concrete blocker has been demonstrated through a prototype.
Before finalizing Flutter, create three technical spikes:
- A polished flight-detail screen with the intended animations.
- An iOS Live Activity controlled from Flutter through a Swift bridge.
- An Android Live Update notification controlled through a Kotlin bridge.
If all three spikes are successful, proceed with Flutter.

## 5. Backend Architecture Options
Option 1 — Supabase plus dedicated API and worker
Recommended
Components:
- Supabase PostgreSQL.
- Supabase Auth.
- Supabase Row Level Security where direct client access is allowed.
- TypeScript API service.
- TypeScript worker service.
- Redis.
- FCM.
- External flight-data provider.
Supabase provides a full PostgreSQL database rather than a document abstraction, with Auth, Storage, Realtime, and Edge Functions integrated around it.
Important constraint
Do not implement flight polling, queue processing, provider monitoring, or long-running ingestion solely through Supabase Edge Functions. Supabase recommends moving heavy or long-running work to background workers.
Advantages
- Relational database fits trips, flights, events, codeshares, airports, subscriptions, and user relationships.
- SQL migrations are portable.
- Fast authentication setup.
- Low infrastructure burden.
- Easy future analytics.
- PostgreSQL constraints can enforce domain integrity.
Disadvantages
- A dedicated worker still needs hosting.
- Redis is an additional service.
- Poor RLS design can create security issues.
- Realtime database subscriptions should not replace push notifications.

Option 2 — Firebase-first backend
Components:
- Firebase Authentication.
- Cloud Firestore.
- Cloud Functions or Cloud Run functions.
- Firebase Cloud Messaging.
- Cloud Scheduler and task queues.
Firestore provides real-time listeners, mobile SDK integration, authentication integration, and security rules.
Advantages
- Excellent mobile SDKs.
- Built-in offline behavior.
- Push infrastructure is naturally integrated.
- Minimal operational work for an MVP.
- Good autonomous scaling.
Disadvantages
- Flight data is naturally relational.
- Codeshares, airport boards, trip joins, history, and statistics become awkward.
- Denormalization increases write complexity.
- Query patterns must be designed before the schema.
- Cost can become difficult to predict when many users watch frequently changing documents.
- Migration away from Firestore is harder than migration from PostgreSQL.
Appropriate use
Choose Firebase only when the priority is producing the fastest possible prototype and the team accepts substantial data-model coupling.

Option 3 — Fully custom cloud architecture
Components:
- PostgreSQL.
- Redis.
- Containerized API.
- Containerized workers.
- Managed queues.
- Secret manager.
- Object storage.
- Cloud-native scheduler and monitoring.
Advantages
- Maximum control.
- Strong scaling options.
- No backend-as-a-service coupling.
- Easier implementation of complex ingestion pipelines.
Disadvantages
- Higher setup and operational cost.
- More security responsibilities.
- More infrastructure code.
- Slower MVP development.
Appropriate use
Adopt this after product-market validation, or earlier only if contractual flight-data volume requires a more specialized ingestion system.

## 6. System Context
┌───────────────────────────────────────────────────────────┐
│ Flutter Mobile App                                       │
│ Android · iPhone · iPad                                  │
│                                                          │
│ UI → View Models → Repositories → Local DB/API Client    │
└───────────────────────────┬───────────────────────────────┘
                            │ HTTPS
                            │
┌───────────────────────────▼───────────────────────────────┐
│ API Service                                               │
│                                                          │
│ Auth · Trips · Flights · Search · Devices · Sharing      │
│ Entitlements · Sync · Notification Preferences           │
└─────────────┬───────────────────────────────┬─────────────┘
              │                               │
              │                               │ enqueue
              ▼                               ▼
┌─────────────────────────┐       ┌─────────────────────────┐
│ PostgreSQL              │       │ Redis / Job Queue       │
│                         │       │                         │
│ Users · Trips · Flights │       │ Poll jobs · Push jobs  │
│ Events · Devices        │       │ Retry · Deduplication  │
└─────────────▲───────────┘       └─────────────┬───────────┘
              │                                 │
              │ persist                         ▼
┌─────────────┴─────────────────────────────────────────────┐
│ Worker Service                                           │
│                                                          │
│ Provider polling · Webhook processing · Normalization    │
│ Event creation · Notification fanout · Live updates      │
└─────────────┬───────────────────────────────┬─────────────┘
              │                               │
              ▼                               ▼
┌─────────────────────────┐       ┌─────────────────────────┐
│ Flight Data Providers   │       │ FCM / APNs             │
│                         │       │                         │
│ FlightAware · Cirium    │       │ Push notifications     │
│ Amadeus · Other         │       │ Live Activity updates  │
└─────────────────────────┘       └─────────────────────────┘

## 7. Repository Structure
Use a monorepo, but do not introduce complex monorepo tooling until it is necessary.
cirrava/
├── apps/
│   └── mobile/
│       ├── lib/
│       │   ├── app/
│       │   ├── core/
│       │   ├── design_system/
│       │   ├── features/
│       │   │   ├── authentication/
│       │   │   ├── home/
│       │   │   ├── flight_search/
│       │   │   ├── flight_detail/
│       │   │   ├── trips/
│       │   │   ├── notifications/
│       │   │   ├── sharing/
│       │   │   └── account/
│       │   ├── infrastructure/
│       │   │   ├── api/
│       │   │   ├── persistence/
│       │   │   ├── notifications/
│       │   │   └── platform/
│       │   └── main.dart
│       ├── ios/
│       │   ├── Runner/
│       │   ├── LiveActivityExtension/
│       │   └── WidgetExtension/
│       ├── android/
│       └── test/
│
├── services/
│   ├── api/
│   │   └── src/
│   │       ├── modules/
│   │       │   ├── auth/
│   │       │   ├── users/
│   │       │   ├── trips/
│   │       │   ├── flights/
│   │       │   ├── search/
│   │       │   ├── devices/
│   │       │   ├── sync/
│   │       │   ├── sharing/
│   │       │   └── entitlements/
│   │       └── main.ts
│   │
│   └── worker/
│       └── src/
│           ├── jobs/
│           ├── providers/
│           ├── normalization/
│           ├── notifications/
│           ├── polling/
│           └── main.ts
│
├── packages/
│   ├── contracts/
│   │   ├── openapi.yaml
│   │   └── generated/
│   ├── flight-domain/
│   ├── provider-sdk/
│   ├── observability/
│   └── test-fixtures/
│
├── database/
│   ├── migrations/
│   ├── seeds/
│   ├── policies/
│   └── generated-types/
│
├── design/
│   ├── README.md
│   ├── tokens/
│   ├── components/
│   ├── screens/
│   ├── flows/
│   ├── assets/
│   └── references/
│
├── docs/
│   ├── architecture/
│   ├── decisions/
│   ├── api/
│   ├── operations/
│   └── product/
│
├── infrastructure/
├── .github/workflows/
├── README.md
└── CONTRIBUTING.md

## 8. Core Domain Model
### 8.1 Flight identity
A flight number alone is not a unique flight.
A flight instance should be identified using:
- Marketing carrier.
- Marketing flight number.
- Scheduled departure local date.
- Origin airport.
- Destination airport.
- Provider-specific flight ID when available.
Codeshare flight numbers must map to one operating flight instance.
Recommended canonical key:
{marketingCarrier}:{marketingFlightNumber}:{originIata}:{destinationIata}:{scheduledDepartureLocalDate}
This key is useful for lookup but must not replace a generated immutable database ID.
### 8.2 Core entities
User
Represents an authenticated account.
Device
Represents an application installation and notification destination.
Trip
A user-managed grouping of one or more flight legs.
TripLeg
Connects a trip to a flight instance and stores user-controlled ordering and notes.
FlightInstance
The canonical representation of a specific flight operating on a specific date.
FlightStatusSnapshot
A point-in-time normalized representation of the provider’s current state.
FlightEvent
An immutable meaningful change derived from one or more snapshots.
ProviderFlightReference
Maps a canonical flight instance to IDs used by external providers.
Airport
Canonical airport reference data.
Airline
Canonical airline and carrier information.
NotificationPreference
Specifies which flight events a user wants to receive.
DeviceToken
Stores the FCM or platform token associated with a device.
ShareLink
A revocable token allowing another user or guest to view a flight or trip.
Subscription and Entitlement
Represents store subscription state independently of any billing provider.

## 9. Normalized Flight Status
Do not expose provider-specific status strings to the client.
Use a normalized state machine:
UNKNOWN
SCHEDULED
CHECK_IN_OPEN
BOARDING
GATE_CLOSED
DELAYED
DEPARTED
EN_ROUTE
LANDED
ARRIVED_AT_GATE
CANCELLED
DIVERTED
RETURNED_TO_GATE
A flight may be DELAYED while also being BOARDING. Therefore, do not rely exclusively on one status enum.
The normalized status object should include independent fields:
{
  "phase": "BOARDING",
  "isDelayed": true,
  "isCancelled": false,
  "isDiverted": false,
  "departureDelayMinutes": 42,
  "arrivalDelayMinutes": 18
}
Meaningful event types
FLIGHT_CREATED
SCHEDULE_CHANGED
DEPARTURE_DELAY_CHANGED
ARRIVAL_DELAY_CHANGED
TERMINAL_CHANGED
GATE_ASSIGNED
GATE_CHANGED
BOARDING_STARTED
GATE_CLOSED
AIRCRAFT_CHANGED
TAIL_NUMBER_ASSIGNED
DEPARTED
ALTITUDE_UPDATED
ROUTE_UPDATED
ESTIMATED_ARRIVAL_CHANGED
LANDED
ARRIVAL_GATE_CHANGED
ARRIVED_AT_GATE
BAGGAGE_BELT_ASSIGNED
CANCELLED
DIVERTED
RETURNED_TO_GATE
Do not generate an event for every provider poll. Generate an event only when a meaningful normalized field changes beyond configured thresholds.

## 10. Time Handling
Flight applications fail when local times are treated casually.
Rules:
- Persist event timestamps in UTC.
- Persist the airport’s IANA timezone.
- Retain the provider’s original timestamp and timezone metadata when needed for debugging.
- Derive display time from UTC plus the relevant airport timezone.
- Never infer timezone from the user’s current device timezone.
- Treat a local departure date as part of flight identity.
- Handle daylight-saving transitions.
- Clearly label departure and destination local times when both appear together.
- Do not send plain timestamps without timezone offsets through the API.
Example:
{
  "scheduledDepartureUtc": "2026-08-12T23:40:00Z",
  "departureTimezone": "America/Chicago",
  "scheduledArrivalUtc": "2026-08-13T02:31:00Z",
  "arrivalTimezone": "America/New_York"
}

## 11. PostgreSQL Data Model
The coding agent should create migrations rather than using dashboard-created tables.
Required tables
profiles
id UUID PRIMARY KEY REFERENCES auth.users
display_name TEXT
avatar_url TEXT
home_airport_id UUID NULL
created_at TIMESTAMPTZ
updated_at TIMESTAMPTZ
deleted_at TIMESTAMPTZ NULL
devices
id UUID PRIMARY KEY
user_id UUID
installation_id TEXT UNIQUE
platform TEXT
app_version TEXT
os_version TEXT
locale TEXT
timezone TEXT
last_seen_at TIMESTAMPTZ
created_at TIMESTAMPTZ
device_tokens
id UUID PRIMARY KEY
device_id UUID
provider TEXT
token TEXT UNIQUE
environment TEXT
is_active BOOLEAN
last_validated_at TIMESTAMPTZ
created_at TIMESTAMPTZ
revoked_at TIMESTAMPTZ NULL
airports
id UUID PRIMARY KEY
iata_code CHAR(3) UNIQUE
icao_code TEXT UNIQUE NULL
name TEXT
city TEXT
country_code CHAR(2)
timezone TEXT
latitude DOUBLE PRECISION
longitude DOUBLE PRECISION
airlines
id UUID PRIMARY KEY
iata_code TEXT
icao_code TEXT
name TEXT
logo_asset_key TEXT NULL
flight_instances
id UUID PRIMARY KEY
operating_airline_id UUID
operating_flight_number TEXT
origin_airport_id UUID
destination_airport_id UUID
scheduled_departure_local_date DATE
current_phase TEXT
is_delayed BOOLEAN
is_cancelled BOOLEAN
is_diverted BOOLEAN
version BIGINT
created_at TIMESTAMPTZ
updated_at TIMESTAMPTZ
Create a composite unique constraint covering the operating carrier, number, origin, destination, and scheduled local departure date.
flight_marketing_numbers
Supports codeshares.
id UUID PRIMARY KEY
flight_instance_id UUID
marketing_airline_id UUID
marketing_flight_number TEXT
flight_status_snapshots
id UUID PRIMARY KEY
flight_instance_id UUID
provider TEXT
provider_observed_at TIMESTAMPTZ
received_at TIMESTAMPTZ
normalized_payload JSONB
raw_payload_reference TEXT NULL
payload_hash TEXT
Partition or archive this table once volume becomes significant.
flight_events
id UUID PRIMARY KEY
flight_instance_id UUID
event_type TEXT
event_time TIMESTAMPTZ
previous_value JSONB NULL
new_value JSONB NULL
source_snapshot_id UUID NULL
deduplication_key TEXT UNIQUE
created_at TIMESTAMPTZ
trips
id UUID PRIMARY KEY
owner_user_id UUID
name TEXT
start_date DATE NULL
end_date DATE NULL
cover_airport_id UUID NULL
version BIGINT
created_at TIMESTAMPTZ
updated_at TIMESTAMPTZ
deleted_at TIMESTAMPTZ NULL
trip_members
Allows shared trips later.
trip_id UUID
user_id UUID
role TEXT
created_at TIMESTAMPTZ
PRIMARY KEY (trip_id, user_id)
trip_legs
id UUID PRIMARY KEY
trip_id UUID
flight_instance_id UUID
position INTEGER
confirmation_code_encrypted TEXT NULL
seat TEXT NULL
user_notes TEXT NULL
version BIGINT
created_at TIMESTAMPTZ
updated_at TIMESTAMPTZ
deleted_at TIMESTAMPTZ NULL
flight_follows
Tracks users who want updates.
user_id UUID
flight_instance_id UUID
notification_level TEXT
created_at TIMESTAMPTZ
PRIMARY KEY (user_id, flight_instance_id)
notification_preferences
id UUID PRIMARY KEY
user_id UUID
event_type TEXT
enabled BOOLEAN
minimum_change_threshold INTEGER NULL
quiet_hours JSONB NULL
notification_deliveries
id UUID PRIMARY KEY
user_id UUID
device_id UUID NULL
flight_event_id UUID
channel TEXT
status TEXT
provider_message_id TEXT NULL
attempt_count INTEGER
last_error TEXT NULL
created_at TIMESTAMPTZ
sent_at TIMESTAMPTZ NULL
provider_flight_references
id UUID PRIMARY KEY
flight_instance_id UUID
provider TEXT
provider_flight_id TEXT
metadata JSONB
UNIQUE (provider, provider_flight_id)
provider_alerts
id UUID PRIMARY KEY
flight_instance_id UUID
provider TEXT
provider_alert_id TEXT
status TEXT
expires_at TIMESTAMPTZ NULL
created_at TIMESTAMPTZ
updated_at TIMESTAMPTZ
share_links
id UUID PRIMARY KEY
resource_type TEXT
resource_id UUID
created_by_user_id UUID
token_hash TEXT UNIQUE
permissions JSONB
expires_at TIMESTAMPTZ NULL
revoked_at TIMESTAMPTZ NULL
created_at TIMESTAMPTZ

## 12. Flight-Data Provider Abstraction
The mobile client must never know which flight-data provider is being used.
The provider interface belongs in the backend.
export interface FlightDataProvider {
  readonly providerName: string;

  searchFlights(
    query: FlightSearchQuery,
  ): Promise<ProviderFlightSearchResult[]>;

  getFlight(
    reference: ProviderFlightReference,
  ): Promise<ProviderFlightSnapshot>;

  getFlightTrack?(
    reference: ProviderFlightReference,
  ): Promise<ProviderTrackPoint[]>;

  createAlert?(
    request: ProviderAlertRequest,
  ): Promise<ProviderAlertRegistration>;

  updateAlert?(
    registration: ProviderAlertRegistration,
    request: ProviderAlertRequest,
  ): Promise<ProviderAlertRegistration>;

  deleteAlert?(
    registration: ProviderAlertRegistration,
  ): Promise<void>;

  verifyWebhook?(
    request: ProviderWebhookRequest,
  ): Promise<boolean>;

  parseWebhook?(
    request: ProviderWebhookRequest,
  ): Promise<ProviderWebhookEvent[]>;

  normalize(
    payload: unknown,
  ): ProviderFlightSnapshot;
}
Provider selection guidance
FlightAware AeroAPI
Potential strengths:
- Current and historical status.
- Flight positions and tracks.
- Predictive arrival information.
- Flight alerts and callback delivery.
- Search by flight, airport, tail number, and related identifiers.
FlightAware documents configurable alerts, callback delivery, status, track, and predictive data. It also explicitly recommends calling AeroAPI from a backend rather than exposing credentials from browser JavaScript.
Cirium
Potential strengths:
- Flight status.
- Schedules.
- Alerts.
- Airport and airline reference information.
- Enterprise aviation datasets.
Cirium exposes flight-status and schedule APIs and offers push-based alert rules.
Amadeus Self-Service
Potential strengths:
- Accessible developer onboarding.
- Flight status.
- Terminal and gate information.
- Delay status.
- Useful for prototypes or supplemental functionality.
Amadeus documents an on-demand status API with updated departure, arrival, terminal, gate, duration, and delay information.
Aviationstack
Potential strengths:
- Easy prototype integration.
- Flight, airport, airline, route, schedule, and historical endpoints.
- Lower initial barrier.
Do not assume its entry-level plan or licensing will satisfy a production consumer application. Commercial usage, caching rights, update frequency, support guarantees, and redistribution rights must be confirmed before launch.
Mandatory provider evaluation criteria
Before selecting a provider, verify:
- B2C mobile redistribution rights.
- Whether airline, airport, aircraft, gate, and tail-number data may be displayed.
- Whether normalized or derived data may be stored.
- Historical-data retention rights.
- Request or result-based pricing.
- Webhook or alert pricing.
- Update latency.
- Global coverage.
- Codeshare quality.
- Cancellation and diversion accuracy.
- Gate and terminal coverage.
- Flight-track availability.
- SLA and support.
- Rate limits.
- Development and production credentials.
- Required attribution.
- Whether user-generated sharing links are permitted.
Do not build production economics around a free API plan.

## 13. Polling and Alert Strategy
Use provider alerts when contractually and technically available. Polling remains necessary for reconciliation and providers without suitable callbacks.
Recommended adaptive polling policy:
Time relative to departure
Poll interval
More than 72 hours
12–24 hours
24–72 hours
3–6 hours
6–24 hours
30–60 minutes
2–6 hours
10–15 minutes
0–2 hours
2–5 minutes
Airborne
1–3 minutes when track data is required
Landed but not at gate
1–3 minutes
Arrived at gate
Stop after final reconciliation
Cancelled
Stop after one later verification
These intervals are recommendations, not provider guarantees. They must be configurable without an application deployment.
Polling job requirements
Every job must be:
- Idempotent.
- Retryable.
- Observable.
- Rate-limit aware.
- Associated with a provider cost estimate.
- Protected by a distributed lock.
- Deduplicated using flight ID and polling window.
- Cancelled when no users follow the flight.
- Rescheduled based on the latest flight phase.

## 14. Snapshot Normalization and Event Generation
Processing pipeline:
Provider response
    ↓
Schema validation
    ↓
Provider-specific normalization
    ↓
Canonical snapshot
    ↓
Hash and duplicate check
    ↓
Persist snapshot
    ↓
Load previous canonical snapshot
    ↓
Calculate meaningful changes
    ↓
Create immutable flight events
    ↓
Update current flight read model
    ↓
Fan out notifications and live updates
Requirements
- Validate every provider response using a runtime schema.
- Never trust undocumented enum values.
- Preserve unknown fields in a debug payload when licensing permits.
- Generate a stable hash for duplicate detection.
- Keep the latest read model directly on or beside the flight instance.
- Keep events immutable.
- Make event generation deterministic and unit-testable.
- Reprocessing the same snapshot must not generate duplicate events.
Example event deduplication key:
{flightInstanceId}:{eventType}:{normalizedValueHash}:{effectiveTimestamp}

## 15. Backend Modules
Start as a modular monolith. Do not create microservices.
API modules
Authentication module
- Verify Supabase JWTs.
- Resolve current user.
- Enforce account state.
- Support account deletion.
Trip module
- Create, update, list, archive, and delete trips.
- Add or remove legs.
- Reorder legs.
- Support optimistic version checks.
Flight search module
- Search provider and local cache.
- Normalize search results.
- Combine codeshares.
- Return clear ambiguity when multiple flights match.
Flight module
- Return current flight state.
- Return event timeline.
- Return tracking data where available.
- Register or release flight follow state.
Device module
- Register an installation.
- Register and rotate notification tokens.
- Disable invalid tokens.
- Store platform capabilities.
Sync module
- Return server changes after a cursor.
- Accept local mutations.
- Return conflicts explicitly.
- Support deletion tombstones.
Sharing module
- Create and revoke share links.
- Return a restricted public view.
- Prevent public endpoints from exposing user notes or confirmation codes.
Entitlement module
- Resolve current paid features.
- Remain independent of RevenueCat, StoreKit, or Google Play implementation.
- Store provider transaction identifiers in a separate integration table.
Worker modules
- Poll scheduler.
- Provider adapters.
- Alert registration.
- Webhook ingestion.
- Snapshot normalizer.
- Event generator.
- Notification planner.
- Push sender.
- Live Activity updater.
- Android Live Update updater.
- Reconciliation jobs.
- Cleanup and archival jobs.

## 16. Public API Contract
Use REST and publish an OpenAPI specification.
Do not introduce GraphQL for the first version. The mobile access patterns are predictable, REST caching is straightforward, and generated Dart clients reduce contract drift.
Core endpoints
POST   /v1/flight-search
GET    /v1/flights/{flightId}
GET    /v1/flights/{flightId}/events
GET    /v1/flights/{flightId}/track

GET    /v1/trips
POST   /v1/trips
GET    /v1/trips/{tripId}
PATCH  /v1/trips/{tripId}
DELETE /v1/trips/{tripId}

POST   /v1/trips/{tripId}/legs
PATCH  /v1/trips/{tripId}/legs/{legId}
DELETE /v1/trips/{tripId}/legs/{legId}

POST   /v1/devices
PUT    /v1/devices/{deviceId}/token
DELETE /v1/devices/{deviceId}

GET    /v1/notification-preferences
PUT    /v1/notification-preferences

POST   /v1/share-links
DELETE /v1/share-links/{shareLinkId}
GET    /v1/shared/{token}

GET    /v1/bootstrap
GET    /v1/sync?cursor={cursor}
POST   /v1/sync/mutations
Internal endpoints
POST /internal/providers/{provider}/webhook
POST /internal/jobs/reconcile-flight
POST /internal/notifications/test
GET  /internal/health/live
GET  /internal/health/ready
Internal endpoints require service authentication and must not rely on obscurity.
API conventions
- JSON only.
- ISO 8601 timestamps with offsets.
- Cursor pagination.
- Request IDs returned in headers.
- Structured error codes.
- Idempotency keys for writes that may be retried.
- ETags for read-heavy flight endpoints.
- Optimistic version fields for editable user data.
- No provider-specific field names in public contracts.
Example error:
{
  "error": {
    "code": "FLIGHT_SEARCH_AMBIGUOUS",
    "message": "More than one flight matched the supplied details.",
    "requestId": "req_01J..."
  }
}

## 17. Mobile Application Layers
Presentation
    ↓
View Models / Controllers
    ↓
Use Cases
    ↓
Repository Interfaces
    ↓
Repository Implementations
    ↓
Remote API + Local Database + Platform Services
Presentation layer
Contains:
- Screens.
- Components.
- Design tokens.
- Animation definitions.
- Accessibility behavior.
- View-only formatting.
It must not call HTTP clients or SQLite directly.
Application layer
Contains use cases such as:
- Search for flights.
- Add a flight to a trip.
- Follow a flight.
- Refresh flight status.
- Reorder trip legs.
- Register a device token.
- Apply sync changes.
Domain layer
Contains:
- Flight and trip entities.
- Value objects.
- Status enums.
- Time formatting rules.
- Repository interfaces.
- Business validation.
Do not put Flutter widget types in the domain layer.
Infrastructure layer
Contains:
- API implementation.
- Drift database.
- Push token implementation.
- Native platform channels.
- Analytics.
- Crash reporting.
- Secure storage.

## 18. Offline-First Strategy
The mobile application should remain useful in airplane mode.
Local database
Store:
- Current user profile.
- Trips.
- Trip legs.
- Followed flight read models.
- Flight event timelines.
- Airport and airline references used by cached trips.
- Pending user mutations.
- Last successful sync cursor.
- Notification preferences.
- Design-safe asset references.
Do not store access tokens in SQLite. Use platform-secure storage.
Source-of-truth rules
Server-authoritative
- Flight status.
- Gates and terminals.
- Delay calculations.
- Provider identifiers.
- Flight events.
- Aircraft and route information.
User-authoritative
- Trip names.
- Notes.
- Flight ordering.
- Notification choices.
- Seat information.
- User labels.
Conflict behavior
- Use field-level last-write-wins for low-risk user metadata.
- Use explicit version conflicts for trip membership and destructive operations.
- Never let stale local flight status overwrite newer server status.
- Use tombstones for deleted trips and legs.
- Queue offline mutations with idempotency IDs.
Sync flow
- Load local data immediately.
- Render cached state.
- Authenticate silently.
- Request changes after the stored sync cursor.
- Apply changes transactionally.
- Upload pending local mutations.
- Resolve or surface conflicts.
- Store the new cursor.
- Refresh visible UI from the local database.
The UI should watch the local database. Network responses should update the database rather than bypassing it.

## 19. Push Notifications and System Live Surfaces
Firebase Cloud Messaging provides cross-platform message delivery, with Apple messages delivered through APNs.
Notification flow
Flight event created
    ↓
Find followers
    ↓
Apply entitlement and preference rules
    ↓
Apply quiet-hour and threshold rules
    ↓
Create notification-delivery records
    ↓
Enqueue push jobs
    ↓
Send through FCM
    ↓
Track success or invalidate token
Notification requirements
- Every notification corresponds to an immutable flight_event.
- Deduplicate by user, event, and channel.
- Use collapse identifiers for rapidly changing estimates.
- Do not send a notification for every location update.
- Gate and cancellation changes are high priority.
- Minor estimated-time fluctuations should use thresholds.
- Notification text must use local airport times where relevant.
- Tapping a notification must deep-link to the relevant flight and timeline event.
- Notification preferences must be evaluated on the server.
iOS Live Activities
Use a Swift ActivityKit extension.
ActivityKit supports starting, updating, and ending Live Activities, including remote updates using push tokens. Live Activities appear on supported system surfaces such as the Lock Screen and Dynamic Island.
FCM also supports remote start, update, and end operations for iOS Live Activities through its HTTP API.
Recommended Live Activity content:
- Flight number.
- Origin and destination.
- Current phase.
- Gate.
- Departure or arrival countdown.
- Delay.
- Progress indicator.
- Arrival estimate.
- Baggage belt after arrival, when available.
Do not continuously update a Live Activity with every aircraft position. Send meaningful phase and timing changes.
Android Live Updates
Android Live Updates provide prominent, progress-oriented notification surfaces for active journeys.
Implement:
- A standard notification fallback for older Android versions.
- An Android Live Update for supported devices.
- A stable notification ID per flight.
- Notification updates rather than repeated new notifications.
- Deep links into flight detail.
- Explicit lifecycle termination after arrival or cancellation.
Native platform interface
The Flutter layer should use an interface similar to:
abstract interface class FlightLiveSurfaceService {
  Future<void> start(FlightLiveSurfacePayload payload);
  Future<void> update(FlightLiveSurfacePayload payload);
  Future<void> end(String flightId);
  Future<bool> isSupported();
}
The shared Dart code must not contain ActivityKit or Android SDK details.

## 20. iPadOS and Large-Screen Behavior
Do not stretch the phone interface across an iPad.
Define layout classes:
compact
medium
expanded
Recommended behavior:
Compact
- Bottom navigation.
- Single-column flight detail.
- Full-screen search.
- Collapsible cards.
Medium
- Navigation rail or adaptive sidebar.
- Wider timeline.
- Optional secondary information panel.
Expanded
- Persistent trip list on the left.
- Selected flight detail in the center.
- Context panel for airport, map, or timeline information.
- Keyboard and pointer support.
- Landscape-first optimization.
Every major screen must have approved compact and expanded designs before being marked complete.

## 21. Claude Design-to-Code Contract
The coding agent must not improvise finished visual design when a Claude Design specification exists.
Required design deliverables
Each completed screen should have:
- Screen name and route.
- Compact layout.
- Expanded layout when applicable.
- Loading state.
- Empty state.
- Offline state.
- Error state.
- Partial-data state.
- Long-text behavior.
- Dark-mode behavior.
- Accessibility notes.
- Animation and transition notes.
- Component names.
- Token references.
- Asset references.
Design directory convention
design/
├── tokens/
│   ├── colors.json
│   ├── typography.json
│   ├── spacing.json
│   ├── radii.json
│   ├── elevation.json
│   └── motion.json
│
├── components/
│   ├── flight-card.md
│   ├── status-pill.md
│   ├── timeline-event.md
│   ├── airport-code.md
│   └── delay-indicator.md
│
├── screens/
│   ├── home/
│   ├── flight-search/
│   ├── flight-detail/
│   ├── trip-detail/
│   └── account/
│
├── flows/
│   ├── add-flight.md
│   ├── onboarding.md
│   └── share-trip.md
│
└── assets/
Design token rules
Do not use raw visual values throughout feature code.
Incorrect:
color: const Color(0xFF111827)
padding: const EdgeInsets.all(18)
borderRadius: BorderRadius.circular(17)
Correct:
color: context.colors.surfacePrimary
padding: EdgeInsets.all(context.spacing.md)
borderRadius: BorderRadius.circular(context.radii.card)
Use semantic names:
surfacePrimary
surfaceElevated
textPrimary
textSecondary
statusOnTime
statusDelayed
statusCancelled
borderSubtle
accentPrimary
Do not name tokens after a visual color such as blue500 in feature code.
Component mapping
Every design component must map to exactly one primary code component.
Example:
Design component: Flight Status Pill
Code component: FlightStatusPill
Source: lib/design_system/components/flight_status_pill.dart
Golden tests:
- on_time
- delayed
- cancelled
- diverted
- dark_mode
- large_text
Definition of design-ready
A screen is ready for implementation only when:
- The route and purpose are known.
- Primary states are designed.
- Required API data is identified.
- Components are named.
- Tokens are defined.
- Interaction behavior is documented.
- Platform differences are documented.
Minor missing details may be filled using the existing design system. The coding agent must not create an entirely new visual pattern to work around missing design direction.

## 22. Primary Screens
MVP screens
Onboarding
- Value proposition.
- Notification explanation.
- Optional account creation.
- Sign in with Apple and Google if account authentication is required.
Home / Upcoming
- Next flight hero.
- Upcoming trips.
- Recent activity.
- Add-flight action.
- Empty state.
Flight Search
Search inputs:
- Flight number and date.
- Origin, destination, and date.
- Optional airline selector.
Results must show enough information to disambiguate codeshares and repeated routes.
Flight Detail
Sections:
- Primary route summary.
- Current status.
- Scheduled and updated times.
- Terminal and gate.
- Delay.
- Progress timeline.
- Aircraft.
- Flight duration.
- Track map if licensed.
- Event history.
- Sharing.
- Notification controls.
Trip Detail
- Ordered flight legs.
- Connection duration.
- Airport transitions.
- Trip notes.
- Share action.
Notifications
- Event-level preferences.
- Quiet hours.
- Live-surface status.
Account
- Profile.
- Home airport.
- Subscription.
- Data export.
- Account deletion.
- Privacy and attribution.

## 23. Maps and Flight Tracks
Treat maps as an enhancement, not the source of truth.
Rules:
- The timeline and status must remain usable without map data.
- Do not draw a straight-line route and imply that it is the actual track.
- Clearly distinguish scheduled route, estimated route, and observed track.
- Simplify track points before sending them to mobile.
- Cache static airport coordinates.
- Avoid repeatedly downloading unchanged tracks.
- Confirm the provider contract permits storage and display of track data.
For the MVP, a route arc between airports is sufficient if clearly labeled as a route visualization rather than live tracking.

## 24. Search and Codeshares
Flight search must handle:
- Marketing flight number.
- Operating flight number.
- Codeshares.
- Overnight flights.
- Flights with the same number on different routes.
- Local departure dates.
- Cancelled flights.
- Schedule changes.
- Airport code aliases.
- Users entering a date based on their own timezone.
Search results should contain:
{
  "candidateId": "temporary-search-result-id",
  "marketingFlightNumber": "UA 123",
  "operatingFlightNumber": "LH 456",
  "origin": "ORD",
  "destination": "FRA",
  "scheduledDepartureUtc": "...",
  "departureTimezone": "America/Chicago",
  "scheduledArrivalUtc": "...",
  "arrivalTimezone": "Europe/Berlin",
  "status": "SCHEDULED"
}
Adding a result must resolve it to a canonical flight_instance.

## 25. Security and Privacy
Secrets
- Flight-provider credentials remain on the server.
- FCM service credentials remain on the server.
- Database service-role keys remain on the server.
- Mobile applications receive only public client keys intended for distribution.
- Never place secrets in checked-in configuration files.
Authentication
- Validate JWTs in the API.
- Use short-lived access tokens and refresh tokens.
- Store mobile tokens in Keychain or Android Keystore-backed storage.
- Revoke device sessions when requested.
- Require recent authentication before destructive account actions.
Database authorization
- Apply Row Level Security to user-owned tables if clients access Supabase directly.
- Prefer API-mediated writes for complex domain operations.
- Service-role operations must be isolated to trusted backend processes.
- Public share views must query restricted projections rather than full trip records.
Supabase Auth can integrate user identity with PostgreSQL Row Level Security.
Confirmation codes
Booking confirmation codes are sensitive.
- Do not include them in analytics.
- Encrypt them at the application layer if stored.
- Exclude them from logs.
- Never include them in share links by default.
- Do not collect them until a concrete feature requires them.
Webhooks
- Use HTTPS.
- Verify provider signatures or shared tokens.
- Apply replay protection.
- Store webhook receipt IDs.
- Return quickly and enqueue processing.
- Do not perform expensive normalization in the request thread.
Privacy
- Collect minimal personal information.
- Provide account deletion.
- Provide data export.
- Define retention for raw provider responses.
- Avoid continuous user-location collection unless a later feature explicitly requires it.
- Document analytics events.
- Do not send flight confirmation information to analytics or crash tools.

## 26. Provider Licensing and Data Compliance
This is a launch-blocking requirement.
Before production:
- Obtain written confirmation that the selected provider permits consumer mobile display.
- Confirm caching and retention rules.
- Confirm whether flight-history storage is permitted.
- Confirm whether shared public links are allowed.
- Confirm attribution requirements.
- Confirm airline and airport logo usage rights.
- Confirm whether derivative delay statistics may be generated.
- Confirm whether data may be used for machine-learning features.
- Confirm whether screenshots containing provider data may be used in marketing.
Create:
docs/compliance/flight-data-license-matrix.md
Do not rely on assumptions from an API pricing page. Provider licensing tiers may distinguish personal, standard, premium, B2C, and B2B use.

## 27. Observability
Every service must emit structured logs.
Required common fields
timestamp
level
service
environment
request_id
job_id
user_id_hash
flight_instance_id
provider
provider_request_id
event_type
duration_ms
error_code
Do not log access tokens, provider secrets, confirmation codes, or raw push tokens.
Metrics
Track:
- API latency.
- API error rate.
- Provider latency.
- Provider error and rate-limit counts.
- Provider request cost estimates.
- Polling jobs scheduled and completed.
- Webhook delay.
- Snapshot-to-event processing delay.
- Push success and failure rates.
- Invalid device-token rate.
- Active followed flights.
- Polls per followed flight.
- Cache hit rate.
- Sync conflicts.
- Mobile crash-free sessions.
- Mobile cold-start time.
- Flight-detail render time.
Alerts
Create operational alerts for:
- Provider failure spike.
- Webhooks not received.
- Queue backlog.
- Push failure spike.
- Polling jobs delayed.
- Database connection exhaustion.
- API error-rate threshold.
- Unusually high provider cost.
- No flight events processed during normally active periods.

## 28. Testing Strategy
Domain unit tests
Cover:
- Flight identity.
- Codeshare mapping.
- Timezone conversion.
- Status normalization.
- Snapshot comparison.
- Event generation.
- Notification thresholds.
- Poll scheduling.
- Sync conflict resolution.
Provider contract tests
Store sanitized provider fixtures.
For each provider:
- Validate known payloads.
- Validate missing fields.
- Validate new unknown enum values.
- Validate cancellation.
- Validate diversion.
- Validate codeshares.
- Validate overnight flight.
- Validate gate change.
- Validate delayed departure.
- Validate malformed webhook.
Provider tests must run without calling the paid API.
Backend integration tests
Use disposable PostgreSQL and Redis instances.
Test:
- Trip creation.
- Adding a flight.
- Duplicate flight following.
- Snapshot ingestion.
- Event creation.
- Notification fanout.
- Webhook idempotency.
- Account deletion.
- Share-link access restrictions.
Mobile tests
Unit
- View models.
- Repositories.
- Formatters.
- Sync engine.
- Notification deep links.
Widget
- Flight card states.
- Timeline events.
- Loading and offline states.
- Large-text behavior.
Golden screenshot
At minimum:
- Light mode.
- Dark mode.
- Compact screen.
- Expanded screen.
- On-time.
- Delayed.
- Cancelled.
- Diverted.
- Missing gate.
- Long airport name.
- Large accessibility font.
End-to-end
Critical paths:
- Search and add a flight.
- Open a cached trip offline.
- Receive a gate-change notification.
- Deep-link from notification.
- Start and end a live system surface.
- Share and revoke a trip link.
- Sign out and sign back in.
- Delete account.
Performance tests
- Flight detail scroll performance.
- Timeline with hundreds of events.
- Map track with thousands of source points.
- Cold start with multiple cached trips.
- Large sync payload.
- Notification burst after provider recovery.

## 29. CI/CD
Pull-request pipeline
Run:
- Formatting.
- Static analysis.
- Unit tests.
- Provider contract tests.
- Database migration validation.
- OpenAPI compatibility checks.
- Generated-client drift check.
- Flutter widget tests.
- Selected golden tests.
- Backend container build.
- Secret scanning.
Main-branch pipeline
Additionally:
- Deploy API to staging.
- Deploy worker to staging.
- Apply staging migrations.
- Build internal Android artifact.
- Build iOS TestFlight artifact when signing is available.
- Run staging smoke tests.
Production release
- Database migration reviewed.
- Provider contract tests pass.
- Backward-compatible mobile API confirmed.
- Mobile minimum-supported API version checked.
- Worker queue drained or migration-safe.
- Monitoring dashboards open.
- Rollback plan documented.
- Feature flags used for risky provider or notification changes.
The API must remain compatible with at least the currently released mobile version and one prior supported version.

## 30. Feature Flags
Implement server-controlled flags for:
- Flight-track map.
- Live Activities.
- Android Live Updates.
- Provider selection.
- Polling cadence changes.
- Sharing.
- Subscription paywall.
- Experimental statistics.
- New normalization rules.
Flags should support:
- Environment targeting.
- Application version targeting.
- Platform targeting.
- Percentage rollout.
- Emergency disable.
Do not use feature flags to conceal unfinished security controls.

## 31. Initial Engineering Milestones
Milestone 0 — Architecture spikes
Deliver:
- Flutter project builds on Android and iOS.
- One responsive design-system demonstration screen.
- Swift ActivityKit proof of concept.
- Kotlin Live Update proof of concept.
- Local SQLite proof of concept.
- Mock backend contract.
- Architecture decision records.
Exit criteria:
- No unresolved framework blocker.
- Development builds install on physical devices.
- Native bridge can start, update, and stop a test live surface.
Milestone 1 — Design system and offline shell
Deliver:
- Token system.
- Typography.
- Themes.
- Core components.
- Navigation.
- Local database.
- Mock trips.
- Home screen.
- Flight-detail screen using fixtures.
- Compact and expanded layouts.
- Golden tests.
Do not integrate paid flight data before the fixture-driven interface is stable.
Milestone 2 — Authentication and trips
Deliver:
- Supabase environments.
- Database migrations.
- Authentication.
- Profile.
- Trip CRUD.
- Device registration.
- Offline mutation queue.
- Basic sync.
Milestone 3 — Flight provider integration
Deliver:
- One provider adapter.
- Flight search.
- Canonical flight creation.
- Codeshare handling.
- Snapshot persistence.
- Current read model.
- Cost and latency metrics.
Milestone 4 — Events and notifications
Deliver:
- Deterministic event generator.
- Notification preferences.
- FCM integration.
- Gate, delay, cancellation, departure, and arrival notifications.
- Notification deep links.
- Delivery audit records.
Milestone 5 — Live system surfaces
Deliver:
- iOS Live Activity.
- Android Live Update.
- Fallback notifications.
- Remote updates.
- Lifecycle termination.
- Device-capability handling.
Milestone 6 — Sharing and launch readiness
Deliver:
- Share links.
- Privacy controls.
- Account deletion.
- Analytics.
- Crash monitoring.
- Accessibility audit.
- Provider licensing checklist.
- Store metadata and screenshots.
- Load and failure testing.

## 32. Coding-Agent Operating Rules
The coding agent must follow these instructions.
Before implementing a feature
- Read the relevant design specification.
- Identify affected domain entities.
- Identify required API changes.
- Update the OpenAPI contract first.
- Add or update database migrations.
- Define failure, empty, loading, offline, and partial-data states.
- Write tests for domain behavior before UI wiring.
During implementation
- Make small, reviewable commits.
- Do not replace stable architecture without an ADR.
- Do not add a dependency when a small internal implementation is sufficient.
- Do not expose provider payloads to mobile.
- Do not access the flight provider from mobile.
- Do not place business rules in widgets.
- Do not duplicate normalization logic between API and worker.
- Do not create a microservice for each module.
- Do not use raw colors or spacing in feature code.
- Do not silently swallow provider errors.
- Do not create notifications directly from provider webhook handlers.
- Do not use device time as authoritative flight time.
- Do not implement screens without offline and error states.
- Do not modify generated API files manually.
When requirements are ambiguous
Prefer, in order:
- Existing design documentation.
- Existing architecture decisions.
- Existing domain conventions.
- The least irreversible implementation.
- A clearly documented assumption.
Do not invent a provider-specific requirement and present it as a product requirement.
Definition of done
A feature is complete only when:
- Domain behavior is tested.
- API contract is updated.
- Database migration exists if required.
- Mobile loading, empty, error, offline, and success states exist.
- Accessibility labels are present.
- Analytics events are documented.
- Logs contain appropriate context.
- No secrets or sensitive values are logged.
- Compact and expanded layouts are checked.
- Relevant screenshot tests pass.
- Documentation is updated.

## 33. Architecture Decisions That Must Be Recorded
Create an ADR for each of the following:
ADR-001 Mobile framework selection
ADR-002 Backend platform selection
ADR-003 Flight-data provider selection
ADR-004 REST and OpenAPI
ADR-005 Offline-first local database
ADR-006 Flight identity and codeshares
ADR-007 Snapshot and event model
ADR-008 Push-notification provider
ADR-009 Native live-surface integration
ADR-010 Authentication and account model
ADR-011 Sharing security model
ADR-012 Subscription and entitlement model
ADR format:
Title
Status
Context
Decision
Alternatives considered
Consequences
Migration or reversal strategy
Date

## 34. Deliberate Non-Goals for the First Release
Do not include these in the initial implementation unless the core product is already stable:
- Flight booking.
- Check-in automation.
- Email inbox scraping.
- Loyalty-account integrations.
- Visa or passport storage.
- Social travel network.
- AI travel concierge.
- Automatic compensation claims.
- Complex airport indoor navigation.
- Full desktop or web application.
- Wearable application.
- Predictive delay model trained internally.
- Multiple simultaneous flight-data providers in production.
The architecture should permit later additions, but the MVP should not carry their implementation complexity.

## 35. Product Decisions Still Requiring Owner Approval
The architecture can proceed while these remain open, but they must be resolved before production launch:
- Final product name and bundle identifiers.
- Launch countries.
- Minimum Android version.
- Minimum iOS version.
- Whether account creation is mandatory.
- Whether anonymous local trips are supported.
- Primary flight-data provider and monthly data budget.
- Free-tier flight limits.
- Subscription model.
- Historical-flight retention period.
- Whether flight tracks are included in the MVP.
- Whether trip sharing supports guests.
- Whether confirmation codes or seat information are stored.
- Whether airline and airport logos will be licensed.
- Required accessibility standard.
- Required languages at launch.
Defaults may be used for development, but production assumptions must be documented.

## 36. Final Instruction to the Coding Agent
Build this application as a reliable flight-information system with an exceptional mobile interface, not as a collection of screens calling a flight API.
The critical boundaries are:
Design system
    ≠ feature-specific styling

Mobile domain
    ≠ provider payload

Local database
    ≠ temporary cache

Flight snapshot
    ≠ flight event

Push notification
    ≠ source of truth

Cross-platform UI
    ≠ prohibition on native code

Modular monolith
    ≠ unstructured monolith
Prioritize the following, in order:
- Correct flight identity and time handling.
- Provider-independent normalization.
- Reliable offline access.
- Meaningful event generation.
- Notification correctness.
- Native live-surface lifecycle.
- Visual fidelity to the approved Claude Design specifications.
- Performance.
- Additional features.
A beautiful interface displaying stale, duplicated, incorrectly timed, or misidentified flight data is not a successful product.
