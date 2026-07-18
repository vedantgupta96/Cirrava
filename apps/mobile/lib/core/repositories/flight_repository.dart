import '../domain/flight.dart';
import '../domain/flight_follow.dart';

abstract interface class FlightRepository {
  Future<void> cacheSearchResults(
    String queryKey,
    List<FlightSnapshot> flights,
  );

  Stream<List<FlightSnapshot>> watchSearchResults(String queryKey);

  Stream<List<FollowedFlight>> watchActiveFollows();

  Stream<FlightSnapshot?> watchFlight(String flightId);

  Future<FlightFollow> follow(String flightId);

  Future<void> unfollow(String followId);
}
