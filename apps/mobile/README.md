# Cirrava mobile

Flutter vertical slice for iPhone and Android. The current build supports one
anonymous Flight Follow from fixture-backed search through cached home and
detail views.

## Local commands

From `apps/mobile`:

```sh
../../.tooling/flutter/bin/flutter pub get
../../.tooling/flutter/bin/flutter analyze --no-pub
../../.tooling/flutter/bin/flutter test --no-pub
```

The optional visual comparison harness regenerates the phone captures checked
into `design/implementation`:

```sh
../../.tooling/flutter/bin/flutter test --no-pub --update-goldens \
  tool/visual_capture_test.dart
```

## Current boundaries

- Flight data is deterministic fixture data, not live provider data.
- The anonymous limit is one active Flight Follow.
- SQLite persists search results and the followed flight on-device.
- Authentication, notifications, live activities/updates, trips, radar, and
  passport history are intentionally outside this slice.

The Terrella Claude Design export in `design/reference/claude-terrella` is the
visual source of truth.
