# Cirrava v1 Experience

This working specification records agreed v1 product behavior. Architecture decisions and domain definitions remain authoritative in `docs/adr/` and `CONTEXT.md`.

## Core Job

A user can find one upcoming Supported Flight, create a Flight Follow, understand its current state through arrival, receive important operational updates, and reopen the last accepted state without network access. A Flight Follow does not imply that the user is a passenger.

Trips, sharing, multi-device sync, maps, flight statistics, baggage-claim information, subscriptions, and custom notification preferences are outside the core v1 experience.

V1 never requests or stores airline confirmation codes, ticket numbers, loyalty identifiers, or seat assignments. Search and Follow creation use only public operational flight information; Cirrava does not establish that a follower is a passenger.

V1 does not display airline or airport logos, liveries, or other protected brand artwork unless Cirrava obtains written rights covering in-app use, notifications, live surfaces, and store marketing. It uses airline and airport names or codes with Cirrava-owned generic iconography and does not imply affiliation or endorsement.

## Flight Follow Lifecycle

- A Trip is not required to follow a flight.
- A Follow targets one canonical operating Flight Instance; marketing codeshares are aliases.
- A reschedule preserves the Flight Instance when provider continuity establishes the same operation, including across local midnight.
- A replacement after cancellation is a separate, linked Flight Instance. Cirrava does not silently move the Follow; it offers an explicit one-tap action.
- A Follow completes after a server-confirmed terminal outcome and final reconciliation: arrival at gate, cancellation, or completed diversion.
- A completed Follow remains as read-only local state for 24 hours and then leaves the visible v1 experience. The completed Follow does not consume an active slot during that window.

## Anonymous Use and Accounts

- No account is required to experience the core job.
- An Anonymous User may have exactly one Active Flight Follow.
- An Account Holder may have at most five Active Flight Follows in v1; Completed Flight Follows do not count against the limit.
- Converting to an Account Holder transfers the existing Follow, notification continuity, and cached timeline automatically.
- V1 account creation and sign-in use a six-digit email one-time code. Passwords and social sign-in providers are out of scope.
- When an Anonymous User attempts to create a second Follow, Cirrava completes account conversion and transfers the existing Follow before creating the additional one.
- V1 has no subscription or paid entitlement. Anonymous use and account capabilities are free within their respective Follow limits.
- Additional active follows require an account. Account holders do not receive a history screen in v1. Trips, durable history, sync and recovery, sharing, and custom notification preferences also require an account when those features are introduced.

## Notifications

Anonymous v1 notifications use a fixed policy:

- terminal or gate assigned or changed;
- delay reaches 15 minutes or changes materially thereafter;
- boarding or gate closed;
- cancellation, diversion, return to gate, or replacement identified;
- departed, landed, or arrived at gate.

A repeat delay notification is eligible only when the estimate moves at least 15 minutes from the last notified estimate or crosses back below the 15-minute threshold. Every notification remains subject to operating-system controls and a server-side Notification Decision.

Cirrava requests notification permission only when the user starts their first Follow. It first explains the relevant updates and then presents the system prompt. Denial does not block the Follow; the flight experience shows that notifications are off and provides a route to system Settings.

## Cached and Offline Behavior

- The UI renders Cached Flight State immediately and identifies when it was last updated.
- Stale or offline state remains visible and clearly labeled; a failed refresh never replaces accepted state with an error screen.
- The local database is the sole source read by the UI. Network responses are normalized and committed transactionally before presentation.
- Offline v1 is read-only except for unfollow. Unfollow takes effect locally and queues server removal.
- Search and starting a new Follow require network access.

## Launch Surfaces

- V1 is distributed only through the United States App Store and Google Play market. Supported Flights still include international services arriving in or departing from a U.S. airport.
- V1 user-facing copy and store metadata are U.S. English. UI strings are externalized for localization, and dates, times, numbers, and time zones use locale-aware formatting from the start.
- Public v1 supports iPhone and Android phones together.
- The minimum iPhone version is iOS 17.2 so a Follow can remotely start a Live Activity when its flight becomes imminent.
- The minimum Android version is Android 10/API 29. Android 16/API 36 and newer receive a promoted Live Update; Android 10 through 15 receive a persistent, updating flight-status notification.
- Each platform includes a narrow Live Flight Surface showing phase, relevant time, delay, terminal, gate, and terminal outcome.
- Live Flight Surfaces exclude maps, aircraft animation, route telemetry, secondary actions, and direct provider access.
- Baggage-claim belts are excluded even when a provider supplies them; a Follow ends at its reconciled terminal outcome.
- A Live Flight Surface starts automatically three hours before scheduled departure, or immediately when a Follow is created inside that window. Earlier disruptions use eligible notifications without maintaining a live surface.
- The surface ends after the server reconciles a terminal outcome and leaves its final state visible for one hour before dismissal.
- iPad, tablets, web, desktop, and wearables are not supported v1 targets.

## Accessibility Release Gate

V1 targets WCAG 2.2 Level AA as its baseline and does not claim conformance until the implemented experience is tested. Release requires:

- completing search, Follow creation, and flight detail with VoiceOver on iPhone and TalkBack on Android;
- semantic labels, roles, states, and logical reading order for every actionable or changing element;
- scalable system text without clipping, overlap, or loss of critical flight information;
- flight phase, disruption, freshness, and notification state communicated by text or shape as well as color;
- primary touch targets of at least 44 by 44 points on iOS and 48 by 48 density-independent pixels on Android;
- sufficient text, icon, component, and focus contrast in every supported theme;
- single-pointer alternatives for gestures and no gesture-only critical action;
- reduced-motion behavior that preserves state communication without unnecessary movement;
- accessible announcements for meaningful live changes without reading every telemetry update;
- manual testing of each platform's Live Flight Surface with its screen reader and large-text settings.
