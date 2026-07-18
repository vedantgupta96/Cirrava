import 'dart:io';

import 'package:cirrava_mobile/app/providers.dart';
import 'package:cirrava_mobile/core/domain/flight.dart';
import 'package:cirrava_mobile/infrastructure/persistence/app_database.dart';
import 'package:cirrava_mobile/infrastructure/persistence/drift_flight_repository.dart';
import 'package:cirrava_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await Future.wait([
      _loadFont('SpaceGrotesk', 'assets/fonts/SpaceGrotesk-Variable.ttf'),
      _loadFont('SpaceMono', 'assets/fonts/SpaceMono-Regular.ttf'),
      _loadFont(
        'MaterialIcons',
        '../../.tooling/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ),
    ]);
  });

  testWidgets('capture Terrella implementation', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = DriftFlightRepository(database);
    final flight = FlightSnapshot(
      id: 'visual-nw472-2026-07-23',
      operatingCarrierCode: 'NW',
      operatingCarrierName: 'Northwind',
      flightNumber: '472',
      originCode: 'SFO',
      originName: 'San Francisco',
      destinationCode: 'JFK',
      destinationName: 'New York Kennedy',
      scheduledDepartureUtc: DateTime.utc(2026, 7, 24, 0, 40),
      estimatedDepartureUtc: DateTime.utc(2026, 7, 24, 1, 25),
      scheduledArrivalUtc: DateTime.utc(2026, 7, 24, 6, 11),
      estimatedArrivalUtc: DateTime.utc(2026, 7, 24, 6, 56),
      originTimeZone: 'America/Los_Angeles',
      destinationTimeZone: 'America/New_York',
      phase: FlightPhase.boarding,
      disruptions: const {DisruptionCondition.delayed},
      codeshareAliases: const [],
      observedAt: DateTime.utc(2026, 7, 18, 18, 0),
      originTerminal: '2',
      originGate: 'B22',
      destinationTerminal: '4',
      destinationGate: 'B4',
    );
    await repository.cacheSearchResults('NW 472', [flight]);
    await repository.follow(flight.id);

    const captureKey = Key('visual-capture');
    await tester.pumpWidget(
      RepaintBoundary(
        key: captureKey,
        child: ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(database)],
          child: const CirravaApp(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(
      find.byKey(captureKey),
      matchesGoldenFile('../../../design/implementation/home-terrella.png'),
    );

    await tester.tap(find.byKey(const Key('tracked-flight-card')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await expectLater(
      find.byKey(captureKey),
      matchesGoldenFile('../../../design/implementation/detail-terrella.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  });
}

Future<void> _loadFont(String family, String path) async {
  final bytes = await File(path).readAsBytes();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}
