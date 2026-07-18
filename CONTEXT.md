# Cirrava

Cirrava is a consumer flight-tracking context centered on reliably following a specific flight from discovery through arrival.

## Language

**Flight Instance**:
A specific operating service segment. It remains the same Flight Instance through schedule changes when continuity indicates the same operation; marketing flight numbers and provider identifiers may refer to it but do not define it.
_Avoid_: Flight record, route

**Codeshare Alias**:
A marketing carrier and flight number that refers to a Flight Instance operated under another carrier or flight number.
_Avoid_: Codeshare flight, duplicate flight

**Replacement Flight**:
A distinct Flight Instance designated to replace a cancelled Flight Instance while preserving both operations' histories.
_Avoid_: Rescheduled flight, rewritten flight

**Flight Phase**:
The single current stage of a Flight Instance's operation, such as scheduled, boarding, en route, landed, or arrived at gate.
_Avoid_: Status

**Disruption Condition**:
An independent condition affecting a Flight Instance, such as delayed, cancelled, diverted, or returned to gate. A disruption may coexist with a Flight Phase.
_Avoid_: Phase, primary status

**Flight Snapshot**:
A normalized observation of a Flight Instance's current state at a point in time.
_Avoid_: Flight Event, status event

**Flight Event**:
An immutable record of a meaningful normalized change derived from one or more Flight Snapshots.
_Avoid_: Poll result, provider update, notification

**Flight Telemetry**:
High-frequency observations such as aircraft position, altitude, speed, and route points that describe movement without forming the human-readable Flight Event history.
_Avoid_: Flight Event, timeline event

**Notification Decision**:
The server-side determination of whether and how a Flight Event should notify a follower after applying severity, thresholds, preferences, and delivery eligibility.
_Avoid_: Flight Event, push notification

**Material Delay**:
A departure or arrival delay of at least 15 minutes. After notification, it changes materially when the estimate moves by another 15 minutes or crosses back below the threshold.
_Avoid_: Minor delay, any estimate change

**Cached Flight State**:
The last accepted normalized state of a followed Flight Instance retained on the device for immediate presentation without network access.
_Avoid_: Temporary cache, offline copy

**Data Freshness**:
The age of the displayed Cached Flight State relative to its last accepted observation.
_Avoid_: Current time, sync status

**Flight Follow**:
A user's intent to monitor one Flight Instance and receive its current information and eligible updates. It does not imply that the user is traveling on the flight.
_Avoid_: Subscription, watched flight, tracked flight

**Active Flight Follow**:
A Flight Follow whose Flight Instance has not completed a server-confirmed terminal outcome and final reconciliation.
_Avoid_: Ongoing tracking, live flight

**Completed Flight Follow**:
A Flight Follow whose Flight Instance has completed a server-confirmed terminal outcome and final reconciliation.
_Avoid_: Archived flight, inactive flight

**Trip**:
An optional user-defined grouping of related Flight Instances. A Trip is not required to create a Flight Follow.
_Avoid_: Itinerary, journey

**Anonymous User**:
A user without a persistent Cirrava account, limited to one active Flight Follow.
_Avoid_: Guest

**Account Holder**:
A user with a persistent Cirrava account.
_Avoid_: Registered user, member

**Supported Flight**:
A scheduled commercial Flight Instance whose origin or destination is a U.S. airport.
_Avoid_: Worldwide flight, domestic-only flight

**Live Flight Surface**:
A platform-native, glanceable presentation of an Active Flight Follow outside the open Cirrava app, implemented as an iOS Live Activity or Android Live Update.
_Avoid_: Widget, notification, live map
