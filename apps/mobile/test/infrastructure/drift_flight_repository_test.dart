import 'package:cirrava_mobile/core/domain/flight_follow.dart';
import 'package:cirrava_mobile/infrastructure/fixtures/fixture_flight_search_service.dart';
import 'package:cirrava_mobile/infrastructure/persistence/app_database.dart';
import 'package:cirrava_mobile/infrastructure/persistence/drift_flight_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('anonymous mode permits one active followed flight', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = DriftFlightRepository(database);
    final service = FixtureFlightSearchService(latency: Duration.zero);
    final flights = await service.search('A');
    await repository.cacheSearchResults('A', flights);

    await repository.follow(flights[0].id);

    expect(
      () => repository.follow(flights[1].id),
      throwsA(isA<AnonymousFollowLimitException>()),
    );
    final active = await repository.watchActiveFollows().first;
    expect(active, hasLength(1));
    expect(active.single.flight.id, flights[0].id);
  });
}
