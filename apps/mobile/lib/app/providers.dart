import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/repositories/flight_repository.dart';
import '../infrastructure/fixtures/fixture_flight_search_service.dart';
import '../infrastructure/fixtures/flight_search_service.dart';
import '../infrastructure/persistence/app_database.dart';
import '../infrastructure/persistence/drift_flight_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.open();
  ref.onDispose(database.close);
  return database;
});

final flightRepositoryProvider = Provider<FlightRepository>((ref) {
  return DriftFlightRepository(ref.watch(appDatabaseProvider));
});

final flightSearchServiceProvider = Provider<FlightSearchService>((ref) {
  return FixtureFlightSearchService();
});

final activeFollowsProvider = StreamProvider((ref) {
  return ref.watch(flightRepositoryProvider).watchActiveFollows();
});

final flightProvider = StreamProvider.family((ref, String flightId) {
  return ref.watch(flightRepositoryProvider).watchFlight(flightId);
});
