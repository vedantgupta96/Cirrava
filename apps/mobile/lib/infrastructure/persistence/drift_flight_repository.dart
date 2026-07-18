import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/domain/flight.dart' as domain;
import '../../core/domain/flight_follow.dart';
import '../../core/repositories/flight_repository.dart';
import 'app_database.dart';

class DriftFlightRepository implements FlightRepository {
  DriftFlightRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> cacheSearchResults(
    String queryKey,
    List<domain.FlightSnapshot> flights,
  ) async {
    await _database.transaction(() async {
      for (final flight in flights) {
        await _database
            .into(_database.cachedFlights)
            .insertOnConflictUpdate(_toCompanion(flight));
      }

      await (_database.delete(
        _database.flightSearchEntries,
      )..where((entry) => entry.queryKey.equals(queryKey))).go();

      for (var index = 0; index < flights.length; index++) {
        await _database
            .into(_database.flightSearchEntries)
            .insert(
              FlightSearchEntriesCompanion.insert(
                queryKey: queryKey,
                flightId: flights[index].id,
                position: index,
              ),
            );
      }
    });
  }

  @override
  Stream<List<domain.FlightSnapshot>> watchSearchResults(String queryKey) {
    final query =
        _database.select(_database.flightSearchEntries).join([
            innerJoin(
              _database.cachedFlights,
              _database.cachedFlights.id.equalsExp(
                _database.flightSearchEntries.flightId,
              ),
            ),
          ])
          ..where(_database.flightSearchEntries.queryKey.equals(queryKey))
          ..orderBy([OrderingTerm.asc(_database.flightSearchEntries.position)]);

    return query.watch().map(
      (rows) => rows
          .map((row) => _toDomain(row.readTable(_database.cachedFlights)))
          .toList(growable: false),
    );
  }

  @override
  Stream<List<FollowedFlight>> watchActiveFollows() {
    final query =
        _database.select(_database.storedFlightFollows).join([
            innerJoin(
              _database.cachedFlights,
              _database.cachedFlights.id.equalsExp(
                _database.storedFlightFollows.flightId,
              ),
            ),
          ])
          ..where(_database.storedFlightFollows.completedAt.isNull())
          ..orderBy([
            OrderingTerm.asc(_database.storedFlightFollows.createdAt),
          ]);

    return query.watch().map(
      (rows) => rows
          .map((row) {
            final stored = row.readTable(_database.storedFlightFollows);
            return FollowedFlight(
              follow: FlightFollow(
                id: stored.id,
                flightId: stored.flightId,
                createdAt: stored.createdAt,
                completedAt: stored.completedAt,
              ),
              flight: _toDomain(row.readTable(_database.cachedFlights)),
            );
          })
          .toList(growable: false),
    );
  }

  @override
  Stream<domain.FlightSnapshot?> watchFlight(String flightId) {
    final query = _database.select(_database.cachedFlights)
      ..where((flight) => flight.id.equals(flightId));
    return query.watchSingleOrNull().map(
      (flight) => flight == null ? null : _toDomain(flight),
    );
  }

  @override
  Future<FlightFollow> follow(String flightId) {
    return _database.transaction(() async {
      final existing =
          await (_database.select(_database.storedFlightFollows)
                ..where((follow) => follow.flightId.equals(flightId))
                ..where((follow) => follow.completedAt.isNull()))
              .getSingleOrNull();
      if (existing != null) {
        return FlightFollow(
          id: existing.id,
          flightId: existing.flightId,
          createdAt: existing.createdAt,
          completedAt: existing.completedAt,
        );
      }

      final active = await (_database.select(
        _database.storedFlightFollows,
      )..where((follow) => follow.completedAt.isNull())).get();
      if (active.isNotEmpty) {
        throw const AnonymousFollowLimitException();
      }

      final createdAt = DateTime.now().toUtc();
      final follow = FlightFollow(
        id: 'follow-$flightId',
        flightId: flightId,
        createdAt: createdAt,
      );
      await _database
          .into(_database.storedFlightFollows)
          .insert(
            StoredFlightFollowsCompanion.insert(
              id: follow.id,
              flightId: flightId,
              createdAt: createdAt,
            ),
          );
      return follow;
    });
  }

