enum FlightPhase {
  scheduled,
  boarding,
  gateClosed,
  departed,
  enRoute,
  landed,
  arrivedAtGate,
}

enum DisruptionCondition { delayed, cancelled, diverted, returnedToGate }

extension FlightPhaseLabel on FlightPhase {
  String get label => switch (this) {
    FlightPhase.scheduled => 'Scheduled',
    FlightPhase.boarding => 'Boarding',
    FlightPhase.gateClosed => 'Gate closed',
    FlightPhase.departed => 'Departed',
    FlightPhase.enRoute => 'En route',
    FlightPhase.landed => 'Landed',
    FlightPhase.arrivedAtGate => 'At gate',
  };
}

extension DisruptionConditionLabel on DisruptionCondition {
  String get label => switch (this) {
    DisruptionCondition.delayed => 'Delayed',
    DisruptionCondition.cancelled => 'Cancelled',
    DisruptionCondition.diverted => 'Diverted',
    DisruptionCondition.returnedToGate => 'Returned to gate',
  };
}

class CodeshareAlias {
  const CodeshareAlias({required this.carrierCode, required this.flightNumber});

  final String carrierCode;
  final String flightNumber;

  String get displayNumber => '$carrierCode$flightNumber';
}

class FlightSnapshot {
  const FlightSnapshot({
    required this.id,
    required this.operatingCarrierCode,
    required this.operatingCarrierName,
    required this.flightNumber,
    required this.originCode,
    required this.originName,
    required this.destinationCode,
    required this.destinationName,
    required this.scheduledDepartureUtc,
    required this.estimatedDepartureUtc,
    required this.scheduledArrivalUtc,
    required this.estimatedArrivalUtc,
    required this.originTimeZone,
    required this.destinationTimeZone,
    required this.phase,
    required this.disruptions,
    required this.codeshareAliases,
    required this.observedAt,
    this.originTerminal,
    this.originGate,
    this.destinationTerminal,
    this.destinationGate,
    this.replacementFlightId,
  });

  final String id;
  final String operatingCarrierCode;
  final String operatingCarrierName;
  final String flightNumber;
  final String originCode;
  final String originName;
  final String destinationCode;
  final String destinationName;
  final DateTime scheduledDepartureUtc;
  final DateTime estimatedDepartureUtc;
  final DateTime scheduledArrivalUtc;
  final DateTime estimatedArrivalUtc;
  final String originTimeZone;
  final String destinationTimeZone;
  final FlightPhase phase;
  final Set<DisruptionCondition> disruptions;
  final List<CodeshareAlias> codeshareAliases;
  final DateTime observedAt;
  final String? originTerminal;
  final String? originGate;
  final String? destinationTerminal;
  final String? destinationGate;
  final String? replacementFlightId;

  String get operatingFlightNumber => '$operatingCarrierCode$flightNumber';

  Duration get departureDelay =>
      estimatedDepartureUtc.difference(scheduledDepartureUtc);

  Duration get arrivalDelay =>
      estimatedArrivalUtc.difference(scheduledArrivalUtc);

  /// A Cached Flight State is considered stale once its last accepted
  /// observation is older than this threshold.
  static const staleThreshold = Duration(minutes: 15);

  /// Whether an observation taken at [observedAt] is stale as of [now].
  ///
  /// Exposed as a pure function so freshness-facing widgets can share the
  /// single staleness rule without holding a full snapshot.
  static bool isStaleFor({
    required DateTime observedAt,
    required DateTime now,
  }) => now.toUtc().difference(observedAt.toUtc()) > staleThreshold;

  bool isStaleAt(DateTime now) =>
      isStaleFor(observedAt: observedAt, now: now);

  bool get isCancelled => disruptions.contains(DisruptionCondition.cancelled);
}
