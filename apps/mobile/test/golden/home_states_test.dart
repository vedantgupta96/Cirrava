import 'dart:async';
import 'dart:io';

import 'package:cirrava_mobile/app/providers.dart';
import 'package:cirrava_mobile/core/domain/flight.dart';
import 'package:cirrava_mobile/core/domain/flight_follow.dart';
import 'package:cirrava_mobile/design_system/app_theme.dart';
import 'package:cirrava_mobile/features/home/home_screen.dart';
import 'package:cirrava_mobile/infrastructure/persistence/app_database.dart';
import 'package:cirrava_mobile/infrastructure/persistence/drift_flight_repository.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

/// Pinned "now" so freshness ages are deterministic.
final _now = DateTime.utc(2026, 7, 24, 0, 0);

/// A fresh, on-time boarding snapshot. Individual tests copy-and-tweak it so
/// each golden differs in exactly one dimension.
FlightSnapshot _baseFlight({DateTime? observedAt}) {
  final scheduledDep = DateTime.utc(2026, 7, 24, 0, 40);
  final scheduledArr = DateTime.utc(2026, 7, 24, 6, 11);
  return FlightSnapshot(
    id: 'golden-dl442',
    operatingCarrierCode: 'DL',
    operatingCarrierName: 'Delta',
    flightNumber: '442',
    originCode: 'ATL',
    originName: 'Atlanta',
    destinationCode: 'JFK',
    destinationName: 'New York Kennedy',
    scheduledDepartureUtc: scheduledDep,
    estimatedDepartureUtc: scheduledDep,
    scheduledArrivalUtc: scheduledArr,
    estimatedArrivalUtc: scheduledArr,
    originTimeZone: 'America/New_York',
    destinationTimeZone: 'America/New_York',
    phase: FlightPhase.boarding,
    disruptions: const {},
    codeshareAliases: const [],
    observedAt: observedAt ?? _now.subtract(const Duration(minutes: 2)),
    originTerminal: '2',
    originGate: 'B22',
    destinationTerminal: '4',
    destinationGate: 'B4',
  );
}

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await Future.wait([
      _loadFont('SpaceGrotesk', 'assets/fonts/SpaceGrotesk-Variable.ttf'),
      _loadFont('SpaceMono', 'assets/fonts/SpaceMono-Regular.ttf'),
      _loadFont(
        'MaterialIcons',
        '../../.tooling/flutter/bin/cache/artifacts/material_fonts/'
            'MaterialIcons-Regular.otf',
      ),
    ]);
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    required String golden,
    List<FlightSnapshot> flights = const [],
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = DriftFlightRepository(database);
    for (final flight in flights) {
      await repository.cacheSearchResults('golden', [flight]);
      await repository.follow(flight.id);
    }

    await withClock(Clock.fixed(_now), () async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(database)],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // Pin the platform so the FAB-vs-inline-add branch is
            // deterministic regardless of the host running the test.
            theme: AppTheme.dark.copyWith(platform: TargetPlatform.android),
            // Override MediaQuery below MaterialApp (which otherwise resets it
            // from the test view) so the globe honours reduced motion and the
            // requested text scale, keeping every golden deterministic.
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                disableAnimations: true,
                textScaler: TextScaler.linear(textScale),
              ),
              child: child!,
            ),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
    });

    await expectLater(
      find.byKey(const Key('home-screen')),
      matchesGoldenFile('goldens/$golden.png'),
    );

    // Unmount and pump so Drift's stream-close timer fires before the test
    // framework checks for pending timers.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('tracked flight, fresh', (tester) async {
    await pumpHome(tester, flights: [_baseFlight()], golden: 'home_tracked');
  });

  testWidgets('no follows (empty hero)', (tester) async {
    await pumpHome(tester, golden: 'home_empty');
  });

  testWidgets('tracked flight, stale', (tester) async {
    await pumpHome(
      tester,
      flights: [
        _baseFlight(observedAt: _now.subtract(const Duration(hours: 3))),
      ],
      golden: 'home_stale',
    );
  });

  testWidgets('tracked flight, refresh failed', (tester) async {
    // Simulate a failed refresh that retains the previously accepted value:
    // emit the accepted list, then push the provider into an error state.
    // The home screen must keep rendering the card (Change 1) and mark
    // freshness stale (Change 2), rather than replacing it with an error
    // screen.
    final controller = StreamController<List<FollowedFlight>>();
    addTearDown(controller.close);

    // Build the accepted value directly rather than reading it back through
    // the repository: awaiting a Drift stream inside testWidgets deadlocks,
    // because the test body runs under FakeAsync and the stream's timer never
    // fires without a pump. This test overrides activeFollowsProvider anyway,
    // so no database is involved.
    final flight = _baseFlight();
    final accepted = [
      FollowedFlight(
        follow: FlightFollow(
          id: 'follow-${flight.id}',
          flightId: flight.id,
          createdAt: _now,
        ),
        flight: flight,
      ),
    ];

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await withClock(Clock.fixed(_now), () async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeFollowsProvider.overrideWith((ref) => controller.stream),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark.copyWith(platform: TargetPlatform.android),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                disableAnimations: true,
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            ),
            home: const HomeScreen(),
          ),
        ),
      );

      controller.add(accepted);
      await tester.pump();
      controller.addError('refresh failed');
      await tester.pump(const Duration(milliseconds: 50));
    });

    expect(find.byKey(const Key('tracked-flight-card')), findsOneWidget);

    await expectLater(
      find.byKey(const Key('home-screen')),
      matchesGoldenFile('goldens/home_refresh_failed.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('large accessibility text', (tester) async {
    await pumpHome(
      tester,
      flights: [_baseFlight()],
      golden: 'home_large_text',
      textScale: 1.6,
    );
  });
}

Future<void> _loadFont(String family, String path) async {
  final bytes = await File(path).readAsBytes();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}
