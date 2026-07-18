import '../../core/domain/flight.dart';

abstract interface class FlightSearchService {
  Future<List<FlightSnapshot>> search(String query);
}

String normalizeFlightQuery(String query) =>
    query.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
