import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class CachedFlights extends Table {
  TextColumn get id => text()();
  TextColumn get operatingCarrierCode => text()();
  TextColumn get operatingCarrierName => text()();
  TextColumn get flightNumber => text()();
  TextColumn get originCode => text()();
  TextColumn get originName => text()();
  TextColumn get destinationCode => text()();
  TextColumn get destinationName => text()();
  DateTimeColumn get scheduledDepartureUtc => dateTime()();
  DateTimeColumn get estimatedDepartureUtc => dateTime()();
  DateTimeColumn get scheduledArrivalUtc => dateTime()();
  DateTimeColumn get estimatedArrivalUtc => dateTime()();
  TextColumn get originTimeZone => text()();
  TextColumn get destinationTimeZone => text()();
  TextColumn get phase => text()();
  TextColumn get disruptionsJson => text()();
  TextColumn get codeshareAliasesJson => text()();
  DateTimeColumn get observedAt => dateTime()();
  TextColumn get originTerminal => text().nullable()();
  TextColumn get originGate => text().nullable()();
  TextColumn get destinationTerminal => text().nullable()();
  TextColumn get destinationGate => text().nullable()();
  TextColumn get replacementFlightId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StoredFlightFollows extends Table {
  TextColumn get id => text()();
  TextColumn get flightId => text().references(CachedFlights, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FlightSearchEntries extends Table {
  TextColumn get queryKey => text()();
  TextColumn get flightId => text().references(CachedFlights, #id)();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {queryKey, flightId};
}

@DriftDatabase(
  tables: [CachedFlights, StoredFlightFollows, FlightSearchEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() => AppDatabase(_openConnection());

  factory AppDatabase.inMemory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final documents = await getApplicationDocumentsDirectory();
    final file = File(paths.join(documents.path, 'cirrava.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
