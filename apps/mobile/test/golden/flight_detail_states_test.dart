import 'dart:io';

import 'package:cirrava_mobile/app/providers.dart';
import 'package:cirrava_mobile/core/domain/flight.dart';
import 'package:cirrava_mobile/design_system/app_theme.dart';
import 'package:cirrava_mobile/features/flight_detail/flight_detail_screen.dart';
import 'package:cirrava_mobile/infrastructure/persistence/app_database.dart';
import 'package:cirrava_mobile/infrastructure/persistence/drift_flight_repository.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

/// Pinned "now" so freshness ages and countdowns are deterministic.
final _now = DateTime.utc(2026, 7, 24, 0, 0);

/// A fresh, on-time boarding snapshot. Individual tests copy-and-tweak it so
/// each golden differs in exactly one dimension.
FlightSnapshot _baseFlight({
  Set<DisruptionCondition> disruptions = const {},
  FlightPhase phase = FlightPhase.boarding,
  Duration departureDelay = Duration.zero,
  DateTime? observedAt,
  String? originGate = 'B22',
  String? originTerminal = '2',
}) {
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
    estimatedDepartureUtc: scheduledDep.add(departureDelay),
    scheduledArrivalUtc: scheduledArr,
    estimatedArrivalUtc: scheduledArr.add(departureDelay),
    originTimeZone: 'America/New_York',
    destinationTimeZone: 'America/New_York',
    phase: phase,
    disruptions: disruptions,
    codeshareAliases: const [],
    observedAt: observedAt ?? _now.subtract(const Duration(minutes: 2)),
    originTerminal: originTerminal,
    originGate: originGate,
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

  Future<void> pumpState(
    WidgetTester tester, {
    required FlightSnapshot flight,
    required String golden,
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = DriftFlightRepository(database);
    await repository.cacheSearchResults('golden', [flight]);

    await withClock(Clock.fixed(_now), () async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(database)],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
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
            home: const FlightDetailScreen(flightId: 'golden-dl442'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
    });

    await expectLater(
      find.byKey(const Key('flight-detail-screen')),
      matchesGoldenFile('goldens/$golden.png'),
    );

    // Unmount and pump so Drift's stream-close timer fires before the test
    // framework checks for pending timers.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('on time', (tester) async {
    await pumpState(tester, flight: _baseFlight(), golden: 'detail_on_time');
  });

  testWidgets('delayed', (tester) async {
    await pumpState(
      tester,
      flight: _baseFlight(
        disruptions: const {DisruptionCondition.delayed},
        departureDelay: const Duration(minutes: 45),
      ),
      golden: 'detail_delayed',
    );
  });

  testWidgets('cancelled', (tester) async {
    await pumpState(
      tester,
      flight: _baseFlight(disruptions: const {DisruptionCondition.cancelled}),
      golden: 'detail_cancelled',
    );
  });

  testWidgets('diverted', (tester) async {
    await pumpState(
      tester,
      flight: _baseFlight(
        disruptions: const {DisruptionCondition.diverted},
        phase: FlightPhase.enRoute,
      ),
      golden: 'detail_diverted',
    );
  });

  testWidgets('offline / stale cached state', (tester) async {
    await pumpState(
      tester,
      flight: _baseFlight(
        observedAt: _now.subtract(const Duration(hours: 3)),
      ),
      golden: 'detail_stale',
    );
  });

  testWidgets('missing gate and terminal (partial data)', (tester) async {
    await pumpState(
      tester,
      flight: _baseFlight(originGate: null, originTerminal: null),
      golden: 'detail_missing_gate',
    );
  });

  testWidgets('large accessibility text', (tester) async {
    await pumpState(
      tester,
      flight: _baseFlight(
        disruptions: const {DisruptionCondition.delayed},
        departureDelay: const Duration(minutes: 45),
      ),
      golden: 'detail_large_text',
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