  @override
  Future<void> unfollow(String followId) async {
    await (_database.delete(
      _database.storedFlightFollows,
    )..where((follow) => follow.id.equals(followId))).go();
  }

  CachedFlightsCompanion _toCompanion(domain.FlightSnapshot flight) {
    return CachedFlightsCompanion.insert(
      id: flight.id,
      operatingCarrierCode: flight.operatingCarrierCode,
      operatingCarrierName: flight.operatingCarrierName,
      flightNumber: flight.flightNumber,
      originCode: flight.originCode,
      originName: flight.originName,
      destinationCode: flight.destinationCode,
      destinationName: flight.destinationName,
      scheduledDepartureUtc: flight.scheduledDepartureUtc.toUtc(),
      estimatedDepartureUtc: flight.estimatedDepartureUtc.toUtc(),
      scheduledArrivalUtc: flight.scheduledArrivalUtc.toUtc(),
      estimatedArrivalUtc: flight.estimatedArrivalUtc.toUtc(),
      originTimeZone: flight.originTimeZone,
      destinationTimeZone: flight.destinationTimeZone,
      phase: flight.phase.name,
      disruptionsJson: jsonEncode(
        flight.disruptions.map((condition) => condition.name).toList(),
      ),
      codeshareAliasesJson: jsonEncode(
        flight.codeshareAliases
            .map(
              (alias) => {
                'carrierCode': alias.carrierCode,
                'flightNumber': alias.flightNumber,
              },
            )
            .toList(),
      ),
      observedAt: flight.observedAt.toUtc(),
      originTerminal: Value(flight.originTerminal),
      originGate: Value(flight.originGate),
      destinationTerminal: Value(flight.destinationTerminal),
      destinationGate: Value(flight.destinationGate),
      replacementFlightId: Value(flight.replacementFlightId),
    );
  }

  domain.FlightSnapshot _toDomain(CachedFlight flight) {
    final disruptions = (jsonDecode(flight.disruptionsJson) as List<dynamic>)
        .cast<String>()
        .map(domain.DisruptionCondition.values.byName)
        .toSet();
    final aliases = (jsonDecode(flight.codeshareAliasesJson) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (alias) => domain.CodeshareAlias(
            carrierCode: alias['carrierCode'] as String,
            flightNumber: alias['flightNumber'] as String,
          ),
        )
        .toList(growable: false);

    return domain.FlightSnapshot(
      id: flight.id,
      operatingCarrierCode: flight.operatingCarrierCode,
      operatingCarrierName: flight.operatingCarrierName,
      flightNumber: flight.flightNumber,
      originCode: flight.originCode,
      originName: flight.originName,
      destinationCode: flight.destinationCode,
      destinationName: flight.destinationName,
      scheduledDepartureUtc: flight.scheduledDepartureUtc.toUtc(),
      estimatedDepartureUtc: flight.estimatedDepartureUtc.toUtc(),
      scheduledArrivalUtc: flight.scheduledArrivalUtc.toUtc(),
      estimatedArrivalUtc: flight.estimatedArrivalUtc.toUtc(),
      originTimeZone: flight.originTimeZone,
      destinationTimeZone: flight.destinationTimeZone,
      phase: domain.FlightPhase.values.byName(flight.phase),
      disruptions: disruptions,
      codeshareAliases: aliases,
      observedAt: flight.observedAt.toUtc(),
      originTerminal: flight.originTerminal,
      originGate: flight.originGate,
      destinationTerminal: flight.destinationTerminal,
      destinationGate: flight.destinationGate,
      replacementFlightId: flight.replacementFlightId,
    );
  }
}
