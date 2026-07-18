import 'package:clock/clock.dart';

import '../../core/domain/flight.dart';
import 'flight_search_service.dart';

class FixtureFlightSearchService implements FlightSearchService {
  FixtureFlightSearchService({
    Clock? clock,
    this.latency = const Duration(milliseconds: 650),
  }) : _clock = clock ?? const Clock();

  final Clock _clock;
  final Duration latency;

  @override
  Future<List<FlightSnapshot>> search(String query) async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }

    final normalized = normalizeFlightQuery(query).replaceAll(' ', '');
    if (normalized.isEmpty) return const [];

    return _flights()
        .where((flight) {
          final aliases = flight.codeshareAliases
              .map((alias) => alias.displayNumber)
              .join(' ');
          final haystack = [
            flight.operatingFlightNumber,
            flight.operatingCarrierName,
            flight.originCode,
            flight.originName,
            flight.destinationCode,
            flight.destinationName,
            aliases,
          ].join(' ').toUpperCase().replaceAll(' ', '');
          return haystack.contains(normalized);
        })
        .toList(growable: false);
  }

  List<FlightSnapshot> _flights() {
    final now = _clock.now().toUtc();
    final tomorrow = DateTime.utc(now.year, now.month, now.day + 1);

    return [
      FlightSnapshot(
        id: 'fixture-aa100-${_dateKey(tomorrow)}',
        operatingCarrierCode: 'AA',
        operatingCarrierName: 'American Airlines',
        flightNumber: '100',
        originCode: 'DFW',
        originName: 'Dallas Fort Worth',
        destinationCode: 'JFK',
        destinationName: 'New York Kennedy',
        scheduledDepartureUtc: tomorrow.add(
          const Duration(hours: 14, minutes: 5),
        ),
        estimatedDepartureUtc: tomorrow.add(
          const Duration(hours: 14, minutes: 5),
        ),
        scheduledArrivalUtc: tomorrow.add(
          const Duration(hours: 17, minutes: 45),
        ),
        estimatedArrivalUtc: tomorrow.add(
          const Duration(hours: 17, minutes: 45),
        ),
        originTimeZone: 'America/Chicago',
        destinationTimeZone: 'America/New_York',
        phase: FlightPhase.scheduled,
        disruptions: const {},
        codeshareAliases: const [],
        observedAt: now.subtract(const Duration(minutes: 2)),
        originTerminal: 'D',
        originGate: 'D24',
        destinationTerminal: '8',
      ),
      FlightSnapshot(
        id: 'fixture-dl442-${_dateKey(tomorrow)}',
        operatingCarrierCode: 'DL',
        operatingCarrierName: 'Delta Air Lines',
        flightNumber: '442',
        originCode: 'ATL',
        originName: 'Atlanta',
        destinationCode: 'LAX',
        destinationName: 'Los Angeles',
        scheduledDepartureUtc: tomorrow.add(
          const Duration(hours: 16, minutes: 20),
        ),
        estimatedDepartureUtc: tomorrow.add(
          const Duration(hours: 17, minutes: 5),
        ),
        scheduledArrivalUtc: tomorrow.add(
          const Duration(hours: 21, minutes: 10),
        ),
        estimatedArrivalUtc: tomorrow.add(
          const Duration(hours: 21, minutes: 55),
        ),
        originTimeZone: 'America/New_York',
        destinationTimeZone: 'America/Los_Angeles',
        phase: FlightPhase.boarding,
        disruptions: const {DisruptionCondition.delayed},
        codeshareAliases: const [
          CodeshareAlias(carrierCode: 'KE', flightNumber: '7205'),
        ],
        observedAt: now.subtract(const Duration(minutes: 4)),
        originTerminal: 'S',
        originGate: 'B18',
        destinationTerminal: '3',
        destinationGate: '31B',
      ),
      FlightSnapshot(
        id: 'fixture-ua908-${_dateKey(tomorrow)}',
        operatingCarrierCode: 'UA',
        operatingCarrierName: 'United Airlines',
        flightNumber: '908',
        originCode: 'ORD',
        originName: "Chicago O'Hare",
        destinationCode: 'SFO',
        destinationName: 'San Francisco',
        scheduledDepartureUtc: tomorrow.add(
          const Duration(hours: 18, minutes: 30),
        ),
        estimatedDepartureUtc: tomorrow.add(
          const Duration(hours: 18, minutes: 30),
        ),
        scheduledArrivalUtc: tomorrow.add(
          const Duration(hours: 23, minutes: 5),
        ),
        estimatedArrivalUtc: tomorrow.add(
          const Duration(hours: 23, minutes: 5),
        ),
        originTimeZone: 'America/Chicago',
        destinationTimeZone: 'America/Los_Angeles',
        phase: FlightPhase.scheduled,
        disruptions: const {DisruptionCondition.cancelled},
        codeshareAliases: const [],
        observedAt: now.subtract(const Duration(minutes: 19)),
        originTerminal: '1',
        originGate: 'C16',
        replacementFlightId: 'fixture-ua2908-${_dateKey(tomorrow)}',
      ),
    ];
  }

  String _dateKey(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
