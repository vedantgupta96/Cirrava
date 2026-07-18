import 'flight.dart';

class FlightFollow {
  const FlightFollow({
    required this.id,
    required this.flightId,
    required this.createdAt,
    this.completedAt,
  });

  final String id;
  final String flightId;
  final DateTime createdAt;
  final DateTime? completedAt;

  bool get isActive => completedAt == null;
}

class FollowedFlight {
  const FollowedFlight({required this.follow, required this.flight});

  final FlightFollow follow;
  final FlightSnapshot flight;
}

class AnonymousFollowLimitException implements Exception {
  const AnonymousFollowLimitException();

  @override
  String toString() => 'An anonymous user can follow one active flight.';
}
