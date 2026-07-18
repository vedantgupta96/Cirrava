import 'package:cirrava_mobile/app/providers.dart';
import 'package:cirrava_mobile/infrastructure/fixtures/fixture_flight_search_service.dart';
import 'package:cirrava_mobile/infrastructure/persistence/app_database.dart';
import 'package:cirrava_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  setUpAll(tz.initializeTimeZones);

  testWidgets('tracks a flight from search and opens its detail', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase.inMemory();
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          flightSearchServiceProvider.overrideWithValue(
            FixtureFlightSearchService(latency: Duration.zero),
          ),
        ],
        child: const CirravaApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.byKey(const Key('home-screen')), findsOneWidget);
    expect(find.text('Ready when you are'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('empty-track-flight-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('flight-search-screen')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(
      find.byKey(const Key('flight-query-field')),
      'DL 442',
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.textContaining('DL442 · ATL'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.widgetWithText(FilledButton, 'Track'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.byKey(const Key('flight-detail-screen')), findsOneWidget);
    expect(find.text('DL442'), findsOneWidget);
    expect(find.textContaining('DELAYED +45'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  });
}
