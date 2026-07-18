// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedFlightsTable extends CachedFlights
    with TableInfo<$CachedFlightsTable, CachedFlight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatingCarrierCodeMeta =
      const VerificationMeta('operatingCarrierCode');
  @override
  late final GeneratedColumn<String> operatingCarrierCode =
      GeneratedColumn<String>(
        'operating_carrier_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _operatingCarrierNameMeta =
      const VerificationMeta('operatingCarrierName');
  @override
  late final GeneratedColumn<String> operatingCarrierName =
      GeneratedColumn<String>(
        'operating_carrier_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _flightNumberMeta = const VerificationMeta(
    'flightNumber',
  );
  @override
  late final GeneratedColumn<String> flightNumber = GeneratedColumn<String>(
    'flight_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originCodeMeta = const VerificationMeta(
    'originCode',
  );
  @override
  late final GeneratedColumn<String> originCode = GeneratedColumn<String>(
    'origin_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originNameMeta = const VerificationMeta(
    'originName',
  );
  @override
  late final GeneratedColumn<String> originName = GeneratedColumn<String>(
    'origin_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationCodeMeta = const VerificationMeta(
    'destinationCode',
  );
  @override
  late final GeneratedColumn<String> destinationCode = GeneratedColumn<String>(
    'destination_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationNameMeta = const VerificationMeta(
    'destinationName',
  );
  @override
  late final GeneratedColumn<String> destinationName = GeneratedColumn<String>(
    'destination_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDepartureUtcMeta =
      const VerificationMeta('scheduledDepartureUtc');
  @override
  late final GeneratedColumn<DateTime> scheduledDepartureUtc =
      GeneratedColumn<DateTime>(
        'scheduled_departure_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _estimatedDepartureUtcMeta =
      const VerificationMeta('estimatedDepartureUtc');
  @override
  late final GeneratedColumn<DateTime> estimatedDepartureUtc =
      GeneratedColumn<DateTime>(
        'estimated_departure_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _scheduledArrivalUtcMeta =
      const VerificationMeta('scheduledArrivalUtc');
  @override
  late final GeneratedColumn<DateTime> scheduledArrivalUtc =
      GeneratedColumn<DateTime>(
        'scheduled_arrival_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _estimatedArrivalUtcMeta =
      const VerificationMeta('estimatedArrivalUtc');
  @override
  late final GeneratedColumn<DateTime> estimatedArrivalUtc =
      GeneratedColumn<DateTime>(
        'estimated_arrival_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _originTimeZoneMeta = const VerificationMeta(
    'originTimeZone',
  );
  @override
  late final GeneratedColumn<String> originTimeZone = GeneratedColumn<String>(
    'origin_time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationTimeZoneMeta =
      const VerificationMeta('destinationTimeZone');
  @override
  late final GeneratedColumn<String> destinationTimeZone =
      GeneratedColumn<String>(
        'destination_time_zone',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _disruptionsJsonMeta = const VerificationMeta(
    'disruptionsJson',
  );
  @override
  late final GeneratedColumn<String> disruptionsJson = GeneratedColumn<String>(
    'disruptions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeshareAliasesJsonMeta =
      const VerificationMeta('codeshareAliasesJson');
  @override
  late final GeneratedColumn<String> codeshareAliasesJson =
      GeneratedColumn<String>(
        'codeshare_aliases_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _observedAtMeta = const VerificationMeta(
    'observedAt',
  );
  @override
  late final GeneratedColumn<DateTime> observedAt = GeneratedColumn<DateTime>(
    'observed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originTerminalMeta = const VerificationMeta(
    'originTerminal',
  );
  @override
  late final GeneratedColumn<String> originTerminal = GeneratedColumn<String>(
    'origin_terminal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originGateMeta = const VerificationMeta(
    'originGate',
  );
  @override
  late final GeneratedColumn<String> originGate = GeneratedColumn<String>(
    'origin_gate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationTerminalMeta =
      const VerificationMeta('destinationTerminal');
  @override
  late final GeneratedColumn<String> destinationTerminal =
      GeneratedColumn<String>(
        'destination_terminal',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _destinationGateMeta = const VerificationMeta(
    'destinationGate',
  );
  @override
  late final GeneratedColumn<String> destinationGate = GeneratedColumn<String>(
    'destination_gate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replacementFlightIdMeta =
      const VerificationMeta('replacementFlightId');
  @override
  late final GeneratedColumn<String> replacementFlightId =
      GeneratedColumn<String>(
        'replacement_flight_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operatingCarrierCode,
    operatingCarrierName,
    flightNumber,
    originCode,
    originName,
    destinationCode,
    destinationName,
    scheduledDepartureUtc,
    estimatedDepartureUtc,
    scheduledArrivalUtc,
    estimatedArrivalUtc,
    originTimeZone,
    destinationTimeZone,
    phase,
    disruptionsJson,
    codeshareAliasesJson,
    observedAt,
    originTerminal,
    originGate,
    destinationTerminal,
    destinationGate,
    replacementFlightId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_flights';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFlight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operating_carrier_code')) {
      context.handle(
        _operatingCarrierCodeMeta,
        operatingCarrierCode.isAcceptableOrUnknown(
          data['operating_carrier_code']!,
          _operatingCarrierCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operatingCarrierCodeMeta);
    }
    if (data.containsKey('operating_carrier_name')) {
      context.handle(
        _operatingCarrierNameMeta,
        operatingCarrierName.isAcceptableOrUnknown(
          data['operating_carrier_name']!,
          _operatingCarrierNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operatingCarrierNameMeta);
    }
    if (data.containsKey('flight_number')) {
      context.handle(
        _flightNumberMeta,
        flightNumber.isAcceptableOrUnknown(
          data['flight_number']!,
          _flightNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_flightNumberMeta);
    }
    if (data.containsKey('origin_code')) {
      context.handle(
        _originCodeMeta,
        originCode.isAcceptableOrUnknown(data['origin_code']!, _originCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_originCodeMeta);
    }
    if (data.containsKey('origin_name')) {
      context.handle(
        _originNameMeta,
        originName.isAcceptableOrUnknown(data['origin_name']!, _originNameMeta),
      );
    } else if (isInserting) {
      context.missing(_originNameMeta);
    }
    if (data.containsKey('destination_code')) {
      context.handle(
        _destinationCodeMeta,
        destinationCode.isAcceptableOrUnknown(
          data['destination_code']!,
          _destinationCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationCodeMeta);
    }
    if (data.containsKey('destination_name')) {
      context.handle(
        _destinationNameMeta,
        destinationName.isAcceptableOrUnknown(
          data['destination_name']!,
          _destinationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationNameMeta);
    }
    if (data.containsKey('scheduled_departure_utc')) {
      context.handle(
        _scheduledDepartureUtcMeta,
        scheduledDepartureUtc.isAcceptableOrUnknown(
          data['scheduled_departure_utc']!,
          _scheduledDepartureUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDepartureUtcMeta);
    }
    if (data.containsKey('estimated_departure_utc')) {
      context.handle(
        _estimatedDepartureUtcMeta,
        estimatedDepartureUtc.isAcceptableOrUnknown(
          data['estimated_departure_utc']!,
          _estimatedDepartureUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedDepartureUtcMeta);
    }
    if (data.containsKey('scheduled_arrival_utc')) {
      context.handle(
        _scheduledArrivalUtcMeta,
        scheduledArrivalUtc.isAcceptableOrUnknown(
          data['scheduled_arrival_utc']!,
          _scheduledArrivalUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledArrivalUtcMeta);
    }
    if (data.containsKey('estimated_arrival_utc')) {
      context.handle(
        _estimatedArrivalUtcMeta,
        estimatedArrivalUtc.isAcceptableOrUnknown(
          data['estimated_arrival_utc']!,
          _estimatedArrivalUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedArrivalUtcMeta);
    }
    if (data.containsKey('origin_time_zone')) {
      context.handle(
        _originTimeZoneMeta,
        originTimeZone.isAcceptableOrUnknown(
          data['origin_time_zone']!,
          _originTimeZoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originTimeZoneMeta);
    }
    if (data.containsKey('destination_time_zone')) {
      context.handle(
        _destinationTimeZoneMeta,
        destinationTimeZone.isAcceptableOrUnknown(
          data['destination_time_zone']!,
          _destinationTimeZoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationTimeZoneMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('disruptions_json')) {
      context.handle(
        _disruptionsJsonMeta,
        disruptionsJson.isAcceptableOrUnknown(
          data['disruptions_json']!,
          _disruptionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_disruptionsJsonMeta);
    }
    if (data.containsKey('codeshare_aliases_json')) {
      context.handle(
        _codeshareAliasesJsonMeta,
        codeshareAliasesJson.isAcceptableOrUnknown(
          data['codeshare_aliases_json']!,
          _codeshareAliasesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codeshareAliasesJsonMeta);
    }
    if (data.containsKey('observed_at')) {
      context.handle(
        _observedAtMeta,
        observedAt.isAcceptableOrUnknown(data['observed_at']!, _observedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_observedAtMeta);
    }
    if (data.containsKey('origin_terminal')) {
      context.handle(
        _originTerminalMeta,
        originTerminal.isAcceptableOrUnknown(
          data['origin_terminal']!,
          _originTerminalMeta,
        ),
      );
    }
    if (data.containsKey('origin_gate')) {
      context.handle(
        _originGateMeta,
        originGate.isAcceptableOrUnknown(data['origin_gate']!, _originGateMeta),
      );
    }
    if (data.containsKey('destination_terminal')) {
      context.handle(
        _destinationTerminalMeta,
        destinationTerminal.isAcceptableOrUnknown(
          data['destination_terminal']!,
          _destinationTerminalMeta,
        ),
      );
    }
    if (data.containsKey('destination_gate')) {
      context.handle(
        _destinationGateMeta,
        destinationGate.isAcceptableOrUnknown(
          data['destination_gate']!,
          _destinationGateMeta,
        ),
      );
    }
    if (data.containsKey('replacement_flight_id')) {
      context.handle(
        _replacementFlightIdMeta,
        replacementFlightId.isAcceptableOrUnknown(
          data['replacement_flight_id']!,
          _replacementFlightIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedFlight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFlight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      operatingCarrierCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operating_carrier_code'],
      )!,
      operatingCarrierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operating_carrier_name'],
      )!,
      flightNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flight_number'],
      )!,
      originCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_code'],
      )!,
      originName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_name'],
      )!,
      destinationCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_code'],
      )!,
      destinationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_name'],
      )!,
      scheduledDepartureUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_departure_utc'],
      )!,
      estimatedDepartureUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}estimated_departure_utc'],
      )!,
      scheduledArrivalUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_arrival_utc'],
      )!,
      estimatedArrivalUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}estimated_arrival_utc'],
      )!,
      originTimeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_time_zone'],
      )!,
      destinationTimeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_time_zone'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      disruptionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disruptions_json'],
      )!,
      codeshareAliasesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codeshare_aliases_json'],
      )!,
      observedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}observed_at'],
      )!,
      originTerminal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_terminal'],
      ),
      originGate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_gate'],
      ),
      destinationTerminal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_terminal'],
      ),
      destinationGate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_gate'],
      ),
      replacementFlightId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}replacement_flight_id'],
      ),
    );
  }

  @override
  $CachedFlightsTable createAlias(String alias) {
    return $CachedFlightsTable(attachedDatabase, alias);
  }
}

class CachedFlight extends DataClass implements Insertable<CachedFlight> {
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
  final String phase;
  final String disruptionsJson;
  final String codeshareAliasesJson;
  final DateTime observedAt;
  final String? originTerminal;
  final String? originGate;
  final String? destinationTerminal;
  final String? destinationGate;
  final String? replacementFlightId;
  const CachedFlight({
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
    required this.disruptionsJson,
    required this.codeshareAliasesJson,
    required this.observedAt,
    this.originTerminal,
    this.originGate,
    this.destinationTerminal,
    this.destinationGate,
    this.replacementFlightId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operating_carrier_code'] = Variable<String>(operatingCarrierCode);
    map['operating_carrier_name'] = Variable<String>(operatingCarrierName);
    map['flight_number'] = Variable<String>(flightNumber);
    map['origin_code'] = Variable<String>(originCode);
    map['origin_name'] = Variable<String>(originName);
    map['destination_code'] = Variable<String>(destinationCode);
    map['destination_name'] = Variable<String>(destinationName);
    map['scheduled_departure_utc'] = Variable<DateTime>(scheduledDepartureUtc);
    map['estimated_departure_utc'] = Variable<DateTime>(estimatedDepartureUtc);
    map['scheduled_arrival_utc'] = Variable<DateTime>(scheduledArrivalUtc);
    map['estimated_arrival_utc'] = Variable<DateTime>(estimatedArrivalUtc);
    map['origin_time_zone'] = Variable<String>(originTimeZone);
    map['destination_time_zone'] = Variable<String>(destinationTimeZone);
    map['phase'] = Variable<String>(phase);
    map['disruptions_json'] = Variable<String>(disruptionsJson);
    map['codeshare_aliases_json'] = Variable<String>(codeshareAliasesJson);
    map['observed_at'] = Variable<DateTime>(observedAt);
    if (!nullToAbsent || originTerminal != null) {
      map['origin_terminal'] = Variable<String>(originTerminal);
    }
    if (!nullToAbsent || originGate != null) {
      map['origin_gate'] = Variable<String>(originGate);
    }
    if (!nullToAbsent || destinationTerminal != null) {
      map['destination_terminal'] = Variable<String>(destinationTerminal);
    }
    if (!nullToAbsent || destinationGate != null) {
      map['destination_gate'] = Variable<String>(destinationGate);
    }
    if (!nullToAbsent || replacementFlightId != null) {
      map['replacement_flight_id'] = Variable<String>(replacementFlightId);
    }
    return map;
  }

  CachedFlightsCompanion toCompanion(bool nullToAbsent) {
    return CachedFlightsCompanion(
      id: Value(id),
      operatingCarrierCode: Value(operatingCarrierCode),
      operatingCarrierName: Value(operatingCarrierName),
      flightNumber: Value(flightNumber),
      originCode: Value(originCode),
      originName: Value(originName),
      destinationCode: Value(destinationCode),
      destinationName: Value(destinationName),
      scheduledDepartureUtc: Value(scheduledDepartureUtc),
      estimatedDepartureUtc: Value(estimatedDepartureUtc),
      scheduledArrivalUtc: Value(scheduledArrivalUtc),
      estimatedArrivalUtc: Value(estimatedArrivalUtc),
      originTimeZone: Value(originTimeZone),
      destinationTimeZone: Value(destinationTimeZone),
      phase: Value(phase),
      disruptionsJson: Value(disruptionsJson),
      codeshareAliasesJson: Value(codeshareAliasesJson),
      observedAt: Value(observedAt),
      originTerminal: originTerminal == null && nullToAbsent
          ? const Value.absent()
          : Value(originTerminal),
      originGate: originGate == null && nullToAbsent
          ? const Value.absent()
          : Value(originGate),
      destinationTerminal: destinationTerminal == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationTerminal),
      destinationGate: destinationGate == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationGate),
      replacementFlightId: replacementFlightId == null && nullToAbsent
          ? const Value.absent()
          : Value(replacementFlightId),
    );
  }

  factory CachedFlight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFlight(
      id: serializer.fromJson<String>(json['id']),
      operatingCarrierCode: serializer.fromJson<String>(
        json['operatingCarrierCode'],
      ),
      operatingCarrierName: serializer.fromJson<String>(
        json['operatingCarrierName'],
      ),
      flightNumber: serializer.fromJson<String>(json['flightNumber']),
      originCode: serializer.fromJson<String>(json['originCode']),
      originName: serializer.fromJson<String>(json['originName']),
      destinationCode: serializer.fromJson<String>(json['destinationCode']),
      destinationName: serializer.fromJson<String>(json['destinationName']),
      scheduledDepartureUtc: serializer.fromJson<DateTime>(
        json['scheduledDepartureUtc'],
      ),
      estimatedDepartureUtc: serializer.fromJson<DateTime>(
        json['estimatedDepartureUtc'],
      ),
      scheduledArrivalUtc: serializer.fromJson<DateTime>(
        json['scheduledArrivalUtc'],
      ),
      estimatedArrivalUtc: serializer.fromJson<DateTime>(
        json['estimatedArrivalUtc'],
      ),
      originTimeZone: serializer.fromJson<String>(json['originTimeZone']),
      destinationTimeZone: serializer.fromJson<String>(
        json['destinationTimeZone'],
      ),
      phase: serializer.fromJson<String>(json['phase']),
      disruptionsJson: serializer.fromJson<String>(json['disruptionsJson']),
      codeshareAliasesJson: serializer.fromJson<String>(
        json['codeshareAliasesJson'],
      ),
      observedAt: serializer.fromJson<DateTime>(json['observedAt']),
      originTerminal: serializer.fromJson<String?>(json['originTerminal']),
      originGate: serializer.fromJson<String?>(json['originGate']),
      destinationTerminal: serializer.fromJson<String?>(
        json['destinationTerminal'],
      ),
      destinationGate: serializer.fromJson<String?>(json['destinationGate']),
      replacementFlightId: serializer.fromJson<String?>(
        json['replacementFlightId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operatingCarrierCode': serializer.toJson<String>(operatingCarrierCode),
      'operatingCarrierName': serializer.toJson<String>(operatingCarrierName),
      'flightNumber': serializer.toJson<String>(flightNumber),
      'originCode': serializer.toJson<String>(originCode),
      'originName': serializer.toJson<String>(originName),
      'destinationCode': serializer.toJson<String>(destinationCode),
      'destinationName': serializer.toJson<String>(destinationName),
      'scheduledDepartureUtc': serializer.toJson<DateTime>(
        scheduledDepartureUtc,
      ),
      'estimatedDepartureUtc': serializer.toJson<DateTime>(
        estimatedDepartureUtc,
      ),
      'scheduledArrivalUtc': serializer.toJson<DateTime>(scheduledArrivalUtc),
      'estimatedArrivalUtc': serializer.toJson<DateTime>(estimatedArrivalUtc),
      'originTimeZone': serializer.toJson<String>(originTimeZone),
      'destinationTimeZone': serializer.toJson<String>(destinationTimeZone),
      'phase': serializer.toJson<String>(phase),
      'disruptionsJson': serializer.toJson<String>(disruptionsJson),
      'codeshareAliasesJson': serializer.toJson<String>(codeshareAliasesJson),
      'observedAt': serializer.toJson<DateTime>(observedAt),
      'originTerminal': serializer.toJson<String?>(originTerminal),
      'originGate': serializer.toJson<String?>(originGate),
      'destinationTerminal': serializer.toJson<String?>(destinationTerminal),
      'destinationGate': serializer.toJson<String?>(destinationGate),
      'replacementFlightId': serializer.toJson<String?>(replacementFlightId),
    };
  }

  CachedFlight copyWith({
    String? id,
    String? operatingCarrierCode,
    String? operatingCarrierName,
    String? flightNumber,
    String? originCode,
    String? originName,
    String? destinationCode,
    String? destinationName,
    DateTime? scheduledDepartureUtc,
    DateTime? estimatedDepartureUtc,
    DateTime? scheduledArrivalUtc,
    DateTime? estimatedArrivalUtc,
    String? originTimeZone,
    String? destinationTimeZone,
    String? phase,
    String? disruptionsJson,
    String? codeshareAliasesJson,
    DateTime? observedAt,
    Value<String?> originTerminal = const Value.absent(),
    Value<String?> originGate = const Value.absent(),
    Value<String?> destinationTerminal = const Value.absent(),
    Value<String?> destinationGate = const Value.absent(),
    Value<String?> replacementFlightId = const Value.absent(),
  }) => CachedFlight(
    id: id ?? this.id,
    operatingCarrierCode: operatingCarrierCode ?? this.operatingCarrierCode,
    operatingCarrierName: operatingCarrierName ?? this.operatingCarrierName,
    flightNumber: flightNumber ?? this.flightNumber,
    originCode: originCode ?? this.originCode,
    originName: originName ?? this.originName,
    destinationCode: destinationCode ?? this.destinationCode,
    destinationName: destinationName ?? this.destinationName,
    scheduledDepartureUtc: scheduledDepartureUtc ?? this.scheduledDepartureUtc,
    estimatedDepartureUtc: estimatedDepartureUtc ?? this.estimatedDepartureUtc,
    scheduledArrivalUtc: scheduledArrivalUtc ?? this.scheduledArrivalUtc,
    estimatedArrivalUtc: estimatedArrivalUtc ?? this.estimatedArrivalUtc,
    originTimeZone: originTimeZone ?? this.originTimeZone,
    destinationTimeZone: destinationTimeZone ?? this.destinationTimeZone,
    phase: phase ?? this.phase,
    disruptionsJson: disruptionsJson ?? this.disruptionsJson,
    codeshareAliasesJson: codeshareAliasesJson ?? this.codeshareAliasesJson,
    observedAt: observedAt ?? this.observedAt,
    originTerminal: originTerminal.present
        ? originTerminal.value
        : this.originTerminal,
    originGate: originGate.present ? originGate.value : this.originGate,
    destinationTerminal: destinationTerminal.present
        ? destinationTerminal.value
        : this.destinationTerminal,
    destinationGate: destinationGate.present
        ? destinationGate.value
        : this.destinationGate,
    replacementFlightId: replacementFlightId.present
        ? replacementFlightId.value
        : this.replacementFlightId,
  );
  CachedFlight copyWithCompanion(CachedFlightsCompanion data) {
    return CachedFlight(
      id: data.id.present ? data.id.value : this.id,
      operatingCarrierCode: data.operatingCarrierCode.present
          ? data.operatingCarrierCode.value
          : this.operatingCarrierCode,
      operatingCarrierName: data.operatingCarrierName.present
          ? data.operatingCarrierName.value
          : this.operatingCarrierName,
      flightNumber: data.flightNumber.present
          ? data.flightNumber.value
          : this.flightNumber,
      originCode: data.originCode.present
          ? data.originCode.value
          : this.originCode,
      originName: data.originName.present
          ? data.originName.value
          : this.originName,
      destinationCode: data.destinationCode.present
          ? data.destinationCode.value
          : this.destinationCode,
      destinationName: data.destinationName.present
          ? data.destinationName.value
          : this.destinationName,
      scheduledDepartureUtc: data.scheduledDepartureUtc.present
          ? data.scheduledDepartureUtc.value
          : this.scheduledDepartureUtc,
      estimatedDepartureUtc: data.estimatedDepartureUtc.present
          ? data.estimatedDepartureUtc.value
          : this.estimatedDepartureUtc,
      scheduledArrivalUtc: data.scheduledArrivalUtc.present
          ? data.scheduledArrivalUtc.value
          : this.scheduledArrivalUtc,
      estimatedArrivalUtc: data.estimatedArrivalUtc.present
          ? data.estimatedArrivalUtc.value
          : this.estimatedArrivalUtc,
      originTimeZone: data.originTimeZone.present
          ? data.originTimeZone.value
          : this.originTimeZone,
      destinationTimeZone: data.destinationTimeZone.present
          ? data.destinationTimeZone.value
          : this.destinationTimeZone,
      phase: data.phase.present ? data.phase.value : this.phase,
      disruptionsJson: data.disruptionsJson.present
          ? data.disruptionsJson.value
          : this.disruptionsJson,
      codeshareAliasesJson: data.codeshareAliasesJson.present
          ? data.codeshareAliasesJson.value
          : this.codeshareAliasesJson,
      observedAt: data.observedAt.present
          ? data.observedAt.value
          : this.observedAt,
      originTerminal: data.originTerminal.present
          ? data.originTerminal.value
          : this.originTerminal,
      originGate: data.originGate.present
          ? data.originGate.value
          : this.originGate,
      destinationTerminal: data.destinationTerminal.present
          ? data.destinationTerminal.value
          : this.destinationTerminal,
      destinationGate: data.destinationGate.present
          ? data.destinationGate.value
          : this.destinationGate,
      replacementFlightId: data.replacementFlightId.present
          ? data.replacementFlightId.value
          : this.replacementFlightId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFlight(')
          ..write('id: $id, ')
          ..write('operatingCarrierCode: $operatingCarrierCode, ')
          ..write('operatingCarrierName: $operatingCarrierName, ')
          ..write('flightNumber: $flightNumber, ')
          ..write('originCode: $originCode, ')
          ..write('originName: $originName, ')
          ..write('destinationCode: $destinationCode, ')
          ..write('destinationName: $destinationName, ')
          ..write('scheduledDepartureUtc: $scheduledDepartureUtc, ')
          ..write('estimatedDepartureUtc: $estimatedDepartureUtc, ')
          ..write('scheduledArrivalUtc: $scheduledArrivalUtc, ')
          ..write('estimatedArrivalUtc: $estimatedArrivalUtc, ')
          ..write('originTimeZone: $originTimeZone, ')
          ..write('destinationTimeZone: $destinationTimeZone, ')
          ..write('phase: $phase, ')
          ..write('disruptionsJson: $disruptionsJson, ')
          ..write('codeshareAliasesJson: $codeshareAliasesJson, ')
          ..write('observedAt: $observedAt, ')
          ..write('originTerminal: $originTerminal, ')
          ..write('originGate: $originGate, ')
          ..write('destinationTerminal: $destinationTerminal, ')
          ..write('destinationGate: $destinationGate, ')
          ..write('replacementFlightId: $replacementFlightId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    operatingCarrierCode,
    operatingCarrierName,
    flightNumber,
    originCode,
    originName,
    destinationCode,
    destinationName,
    scheduledDepartureUtc,
    estimatedDepartureUtc,
    scheduledArrivalUtc,
    estimatedArrivalUtc,
    originTimeZone,
    destinationTimeZone,
    phase,
    disruptionsJson,
    codeshareAliasesJson,
    observedAt,
    originTerminal,
    originGate,
    destinationTerminal,
    destinationGate,
    replacementFlightId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFlight &&
          other.id == this.id &&
          other.operatingCarrierCode == this.operatingCarrierCode &&
          other.operatingCarrierName == this.operatingCarrierName &&
          other.flightNumber == this.flightNumber &&
          other.originCode == this.originCode &&
          other.originName == this.originName &&
          other.destinationCode == this.destinationCode &&
          other.destinationName == this.destinationName &&
          other.scheduledDepartureUtc == this.scheduledDepartureUtc &&
          other.estimatedDepartureUtc == this.estimatedDepartureUtc &&
          other.scheduledArrivalUtc == this.scheduledArrivalUtc &&
          other.estimatedArrivalUtc == this.estimatedArrivalUtc &&
          other.originTimeZone == this.originTimeZone &&
          other.destinationTimeZone == this.destinationTimeZone &&
          other.phase == this.phase &&
          other.disruptionsJson == this.disruptionsJson &&
          other.codeshareAliasesJson == this.codeshareAliasesJson &&
          other.observedAt == this.observedAt &&
          other.originTerminal == this.originTerminal &&
          other.originGate == this.originGate &&
          other.destinationTerminal == this.destinationTerminal &&
          other.destinationGate == this.destinationGate &&
          other.replacementFlightId == this.replacementFlightId);
}

class CachedFlightsCompanion extends UpdateCompanion<CachedFlight> {
  final Value<String> id;
  final Value<String> operatingCarrierCode;
  final Value<String> operatingCarrierName;
  final Value<String> flightNumber;
  final Value<String> originCode;
  final Value<String> originName;
  final Value<String> destinationCode;
  final Value<String> destinationName;
  final Value<DateTime> scheduledDepartureUtc;
  final Value<DateTime> estimatedDepartureUtc;
  final Value<DateTime> scheduledArrivalUtc;
  final Value<DateTime> estimatedArrivalUtc;
  final Value<String> originTimeZone;
  final Value<String> destinationTimeZone;
  final Value<String> phase;
  final Value<String> disruptionsJson;
  final Value<String> codeshareAliasesJson;
  final Value<DateTime> observedAt;
  final Value<String?> originTerminal;
  final Value<String?> originGate;
  final Value<String?> destinationTerminal;
  final Value<String?> destinationGate;
  final Value<String?> replacementFlightId;
  final Value<int> rowid;
  const CachedFlightsCompanion({
    this.id = const Value.absent(),
    this.operatingCarrierCode = const Value.absent(),
    this.operatingCarrierName = const Value.absent(),
    this.flightNumber = const Value.absent(),
    this.originCode = const Value.absent(),
    this.originName = const Value.absent(),
    this.destinationCode = const Value.absent(),
    this.destinationName = const Value.absent(),
    this.scheduledDepartureUtc = const Value.absent(),
    this.estimatedDepartureUtc = const Value.absent(),
    this.scheduledArrivalUtc = const Value.absent(),
    this.estimatedArrivalUtc = const Value.absent(),
    this.originTimeZone = const Value.absent(),
    this.destinationTimeZone = const Value.absent(),
    this.phase = const Value.absent(),
    this.disruptionsJson = const Value.absent(),
    this.codeshareAliasesJson = const Value.absent(),
    this.observedAt = const Value.absent(),
    this.originTerminal = const Value.absent(),
    this.originGate = const Value.absent(),
    this.destinationTerminal = const Value.absent(),
    this.destinationGate = const Value.absent(),
    this.replacementFlightId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedFlightsCompanion.insert({
    required String id,
    required String operatingCarrierCode,
    required String operatingCarrierName,
    required String flightNumber,
    required String originCode,
    required String originName,
    required String destinationCode,
    required String destinationName,
    required DateTime scheduledDepartureUtc,
    required DateTime estimatedDepartureUtc,
    required DateTime scheduledArrivalUtc,
    required DateTime estimatedArrivalUtc,
    required String originTimeZone,
    required String destinationTimeZone,
    required String phase,
    required String disruptionsJson,
    required String codeshareAliasesJson,
    required DateTime observedAt,
    this.originTerminal = const Value.absent(),
    this.originGate = const Value.absent(),
    this.destinationTerminal = const Value.absent(),
    this.destinationGate = const Value.absent(),
    this.replacementFlightId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       operatingCarrierCode = Value(operatingCarrierCode),
       operatingCarrierName = Value(operatingCarrierName),
       flightNumber = Value(flightNumber),
       originCode = Value(originCode),
       originName = Value(originName),
       destinationCode = Value(destinationCode),
       destinationName = Value(destinationName),
       scheduledDepartureUtc = Value(scheduledDepartureUtc),
       estimatedDepartureUtc = Value(estimatedDepartureUtc),
       scheduledArrivalUtc = Value(scheduledArrivalUtc),
       estimatedArrivalUtc = Value(estimatedArrivalUtc),
       originTimeZone = Value(originTimeZone),
       destinationTimeZone = Value(destinationTimeZone),
       phase = Value(phase),
       disruptionsJson = Value(disruptionsJson),
       codeshareAliasesJson = Value(codeshareAliasesJson),
       observedAt = Value(observedAt);
  static Insertable<CachedFlight> custom({
    Expression<String>? id,
    Expression<String>? operatingCarrierCode,
    Expression<String>? operatingCarrierName,
    Expression<String>? flightNumber,
    Expression<String>? originCode,
    Expression<String>? originName,
    Expression<String>? destinationCode,
    Expression<String>? destinationName,
    Expression<DateTime>? scheduledDepartureUtc,
    Expression<DateTime>? estimatedDepartureUtc,
    Expression<DateTime>? scheduledArrivalUtc,
    Expression<DateTime>? estimatedArrivalUtc,
    Expression<String>? originTimeZone,
    Expression<String>? destinationTimeZone,
    Expression<String>? phase,
    Expression<String>? disruptionsJson,
    Expression<String>? codeshareAliasesJson,
    Expression<DateTime>? observedAt,
    Expression<String>? originTerminal,
    Expression<String>? originGate,
    Expression<String>? destinationTerminal,
    Expression<String>? destinationGate,
    Expression<String>? replacementFlightId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operatingCarrierCode != null)
        'operating_carrier_code': operatingCarrierCode,
      if (operatingCarrierName != null)
        'operating_carrier_name': operatingCarrierName,
      if (flightNumber != null) 'flight_number': flightNumber,
      if (originCode != null) 'origin_code': originCode,
      if (originName != null) 'origin_name': originName,
      if (destinationCode != null) 'destination_code': destinationCode,
      if (destinationName != null) 'destination_name': destinationName,
      if (scheduledDepartureUtc != null)
        'scheduled_departure_utc': scheduledDepartureUtc,
      if (estimatedDepartureUtc != null)
        'estimated_departure_utc': estimatedDepartureUtc,
      if (scheduledArrivalUtc != null)
        'scheduled_arrival_utc': scheduledArrivalUtc,
      if (estimatedArrivalUtc != null)
        'estimated_arrival_utc': estimatedArrivalUtc,
      if (originTimeZone != null) 'origin_time_zone': originTimeZone,
      if (destinationTimeZone != null)
        'destination_time_zone': destinationTimeZone,
      if (phase != null) 'phase': phase,
      if (disruptionsJson != null) 'disruptions_json': disruptionsJson,
      if (codeshareAliasesJson != null)
        'codeshare_aliases_json': codeshareAliasesJson,
      if (observedAt != null) 'observed_at': observedAt,
      if (originTerminal != null) 'origin_terminal': originTerminal,
      if (originGate != null) 'origin_gate': originGate,
      if (destinationTerminal != null)
        'destination_terminal': destinationTerminal,
      if (destinationGate != null) 'destination_gate': destinationGate,
      if (replacementFlightId != null)
        'replacement_flight_id': replacementFlightId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedFlightsCompanion copyWith({
    Value<String>? id,
    Value<String>? operatingCarrierCode,
    Value<String>? operatingCarrierName,
    Value<String>? flightNumber,
    Value<String>? originCode,
    Value<String>? originName,
    Value<String>? destinationCode,
    Value<String>? destinationName,
    Value<DateTime>? scheduledDepartureUtc,
    Value<DateTime>? estimatedDepartureUtc,
    Value<DateTime>? scheduledArrivalUtc,
    Value<DateTime>? estimatedArrivalUtc,
    Value<String>? originTimeZone,
    Value<String>? destinationTimeZone,
    Value<String>? phase,
    Value<String>? disruptionsJson,
    Value<String>? codeshareAliasesJson,
    Value<DateTime>? observedAt,
    Value<String?>? originTerminal,
    Value<String?>? originGate,
    Value<String?>? destinationTerminal,
    Value<String?>? destinationGate,
    Value<String?>? replacementFlightId,
    Value<int>? rowid,
  }) {
    return CachedFlightsCompanion(
      id: id ?? this.id,
      operatingCarrierCode: operatingCarrierCode ?? this.operatingCarrierCode,
      operatingCarrierName: operatingCarrierName ?? this.operatingCarrierName,
      flightNumber: flightNumber ?? this.flightNumber,
      originCode: originCode ?? this.originCode,
      originName: originName ?? this.originName,
      destinationCode: destinationCode ?? this.destinationCode,
      destinationName: destinationName ?? this.destinationName,
      scheduledDepartureUtc:
          scheduledDepartureUtc ?? this.scheduledDepartureUtc,
      estimatedDepartureUtc:
          estimatedDepartureUtc ?? this.estimatedDepartureUtc,
      scheduledArrivalUtc: scheduledArrivalUtc ?? this.scheduledArrivalUtc,
      estimatedArrivalUtc: estimatedArrivalUtc ?? this.estimatedArrivalUtc,
      originTimeZone: originTimeZone ?? this.originTimeZone,
      destinationTimeZone: destinationTimeZone ?? this.destinationTimeZone,
      phase: phase ?? this.phase,
      disruptionsJson: disruptionsJson ?? this.disruptionsJson,
      codeshareAliasesJson: codeshareAliasesJson ?? this.codeshareAliasesJson,
      observedAt: observedAt ?? this.observedAt,
      originTerminal: originTerminal ?? this.originTerminal,
      originGate: originGate ?? this.originGate,
      destinationTerminal: destinationTerminal ?? this.destinationTerminal,
      destinationGate: destinationGate ?? this.destinationGate,
      replacementFlightId: replacementFlightId ?? this.replacementFlightId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operatingCarrierCode.present) {
      map['operating_carrier_code'] = Variable<String>(
        operatingCarrierCode.value,
      );
    }
    if (operatingCarrierName.present) {
      map['operating_carrier_name'] = Variable<String>(
        operatingCarrierName.value,
      );
    }
    if (flightNumber.present) {
      map['flight_number'] = Variable<String>(flightNumber.value);
    }
    if (originCode.present) {
      map['origin_code'] = Variable<String>(originCode.value);
    }
    if (originName.present) {
      map['origin_name'] = Variable<String>(originName.value);
    }
    if (destinationCode.present) {
      map['destination_code'] = Variable<String>(destinationCode.value);
    }
    if (destinationName.present) {
      map['destination_name'] = Variable<String>(destinationName.value);
    }
    if (scheduledDepartureUtc.present) {
      map['scheduled_departure_utc'] = Variable<DateTime>(
        scheduledDepartureUtc.value,
      );
    }
    if (estimatedDepartureUtc.present) {
      map['estimated_departure_utc'] = Variable<DateTime>(
        estimatedDepartureUtc.value,
      );
    }
    if (scheduledArrivalUtc.present) {
      map['scheduled_arrival_utc'] = Variable<DateTime>(
        scheduledArrivalUtc.value,
      );
    }
    if (estimatedArrivalUtc.present) {
      map['estimated_arrival_utc'] = Variable<DateTime>(
        estimatedArrivalUtc.value,
      );
    }
    if (originTimeZone.present) {
      map['origin_time_zone'] = Variable<String>(originTimeZone.value);
    }
    if (destinationTimeZone.present) {
      map['destination_time_zone'] = Variable<String>(
        destinationTimeZone.value,
      );
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (disruptionsJson.present) {
      map['disruptions_json'] = Variable<String>(disruptionsJson.value);
    }
    if (codeshareAliasesJson.present) {
      map['codeshare_aliases_json'] = Variable<String>(
        codeshareAliasesJson.value,
      );
    }
    if (observedAt.present) {
      map['observed_at'] = Variable<DateTime>(observedAt.value);
    }
    if (originTerminal.present) {
      map['origin_terminal'] = Variable<String>(originTerminal.value);
    }
    if (originGate.present) {
      map['origin_gate'] = Variable<String>(originGate.value);
    }
    if (destinationTerminal.present) {
      map['destination_terminal'] = Variable<String>(destinationTerminal.value);
    }
    if (destinationGate.present) {
      map['destination_gate'] = Variable<String>(destinationGate.value);
    }
    if (replacementFlightId.present) {
      map['replacement_flight_id'] = Variable<String>(
        replacementFlightId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFlightsCompanion(')
          ..write('id: $id, ')
          ..write('operatingCarrierCode: $operatingCarrierCode, ')
          ..write('operatingCarrierName: $operatingCarrierName, ')
          ..write('flightNumber: $flightNumber, ')
          ..write('originCode: $originCode, ')
          ..write('originName: $originName, ')
          ..write('destinationCode: $destinationCode, ')
          ..write('destinationName: $destinationName, ')
          ..write('scheduledDepartureUtc: $scheduledDepartureUtc, ')
          ..write('estimatedDepartureUtc: $estimatedDepartureUtc, ')
          ..write('scheduledArrivalUtc: $scheduledArrivalUtc, ')
          ..write('estimatedArrivalUtc: $estimatedArrivalUtc, ')
          ..write('originTimeZone: $originTimeZone, ')
          ..write('destinationTimeZone: $destinationTimeZone, ')
          ..write('phase: $phase, ')
          ..write('disruptionsJson: $disruptionsJson, ')
          ..write('codeshareAliasesJson: $codeshareAliasesJson, ')
          ..write('observedAt: $observedAt, ')
          ..write('originTerminal: $originTerminal, ')
          ..write('originGate: $originGate, ')
          ..write('destinationTerminal: $destinationTerminal, ')
          ..write('destinationGate: $destinationGate, ')
          ..write('replacementFlightId: $replacementFlightId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredFlightFollowsTable extends StoredFlightFollows
    with TableInfo<$StoredFlightFollowsTable, StoredFlightFollow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredFlightFollowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flightIdMeta = const VerificationMeta(
    'flightId',
  );
  @override
  late final GeneratedColumn<String> flightId = GeneratedColumn<String>(
    'flight_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cached_flights (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, flightId, createdAt, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_flight_follows';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredFlightFollow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('flight_id')) {
      context.handle(
        _flightIdMeta,
        flightId.isAcceptableOrUnknown(data['flight_id']!, _flightIdMeta),
      );
    } else if (isInserting) {
      context.missing(_flightIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredFlightFollow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredFlightFollow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      flightId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flight_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $StoredFlightFollowsTable createAlias(String alias) {
    return $StoredFlightFollowsTable(attachedDatabase, alias);
  }
}

class StoredFlightFollow extends DataClass
    implements Insertable<StoredFlightFollow> {
  final String id;
  final String flightId;
  final DateTime createdAt;
  final DateTime? completedAt;
  const StoredFlightFollow({
    required this.id,
    required this.flightId,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['flight_id'] = Variable<String>(flightId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  StoredFlightFollowsCompanion toCompanion(bool nullToAbsent) {
    return StoredFlightFollowsCompanion(
      id: Value(id),
      flightId: Value(flightId),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory StoredFlightFollow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredFlightFollow(
      id: serializer.fromJson<String>(json['id']),
      flightId: serializer.fromJson<String>(json['flightId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'flightId': serializer.toJson<String>(flightId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  StoredFlightFollow copyWith({
    String? id,
    String? flightId,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => StoredFlightFollow(
    id: id ?? this.id,
    flightId: flightId ?? this.flightId,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  StoredFlightFollow copyWithCompanion(StoredFlightFollowsCompanion data) {
    return StoredFlightFollow(
      id: data.id.present ? data.id.value : this.id,
      flightId: data.flightId.present ? data.flightId.value : this.flightId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredFlightFollow(')
          ..write('id: $id, ')
          ..write('flightId: $flightId, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, flightId, createdAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredFlightFollow &&
          other.id == this.id &&
          other.flightId == this.flightId &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class StoredFlightFollowsCompanion extends UpdateCompanion<StoredFlightFollow> {
  final Value<String> id;
  final Value<String> flightId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const StoredFlightFollowsCompanion({
    this.id = const Value.absent(),
    this.flightId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredFlightFollowsCompanion.insert({
    required String id,
    required String flightId,
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       flightId = Value(flightId),
       createdAt = Value(createdAt);
  static Insertable<StoredFlightFollow> custom({
    Expression<String>? id,
    Expression<String>? flightId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flightId != null) 'flight_id': flightId,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredFlightFollowsCompanion copyWith({
    Value<String>? id,
    Value<String>? flightId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return StoredFlightFollowsCompanion(
      id: id ?? this.id,
      flightId: flightId ?? this.flightId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (flightId.present) {
      map['flight_id'] = Variable<String>(flightId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredFlightFollowsCompanion(')
          ..write('id: $id, ')
          ..write('flightId: $flightId, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FlightSearchEntriesTable extends FlightSearchEntries
    with TableInfo<$FlightSearchEntriesTable, FlightSearchEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightSearchEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryKeyMeta = const VerificationMeta(
    'queryKey',
  );
  @override
  late final GeneratedColumn<String> queryKey = GeneratedColumn<String>(
    'query_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flightIdMeta = const VerificationMeta(
    'flightId',
  );
  @override
  late final GeneratedColumn<String> flightId = GeneratedColumn<String>(
    'flight_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cached_flights (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [queryKey, flightId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_search_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlightSearchEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query_key')) {
      context.handle(
        _queryKeyMeta,
        queryKey.isAcceptableOrUnknown(data['query_key']!, _queryKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_queryKeyMeta);
    }
    if (data.containsKey('flight_id')) {
      context.handle(
        _flightIdMeta,
        flightId.isAcceptableOrUnknown(data['flight_id']!, _flightIdMeta),
      );
    } else if (isInserting) {
      context.missing(_flightIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {queryKey, flightId};
  @override
  FlightSearchEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlightSearchEntry(
      queryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query_key'],
      )!,
      flightId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flight_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $FlightSearchEntriesTable createAlias(String alias) {
    return $FlightSearchEntriesTable(attachedDatabase, alias);
  }
}

class FlightSearchEntry extends DataClass
    implements Insertable<FlightSearchEntry> {
  final String queryKey;
  final String flightId;
  final int position;
  const FlightSearchEntry({
    required this.queryKey,
    required this.flightId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query_key'] = Variable<String>(queryKey);
    map['flight_id'] = Variable<String>(flightId);
    map['position'] = Variable<int>(position);
    return map;
  }

  FlightSearchEntriesCompanion toCompanion(bool nullToAbsent) {
    return FlightSearchEntriesCompanion(
      queryKey: Value(queryKey),
      flightId: Value(flightId),
      position: Value(position),
    );
  }

  factory FlightSearchEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlightSearchEntry(
      queryKey: serializer.fromJson<String>(json['queryKey']),
      flightId: serializer.fromJson<String>(json['flightId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queryKey': serializer.toJson<String>(queryKey),
      'flightId': serializer.toJson<String>(flightId),
      'position': serializer.toJson<int>(position),
    };
  }

  FlightSearchEntry copyWith({
    String? queryKey,
    String? flightId,
    int? position,
  }) => FlightSearchEntry(
    queryKey: queryKey ?? this.queryKey,
    flightId: flightId ?? this.flightId,
    position: position ?? this.position,
  );
  FlightSearchEntry copyWithCompanion(FlightSearchEntriesCompanion data) {
    return FlightSearchEntry(
      queryKey: data.queryKey.present ? data.queryKey.value : this.queryKey,
      flightId: data.flightId.present ? data.flightId.value : this.flightId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightSearchEntry(')
          ..write('queryKey: $queryKey, ')
          ..write('flightId: $flightId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(queryKey, flightId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlightSearchEntry &&
          other.queryKey == this.queryKey &&
          other.flightId == this.flightId &&
          other.position == this.position);
}

class FlightSearchEntriesCompanion extends UpdateCompanion<FlightSearchEntry> {
  final Value<String> queryKey;
  final Value<String> flightId;
  final Value<int> position;
  final Value<int> rowid;
  const FlightSearchEntriesCompanion({
    this.queryKey = const Value.absent(),
    this.flightId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlightSearchEntriesCompanion.insert({
    required String queryKey,
    required String flightId,
    required int position,
    this.rowid = const Value.absent(),
  }) : queryKey = Value(queryKey),
       flightId = Value(flightId),
       position = Value(position);
  static Insertable<FlightSearchEntry> custom({
    Expression<String>? queryKey,
    Expression<String>? flightId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (queryKey != null) 'query_key': queryKey,
      if (flightId != null) 'flight_id': flightId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlightSearchEntriesCompanion copyWith({
    Value<String>? queryKey,
    Value<String>? flightId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return FlightSearchEntriesCompanion(
      queryKey: queryKey ?? this.queryKey,
      flightId: flightId ?? this.flightId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queryKey.present) {
      map['query_key'] = Variable<String>(queryKey.value);
    }
    if (flightId.present) {
      map['flight_id'] = Variable<String>(flightId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightSearchEntriesCompanion(')
          ..write('queryKey: $queryKey, ')
          ..write('flightId: $flightId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedFlightsTable cachedFlights = $CachedFlightsTable(this);
  late final $StoredFlightFollowsTable storedFlightFollows =
      $StoredFlightFollowsTable(this);
  late final $FlightSearchEntriesTable flightSearchEntries =
      $FlightSearchEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedFlights,
    storedFlightFollows,
    flightSearchEntries,
  ];
}

typedef $$CachedFlightsTableCreateCompanionBuilder =
    CachedFlightsCompanion Function({
      required String id,
      required String operatingCarrierCode,
      required String operatingCarrierName,
      required String flightNumber,
      required String originCode,
      required String originName,
      required String destinationCode,
      required String destinationName,
      required DateTime scheduledDepartureUtc,
      required DateTime estimatedDepartureUtc,
      required DateTime scheduledArrivalUtc,
      required DateTime estimatedArrivalUtc,
      required String originTimeZone,
      required String destinationTimeZone,
      required String phase,
      required String disruptionsJson,
      required String codeshareAliasesJson,
      required DateTime observedAt,
      Value<String?> originTerminal,
      Value<String?> originGate,
      Value<String?> destinationTerminal,
      Value<String?> destinationGate,
      Value<String?> replacementFlightId,
      Value<int> rowid,
    });
typedef $$CachedFlightsTableUpdateCompanionBuilder =
    CachedFlightsCompanion Function({
      Value<String> id,
      Value<String> operatingCarrierCode,
      Value<String> operatingCarrierName,
      Value<String> flightNumber,
      Value<String> originCode,
      Value<String> originName,
      Value<String> destinationCode,
      Value<String> destinationName,
      Value<DateTime> scheduledDepartureUtc,
      Value<DateTime> estimatedDepartureUtc,
      Value<DateTime> scheduledArrivalUtc,
      Value<DateTime> estimatedArrivalUtc,
      Value<String> originTimeZone,
      Value<String> destinationTimeZone,
      Value<String> phase,
      Value<String> disruptionsJson,
      Value<String> codeshareAliasesJson,
      Value<DateTime> observedAt,
      Value<String?> originTerminal,
      Value<String?> originGate,
      Value<String?> destinationTerminal,
      Value<String?> destinationGate,
      Value<String?> replacementFlightId,
      Value<int> rowid,
    });

final class $$CachedFlightsTableReferences
    extends BaseReferences<_$AppDatabase, $CachedFlightsTable, CachedFlight> {
  $$CachedFlightsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $StoredFlightFollowsTable,
    List<StoredFlightFollow>
  >
  _storedFlightFollowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedFlightFollows,
        aliasName: 'cached_flights__id__stored_flight_follows__flight_id',
      );

  $$StoredFlightFollowsTableProcessedTableManager get storedFlightFollowsRefs {
    final manager = $$StoredFlightFollowsTableTableManager(
      $_db,
      $_db.storedFlightFollows,
    ).filter((f) => f.flightId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedFlightFollowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FlightSearchEntriesTable, List<FlightSearchEntry>>
  _flightSearchEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.flightSearchEntries,
        aliasName: 'cached_flights__id__flight_search_entries__flight_id',
      );

  $$FlightSearchEntriesTableProcessedTableManager get flightSearchEntriesRefs {
    final manager = $$FlightSearchEntriesTableTableManager(
      $_db,
      $_db.flightSearchEntries,
    ).filter((f) => f.flightId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _flightSearchEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CachedFlightsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFlightsTable> {
  $$CachedFlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatingCarrierCode => $composableBuilder(
    column: $table.operatingCarrierCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatingCarrierName => $composableBuilder(
    column: $table.operatingCarrierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originCode => $composableBuilder(
    column: $table.originCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originName => $composableBuilder(
    column: $table.originName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationCode => $composableBuilder(
    column: $table.destinationCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationName => $composableBuilder(
    column: $table.destinationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledDepartureUtc => $composableBuilder(
    column: $table.scheduledDepartureUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get estimatedDepartureUtc => $composableBuilder(
    column: $table.estimatedDepartureUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledArrivalUtc => $composableBuilder(
    column: $table.scheduledArrivalUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get estimatedArrivalUtc => $composableBuilder(
    column: $table.estimatedArrivalUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originTimeZone => $composableBuilder(
    column: $table.originTimeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationTimeZone => $composableBuilder(
    column: $table.destinationTimeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get disruptionsJson => $composableBuilder(
    column: $table.disruptionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codeshareAliasesJson => $composableBuilder(
    column: $table.codeshareAliasesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originTerminal => $composableBuilder(
    column: $table.originTerminal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originGate => $composableBuilder(
    column: $table.originGate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationTerminal => $composableBuilder(
    column: $table.destinationTerminal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationGate => $composableBuilder(
    column: $table.destinationGate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replacementFlightId => $composableBuilder(
    column: $table.replacementFlightId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storedFlightFollowsRefs(
    Expression<bool> Function($$StoredFlightFollowsTableFilterComposer f) f,
  ) {
    final $$StoredFlightFollowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedFlightFollows,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredFlightFollowsTableFilterComposer(
            $db: $db,
            $table: $db.storedFlightFollows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> flightSearchEntriesRefs(
    Expression<bool> Function($$FlightSearchEntriesTableFilterComposer f) f,
  ) {
    final $$FlightSearchEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flightSearchEntries,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightSearchEntriesTableFilterComposer(
            $db: $db,
            $table: $db.flightSearchEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CachedFlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFlightsTable> {
  $$CachedFlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatingCarrierCode => $composableBuilder(
    column: $table.operatingCarrierCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatingCarrierName => $composableBuilder(
    column: $table.operatingCarrierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originCode => $composableBuilder(
    column: $table.originCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originName => $composableBuilder(
    column: $table.originName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationCode => $composableBuilder(
    column: $table.destinationCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationName => $composableBuilder(
    column: $table.destinationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledDepartureUtc => $composableBuilder(
    column: $table.scheduledDepartureUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get estimatedDepartureUtc => $composableBuilder(
    column: $table.estimatedDepartureUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledArrivalUtc => $composableBuilder(
    column: $table.scheduledArrivalUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get estimatedArrivalUtc => $composableBuilder(
    column: $table.estimatedArrivalUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originTimeZone => $composableBuilder(
    column: $table.originTimeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationTimeZone => $composableBuilder(
    column: $table.destinationTimeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get disruptionsJson => $composableBuilder(
    column: $table.disruptionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codeshareAliasesJson => $composableBuilder(
    column: $table.codeshareAliasesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originTerminal => $composableBuilder(
    column: $table.originTerminal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originGate => $composableBuilder(
    column: $table.originGate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationTerminal => $composableBuilder(
    column: $table.destinationTerminal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationGate => $composableBuilder(
    column: $table.destinationGate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replacementFlightId => $composableBuilder(
    column: $table.replacementFlightId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedFlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFlightsTable> {
  $$CachedFlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operatingCarrierCode => $composableBuilder(
    column: $table.operatingCarrierCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operatingCarrierName => $composableBuilder(
    column: $table.operatingCarrierName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flightNumber => $composableBuilder(
    column: $table.flightNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originCode => $composableBuilder(
    column: $table.originCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originName => $composableBuilder(
    column: $table.originName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationCode => $composableBuilder(
    column: $table.destinationCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationName => $composableBuilder(
    column: $table.destinationName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledDepartureUtc => $composableBuilder(
    column: $table.scheduledDepartureUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get estimatedDepartureUtc => $composableBuilder(
    column: $table.estimatedDepartureUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledArrivalUtc => $composableBuilder(
    column: $table.scheduledArrivalUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get estimatedArrivalUtc => $composableBuilder(
    column: $table.estimatedArrivalUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originTimeZone => $composableBuilder(
    column: $table.originTimeZone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationTimeZone => $composableBuilder(
    column: $table.destinationTimeZone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get disruptionsJson => $composableBuilder(
    column: $table.disruptionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codeshareAliasesJson => $composableBuilder(
    column: $table.codeshareAliasesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originTerminal => $composableBuilder(
    column: $table.originTerminal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originGate => $composableBuilder(
    column: $table.originGate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationTerminal => $composableBuilder(
    column: $table.destinationTerminal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationGate => $composableBuilder(
    column: $table.destinationGate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replacementFlightId => $composableBuilder(
    column: $table.replacementFlightId,
    builder: (column) => column,
  );

  Expression<T> storedFlightFollowsRefs<T extends Object>(
    Expression<T> Function($$StoredFlightFollowsTableAnnotationComposer a) f,
  ) {
    final $$StoredFlightFollowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedFlightFollows,
          getReferencedColumn: (t) => t.flightId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredFlightFollowsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedFlightFollows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> flightSearchEntriesRefs<T extends Object>(
    Expression<T> Function($$FlightSearchEntriesTableAnnotationComposer a) f,
  ) {
    final $$FlightSearchEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.flightSearchEntries,
          getReferencedColumn: (t) => t.flightId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlightSearchEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.flightSearchEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CachedFlightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFlightsTable,
          CachedFlight,
          $$CachedFlightsTableFilterComposer,
          $$CachedFlightsTableOrderingComposer,
          $$CachedFlightsTableAnnotationComposer,
          $$CachedFlightsTableCreateCompanionBuilder,
          $$CachedFlightsTableUpdateCompanionBuilder,
          (CachedFlight, $$CachedFlightsTableReferences),
          CachedFlight,
          PrefetchHooks Function({
            bool storedFlightFollowsRefs,
            bool flightSearchEntriesRefs,
          })
        > {
  $$CachedFlightsTableTableManager(_$AppDatabase db, $CachedFlightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> operatingCarrierCode = const Value.absent(),
                Value<String> operatingCarrierName = const Value.absent(),
                Value<String> flightNumber = const Value.absent(),
                Value<String> originCode = const Value.absent(),
                Value<String> originName = const Value.absent(),
                Value<String> destinationCode = const Value.absent(),
                Value<String> destinationName = const Value.absent(),
                Value<DateTime> scheduledDepartureUtc = const Value.absent(),
                Value<DateTime> estimatedDepartureUtc = const Value.absent(),
                Value<DateTime> scheduledArrivalUtc = const Value.absent(),
                Value<DateTime> estimatedArrivalUtc = const Value.absent(),
                Value<String> originTimeZone = const Value.absent(),
                Value<String> destinationTimeZone = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> disruptionsJson = const Value.absent(),
                Value<String> codeshareAliasesJson = const Value.absent(),
                Value<DateTime> observedAt = const Value.absent(),
                Value<String?> originTerminal = const Value.absent(),
                Value<String?> originGate = const Value.absent(),
                Value<String?> destinationTerminal = const Value.absent(),
                Value<String?> destinationGate = const Value.absent(),
                Value<String?> replacementFlightId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFlightsCompanion(
                id: id,
                operatingCarrierCode: operatingCarrierCode,
                operatingCarrierName: operatingCarrierName,
                flightNumber: flightNumber,
                originCode: originCode,
                originName: originName,
                destinationCode: destinationCode,
                destinationName: destinationName,
                scheduledDepartureUtc: scheduledDepartureUtc,
                estimatedDepartureUtc: estimatedDepartureUtc,
                scheduledArrivalUtc: scheduledArrivalUtc,
                estimatedArrivalUtc: estimatedArrivalUtc,
                originTimeZone: originTimeZone,
                destinationTimeZone: destinationTimeZone,
                phase: phase,
                disruptionsJson: disruptionsJson,
                codeshareAliasesJson: codeshareAliasesJson,
                observedAt: observedAt,
                originTerminal: originTerminal,
                originGate: originGate,
                destinationTerminal: destinationTerminal,
                destinationGate: destinationGate,
                replacementFlightId: replacementFlightId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String operatingCarrierCode,
                required String operatingCarrierName,
                required String flightNumber,
                required String originCode,
                required String originName,
                required String destinationCode,
                required String destinationName,
                required DateTime scheduledDepartureUtc,
                required DateTime estimatedDepartureUtc,
                required DateTime scheduledArrivalUtc,
                required DateTime estimatedArrivalUtc,
                required String originTimeZone,
                required String destinationTimeZone,
                required String phase,
                required String disruptionsJson,
                required String codeshareAliasesJson,
                required DateTime observedAt,
                Value<String?> originTerminal = const Value.absent(),
                Value<String?> originGate = const Value.absent(),
                Value<String?> destinationTerminal = const Value.absent(),
                Value<String?> destinationGate = const Value.absent(),
                Value<String?> replacementFlightId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFlightsCompanion.insert(
                id: id,
                operatingCarrierCode: operatingCarrierCode,
                operatingCarrierName: operatingCarrierName,
                flightNumber: flightNumber,
                originCode: originCode,
                originName: originName,
                destinationCode: destinationCode,
                destinationName: destinationName,
                scheduledDepartureUtc: scheduledDepartureUtc,
                estimatedDepartureUtc: estimatedDepartureUtc,
                scheduledArrivalUtc: scheduledArrivalUtc,
                estimatedArrivalUtc: estimatedArrivalUtc,
                originTimeZone: originTimeZone,
                destinationTimeZone: destinationTimeZone,
                phase: phase,
                disruptionsJson: disruptionsJson,
                codeshareAliasesJson: codeshareAliasesJson,
                observedAt: observedAt,
                originTerminal: originTerminal,
                originGate: originGate,
                destinationTerminal: destinationTerminal,
                destinationGate: destinationGate,
                replacementFlightId: replacementFlightId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CachedFlightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                storedFlightFollowsRefs = false,
                flightSearchEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (storedFlightFollowsRefs) db.storedFlightFollows,
                    if (flightSearchEntriesRefs) db.flightSearchEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (storedFlightFollowsRefs)
                        await $_getPrefetchedData<
                          CachedFlight,
                          $CachedFlightsTable,
                          StoredFlightFollow
                        >(
                          currentTable: table,
                          referencedTable: $$CachedFlightsTableReferences
                              ._storedFlightFollowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CachedFlightsTableReferences(
                                db,
                                table,
                                p0,
                              ).storedFlightFollowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.flightId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (flightSearchEntriesRefs)
                        await $_getPrefetchedData<
                          CachedFlight,
                          $CachedFlightsTable,
                          FlightSearchEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CachedFlightsTableReferences
                              ._flightSearchEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CachedFlightsTableReferences(
                                db,
                                table,
                                p0,
                              ).flightSearchEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.flightId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CachedFlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFlightsTable,
      CachedFlight,
      $$CachedFlightsTableFilterComposer,
      $$CachedFlightsTableOrderingComposer,
      $$CachedFlightsTableAnnotationComposer,
      $$CachedFlightsTableCreateCompanionBuilder,
      $$CachedFlightsTableUpdateCompanionBuilder,
      (CachedFlight, $$CachedFlightsTableReferences),
      CachedFlight,
      PrefetchHooks Function({
        bool storedFlightFollowsRefs,
        bool flightSearchEntriesRefs,
      })
    >;
typedef $$StoredFlightFollowsTableCreateCompanionBuilder =
    StoredFlightFollowsCompanion Function({
      required String id,
      required String flightId,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$StoredFlightFollowsTableUpdateCompanionBuilder =
    StoredFlightFollowsCompanion Function({
      Value<String> id,
      Value<String> flightId,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$StoredFlightFollowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StoredFlightFollowsTable,
          StoredFlightFollow
        > {
  $$StoredFlightFollowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CachedFlightsTable _flightIdTable(_$AppDatabase db) => db
      .cachedFlights
      .createAlias('stored_flight_follows__flight_id__cached_flights__id');

  $$CachedFlightsTableProcessedTableManager get flightId {
    final $_column = $_itemColumn<String>('flight_id')!;

    final manager = $$CachedFlightsTableTableManager(
      $_db,
      $_db.cachedFlights,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flightIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredFlightFollowsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredFlightFollowsTable> {
  $$StoredFlightFollowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CachedFlightsTableFilterComposer get flightId {
    final $$CachedFlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.cachedFlights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFlightsTableFilterComposer(
            $db: $db,
            $table: $db.cachedFlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredFlightFollowsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredFlightFollowsTable> {
  $$StoredFlightFollowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CachedFlightsTableOrderingComposer get flightId {
    final $$CachedFlightsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.cachedFlights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFlightsTableOrderingComposer(
            $db: $db,
            $table: $db.cachedFlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredFlightFollowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredFlightFollowsTable> {
  $$StoredFlightFollowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$CachedFlightsTableAnnotationComposer get flightId {
    final $$CachedFlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.cachedFlights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.cachedFlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredFlightFollowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredFlightFollowsTable,
          StoredFlightFollow,
          $$StoredFlightFollowsTableFilterComposer,
          $$StoredFlightFollowsTableOrderingComposer,
          $$StoredFlightFollowsTableAnnotationComposer,
          $$StoredFlightFollowsTableCreateCompanionBuilder,
          $$StoredFlightFollowsTableUpdateCompanionBuilder,
          (StoredFlightFollow, $$StoredFlightFollowsTableReferences),
          StoredFlightFollow,
          PrefetchHooks Function({bool flightId})
        > {
  $$StoredFlightFollowsTableTableManager(
    _$AppDatabase db,
    $StoredFlightFollowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredFlightFollowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredFlightFollowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoredFlightFollowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> flightId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredFlightFollowsCompanion(
                id: id,
                flightId: flightId,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String flightId,
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredFlightFollowsCompanion.insert(
                id: id,
                flightId: flightId,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoredFlightFollowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (flightId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.flightId,
                                referencedTable:
                                    $$StoredFlightFollowsTableReferences
                                        ._flightIdTable(db),
                                referencedColumn:
                                    $$StoredFlightFollowsTableReferences
                                        ._flightIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredFlightFollowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredFlightFollowsTable,
      StoredFlightFollow,
      $$StoredFlightFollowsTableFilterComposer,
      $$StoredFlightFollowsTableOrderingComposer,
      $$StoredFlightFollowsTableAnnotationComposer,
      $$StoredFlightFollowsTableCreateCompanionBuilder,
      $$StoredFlightFollowsTableUpdateCompanionBuilder,
      (StoredFlightFollow, $$StoredFlightFollowsTableReferences),
      StoredFlightFollow,
      PrefetchHooks Function({bool flightId})
    >;
typedef $$FlightSearchEntriesTableCreateCompanionBuilder =
    FlightSearchEntriesCompanion Function({
      required String queryKey,
      required String flightId,
      required int position,
      Value<int> rowid,
    });
typedef $$FlightSearchEntriesTableUpdateCompanionBuilder =
    FlightSearchEntriesCompanion Function({
      Value<String> queryKey,
      Value<String> flightId,
      Value<int> position,
      Value<int> rowid,
    });

final class $$FlightSearchEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FlightSearchEntriesTable,
          FlightSearchEntry
        > {
  $$FlightSearchEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CachedFlightsTable _flightIdTable(_$AppDatabase db) => db
      .cachedFlights
      .createAlias('flight_search_entries__flight_id__cached_flights__id');

  $$CachedFlightsTableProcessedTableManager get flightId {
    final $_column = $_itemColumn<String>('flight_id')!;

    final manager = $$CachedFlightsTableTableManager(
      $_db,
      $_db.cachedFlights,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flightIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FlightSearchEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FlightSearchEntriesTable> {
  $$FlightSearchEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get queryKey => $composableBuilder(
    column: $table.queryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$CachedFlightsTableFilterComposer get flightId {
    final $$CachedFlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.cachedFlights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFlightsTableFilterComposer(
            $db: $db,
            $table: $db.cachedFlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightSearchEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FlightSearchEntriesTable> {
  $$FlightSearchEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get queryKey => $composableBuilder(
    column: $table.queryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$CachedFlightsTableOrderingComposer get flightId {
    final $$CachedFlightsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.cachedFlights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFlightsTableOrderingComposer(
            $db: $db,
            $table: $db.cachedFlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightSearchEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlightSearchEntriesTable> {
  $$FlightSearchEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get queryKey =>
      $composableBuilder(column: $table.queryKey, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$CachedFlightsTableAnnotationComposer get flightId {
    final $$CachedFlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.cachedFlights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.cachedFlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightSearchEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlightSearchEntriesTable,
          FlightSearchEntry,
          $$FlightSearchEntriesTableFilterComposer,
          $$FlightSearchEntriesTableOrderingComposer,
          $$FlightSearchEntriesTableAnnotationComposer,
          $$FlightSearchEntriesTableCreateCompanionBuilder,
          $$FlightSearchEntriesTableUpdateCompanionBuilder,
          (FlightSearchEntry, $$FlightSearchEntriesTableReferences),
          FlightSearchEntry,
          PrefetchHooks Function({bool flightId})
        > {
  $$FlightSearchEntriesTableTableManager(
    _$AppDatabase db,
    $FlightSearchEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlightSearchEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlightSearchEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FlightSearchEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> queryKey = const Value.absent(),
                Value<String> flightId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlightSearchEntriesCompanion(
                queryKey: queryKey,
                flightId: flightId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String queryKey,
                required String flightId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => FlightSearchEntriesCompanion.insert(
                queryKey: queryKey,
                flightId: flightId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlightSearchEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (flightId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.flightId,
                                referencedTable:
                                    $$FlightSearchEntriesTableReferences
                                        ._flightIdTable(db),
                                referencedColumn:
                                    $$FlightSearchEntriesTableReferences
                                        ._flightIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FlightSearchEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlightSearchEntriesTable,
      FlightSearchEntry,
      $$FlightSearchEntriesTableFilterComposer,
      $$FlightSearchEntriesTableOrderingComposer,
      $$FlightSearchEntriesTableAnnotationComposer,
      $$FlightSearchEntriesTableCreateCompanionBuilder,
      $$FlightSearchEntriesTableUpdateCompanionBuilder,
      (FlightSearchEntry, $$FlightSearchEntriesTableReferences),
      FlightSearchEntry,
      PrefetchHooks Function({bool flightId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedFlightsTableTableManager get cachedFlights =>
      $$CachedFlightsTableTableManager(_db, _db.cachedFlights);
  $$StoredFlightFollowsTableTableManager get storedFlightFollows =>
      $$StoredFlightFollowsTableTableManager(_db, _db.storedFlightFollows);
  $$FlightSearchEntriesTableTableManager get flightSearchEntries =>
      $$FlightSearchEntriesTableTableManager(_db, _db.flightSearchEntries);
}
