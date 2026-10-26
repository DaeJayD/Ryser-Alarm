// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AlarmsTable extends Alarms with TableInfo<$AlarmsTable, Alarm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localHourMeta = const VerificationMeta(
    'localHour',
  );
  @override
  late final GeneratedColumn<int> localHour = GeneratedColumn<int>(
    'local_hour',
    aliasedName,
    false,
    check: () => const CustomExpression('local_hour BETWEEN 0 AND 23'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localMinuteMeta = const VerificationMeta(
    'localMinute',
  );
  @override
  late final GeneratedColumn<int> localMinute = GeneratedColumn<int>(
    'local_minute',
    aliasedName,
    false,
    check: () => const CustomExpression('local_minute BETWEEN 0 AND 59'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurrenceTypeMeta = const VerificationMeta(
    'recurrenceType',
  );
  @override
  late final GeneratedColumn<String> recurrenceType = GeneratedColumn<String>(
    'recurrence_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatDaysMaskMeta = const VerificationMeta(
    'repeatDaysMask',
  );
  @override
  late final GeneratedColumn<int> repeatDaysMask = GeneratedColumn<int>(
    'repeat_days_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _soundIdMeta = const VerificationMeta(
    'soundId',
  );
  @override
  late final GeneratedColumn<String> soundId = GeneratedColumn<String>(
    'sound_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ringtoneUriMeta = const VerificationMeta(
    'ringtoneUri',
  );
  @override
  late final GeneratedColumn<String> ringtoneUri = GeneratedColumn<String>(
    'ringtone_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ringtoneTitleMeta = const VerificationMeta(
    'ringtoneTitle',
  );
  @override
  late final GeneratedColumn<String> ringtoneTitle = GeneratedColumn<String>(
    'ringtone_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adaptiveSoundRotationMeta =
      const VerificationMeta('adaptiveSoundRotation');
  @override
  late final GeneratedColumn<bool> adaptiveSoundRotation =
      GeneratedColumn<bool>(
        'adaptive_sound_rotation',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("adaptive_sound_rotation" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _increasingVolumeMeta = const VerificationMeta(
    'increasingVolume',
  );
  @override
  late final GeneratedColumn<bool> increasingVolume = GeneratedColumn<bool>(
    'increasing_volume',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("increasing_volume" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _vibrationEnabledMeta = const VerificationMeta(
    'vibrationEnabled',
  );
  @override
  late final GeneratedColumn<bool> vibrationEnabled = GeneratedColumn<bool>(
    'vibration_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibration_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _snoozeEnabledMeta = const VerificationMeta(
    'snoozeEnabled',
  );
  @override
  late final GeneratedColumn<bool> snoozeEnabled = GeneratedColumn<bool>(
    'snooze_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("snooze_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _snoozeDurationMinutesMeta =
      const VerificationMeta('snoozeDurationMinutes');
  @override
  late final GeneratedColumn<int> snoozeDurationMinutes = GeneratedColumn<int>(
    'snooze_duration_minutes',
    aliasedName,
    false,
    check: () =>
        const CustomExpression('snooze_duration_minutes BETWEEN 1 AND 60'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _definitionRevisionMeta =
      const VerificationMeta('definitionRevision');
  @override
  late final GeneratedColumn<int> definitionRevision = GeneratedColumn<int>(
    'definition_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localHour,
    localMinute,
    label,
    enabled,
    recurrenceType,
    repeatDaysMask,
    soundId,
    ringtoneUri,
    ringtoneTitle,
    adaptiveSoundRotation,
    increasingVolume,
    vibrationEnabled,
    snoozeEnabled,
    snoozeDurationMinutes,
    definitionRevision,
    createdAtMs,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Alarm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_hour')) {
      context.handle(
        _localHourMeta,
        localHour.isAcceptableOrUnknown(data['local_hour']!, _localHourMeta),
      );
    } else if (isInserting) {
      context.missing(_localHourMeta);
    }
    if (data.containsKey('local_minute')) {
      context.handle(
        _localMinuteMeta,
        localMinute.isAcceptableOrUnknown(
          data['local_minute']!,
          _localMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localMinuteMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('recurrence_type')) {
      context.handle(
        _recurrenceTypeMeta,
        recurrenceType.isAcceptableOrUnknown(
          data['recurrence_type']!,
          _recurrenceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recurrenceTypeMeta);
    }
    if (data.containsKey('repeat_days_mask')) {
      context.handle(
        _repeatDaysMaskMeta,
        repeatDaysMask.isAcceptableOrUnknown(
          data['repeat_days_mask']!,
          _repeatDaysMaskMeta,
        ),
      );
    }
    if (data.containsKey('sound_id')) {
      context.handle(
        _soundIdMeta,
        soundId.isAcceptableOrUnknown(data['sound_id']!, _soundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_soundIdMeta);
    }
    if (data.containsKey('ringtone_uri')) {
      context.handle(
        _ringtoneUriMeta,
        ringtoneUri.isAcceptableOrUnknown(
          data['ringtone_uri']!,
          _ringtoneUriMeta,
        ),
      );
    }
    if (data.containsKey('ringtone_title')) {
      context.handle(
        _ringtoneTitleMeta,
        ringtoneTitle.isAcceptableOrUnknown(
          data['ringtone_title']!,
          _ringtoneTitleMeta,
        ),
      );
    }
    if (data.containsKey('adaptive_sound_rotation')) {
      context.handle(
        _adaptiveSoundRotationMeta,
        adaptiveSoundRotation.isAcceptableOrUnknown(
          data['adaptive_sound_rotation']!,
          _adaptiveSoundRotationMeta,
        ),
      );
    }
    if (data.containsKey('increasing_volume')) {
      context.handle(
        _increasingVolumeMeta,
        increasingVolume.isAcceptableOrUnknown(
          data['increasing_volume']!,
          _increasingVolumeMeta,
        ),
      );
    }
    if (data.containsKey('vibration_enabled')) {
      context.handle(
        _vibrationEnabledMeta,
        vibrationEnabled.isAcceptableOrUnknown(
          data['vibration_enabled']!,
          _vibrationEnabledMeta,
        ),
      );
    }
    if (data.containsKey('snooze_enabled')) {
      context.handle(
        _snoozeEnabledMeta,
        snoozeEnabled.isAcceptableOrUnknown(
          data['snooze_enabled']!,
          _snoozeEnabledMeta,
        ),
      );
    }
    if (data.containsKey('snooze_duration_minutes')) {
      context.handle(
        _snoozeDurationMinutesMeta,
        snoozeDurationMinutes.isAcceptableOrUnknown(
          data['snooze_duration_minutes']!,
          _snoozeDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snoozeDurationMinutesMeta);
    }
    if (data.containsKey('definition_revision')) {
      context.handle(
        _definitionRevisionMeta,
        definitionRevision.isAcceptableOrUnknown(
          data['definition_revision']!,
          _definitionRevisionMeta,
        ),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alarm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alarm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_hour'],
      )!,
      localMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_minute'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      recurrenceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_type'],
      )!,
      repeatDaysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_days_mask'],
      )!,
      soundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sound_id'],
      )!,
      ringtoneUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ringtone_uri'],
      ),
      ringtoneTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ringtone_title'],
      ),
      adaptiveSoundRotation: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adaptive_sound_rotation'],
      )!,
      increasingVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}increasing_volume'],
      )!,
      vibrationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibration_enabled'],
      )!,
      snoozeEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}snooze_enabled'],
      )!,
      snoozeDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snooze_duration_minutes'],
      )!,
      definitionRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}definition_revision'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $AlarmsTable createAlias(String alias) {
    return $AlarmsTable(attachedDatabase, alias);
  }
}

class Alarm extends DataClass implements Insertable<Alarm> {
  final String id;
  final int localHour;
  final int localMinute;
  final String? label;
  final bool enabled;
  final String recurrenceType;
  final int repeatDaysMask;
  final String soundId;
  final String? ringtoneUri;
  final String? ringtoneTitle;
  final bool adaptiveSoundRotation;
  final bool increasingVolume;
  final bool vibrationEnabled;
  final bool snoozeEnabled;
  final int snoozeDurationMinutes;
  final int definitionRevision;
  final int createdAtMs;
  final int updatedAtMs;
  const Alarm({
    required this.id,
    required this.localHour,
    required this.localMinute,
    this.label,
    required this.enabled,
    required this.recurrenceType,
    required this.repeatDaysMask,
    required this.soundId,
    this.ringtoneUri,
    this.ringtoneTitle,
    required this.adaptiveSoundRotation,
    required this.increasingVolume,
    required this.vibrationEnabled,
    required this.snoozeEnabled,
    required this.snoozeDurationMinutes,
    required this.definitionRevision,
    required this.createdAtMs,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_hour'] = Variable<int>(localHour);
    map['local_minute'] = Variable<int>(localMinute);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['recurrence_type'] = Variable<String>(recurrenceType);
    map['repeat_days_mask'] = Variable<int>(repeatDaysMask);
    map['sound_id'] = Variable<String>(soundId);
    if (!nullToAbsent || ringtoneUri != null) {
      map['ringtone_uri'] = Variable<String>(ringtoneUri);
    }
    if (!nullToAbsent || ringtoneTitle != null) {
      map['ringtone_title'] = Variable<String>(ringtoneTitle);
    }
    map['adaptive_sound_rotation'] = Variable<bool>(adaptiveSoundRotation);
    map['increasing_volume'] = Variable<bool>(increasingVolume);
    map['vibration_enabled'] = Variable<bool>(vibrationEnabled);
    map['snooze_enabled'] = Variable<bool>(snoozeEnabled);
    map['snooze_duration_minutes'] = Variable<int>(snoozeDurationMinutes);
    map['definition_revision'] = Variable<int>(definitionRevision);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  AlarmsCompanion toCompanion(bool nullToAbsent) {
    return AlarmsCompanion(
      id: Value(id),
      localHour: Value(localHour),
      localMinute: Value(localMinute),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      enabled: Value(enabled),
      recurrenceType: Value(recurrenceType),
      repeatDaysMask: Value(repeatDaysMask),
      soundId: Value(soundId),
      ringtoneUri: ringtoneUri == null && nullToAbsent
          ? const Value.absent()
          : Value(ringtoneUri),
      ringtoneTitle: ringtoneTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(ringtoneTitle),
      adaptiveSoundRotation: Value(adaptiveSoundRotation),
      increasingVolume: Value(increasingVolume),
      vibrationEnabled: Value(vibrationEnabled),
      snoozeEnabled: Value(snoozeEnabled),
      snoozeDurationMinutes: Value(snoozeDurationMinutes),
      definitionRevision: Value(definitionRevision),
      createdAtMs: Value(createdAtMs),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory Alarm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alarm(
      id: serializer.fromJson<String>(json['id']),
      localHour: serializer.fromJson<int>(json['localHour']),
      localMinute: serializer.fromJson<int>(json['localMinute']),
      label: serializer.fromJson<String?>(json['label']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      recurrenceType: serializer.fromJson<String>(json['recurrenceType']),
      repeatDaysMask: serializer.fromJson<int>(json['repeatDaysMask']),
      soundId: serializer.fromJson<String>(json['soundId']),
      ringtoneUri: serializer.fromJson<String?>(json['ringtoneUri']),
      ringtoneTitle: serializer.fromJson<String?>(json['ringtoneTitle']),
      adaptiveSoundRotation: serializer.fromJson<bool>(
        json['adaptiveSoundRotation'],
      ),
      increasingVolume: serializer.fromJson<bool>(json['increasingVolume']),
      vibrationEnabled: serializer.fromJson<bool>(json['vibrationEnabled']),
      snoozeEnabled: serializer.fromJson<bool>(json['snoozeEnabled']),
      snoozeDurationMinutes: serializer.fromJson<int>(
        json['snoozeDurationMinutes'],
      ),
      definitionRevision: serializer.fromJson<int>(json['definitionRevision']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localHour': serializer.toJson<int>(localHour),
      'localMinute': serializer.toJson<int>(localMinute),
      'label': serializer.toJson<String?>(label),
      'enabled': serializer.toJson<bool>(enabled),
      'recurrenceType': serializer.toJson<String>(recurrenceType),
      'repeatDaysMask': serializer.toJson<int>(repeatDaysMask),
      'soundId': serializer.toJson<String>(soundId),
      'ringtoneUri': serializer.toJson<String?>(ringtoneUri),
      'ringtoneTitle': serializer.toJson<String?>(ringtoneTitle),
      'adaptiveSoundRotation': serializer.toJson<bool>(adaptiveSoundRotation),
      'increasingVolume': serializer.toJson<bool>(increasingVolume),
      'vibrationEnabled': serializer.toJson<bool>(vibrationEnabled),
      'snoozeEnabled': serializer.toJson<bool>(snoozeEnabled),
      'snoozeDurationMinutes': serializer.toJson<int>(snoozeDurationMinutes),
      'definitionRevision': serializer.toJson<int>(definitionRevision),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  Alarm copyWith({
    String? id,
    int? localHour,
    int? localMinute,
    Value<String?> label = const Value.absent(),
    bool? enabled,
    String? recurrenceType,
    int? repeatDaysMask,
    String? soundId,
    Value<String?> ringtoneUri = const Value.absent(),
    Value<String?> ringtoneTitle = const Value.absent(),
    bool? adaptiveSoundRotation,
    bool? increasingVolume,
    bool? vibrationEnabled,
    bool? snoozeEnabled,
    int? snoozeDurationMinutes,
    int? definitionRevision,
    int? createdAtMs,
    int? updatedAtMs,
  }) => Alarm(
    id: id ?? this.id,
    localHour: localHour ?? this.localHour,
    localMinute: localMinute ?? this.localMinute,
    label: label.present ? label.value : this.label,
    enabled: enabled ?? this.enabled,
    recurrenceType: recurrenceType ?? this.recurrenceType,
    repeatDaysMask: repeatDaysMask ?? this.repeatDaysMask,
    soundId: soundId ?? this.soundId,
    ringtoneUri: ringtoneUri.present ? ringtoneUri.value : this.ringtoneUri,
    ringtoneTitle: ringtoneTitle.present
        ? ringtoneTitle.value
        : this.ringtoneTitle,
    adaptiveSoundRotation: adaptiveSoundRotation ?? this.adaptiveSoundRotation,
    increasingVolume: increasingVolume ?? this.increasingVolume,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
    snoozeDurationMinutes: snoozeDurationMinutes ?? this.snoozeDurationMinutes,
    definitionRevision: definitionRevision ?? this.definitionRevision,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  Alarm copyWithCompanion(AlarmsCompanion data) {
    return Alarm(
      id: data.id.present ? data.id.value : this.id,
      localHour: data.localHour.present ? data.localHour.value : this.localHour,
      localMinute: data.localMinute.present
          ? data.localMinute.value
          : this.localMinute,
      label: data.label.present ? data.label.value : this.label,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      recurrenceType: data.recurrenceType.present
          ? data.recurrenceType.value
          : this.recurrenceType,
      repeatDaysMask: data.repeatDaysMask.present
          ? data.repeatDaysMask.value
          : this.repeatDaysMask,
      soundId: data.soundId.present ? data.soundId.value : this.soundId,
      ringtoneUri: data.ringtoneUri.present
          ? data.ringtoneUri.value
          : this.ringtoneUri,
      ringtoneTitle: data.ringtoneTitle.present
          ? data.ringtoneTitle.value
          : this.ringtoneTitle,
      adaptiveSoundRotation: data.adaptiveSoundRotation.present
          ? data.adaptiveSoundRotation.value
          : this.adaptiveSoundRotation,
      increasingVolume: data.increasingVolume.present
          ? data.increasingVolume.value
          : this.increasingVolume,
      vibrationEnabled: data.vibrationEnabled.present
          ? data.vibrationEnabled.value
          : this.vibrationEnabled,
      snoozeEnabled: data.snoozeEnabled.present
          ? data.snoozeEnabled.value
          : this.snoozeEnabled,
      snoozeDurationMinutes: data.snoozeDurationMinutes.present
          ? data.snoozeDurationMinutes.value
          : this.snoozeDurationMinutes,
      definitionRevision: data.definitionRevision.present
          ? data.definitionRevision.value
          : this.definitionRevision,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alarm(')
          ..write('id: $id, ')
          ..write('localHour: $localHour, ')
          ..write('localMinute: $localMinute, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('repeatDaysMask: $repeatDaysMask, ')
          ..write('soundId: $soundId, ')
          ..write('ringtoneUri: $ringtoneUri, ')
          ..write('ringtoneTitle: $ringtoneTitle, ')
          ..write('adaptiveSoundRotation: $adaptiveSoundRotation, ')
          ..write('increasingVolume: $increasingVolume, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('snoozeEnabled: $snoozeEnabled, ')
          ..write('snoozeDurationMinutes: $snoozeDurationMinutes, ')
          ..write('definitionRevision: $definitionRevision, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localHour,
    localMinute,
    label,
    enabled,
    recurrenceType,
    repeatDaysMask,
    soundId,
    ringtoneUri,
    ringtoneTitle,
    adaptiveSoundRotation,
    increasingVolume,
    vibrationEnabled,
    snoozeEnabled,
    snoozeDurationMinutes,
    definitionRevision,
    createdAtMs,
    updatedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alarm &&
          other.id == this.id &&
          other.localHour == this.localHour &&
          other.localMinute == this.localMinute &&
          other.label == this.label &&
          other.enabled == this.enabled &&
          other.recurrenceType == this.recurrenceType &&
          other.repeatDaysMask == this.repeatDaysMask &&
          other.soundId == this.soundId &&
          other.ringtoneUri == this.ringtoneUri &&
          other.ringtoneTitle == this.ringtoneTitle &&
          other.adaptiveSoundRotation == this.adaptiveSoundRotation &&
          other.increasingVolume == this.increasingVolume &&
          other.vibrationEnabled == this.vibrationEnabled &&
          other.snoozeEnabled == this.snoozeEnabled &&
          other.snoozeDurationMinutes == this.snoozeDurationMinutes &&
          other.definitionRevision == this.definitionRevision &&
          other.createdAtMs == this.createdAtMs &&
          other.updatedAtMs == this.updatedAtMs);
}

class AlarmsCompanion extends UpdateCompanion<Alarm> {
  final Value<String> id;
  final Value<int> localHour;
  final Value<int> localMinute;
  final Value<String?> label;
  final Value<bool> enabled;
  final Value<String> recurrenceType;
  final Value<int> repeatDaysMask;
  final Value<String> soundId;
  final Value<String?> ringtoneUri;
  final Value<String?> ringtoneTitle;
  final Value<bool> adaptiveSoundRotation;
  final Value<bool> increasingVolume;
  final Value<bool> vibrationEnabled;
  final Value<bool> snoozeEnabled;
  final Value<int> snoozeDurationMinutes;
  final Value<int> definitionRevision;
  final Value<int> createdAtMs;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const AlarmsCompanion({
    this.id = const Value.absent(),
    this.localHour = const Value.absent(),
    this.localMinute = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.repeatDaysMask = const Value.absent(),
    this.soundId = const Value.absent(),
    this.ringtoneUri = const Value.absent(),
    this.ringtoneTitle = const Value.absent(),
    this.adaptiveSoundRotation = const Value.absent(),
    this.increasingVolume = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.snoozeEnabled = const Value.absent(),
    this.snoozeDurationMinutes = const Value.absent(),
    this.definitionRevision = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlarmsCompanion.insert({
    required String id,
    required int localHour,
    required int localMinute,
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    required String recurrenceType,
    this.repeatDaysMask = const Value.absent(),
    required String soundId,
    this.ringtoneUri = const Value.absent(),
    this.ringtoneTitle = const Value.absent(),
    this.adaptiveSoundRotation = const Value.absent(),
    this.increasingVolume = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.snoozeEnabled = const Value.absent(),
    required int snoozeDurationMinutes,
    this.definitionRevision = const Value.absent(),
    required int createdAtMs,
    required int updatedAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localHour = Value(localHour),
       localMinute = Value(localMinute),
       recurrenceType = Value(recurrenceType),
       soundId = Value(soundId),
       snoozeDurationMinutes = Value(snoozeDurationMinutes),
       createdAtMs = Value(createdAtMs),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<Alarm> custom({
    Expression<String>? id,
    Expression<int>? localHour,
    Expression<int>? localMinute,
    Expression<String>? label,
    Expression<bool>? enabled,
    Expression<String>? recurrenceType,
    Expression<int>? repeatDaysMask,
    Expression<String>? soundId,
    Expression<String>? ringtoneUri,
    Expression<String>? ringtoneTitle,
    Expression<bool>? adaptiveSoundRotation,
    Expression<bool>? increasingVolume,
    Expression<bool>? vibrationEnabled,
    Expression<bool>? snoozeEnabled,
    Expression<int>? snoozeDurationMinutes,
    Expression<int>? definitionRevision,
    Expression<int>? createdAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localHour != null) 'local_hour': localHour,
      if (localMinute != null) 'local_minute': localMinute,
      if (label != null) 'label': label,
      if (enabled != null) 'enabled': enabled,
      if (recurrenceType != null) 'recurrence_type': recurrenceType,
      if (repeatDaysMask != null) 'repeat_days_mask': repeatDaysMask,
      if (soundId != null) 'sound_id': soundId,
      if (ringtoneUri != null) 'ringtone_uri': ringtoneUri,
      if (ringtoneTitle != null) 'ringtone_title': ringtoneTitle,
      if (adaptiveSoundRotation != null)
        'adaptive_sound_rotation': adaptiveSoundRotation,
      if (increasingVolume != null) 'increasing_volume': increasingVolume,
      if (vibrationEnabled != null) 'vibration_enabled': vibrationEnabled,
      if (snoozeEnabled != null) 'snooze_enabled': snoozeEnabled,
      if (snoozeDurationMinutes != null)
        'snooze_duration_minutes': snoozeDurationMinutes,
      if (definitionRevision != null) 'definition_revision': definitionRevision,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlarmsCompanion copyWith({
    Value<String>? id,
    Value<int>? localHour,
    Value<int>? localMinute,
    Value<String?>? label,
    Value<bool>? enabled,
    Value<String>? recurrenceType,
    Value<int>? repeatDaysMask,
    Value<String>? soundId,
    Value<String?>? ringtoneUri,
    Value<String?>? ringtoneTitle,
    Value<bool>? adaptiveSoundRotation,
    Value<bool>? increasingVolume,
    Value<bool>? vibrationEnabled,
    Value<bool>? snoozeEnabled,
    Value<int>? snoozeDurationMinutes,
    Value<int>? definitionRevision,
    Value<int>? createdAtMs,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return AlarmsCompanion(
      id: id ?? this.id,
      localHour: localHour ?? this.localHour,
      localMinute: localMinute ?? this.localMinute,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      repeatDaysMask: repeatDaysMask ?? this.repeatDaysMask,
      soundId: soundId ?? this.soundId,
      ringtoneUri: ringtoneUri ?? this.ringtoneUri,
      ringtoneTitle: ringtoneTitle ?? this.ringtoneTitle,
      adaptiveSoundRotation:
          adaptiveSoundRotation ?? this.adaptiveSoundRotation,
      increasingVolume: increasingVolume ?? this.increasingVolume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
      snoozeDurationMinutes:
          snoozeDurationMinutes ?? this.snoozeDurationMinutes,
      definitionRevision: definitionRevision ?? this.definitionRevision,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localHour.present) {
      map['local_hour'] = Variable<int>(localHour.value);
    }
    if (localMinute.present) {
      map['local_minute'] = Variable<int>(localMinute.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (recurrenceType.present) {
      map['recurrence_type'] = Variable<String>(recurrenceType.value);
    }
    if (repeatDaysMask.present) {
      map['repeat_days_mask'] = Variable<int>(repeatDaysMask.value);
    }
    if (soundId.present) {
      map['sound_id'] = Variable<String>(soundId.value);
    }
    if (ringtoneUri.present) {
      map['ringtone_uri'] = Variable<String>(ringtoneUri.value);
    }
    if (ringtoneTitle.present) {
      map['ringtone_title'] = Variable<String>(ringtoneTitle.value);
    }
    if (adaptiveSoundRotation.present) {
      map['adaptive_sound_rotation'] = Variable<bool>(
        adaptiveSoundRotation.value,
      );
    }
    if (increasingVolume.present) {
      map['increasing_volume'] = Variable<bool>(increasingVolume.value);
    }
    if (vibrationEnabled.present) {
      map['vibration_enabled'] = Variable<bool>(vibrationEnabled.value);
    }
    if (snoozeEnabled.present) {
      map['snooze_enabled'] = Variable<bool>(snoozeEnabled.value);
    }
    if (snoozeDurationMinutes.present) {
      map['snooze_duration_minutes'] = Variable<int>(
        snoozeDurationMinutes.value,
      );
    }
    if (definitionRevision.present) {
      map['definition_revision'] = Variable<int>(definitionRevision.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsCompanion(')
          ..write('id: $id, ')
          ..write('localHour: $localHour, ')
          ..write('localMinute: $localMinute, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('repeatDaysMask: $repeatDaysMask, ')
          ..write('soundId: $soundId, ')
          ..write('ringtoneUri: $ringtoneUri, ')
          ..write('ringtoneTitle: $ringtoneTitle, ')
          ..write('adaptiveSoundRotation: $adaptiveSoundRotation, ')
          ..write('increasingVolume: $increasingVolume, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('snoozeEnabled: $snoozeEnabled, ')
          ..write('snoozeDurationMinutes: $snoozeDurationMinutes, ')
          ..write('definitionRevision: $definitionRevision, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmSoundsTable extends AlarmSounds
    with TableInfo<$AlarmSoundsTable, AlarmSound> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmSoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetPathMeta = const VerificationMeta(
    'assetPath',
  );
  @override
  late final GeneratedColumn<String> assetPath = GeneratedColumn<String>(
    'asset_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soundFamilyMeta = const VerificationMeta(
    'soundFamily',
  );
  @override
  late final GeneratedColumn<String> soundFamily = GeneratedColumn<String>(
    'sound_family',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityLevelMeta = const VerificationMeta(
    'intensityLevel',
  );
  @override
  late final GeneratedColumn<int> intensityLevel = GeneratedColumn<int>(
    'intensity_level',
    aliasedName,
    false,
    check: () => const CustomExpression('intensity_level BETWEEN 1 AND 5'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastUsedAtMsMeta = const VerificationMeta(
    'lastUsedAtMs',
  );
  @override
  late final GeneratedColumn<int> lastUsedAtMs = GeneratedColumn<int>(
    'last_used_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    assetPath,
    soundFamily,
    intensityLevel,
    enabled,
    lastUsedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarm_sounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlarmSound> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('asset_path')) {
      context.handle(
        _assetPathMeta,
        assetPath.isAcceptableOrUnknown(data['asset_path']!, _assetPathMeta),
      );
    } else if (isInserting) {
      context.missing(_assetPathMeta);
    }
    if (data.containsKey('sound_family')) {
      context.handle(
        _soundFamilyMeta,
        soundFamily.isAcceptableOrUnknown(
          data['sound_family']!,
          _soundFamilyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_soundFamilyMeta);
    }
    if (data.containsKey('intensity_level')) {
      context.handle(
        _intensityLevelMeta,
        intensityLevel.isAcceptableOrUnknown(
          data['intensity_level']!,
          _intensityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intensityLevelMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('last_used_at_ms')) {
      context.handle(
        _lastUsedAtMsMeta,
        lastUsedAtMs.isAcceptableOrUnknown(
          data['last_used_at_ms']!,
          _lastUsedAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmSound map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmSound(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      assetPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_path'],
      )!,
      soundFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sound_family'],
      )!,
      intensityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity_level'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      lastUsedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_used_at_ms'],
      ),
    );
  }

  @override
  $AlarmSoundsTable createAlias(String alias) {
    return $AlarmSoundsTable(attachedDatabase, alias);
  }
}

class AlarmSound extends DataClass implements Insertable<AlarmSound> {
  final String id;
  final String name;
  final String assetPath;
  final String soundFamily;
  final int intensityLevel;
  final bool enabled;
  final int? lastUsedAtMs;
  const AlarmSound({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.soundFamily,
    required this.intensityLevel,
    required this.enabled,
    this.lastUsedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['asset_path'] = Variable<String>(assetPath);
    map['sound_family'] = Variable<String>(soundFamily);
    map['intensity_level'] = Variable<int>(intensityLevel);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || lastUsedAtMs != null) {
      map['last_used_at_ms'] = Variable<int>(lastUsedAtMs);
    }
    return map;
  }

  AlarmSoundsCompanion toCompanion(bool nullToAbsent) {
    return AlarmSoundsCompanion(
      id: Value(id),
      name: Value(name),
      assetPath: Value(assetPath),
      soundFamily: Value(soundFamily),
      intensityLevel: Value(intensityLevel),
      enabled: Value(enabled),
      lastUsedAtMs: lastUsedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAtMs),
    );
  }

  factory AlarmSound.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmSound(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      assetPath: serializer.fromJson<String>(json['assetPath']),
      soundFamily: serializer.fromJson<String>(json['soundFamily']),
      intensityLevel: serializer.fromJson<int>(json['intensityLevel']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      lastUsedAtMs: serializer.fromJson<int?>(json['lastUsedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'assetPath': serializer.toJson<String>(assetPath),
      'soundFamily': serializer.toJson<String>(soundFamily),
      'intensityLevel': serializer.toJson<int>(intensityLevel),
      'enabled': serializer.toJson<bool>(enabled),
      'lastUsedAtMs': serializer.toJson<int?>(lastUsedAtMs),
    };
  }

  AlarmSound copyWith({
    String? id,
    String? name,
    String? assetPath,
    String? soundFamily,
    int? intensityLevel,
    bool? enabled,
    Value<int?> lastUsedAtMs = const Value.absent(),
  }) => AlarmSound(
    id: id ?? this.id,
    name: name ?? this.name,
    assetPath: assetPath ?? this.assetPath,
    soundFamily: soundFamily ?? this.soundFamily,
    intensityLevel: intensityLevel ?? this.intensityLevel,
    enabled: enabled ?? this.enabled,
    lastUsedAtMs: lastUsedAtMs.present ? lastUsedAtMs.value : this.lastUsedAtMs,
  );
  AlarmSound copyWithCompanion(AlarmSoundsCompanion data) {
    return AlarmSound(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      assetPath: data.assetPath.present ? data.assetPath.value : this.assetPath,
      soundFamily: data.soundFamily.present
          ? data.soundFamily.value
          : this.soundFamily,
      intensityLevel: data.intensityLevel.present
          ? data.intensityLevel.value
          : this.intensityLevel,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      lastUsedAtMs: data.lastUsedAtMs.present
          ? data.lastUsedAtMs.value
          : this.lastUsedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmSound(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assetPath: $assetPath, ')
          ..write('soundFamily: $soundFamily, ')
          ..write('intensityLevel: $intensityLevel, ')
          ..write('enabled: $enabled, ')
          ..write('lastUsedAtMs: $lastUsedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    assetPath,
    soundFamily,
    intensityLevel,
    enabled,
    lastUsedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmSound &&
          other.id == this.id &&
          other.name == this.name &&
          other.assetPath == this.assetPath &&
          other.soundFamily == this.soundFamily &&
          other.intensityLevel == this.intensityLevel &&
          other.enabled == this.enabled &&
          other.lastUsedAtMs == this.lastUsedAtMs);
}

class AlarmSoundsCompanion extends UpdateCompanion<AlarmSound> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> assetPath;
  final Value<String> soundFamily;
  final Value<int> intensityLevel;
  final Value<bool> enabled;
  final Value<int?> lastUsedAtMs;
  final Value<int> rowid;
  const AlarmSoundsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.assetPath = const Value.absent(),
    this.soundFamily = const Value.absent(),
    this.intensityLevel = const Value.absent(),
    this.enabled = const Value.absent(),
    this.lastUsedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlarmSoundsCompanion.insert({
    required String id,
    required String name,
    required String assetPath,
    required String soundFamily,
    required int intensityLevel,
    this.enabled = const Value.absent(),
    this.lastUsedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       assetPath = Value(assetPath),
       soundFamily = Value(soundFamily),
       intensityLevel = Value(intensityLevel);
  static Insertable<AlarmSound> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? assetPath,
    Expression<String>? soundFamily,
    Expression<int>? intensityLevel,
    Expression<bool>? enabled,
    Expression<int>? lastUsedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (assetPath != null) 'asset_path': assetPath,
      if (soundFamily != null) 'sound_family': soundFamily,
      if (intensityLevel != null) 'intensity_level': intensityLevel,
      if (enabled != null) 'enabled': enabled,
      if (lastUsedAtMs != null) 'last_used_at_ms': lastUsedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlarmSoundsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? assetPath,
    Value<String>? soundFamily,
    Value<int>? intensityLevel,
    Value<bool>? enabled,
    Value<int?>? lastUsedAtMs,
    Value<int>? rowid,
  }) {
    return AlarmSoundsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      soundFamily: soundFamily ?? this.soundFamily,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      enabled: enabled ?? this.enabled,
      lastUsedAtMs: lastUsedAtMs ?? this.lastUsedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (assetPath.present) {
      map['asset_path'] = Variable<String>(assetPath.value);
    }
    if (soundFamily.present) {
      map['sound_family'] = Variable<String>(soundFamily.value);
    }
    if (intensityLevel.present) {
      map['intensity_level'] = Variable<int>(intensityLevel.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (lastUsedAtMs.present) {
      map['last_used_at_ms'] = Variable<int>(lastUsedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmSoundsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assetPath: $assetPath, ')
          ..write('soundFamily: $soundFamily, ')
          ..write('intensityLevel: $intensityLevel, ')
          ..write('enabled: $enabled, ')
          ..write('lastUsedAtMs: $lastUsedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WakeSessionsTable extends WakeSessions
    with TableInfo<$WakeSessionsTable, WakeSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WakeSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alarmIdMeta = const VerificationMeta(
    'alarmId',
  );
  @override
  late final GeneratedColumn<String> alarmId = GeneratedColumn<String>(
    'alarm_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTimeMsMeta = const VerificationMeta(
    'scheduledTimeMs',
  );
  @override
  late final GeneratedColumn<int> scheduledTimeMs = GeneratedColumn<int>(
    'scheduled_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggeredAtMsMeta = const VerificationMeta(
    'triggeredAtMs',
  );
  @override
  late final GeneratedColumn<int> triggeredAtMs = GeneratedColumn<int>(
    'triggered_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialSoundIdMeta = const VerificationMeta(
    'initialSoundId',
  );
  @override
  late final GeneratedColumn<String> initialSoundId = GeneratedColumn<String>(
    'initial_sound_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialVolumeMeta = const VerificationMeta(
    'initialVolume',
  );
  @override
  late final GeneratedColumn<double> initialVolume = GeneratedColumn<double>(
    'initial_volume',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstInteractionAtMsMeta =
      const VerificationMeta('firstInteractionAtMs');
  @override
  late final GeneratedColumn<int> firstInteractionAtMs = GeneratedColumn<int>(
    'first_interaction_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _responseLatencyMsMeta = const VerificationMeta(
    'responseLatencyMs',
  );
  @override
  late final GeneratedColumn<int> responseLatencyMs = GeneratedColumn<int>(
    'response_latency_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snoozeCountMeta = const VerificationMeta(
    'snoozeCount',
  );
  @override
  late final GeneratedColumn<int> snoozeCount = GeneratedColumn<int>(
    'snooze_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _soundChangeCountMeta = const VerificationMeta(
    'soundChangeCount',
  );
  @override
  late final GeneratedColumn<int> soundChangeCount = GeneratedColumn<int>(
    'sound_change_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _escalationCountMeta = const VerificationMeta(
    'escalationCount',
  );
  @override
  late final GeneratedColumn<int> escalationCount = GeneratedColumn<int>(
    'escalation_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dismissedAtMsMeta = const VerificationMeta(
    'dismissedAtMs',
  );
  @override
  late final GeneratedColumn<int> dismissedAtMs = GeneratedColumn<int>(
    'dismissed_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeEnforcementEnabledMeta =
      const VerificationMeta('wakeEnforcementEnabled');
  @override
  late final GeneratedColumn<bool> wakeEnforcementEnabled =
      GeneratedColumn<bool>(
        'wake_enforcement_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("wake_enforcement_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _currentWakeFlowStateMeta =
      const VerificationMeta('currentWakeFlowState');
  @override
  late final GeneratedColumn<String> currentWakeFlowState =
      GeneratedColumn<String>(
        'current_wake_flow_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('completed'),
      );
  static const VerificationMeta _missionTypeMeta = const VerificationMeta(
    'missionType',
  );
  @override
  late final GeneratedColumn<String> missionType = GeneratedColumn<String>(
    'mission_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _missionAttemptCountMeta =
      const VerificationMeta('missionAttemptCount');
  @override
  late final GeneratedColumn<int> missionAttemptCount = GeneratedColumn<int>(
    'mission_attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _missionFailureCountMeta =
      const VerificationMeta('missionFailureCount');
  @override
  late final GeneratedColumn<int> missionFailureCount = GeneratedColumn<int>(
    'mission_failure_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wakeCheckAttemptCountMeta =
      const VerificationMeta('wakeCheckAttemptCount');
  @override
  late final GeneratedColumn<int> wakeCheckAttemptCount = GeneratedColumn<int>(
    'wake_check_attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wakeCheckFailureCountMeta =
      const VerificationMeta('wakeCheckFailureCount');
  @override
  late final GeneratedColumn<int> wakeCheckFailureCount = GeneratedColumn<int>(
    'wake_check_failure_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _confirmedAwakeAtMsMeta =
      const VerificationMeta('confirmedAwakeAtMs');
  @override
  late final GeneratedColumn<int> confirmedAwakeAtMs = GeneratedColumn<int>(
    'confirmed_awake_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMsMeta = const VerificationMeta(
    'completedAtMs',
  );
  @override
  late final GeneratedColumn<int> completedAtMs = GeneratedColumn<int>(
    'completed_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _protocolIdMeta = const VerificationMeta(
    'protocolId',
  );
  @override
  late final GeneratedColumn<String> protocolId = GeneratedColumn<String>(
    'protocol_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _protocolVersionMeta = const VerificationMeta(
    'protocolVersion',
  );
  @override
  late final GeneratedColumn<int> protocolVersion = GeneratedColumn<int>(
    'protocol_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _protocolSnapshotJsonMeta =
      const VerificationMeta('protocolSnapshotJson');
  @override
  late final GeneratedColumn<String> protocolSnapshotJson =
      GeneratedColumn<String>(
        'protocol_snapshot_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _analysisStatusMeta = const VerificationMeta(
    'analysisStatus',
  );
  @override
  late final GeneratedColumn<String> analysisStatus = GeneratedColumn<String>(
    'analysis_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alarmId,
    scheduledTimeMs,
    triggeredAtMs,
    initialSoundId,
    initialVolume,
    firstInteractionAtMs,
    responseLatencyMs,
    snoozeCount,
    soundChangeCount,
    escalationCount,
    dismissedAtMs,
    outcome,
    wakeEnforcementEnabled,
    currentWakeFlowState,
    missionType,
    missionAttemptCount,
    missionFailureCount,
    wakeCheckAttemptCount,
    wakeCheckFailureCount,
    confirmedAwakeAtMs,
    createdAtMs,
    completedAtMs,
    protocolId,
    protocolVersion,
    protocolSnapshotJson,
    analysisStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wake_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WakeSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('alarm_id')) {
      context.handle(
        _alarmIdMeta,
        alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('scheduled_time_ms')) {
      context.handle(
        _scheduledTimeMsMeta,
        scheduledTimeMs.isAcceptableOrUnknown(
          data['scheduled_time_ms']!,
          _scheduledTimeMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTimeMsMeta);
    }
    if (data.containsKey('triggered_at_ms')) {
      context.handle(
        _triggeredAtMsMeta,
        triggeredAtMs.isAcceptableOrUnknown(
          data['triggered_at_ms']!,
          _triggeredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggeredAtMsMeta);
    }
    if (data.containsKey('initial_sound_id')) {
      context.handle(
        _initialSoundIdMeta,
        initialSoundId.isAcceptableOrUnknown(
          data['initial_sound_id']!,
          _initialSoundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialSoundIdMeta);
    }
    if (data.containsKey('initial_volume')) {
      context.handle(
        _initialVolumeMeta,
        initialVolume.isAcceptableOrUnknown(
          data['initial_volume']!,
          _initialVolumeMeta,
        ),
      );
    }
    if (data.containsKey('first_interaction_at_ms')) {
      context.handle(
        _firstInteractionAtMsMeta,
        firstInteractionAtMs.isAcceptableOrUnknown(
          data['first_interaction_at_ms']!,
          _firstInteractionAtMsMeta,
        ),
      );
    }
    if (data.containsKey('response_latency_ms')) {
      context.handle(
        _responseLatencyMsMeta,
        responseLatencyMs.isAcceptableOrUnknown(
          data['response_latency_ms']!,
          _responseLatencyMsMeta,
        ),
      );
    }
    if (data.containsKey('snooze_count')) {
      context.handle(
        _snoozeCountMeta,
        snoozeCount.isAcceptableOrUnknown(
          data['snooze_count']!,
          _snoozeCountMeta,
        ),
      );
    }
    if (data.containsKey('sound_change_count')) {
      context.handle(
        _soundChangeCountMeta,
        soundChangeCount.isAcceptableOrUnknown(
          data['sound_change_count']!,
          _soundChangeCountMeta,
        ),
      );
    }
    if (data.containsKey('escalation_count')) {
      context.handle(
        _escalationCountMeta,
        escalationCount.isAcceptableOrUnknown(
          data['escalation_count']!,
          _escalationCountMeta,
        ),
      );
    }
    if (data.containsKey('dismissed_at_ms')) {
      context.handle(
        _dismissedAtMsMeta,
        dismissedAtMs.isAcceptableOrUnknown(
          data['dismissed_at_ms']!,
          _dismissedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('wake_enforcement_enabled')) {
      context.handle(
        _wakeEnforcementEnabledMeta,
        wakeEnforcementEnabled.isAcceptableOrUnknown(
          data['wake_enforcement_enabled']!,
          _wakeEnforcementEnabledMeta,
        ),
      );
    }
    if (data.containsKey('current_wake_flow_state')) {
      context.handle(
        _currentWakeFlowStateMeta,
        currentWakeFlowState.isAcceptableOrUnknown(
          data['current_wake_flow_state']!,
          _currentWakeFlowStateMeta,
        ),
      );
    }
    if (data.containsKey('mission_type')) {
      context.handle(
        _missionTypeMeta,
        missionType.isAcceptableOrUnknown(
          data['mission_type']!,
          _missionTypeMeta,
        ),
      );
    }
    if (data.containsKey('mission_attempt_count')) {
      context.handle(
        _missionAttemptCountMeta,
        missionAttemptCount.isAcceptableOrUnknown(
          data['mission_attempt_count']!,
          _missionAttemptCountMeta,
        ),
      );
    }
    if (data.containsKey('mission_failure_count')) {
      context.handle(
        _missionFailureCountMeta,
        missionFailureCount.isAcceptableOrUnknown(
          data['mission_failure_count']!,
          _missionFailureCountMeta,
        ),
      );
    }
    if (data.containsKey('wake_check_attempt_count')) {
      context.handle(
        _wakeCheckAttemptCountMeta,
        wakeCheckAttemptCount.isAcceptableOrUnknown(
          data['wake_check_attempt_count']!,
          _wakeCheckAttemptCountMeta,
        ),
      );
    }
    if (data.containsKey('wake_check_failure_count')) {
      context.handle(
        _wakeCheckFailureCountMeta,
        wakeCheckFailureCount.isAcceptableOrUnknown(
          data['wake_check_failure_count']!,
          _wakeCheckFailureCountMeta,
        ),
      );
    }
    if (data.containsKey('confirmed_awake_at_ms')) {
      context.handle(
        _confirmedAwakeAtMsMeta,
        confirmedAwakeAtMs.isAcceptableOrUnknown(
          data['confirmed_awake_at_ms']!,
          _confirmedAwakeAtMsMeta,
        ),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('completed_at_ms')) {
      context.handle(
        _completedAtMsMeta,
        completedAtMs.isAcceptableOrUnknown(
          data['completed_at_ms']!,
          _completedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('protocol_id')) {
      context.handle(
        _protocolIdMeta,
        protocolId.isAcceptableOrUnknown(data['protocol_id']!, _protocolIdMeta),
      );
    }
    if (data.containsKey('protocol_version')) {
      context.handle(
        _protocolVersionMeta,
        protocolVersion.isAcceptableOrUnknown(
          data['protocol_version']!,
          _protocolVersionMeta,
        ),
      );
    }
    if (data.containsKey('protocol_snapshot_json')) {
      context.handle(
        _protocolSnapshotJsonMeta,
        protocolSnapshotJson.isAcceptableOrUnknown(
          data['protocol_snapshot_json']!,
          _protocolSnapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('analysis_status')) {
      context.handle(
        _analysisStatusMeta,
        analysisStatus.isAcceptableOrUnknown(
          data['analysis_status']!,
          _analysisStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WakeSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WakeSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      alarmId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alarm_id'],
      )!,
      scheduledTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_time_ms'],
      )!,
      triggeredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triggered_at_ms'],
      )!,
      initialSoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_sound_id'],
      )!,
      initialVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_volume'],
      ),
      firstInteractionAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_interaction_at_ms'],
      ),
      responseLatencyMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_latency_ms'],
      ),
      snoozeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snooze_count'],
      )!,
      soundChangeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sound_change_count'],
      )!,
      escalationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escalation_count'],
      )!,
      dismissedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dismissed_at_ms'],
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      wakeEnforcementEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}wake_enforcement_enabled'],
      )!,
      currentWakeFlowState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_wake_flow_state'],
      )!,
      missionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_type'],
      ),
      missionAttemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mission_attempt_count'],
      )!,
      missionFailureCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mission_failure_count'],
      )!,
      wakeCheckAttemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_check_attempt_count'],
      )!,
      wakeCheckFailureCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_check_failure_count'],
      )!,
      confirmedAwakeAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confirmed_awake_at_ms'],
      ),
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      completedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_ms'],
      ),
      protocolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_id'],
      ),
      protocolVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protocol_version'],
      ),
      protocolSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_snapshot_json'],
      ),
      analysisStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_status'],
      )!,
    );
  }

  @override
  $WakeSessionsTable createAlias(String alias) {
    return $WakeSessionsTable(attachedDatabase, alias);
  }
}

class WakeSession extends DataClass implements Insertable<WakeSession> {
  final String id;
  final String alarmId;
  final int scheduledTimeMs;
  final int triggeredAtMs;
  final String initialSoundId;
  final double? initialVolume;
  final int? firstInteractionAtMs;
  final int? responseLatencyMs;
  final int snoozeCount;
  final int soundChangeCount;
  final int escalationCount;
  final int? dismissedAtMs;
  final String outcome;
  final bool wakeEnforcementEnabled;
  final String currentWakeFlowState;
  final String? missionType;
  final int missionAttemptCount;
  final int missionFailureCount;
  final int wakeCheckAttemptCount;
  final int wakeCheckFailureCount;
  final int? confirmedAwakeAtMs;
  final int createdAtMs;
  final int? completedAtMs;
  final String? protocolId;
  final int? protocolVersion;
  final String? protocolSnapshotJson;
  final String analysisStatus;
  const WakeSession({
    required this.id,
    required this.alarmId,
    required this.scheduledTimeMs,
    required this.triggeredAtMs,
    required this.initialSoundId,
    this.initialVolume,
    this.firstInteractionAtMs,
    this.responseLatencyMs,
    required this.snoozeCount,
    required this.soundChangeCount,
    required this.escalationCount,
    this.dismissedAtMs,
    required this.outcome,
    required this.wakeEnforcementEnabled,
    required this.currentWakeFlowState,
    this.missionType,
    required this.missionAttemptCount,
    required this.missionFailureCount,
    required this.wakeCheckAttemptCount,
    required this.wakeCheckFailureCount,
    this.confirmedAwakeAtMs,
    required this.createdAtMs,
    this.completedAtMs,
    this.protocolId,
    this.protocolVersion,
    this.protocolSnapshotJson,
    required this.analysisStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['alarm_id'] = Variable<String>(alarmId);
    map['scheduled_time_ms'] = Variable<int>(scheduledTimeMs);
    map['triggered_at_ms'] = Variable<int>(triggeredAtMs);
    map['initial_sound_id'] = Variable<String>(initialSoundId);
    if (!nullToAbsent || initialVolume != null) {
      map['initial_volume'] = Variable<double>(initialVolume);
    }
    if (!nullToAbsent || firstInteractionAtMs != null) {
      map['first_interaction_at_ms'] = Variable<int>(firstInteractionAtMs);
    }
    if (!nullToAbsent || responseLatencyMs != null) {
      map['response_latency_ms'] = Variable<int>(responseLatencyMs);
    }
    map['snooze_count'] = Variable<int>(snoozeCount);
    map['sound_change_count'] = Variable<int>(soundChangeCount);
    map['escalation_count'] = Variable<int>(escalationCount);
    if (!nullToAbsent || dismissedAtMs != null) {
      map['dismissed_at_ms'] = Variable<int>(dismissedAtMs);
    }
    map['outcome'] = Variable<String>(outcome);
    map['wake_enforcement_enabled'] = Variable<bool>(wakeEnforcementEnabled);
    map['current_wake_flow_state'] = Variable<String>(currentWakeFlowState);
    if (!nullToAbsent || missionType != null) {
      map['mission_type'] = Variable<String>(missionType);
    }
    map['mission_attempt_count'] = Variable<int>(missionAttemptCount);
    map['mission_failure_count'] = Variable<int>(missionFailureCount);
    map['wake_check_attempt_count'] = Variable<int>(wakeCheckAttemptCount);
    map['wake_check_failure_count'] = Variable<int>(wakeCheckFailureCount);
    if (!nullToAbsent || confirmedAwakeAtMs != null) {
      map['confirmed_awake_at_ms'] = Variable<int>(confirmedAwakeAtMs);
    }
    map['created_at_ms'] = Variable<int>(createdAtMs);
    if (!nullToAbsent || completedAtMs != null) {
      map['completed_at_ms'] = Variable<int>(completedAtMs);
    }
    if (!nullToAbsent || protocolId != null) {
      map['protocol_id'] = Variable<String>(protocolId);
    }
    if (!nullToAbsent || protocolVersion != null) {
      map['protocol_version'] = Variable<int>(protocolVersion);
    }
    if (!nullToAbsent || protocolSnapshotJson != null) {
      map['protocol_snapshot_json'] = Variable<String>(protocolSnapshotJson);
    }
    map['analysis_status'] = Variable<String>(analysisStatus);
    return map;
  }

  WakeSessionsCompanion toCompanion(bool nullToAbsent) {
    return WakeSessionsCompanion(
      id: Value(id),
      alarmId: Value(alarmId),
      scheduledTimeMs: Value(scheduledTimeMs),
      triggeredAtMs: Value(triggeredAtMs),
      initialSoundId: Value(initialSoundId),
      initialVolume: initialVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(initialVolume),
      firstInteractionAtMs: firstInteractionAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(firstInteractionAtMs),
      responseLatencyMs: responseLatencyMs == null && nullToAbsent
          ? const Value.absent()
          : Value(responseLatencyMs),
      snoozeCount: Value(snoozeCount),
      soundChangeCount: Value(soundChangeCount),
      escalationCount: Value(escalationCount),
      dismissedAtMs: dismissedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(dismissedAtMs),
      outcome: Value(outcome),
      wakeEnforcementEnabled: Value(wakeEnforcementEnabled),
      currentWakeFlowState: Value(currentWakeFlowState),
      missionType: missionType == null && nullToAbsent
          ? const Value.absent()
          : Value(missionType),
      missionAttemptCount: Value(missionAttemptCount),
      missionFailureCount: Value(missionFailureCount),
      wakeCheckAttemptCount: Value(wakeCheckAttemptCount),
      wakeCheckFailureCount: Value(wakeCheckFailureCount),
      confirmedAwakeAtMs: confirmedAwakeAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAwakeAtMs),
      createdAtMs: Value(createdAtMs),
      completedAtMs: completedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMs),
      protocolId: protocolId == null && nullToAbsent
          ? const Value.absent()
          : Value(protocolId),
      protocolVersion: protocolVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(protocolVersion),
      protocolSnapshotJson: protocolSnapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(protocolSnapshotJson),
      analysisStatus: Value(analysisStatus),
    );
  }

  factory WakeSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WakeSession(
      id: serializer.fromJson<String>(json['id']),
      alarmId: serializer.fromJson<String>(json['alarmId']),
      scheduledTimeMs: serializer.fromJson<int>(json['scheduledTimeMs']),
      triggeredAtMs: serializer.fromJson<int>(json['triggeredAtMs']),
      initialSoundId: serializer.fromJson<String>(json['initialSoundId']),
      initialVolume: serializer.fromJson<double?>(json['initialVolume']),
      firstInteractionAtMs: serializer.fromJson<int?>(
        json['firstInteractionAtMs'],
      ),
      responseLatencyMs: serializer.fromJson<int?>(json['responseLatencyMs']),
      snoozeCount: serializer.fromJson<int>(json['snoozeCount']),
      soundChangeCount: serializer.fromJson<int>(json['soundChangeCount']),
      escalationCount: serializer.fromJson<int>(json['escalationCount']),
      dismissedAtMs: serializer.fromJson<int?>(json['dismissedAtMs']),
      outcome: serializer.fromJson<String>(json['outcome']),
      wakeEnforcementEnabled: serializer.fromJson<bool>(
        json['wakeEnforcementEnabled'],
      ),
      currentWakeFlowState: serializer.fromJson<String>(
        json['currentWakeFlowState'],
      ),
      missionType: serializer.fromJson<String?>(json['missionType']),
      missionAttemptCount: serializer.fromJson<int>(
        json['missionAttemptCount'],
      ),
      missionFailureCount: serializer.fromJson<int>(
        json['missionFailureCount'],
      ),
      wakeCheckAttemptCount: serializer.fromJson<int>(
        json['wakeCheckAttemptCount'],
      ),
      wakeCheckFailureCount: serializer.fromJson<int>(
        json['wakeCheckFailureCount'],
      ),
      confirmedAwakeAtMs: serializer.fromJson<int?>(json['confirmedAwakeAtMs']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      completedAtMs: serializer.fromJson<int?>(json['completedAtMs']),
      protocolId: serializer.fromJson<String?>(json['protocolId']),
      protocolVersion: serializer.fromJson<int?>(json['protocolVersion']),
      protocolSnapshotJson: serializer.fromJson<String?>(
        json['protocolSnapshotJson'],
      ),
      analysisStatus: serializer.fromJson<String>(json['analysisStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'alarmId': serializer.toJson<String>(alarmId),
      'scheduledTimeMs': serializer.toJson<int>(scheduledTimeMs),
      'triggeredAtMs': serializer.toJson<int>(triggeredAtMs),
      'initialSoundId': serializer.toJson<String>(initialSoundId),
      'initialVolume': serializer.toJson<double?>(initialVolume),
      'firstInteractionAtMs': serializer.toJson<int?>(firstInteractionAtMs),
      'responseLatencyMs': serializer.toJson<int?>(responseLatencyMs),
      'snoozeCount': serializer.toJson<int>(snoozeCount),
      'soundChangeCount': serializer.toJson<int>(soundChangeCount),
      'escalationCount': serializer.toJson<int>(escalationCount),
      'dismissedAtMs': serializer.toJson<int?>(dismissedAtMs),
      'outcome': serializer.toJson<String>(outcome),
      'wakeEnforcementEnabled': serializer.toJson<bool>(wakeEnforcementEnabled),
      'currentWakeFlowState': serializer.toJson<String>(currentWakeFlowState),
      'missionType': serializer.toJson<String?>(missionType),
      'missionAttemptCount': serializer.toJson<int>(missionAttemptCount),
      'missionFailureCount': serializer.toJson<int>(missionFailureCount),
      'wakeCheckAttemptCount': serializer.toJson<int>(wakeCheckAttemptCount),
      'wakeCheckFailureCount': serializer.toJson<int>(wakeCheckFailureCount),
      'confirmedAwakeAtMs': serializer.toJson<int?>(confirmedAwakeAtMs),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'completedAtMs': serializer.toJson<int?>(completedAtMs),
      'protocolId': serializer.toJson<String?>(protocolId),
      'protocolVersion': serializer.toJson<int?>(protocolVersion),
      'protocolSnapshotJson': serializer.toJson<String?>(protocolSnapshotJson),
      'analysisStatus': serializer.toJson<String>(analysisStatus),
    };
  }

  WakeSession copyWith({
    String? id,
    String? alarmId,
    int? scheduledTimeMs,
    int? triggeredAtMs,
    String? initialSoundId,
    Value<double?> initialVolume = const Value.absent(),
    Value<int?> firstInteractionAtMs = const Value.absent(),
    Value<int?> responseLatencyMs = const Value.absent(),
    int? snoozeCount,
    int? soundChangeCount,
    int? escalationCount,
    Value<int?> dismissedAtMs = const Value.absent(),
    String? outcome,
    bool? wakeEnforcementEnabled,
    String? currentWakeFlowState,
    Value<String?> missionType = const Value.absent(),
    int? missionAttemptCount,
    int? missionFailureCount,
    int? wakeCheckAttemptCount,
    int? wakeCheckFailureCount,
    Value<int?> confirmedAwakeAtMs = const Value.absent(),
    int? createdAtMs,
    Value<int?> completedAtMs = const Value.absent(),
    Value<String?> protocolId = const Value.absent(),
    Value<int?> protocolVersion = const Value.absent(),
    Value<String?> protocolSnapshotJson = const Value.absent(),
    String? analysisStatus,
  }) => WakeSession(
    id: id ?? this.id,
    alarmId: alarmId ?? this.alarmId,
    scheduledTimeMs: scheduledTimeMs ?? this.scheduledTimeMs,
    triggeredAtMs: triggeredAtMs ?? this.triggeredAtMs,
    initialSoundId: initialSoundId ?? this.initialSoundId,
    initialVolume: initialVolume.present
        ? initialVolume.value
        : this.initialVolume,
    firstInteractionAtMs: firstInteractionAtMs.present
        ? firstInteractionAtMs.value
        : this.firstInteractionAtMs,
    responseLatencyMs: responseLatencyMs.present
        ? responseLatencyMs.value
        : this.responseLatencyMs,
    snoozeCount: snoozeCount ?? this.snoozeCount,
    soundChangeCount: soundChangeCount ?? this.soundChangeCount,
    escalationCount: escalationCount ?? this.escalationCount,
    dismissedAtMs: dismissedAtMs.present
        ? dismissedAtMs.value
        : this.dismissedAtMs,
    outcome: outcome ?? this.outcome,
    wakeEnforcementEnabled:
        wakeEnforcementEnabled ?? this.wakeEnforcementEnabled,
    currentWakeFlowState: currentWakeFlowState ?? this.currentWakeFlowState,
    missionType: missionType.present ? missionType.value : this.missionType,
    missionAttemptCount: missionAttemptCount ?? this.missionAttemptCount,
    missionFailureCount: missionFailureCount ?? this.missionFailureCount,
    wakeCheckAttemptCount: wakeCheckAttemptCount ?? this.wakeCheckAttemptCount,
    wakeCheckFailureCount: wakeCheckFailureCount ?? this.wakeCheckFailureCount,
    confirmedAwakeAtMs: confirmedAwakeAtMs.present
        ? confirmedAwakeAtMs.value
        : this.confirmedAwakeAtMs,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    completedAtMs: completedAtMs.present
        ? completedAtMs.value
        : this.completedAtMs,
    protocolId: protocolId.present ? protocolId.value : this.protocolId,
    protocolVersion: protocolVersion.present
        ? protocolVersion.value
        : this.protocolVersion,
    protocolSnapshotJson: protocolSnapshotJson.present
        ? protocolSnapshotJson.value
        : this.protocolSnapshotJson,
    analysisStatus: analysisStatus ?? this.analysisStatus,
  );
  WakeSession copyWithCompanion(WakeSessionsCompanion data) {
    return WakeSession(
      id: data.id.present ? data.id.value : this.id,
      alarmId: data.alarmId.present ? data.alarmId.value : this.alarmId,
      scheduledTimeMs: data.scheduledTimeMs.present
          ? data.scheduledTimeMs.value
          : this.scheduledTimeMs,
      triggeredAtMs: data.triggeredAtMs.present
          ? data.triggeredAtMs.value
          : this.triggeredAtMs,
      initialSoundId: data.initialSoundId.present
          ? data.initialSoundId.value
          : this.initialSoundId,
      initialVolume: data.initialVolume.present
          ? data.initialVolume.value
          : this.initialVolume,
      firstInteractionAtMs: data.firstInteractionAtMs.present
          ? data.firstInteractionAtMs.value
          : this.firstInteractionAtMs,
      responseLatencyMs: data.responseLatencyMs.present
          ? data.responseLatencyMs.value
          : this.responseLatencyMs,
      snoozeCount: data.snoozeCount.present
          ? data.snoozeCount.value
          : this.snoozeCount,
      soundChangeCount: data.soundChangeCount.present
          ? data.soundChangeCount.value
          : this.soundChangeCount,
      escalationCount: data.escalationCount.present
          ? data.escalationCount.value
          : this.escalationCount,
      dismissedAtMs: data.dismissedAtMs.present
          ? data.dismissedAtMs.value
          : this.dismissedAtMs,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      wakeEnforcementEnabled: data.wakeEnforcementEnabled.present
          ? data.wakeEnforcementEnabled.value
          : this.wakeEnforcementEnabled,
      currentWakeFlowState: data.currentWakeFlowState.present
          ? data.currentWakeFlowState.value
          : this.currentWakeFlowState,
      missionType: data.missionType.present
          ? data.missionType.value
          : this.missionType,
      missionAttemptCount: data.missionAttemptCount.present
          ? data.missionAttemptCount.value
          : this.missionAttemptCount,
      missionFailureCount: data.missionFailureCount.present
          ? data.missionFailureCount.value
          : this.missionFailureCount,
      wakeCheckAttemptCount: data.wakeCheckAttemptCount.present
          ? data.wakeCheckAttemptCount.value
          : this.wakeCheckAttemptCount,
      wakeCheckFailureCount: data.wakeCheckFailureCount.present
          ? data.wakeCheckFailureCount.value
          : this.wakeCheckFailureCount,
      confirmedAwakeAtMs: data.confirmedAwakeAtMs.present
          ? data.confirmedAwakeAtMs.value
          : this.confirmedAwakeAtMs,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      completedAtMs: data.completedAtMs.present
          ? data.completedAtMs.value
          : this.completedAtMs,
      protocolId: data.protocolId.present
          ? data.protocolId.value
          : this.protocolId,
      protocolVersion: data.protocolVersion.present
          ? data.protocolVersion.value
          : this.protocolVersion,
      protocolSnapshotJson: data.protocolSnapshotJson.present
          ? data.protocolSnapshotJson.value
          : this.protocolSnapshotJson,
      analysisStatus: data.analysisStatus.present
          ? data.analysisStatus.value
          : this.analysisStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WakeSession(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('scheduledTimeMs: $scheduledTimeMs, ')
          ..write('triggeredAtMs: $triggeredAtMs, ')
          ..write('initialSoundId: $initialSoundId, ')
          ..write('initialVolume: $initialVolume, ')
          ..write('firstInteractionAtMs: $firstInteractionAtMs, ')
          ..write('responseLatencyMs: $responseLatencyMs, ')
          ..write('snoozeCount: $snoozeCount, ')
          ..write('soundChangeCount: $soundChangeCount, ')
          ..write('escalationCount: $escalationCount, ')
          ..write('dismissedAtMs: $dismissedAtMs, ')
          ..write('outcome: $outcome, ')
          ..write('wakeEnforcementEnabled: $wakeEnforcementEnabled, ')
          ..write('currentWakeFlowState: $currentWakeFlowState, ')
          ..write('missionType: $missionType, ')
          ..write('missionAttemptCount: $missionAttemptCount, ')
          ..write('missionFailureCount: $missionFailureCount, ')
          ..write('wakeCheckAttemptCount: $wakeCheckAttemptCount, ')
          ..write('wakeCheckFailureCount: $wakeCheckFailureCount, ')
          ..write('confirmedAwakeAtMs: $confirmedAwakeAtMs, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('protocolId: $protocolId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('protocolSnapshotJson: $protocolSnapshotJson, ')
          ..write('analysisStatus: $analysisStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    alarmId,
    scheduledTimeMs,
    triggeredAtMs,
    initialSoundId,
    initialVolume,
    firstInteractionAtMs,
    responseLatencyMs,
    snoozeCount,
    soundChangeCount,
    escalationCount,
    dismissedAtMs,
    outcome,
    wakeEnforcementEnabled,
    currentWakeFlowState,
    missionType,
    missionAttemptCount,
    missionFailureCount,
    wakeCheckAttemptCount,
    wakeCheckFailureCount,
    confirmedAwakeAtMs,
    createdAtMs,
    completedAtMs,
    protocolId,
    protocolVersion,
    protocolSnapshotJson,
    analysisStatus,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WakeSession &&
          other.id == this.id &&
          other.alarmId == this.alarmId &&
          other.scheduledTimeMs == this.scheduledTimeMs &&
          other.triggeredAtMs == this.triggeredAtMs &&
          other.initialSoundId == this.initialSoundId &&
          other.initialVolume == this.initialVolume &&
          other.firstInteractionAtMs == this.firstInteractionAtMs &&
          other.responseLatencyMs == this.responseLatencyMs &&
          other.snoozeCount == this.snoozeCount &&
          other.soundChangeCount == this.soundChangeCount &&
          other.escalationCount == this.escalationCount &&
          other.dismissedAtMs == this.dismissedAtMs &&
          other.outcome == this.outcome &&
          other.wakeEnforcementEnabled == this.wakeEnforcementEnabled &&
          other.currentWakeFlowState == this.currentWakeFlowState &&
          other.missionType == this.missionType &&
          other.missionAttemptCount == this.missionAttemptCount &&
          other.missionFailureCount == this.missionFailureCount &&
          other.wakeCheckAttemptCount == this.wakeCheckAttemptCount &&
          other.wakeCheckFailureCount == this.wakeCheckFailureCount &&
          other.confirmedAwakeAtMs == this.confirmedAwakeAtMs &&
          other.createdAtMs == this.createdAtMs &&
          other.completedAtMs == this.completedAtMs &&
          other.protocolId == this.protocolId &&
          other.protocolVersion == this.protocolVersion &&
          other.protocolSnapshotJson == this.protocolSnapshotJson &&
          other.analysisStatus == this.analysisStatus);
}

class WakeSessionsCompanion extends UpdateCompanion<WakeSession> {
  final Value<String> id;
  final Value<String> alarmId;
  final Value<int> scheduledTimeMs;
  final Value<int> triggeredAtMs;
  final Value<String> initialSoundId;
  final Value<double?> initialVolume;
  final Value<int?> firstInteractionAtMs;
  final Value<int?> responseLatencyMs;
  final Value<int> snoozeCount;
  final Value<int> soundChangeCount;
  final Value<int> escalationCount;
  final Value<int?> dismissedAtMs;
  final Value<String> outcome;
  final Value<bool> wakeEnforcementEnabled;
  final Value<String> currentWakeFlowState;
  final Value<String?> missionType;
  final Value<int> missionAttemptCount;
  final Value<int> missionFailureCount;
  final Value<int> wakeCheckAttemptCount;
  final Value<int> wakeCheckFailureCount;
  final Value<int?> confirmedAwakeAtMs;
  final Value<int> createdAtMs;
  final Value<int?> completedAtMs;
  final Value<String?> protocolId;
  final Value<int?> protocolVersion;
  final Value<String?> protocolSnapshotJson;
  final Value<String> analysisStatus;
  final Value<int> rowid;
  const WakeSessionsCompanion({
    this.id = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.scheduledTimeMs = const Value.absent(),
    this.triggeredAtMs = const Value.absent(),
    this.initialSoundId = const Value.absent(),
    this.initialVolume = const Value.absent(),
    this.firstInteractionAtMs = const Value.absent(),
    this.responseLatencyMs = const Value.absent(),
    this.snoozeCount = const Value.absent(),
    this.soundChangeCount = const Value.absent(),
    this.escalationCount = const Value.absent(),
    this.dismissedAtMs = const Value.absent(),
    this.outcome = const Value.absent(),
    this.wakeEnforcementEnabled = const Value.absent(),
    this.currentWakeFlowState = const Value.absent(),
    this.missionType = const Value.absent(),
    this.missionAttemptCount = const Value.absent(),
    this.missionFailureCount = const Value.absent(),
    this.wakeCheckAttemptCount = const Value.absent(),
    this.wakeCheckFailureCount = const Value.absent(),
    this.confirmedAwakeAtMs = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    this.protocolId = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.protocolSnapshotJson = const Value.absent(),
    this.analysisStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WakeSessionsCompanion.insert({
    required String id,
    required String alarmId,
    required int scheduledTimeMs,
    required int triggeredAtMs,
    required String initialSoundId,
    this.initialVolume = const Value.absent(),
    this.firstInteractionAtMs = const Value.absent(),
    this.responseLatencyMs = const Value.absent(),
    this.snoozeCount = const Value.absent(),
    this.soundChangeCount = const Value.absent(),
    this.escalationCount = const Value.absent(),
    this.dismissedAtMs = const Value.absent(),
    required String outcome,
    this.wakeEnforcementEnabled = const Value.absent(),
    this.currentWakeFlowState = const Value.absent(),
    this.missionType = const Value.absent(),
    this.missionAttemptCount = const Value.absent(),
    this.missionFailureCount = const Value.absent(),
    this.wakeCheckAttemptCount = const Value.absent(),
    this.wakeCheckFailureCount = const Value.absent(),
    this.confirmedAwakeAtMs = const Value.absent(),
    required int createdAtMs,
    this.completedAtMs = const Value.absent(),
    this.protocolId = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.protocolSnapshotJson = const Value.absent(),
    this.analysisStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       alarmId = Value(alarmId),
       scheduledTimeMs = Value(scheduledTimeMs),
       triggeredAtMs = Value(triggeredAtMs),
       initialSoundId = Value(initialSoundId),
       outcome = Value(outcome),
       createdAtMs = Value(createdAtMs);
  static Insertable<WakeSession> custom({
    Expression<String>? id,
    Expression<String>? alarmId,
    Expression<int>? scheduledTimeMs,
    Expression<int>? triggeredAtMs,
    Expression<String>? initialSoundId,
    Expression<double>? initialVolume,
    Expression<int>? firstInteractionAtMs,
    Expression<int>? responseLatencyMs,
    Expression<int>? snoozeCount,
    Expression<int>? soundChangeCount,
    Expression<int>? escalationCount,
    Expression<int>? dismissedAtMs,
    Expression<String>? outcome,
    Expression<bool>? wakeEnforcementEnabled,
    Expression<String>? currentWakeFlowState,
    Expression<String>? missionType,
    Expression<int>? missionAttemptCount,
    Expression<int>? missionFailureCount,
    Expression<int>? wakeCheckAttemptCount,
    Expression<int>? wakeCheckFailureCount,
    Expression<int>? confirmedAwakeAtMs,
    Expression<int>? createdAtMs,
    Expression<int>? completedAtMs,
    Expression<String>? protocolId,
    Expression<int>? protocolVersion,
    Expression<String>? protocolSnapshotJson,
    Expression<String>? analysisStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alarmId != null) 'alarm_id': alarmId,
      if (scheduledTimeMs != null) 'scheduled_time_ms': scheduledTimeMs,
      if (triggeredAtMs != null) 'triggered_at_ms': triggeredAtMs,
      if (initialSoundId != null) 'initial_sound_id': initialSoundId,
      if (initialVolume != null) 'initial_volume': initialVolume,
      if (firstInteractionAtMs != null)
        'first_interaction_at_ms': firstInteractionAtMs,
      if (responseLatencyMs != null) 'response_latency_ms': responseLatencyMs,
      if (snoozeCount != null) 'snooze_count': snoozeCount,
      if (soundChangeCount != null) 'sound_change_count': soundChangeCount,
      if (escalationCount != null) 'escalation_count': escalationCount,
      if (dismissedAtMs != null) 'dismissed_at_ms': dismissedAtMs,
      if (outcome != null) 'outcome': outcome,
      if (wakeEnforcementEnabled != null)
        'wake_enforcement_enabled': wakeEnforcementEnabled,
      if (currentWakeFlowState != null)
        'current_wake_flow_state': currentWakeFlowState,
      if (missionType != null) 'mission_type': missionType,
      if (missionAttemptCount != null)
        'mission_attempt_count': missionAttemptCount,
      if (missionFailureCount != null)
        'mission_failure_count': missionFailureCount,
      if (wakeCheckAttemptCount != null)
        'wake_check_attempt_count': wakeCheckAttemptCount,
      if (wakeCheckFailureCount != null)
        'wake_check_failure_count': wakeCheckFailureCount,
      if (confirmedAwakeAtMs != null)
        'confirmed_awake_at_ms': confirmedAwakeAtMs,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (completedAtMs != null) 'completed_at_ms': completedAtMs,
      if (protocolId != null) 'protocol_id': protocolId,
      if (protocolVersion != null) 'protocol_version': protocolVersion,
      if (protocolSnapshotJson != null)
        'protocol_snapshot_json': protocolSnapshotJson,
      if (analysisStatus != null) 'analysis_status': analysisStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WakeSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? alarmId,
    Value<int>? scheduledTimeMs,
    Value<int>? triggeredAtMs,
    Value<String>? initialSoundId,
    Value<double?>? initialVolume,
    Value<int?>? firstInteractionAtMs,
    Value<int?>? responseLatencyMs,
    Value<int>? snoozeCount,
    Value<int>? soundChangeCount,
    Value<int>? escalationCount,
    Value<int?>? dismissedAtMs,
    Value<String>? outcome,
    Value<bool>? wakeEnforcementEnabled,
    Value<String>? currentWakeFlowState,
    Value<String?>? missionType,
    Value<int>? missionAttemptCount,
    Value<int>? missionFailureCount,
    Value<int>? wakeCheckAttemptCount,
    Value<int>? wakeCheckFailureCount,
    Value<int?>? confirmedAwakeAtMs,
    Value<int>? createdAtMs,
    Value<int?>? completedAtMs,
    Value<String?>? protocolId,
    Value<int?>? protocolVersion,
    Value<String?>? protocolSnapshotJson,
    Value<String>? analysisStatus,
    Value<int>? rowid,
  }) {
    return WakeSessionsCompanion(
      id: id ?? this.id,
      alarmId: alarmId ?? this.alarmId,
      scheduledTimeMs: scheduledTimeMs ?? this.scheduledTimeMs,
      triggeredAtMs: triggeredAtMs ?? this.triggeredAtMs,
      initialSoundId: initialSoundId ?? this.initialSoundId,
      initialVolume: initialVolume ?? this.initialVolume,
      firstInteractionAtMs: firstInteractionAtMs ?? this.firstInteractionAtMs,
      responseLatencyMs: responseLatencyMs ?? this.responseLatencyMs,
      snoozeCount: snoozeCount ?? this.snoozeCount,
      soundChangeCount: soundChangeCount ?? this.soundChangeCount,
      escalationCount: escalationCount ?? this.escalationCount,
      dismissedAtMs: dismissedAtMs ?? this.dismissedAtMs,
      outcome: outcome ?? this.outcome,
      wakeEnforcementEnabled:
          wakeEnforcementEnabled ?? this.wakeEnforcementEnabled,
      currentWakeFlowState: currentWakeFlowState ?? this.currentWakeFlowState,
      missionType: missionType ?? this.missionType,
      missionAttemptCount: missionAttemptCount ?? this.missionAttemptCount,
      missionFailureCount: missionFailureCount ?? this.missionFailureCount,
      wakeCheckAttemptCount:
          wakeCheckAttemptCount ?? this.wakeCheckAttemptCount,
      wakeCheckFailureCount:
          wakeCheckFailureCount ?? this.wakeCheckFailureCount,
      confirmedAwakeAtMs: confirmedAwakeAtMs ?? this.confirmedAwakeAtMs,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      completedAtMs: completedAtMs ?? this.completedAtMs,
      protocolId: protocolId ?? this.protocolId,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      protocolSnapshotJson: protocolSnapshotJson ?? this.protocolSnapshotJson,
      analysisStatus: analysisStatus ?? this.analysisStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<String>(alarmId.value);
    }
    if (scheduledTimeMs.present) {
      map['scheduled_time_ms'] = Variable<int>(scheduledTimeMs.value);
    }
    if (triggeredAtMs.present) {
      map['triggered_at_ms'] = Variable<int>(triggeredAtMs.value);
    }
    if (initialSoundId.present) {
      map['initial_sound_id'] = Variable<String>(initialSoundId.value);
    }
    if (initialVolume.present) {
      map['initial_volume'] = Variable<double>(initialVolume.value);
    }
    if (firstInteractionAtMs.present) {
      map['first_interaction_at_ms'] = Variable<int>(
        firstInteractionAtMs.value,
      );
    }
    if (responseLatencyMs.present) {
      map['response_latency_ms'] = Variable<int>(responseLatencyMs.value);
    }
    if (snoozeCount.present) {
      map['snooze_count'] = Variable<int>(snoozeCount.value);
    }
    if (soundChangeCount.present) {
      map['sound_change_count'] = Variable<int>(soundChangeCount.value);
    }
    if (escalationCount.present) {
      map['escalation_count'] = Variable<int>(escalationCount.value);
    }
    if (dismissedAtMs.present) {
      map['dismissed_at_ms'] = Variable<int>(dismissedAtMs.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (wakeEnforcementEnabled.present) {
      map['wake_enforcement_enabled'] = Variable<bool>(
        wakeEnforcementEnabled.value,
      );
    }
    if (currentWakeFlowState.present) {
      map['current_wake_flow_state'] = Variable<String>(
        currentWakeFlowState.value,
      );
    }
    if (missionType.present) {
      map['mission_type'] = Variable<String>(missionType.value);
    }
    if (missionAttemptCount.present) {
      map['mission_attempt_count'] = Variable<int>(missionAttemptCount.value);
    }
    if (missionFailureCount.present) {
      map['mission_failure_count'] = Variable<int>(missionFailureCount.value);
    }
    if (wakeCheckAttemptCount.present) {
      map['wake_check_attempt_count'] = Variable<int>(
        wakeCheckAttemptCount.value,
      );
    }
    if (wakeCheckFailureCount.present) {
      map['wake_check_failure_count'] = Variable<int>(
        wakeCheckFailureCount.value,
      );
    }
    if (confirmedAwakeAtMs.present) {
      map['confirmed_awake_at_ms'] = Variable<int>(confirmedAwakeAtMs.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (completedAtMs.present) {
      map['completed_at_ms'] = Variable<int>(completedAtMs.value);
    }
    if (protocolId.present) {
      map['protocol_id'] = Variable<String>(protocolId.value);
    }
    if (protocolVersion.present) {
      map['protocol_version'] = Variable<int>(protocolVersion.value);
    }
    if (protocolSnapshotJson.present) {
      map['protocol_snapshot_json'] = Variable<String>(
        protocolSnapshotJson.value,
      );
    }
    if (analysisStatus.present) {
      map['analysis_status'] = Variable<String>(analysisStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WakeSessionsCompanion(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('scheduledTimeMs: $scheduledTimeMs, ')
          ..write('triggeredAtMs: $triggeredAtMs, ')
          ..write('initialSoundId: $initialSoundId, ')
          ..write('initialVolume: $initialVolume, ')
          ..write('firstInteractionAtMs: $firstInteractionAtMs, ')
          ..write('responseLatencyMs: $responseLatencyMs, ')
          ..write('snoozeCount: $snoozeCount, ')
          ..write('soundChangeCount: $soundChangeCount, ')
          ..write('escalationCount: $escalationCount, ')
          ..write('dismissedAtMs: $dismissedAtMs, ')
          ..write('outcome: $outcome, ')
          ..write('wakeEnforcementEnabled: $wakeEnforcementEnabled, ')
          ..write('currentWakeFlowState: $currentWakeFlowState, ')
          ..write('missionType: $missionType, ')
          ..write('missionAttemptCount: $missionAttemptCount, ')
          ..write('missionFailureCount: $missionFailureCount, ')
          ..write('wakeCheckAttemptCount: $wakeCheckAttemptCount, ')
          ..write('wakeCheckFailureCount: $wakeCheckFailureCount, ')
          ..write('confirmedAwakeAtMs: $confirmedAwakeAtMs, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('protocolId: $protocolId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('protocolSnapshotJson: $protocolSnapshotJson, ')
          ..write('analysisStatus: $analysisStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WakeEventsTable extends WakeEvents
    with TableInfo<$WakeEventsTable, WakeEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WakeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeSessionIdMeta = const VerificationMeta(
    'wakeSessionId',
  );
  @override
  late final GeneratedColumn<String> wakeSessionId = GeneratedColumn<String>(
    'wake_session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceNumberMeta = const VerificationMeta(
    'sequenceNumber',
  );
  @override
  late final GeneratedColumn<int> sequenceNumber = GeneratedColumn<int>(
    'sequence_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMsMeta = const VerificationMeta(
    'occurredAtMs',
  );
  @override
  late final GeneratedColumn<int> occurredAtMs = GeneratedColumn<int>(
    'occurred_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wakeSessionId,
    sequenceNumber,
    eventType,
    occurredAtMs,
    metadataJson,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wake_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<WakeEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wake_session_id')) {
      context.handle(
        _wakeSessionIdMeta,
        wakeSessionId.isAcceptableOrUnknown(
          data['wake_session_id']!,
          _wakeSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeSessionIdMeta);
    }
    if (data.containsKey('sequence_number')) {
      context.handle(
        _sequenceNumberMeta,
        sequenceNumber.isAcceptableOrUnknown(
          data['sequence_number']!,
          _sequenceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceNumberMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('occurred_at_ms')) {
      context.handle(
        _occurredAtMsMeta,
        occurredAtMs.isAcceptableOrUnknown(
          data['occurred_at_ms']!,
          _occurredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMsMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metadataJsonMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WakeEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WakeEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wakeSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_session_id'],
      )!,
      sequenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_number'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      occurredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_ms'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $WakeEventsTable createAlias(String alias) {
    return $WakeEventsTable(attachedDatabase, alias);
  }
}

class WakeEvent extends DataClass implements Insertable<WakeEvent> {
  final String id;
  final String wakeSessionId;
  final int sequenceNumber;
  final String eventType;
  final int occurredAtMs;
  final String metadataJson;
  final String source;
  const WakeEvent({
    required this.id,
    required this.wakeSessionId,
    required this.sequenceNumber,
    required this.eventType,
    required this.occurredAtMs,
    required this.metadataJson,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wake_session_id'] = Variable<String>(wakeSessionId);
    map['sequence_number'] = Variable<int>(sequenceNumber);
    map['event_type'] = Variable<String>(eventType);
    map['occurred_at_ms'] = Variable<int>(occurredAtMs);
    map['metadata_json'] = Variable<String>(metadataJson);
    map['source'] = Variable<String>(source);
    return map;
  }

  WakeEventsCompanion toCompanion(bool nullToAbsent) {
    return WakeEventsCompanion(
      id: Value(id),
      wakeSessionId: Value(wakeSessionId),
      sequenceNumber: Value(sequenceNumber),
      eventType: Value(eventType),
      occurredAtMs: Value(occurredAtMs),
      metadataJson: Value(metadataJson),
      source: Value(source),
    );
  }

  factory WakeEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WakeEvent(
      id: serializer.fromJson<String>(json['id']),
      wakeSessionId: serializer.fromJson<String>(json['wakeSessionId']),
      sequenceNumber: serializer.fromJson<int>(json['sequenceNumber']),
      eventType: serializer.fromJson<String>(json['eventType']),
      occurredAtMs: serializer.fromJson<int>(json['occurredAtMs']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wakeSessionId': serializer.toJson<String>(wakeSessionId),
      'sequenceNumber': serializer.toJson<int>(sequenceNumber),
      'eventType': serializer.toJson<String>(eventType),
      'occurredAtMs': serializer.toJson<int>(occurredAtMs),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'source': serializer.toJson<String>(source),
    };
  }

  WakeEvent copyWith({
    String? id,
    String? wakeSessionId,
    int? sequenceNumber,
    String? eventType,
    int? occurredAtMs,
    String? metadataJson,
    String? source,
  }) => WakeEvent(
    id: id ?? this.id,
    wakeSessionId: wakeSessionId ?? this.wakeSessionId,
    sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    eventType: eventType ?? this.eventType,
    occurredAtMs: occurredAtMs ?? this.occurredAtMs,
    metadataJson: metadataJson ?? this.metadataJson,
    source: source ?? this.source,
  );
  WakeEvent copyWithCompanion(WakeEventsCompanion data) {
    return WakeEvent(
      id: data.id.present ? data.id.value : this.id,
      wakeSessionId: data.wakeSessionId.present
          ? data.wakeSessionId.value
          : this.wakeSessionId,
      sequenceNumber: data.sequenceNumber.present
          ? data.sequenceNumber.value
          : this.sequenceNumber,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      occurredAtMs: data.occurredAtMs.present
          ? data.occurredAtMs.value
          : this.occurredAtMs,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WakeEvent(')
          ..write('id: $id, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAtMs: $occurredAtMs, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wakeSessionId,
    sequenceNumber,
    eventType,
    occurredAtMs,
    metadataJson,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WakeEvent &&
          other.id == this.id &&
          other.wakeSessionId == this.wakeSessionId &&
          other.sequenceNumber == this.sequenceNumber &&
          other.eventType == this.eventType &&
          other.occurredAtMs == this.occurredAtMs &&
          other.metadataJson == this.metadataJson &&
          other.source == this.source);
}

class WakeEventsCompanion extends UpdateCompanion<WakeEvent> {
  final Value<String> id;
  final Value<String> wakeSessionId;
  final Value<int> sequenceNumber;
  final Value<String> eventType;
  final Value<int> occurredAtMs;
  final Value<String> metadataJson;
  final Value<String> source;
  final Value<int> rowid;
  const WakeEventsCompanion({
    this.id = const Value.absent(),
    this.wakeSessionId = const Value.absent(),
    this.sequenceNumber = const Value.absent(),
    this.eventType = const Value.absent(),
    this.occurredAtMs = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WakeEventsCompanion.insert({
    required String id,
    required String wakeSessionId,
    required int sequenceNumber,
    required String eventType,
    required int occurredAtMs,
    required String metadataJson,
    required String source,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wakeSessionId = Value(wakeSessionId),
       sequenceNumber = Value(sequenceNumber),
       eventType = Value(eventType),
       occurredAtMs = Value(occurredAtMs),
       metadataJson = Value(metadataJson),
       source = Value(source);
  static Insertable<WakeEvent> custom({
    Expression<String>? id,
    Expression<String>? wakeSessionId,
    Expression<int>? sequenceNumber,
    Expression<String>? eventType,
    Expression<int>? occurredAtMs,
    Expression<String>? metadataJson,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wakeSessionId != null) 'wake_session_id': wakeSessionId,
      if (sequenceNumber != null) 'sequence_number': sequenceNumber,
      if (eventType != null) 'event_type': eventType,
      if (occurredAtMs != null) 'occurred_at_ms': occurredAtMs,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WakeEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? wakeSessionId,
    Value<int>? sequenceNumber,
    Value<String>? eventType,
    Value<int>? occurredAtMs,
    Value<String>? metadataJson,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return WakeEventsCompanion(
      id: id ?? this.id,
      wakeSessionId: wakeSessionId ?? this.wakeSessionId,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      eventType: eventType ?? this.eventType,
      occurredAtMs: occurredAtMs ?? this.occurredAtMs,
      metadataJson: metadataJson ?? this.metadataJson,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wakeSessionId.present) {
      map['wake_session_id'] = Variable<String>(wakeSessionId.value);
    }
    if (sequenceNumber.present) {
      map['sequence_number'] = Variable<int>(sequenceNumber.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (occurredAtMs.present) {
      map['occurred_at_ms'] = Variable<int>(occurredAtMs.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WakeEventsCompanion(')
          ..write('id: $id, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAtMs: $occurredAtMs, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, valueType, value, updatedAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String valueType;
  final String value;
  final int updatedAtMs;
  const AppSetting({
    required this.key,
    required this.valueType,
    required this.value,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_type'] = Variable<String>(valueType);
    map['value'] = Variable<String>(value);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      valueType: Value(valueType),
      value: Value(value),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      valueType: serializer.fromJson<String>(json['valueType']),
      value: serializer.fromJson<String>(json['value']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueType': serializer.toJson<String>(valueType),
      'value': serializer.toJson<String>(value),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  AppSetting copyWith({
    String? key,
    String? valueType,
    String? value,
    int? updatedAtMs,
  }) => AppSetting(
    key: key ?? this.key,
    valueType: valueType ?? this.valueType,
    value: value ?? this.value,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      value: data.value.present ? data.value.value : this.value,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('valueType: $valueType, ')
          ..write('value: $value, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueType, value, updatedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.valueType == this.valueType &&
          other.value == this.value &&
          other.updatedAtMs == this.updatedAtMs);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> valueType;
  final Value<String> value;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.valueType = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String valueType,
    required String value,
    required int updatedAtMs,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       valueType = Value(valueType),
       value = Value(value),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? valueType,
    Expression<String>? value,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueType != null) 'value_type': valueType,
      if (value != null) 'value': value,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? valueType,
    Value<String>? value,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      valueType: valueType ?? this.valueType,
      value: value ?? this.value,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('valueType: $valueType, ')
          ..write('value: $value, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MissionsTable extends Missions with TableInfo<$MissionsTable, Mission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alarmIdMeta = const VerificationMeta(
    'alarmId',
  );
  @override
  late final GeneratedColumn<String> alarmId = GeneratedColumn<String>(
    'alarm_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alarms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _missionTypeMeta = const VerificationMeta(
    'missionType',
  );
  @override
  late final GeneratedColumn<String> missionType = GeneratedColumn<String>(
    'mission_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configurationJsonMeta = const VerificationMeta(
    'configurationJson',
  );
  @override
  late final GeneratedColumn<String> configurationJson =
      GeneratedColumn<String>(
        'configuration_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alarmId,
    missionType,
    enabled,
    difficulty,
    configurationJson,
    createdAtMs,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'missions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mission> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('alarm_id')) {
      context.handle(
        _alarmIdMeta,
        alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('mission_type')) {
      context.handle(
        _missionTypeMeta,
        missionType.isAcceptableOrUnknown(
          data['mission_type']!,
          _missionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_missionTypeMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('configuration_json')) {
      context.handle(
        _configurationJsonMeta,
        configurationJson.isAcceptableOrUnknown(
          data['configuration_json']!,
          _configurationJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mission(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      alarmId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alarm_id'],
      )!,
      missionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_type'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      configurationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}configuration_json'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $MissionsTable createAlias(String alias) {
    return $MissionsTable(attachedDatabase, alias);
  }
}

class Mission extends DataClass implements Insertable<Mission> {
  final String id;
  final String alarmId;
  final String missionType;
  final bool enabled;
  final String difficulty;
  final String configurationJson;
  final int createdAtMs;
  final int updatedAtMs;
  const Mission({
    required this.id,
    required this.alarmId,
    required this.missionType,
    required this.enabled,
    required this.difficulty,
    required this.configurationJson,
    required this.createdAtMs,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['alarm_id'] = Variable<String>(alarmId);
    map['mission_type'] = Variable<String>(missionType);
    map['enabled'] = Variable<bool>(enabled);
    map['difficulty'] = Variable<String>(difficulty);
    map['configuration_json'] = Variable<String>(configurationJson);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  MissionsCompanion toCompanion(bool nullToAbsent) {
    return MissionsCompanion(
      id: Value(id),
      alarmId: Value(alarmId),
      missionType: Value(missionType),
      enabled: Value(enabled),
      difficulty: Value(difficulty),
      configurationJson: Value(configurationJson),
      createdAtMs: Value(createdAtMs),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory Mission.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mission(
      id: serializer.fromJson<String>(json['id']),
      alarmId: serializer.fromJson<String>(json['alarmId']),
      missionType: serializer.fromJson<String>(json['missionType']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      configurationJson: serializer.fromJson<String>(json['configurationJson']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'alarmId': serializer.toJson<String>(alarmId),
      'missionType': serializer.toJson<String>(missionType),
      'enabled': serializer.toJson<bool>(enabled),
      'difficulty': serializer.toJson<String>(difficulty),
      'configurationJson': serializer.toJson<String>(configurationJson),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  Mission copyWith({
    String? id,
    String? alarmId,
    String? missionType,
    bool? enabled,
    String? difficulty,
    String? configurationJson,
    int? createdAtMs,
    int? updatedAtMs,
  }) => Mission(
    id: id ?? this.id,
    alarmId: alarmId ?? this.alarmId,
    missionType: missionType ?? this.missionType,
    enabled: enabled ?? this.enabled,
    difficulty: difficulty ?? this.difficulty,
    configurationJson: configurationJson ?? this.configurationJson,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  Mission copyWithCompanion(MissionsCompanion data) {
    return Mission(
      id: data.id.present ? data.id.value : this.id,
      alarmId: data.alarmId.present ? data.alarmId.value : this.alarmId,
      missionType: data.missionType.present
          ? data.missionType.value
          : this.missionType,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      configurationJson: data.configurationJson.present
          ? data.configurationJson.value
          : this.configurationJson,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mission(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('missionType: $missionType, ')
          ..write('enabled: $enabled, ')
          ..write('difficulty: $difficulty, ')
          ..write('configurationJson: $configurationJson, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    alarmId,
    missionType,
    enabled,
    difficulty,
    configurationJson,
    createdAtMs,
    updatedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mission &&
          other.id == this.id &&
          other.alarmId == this.alarmId &&
          other.missionType == this.missionType &&
          other.enabled == this.enabled &&
          other.difficulty == this.difficulty &&
          other.configurationJson == this.configurationJson &&
          other.createdAtMs == this.createdAtMs &&
          other.updatedAtMs == this.updatedAtMs);
}

class MissionsCompanion extends UpdateCompanion<Mission> {
  final Value<String> id;
  final Value<String> alarmId;
  final Value<String> missionType;
  final Value<bool> enabled;
  final Value<String> difficulty;
  final Value<String> configurationJson;
  final Value<int> createdAtMs;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const MissionsCompanion({
    this.id = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.missionType = const Value.absent(),
    this.enabled = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.configurationJson = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MissionsCompanion.insert({
    required String id,
    required String alarmId,
    required String missionType,
    this.enabled = const Value.absent(),
    required String difficulty,
    this.configurationJson = const Value.absent(),
    required int createdAtMs,
    required int updatedAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       alarmId = Value(alarmId),
       missionType = Value(missionType),
       difficulty = Value(difficulty),
       createdAtMs = Value(createdAtMs),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<Mission> custom({
    Expression<String>? id,
    Expression<String>? alarmId,
    Expression<String>? missionType,
    Expression<bool>? enabled,
    Expression<String>? difficulty,
    Expression<String>? configurationJson,
    Expression<int>? createdAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alarmId != null) 'alarm_id': alarmId,
      if (missionType != null) 'mission_type': missionType,
      if (enabled != null) 'enabled': enabled,
      if (difficulty != null) 'difficulty': difficulty,
      if (configurationJson != null) 'configuration_json': configurationJson,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MissionsCompanion copyWith({
    Value<String>? id,
    Value<String>? alarmId,
    Value<String>? missionType,
    Value<bool>? enabled,
    Value<String>? difficulty,
    Value<String>? configurationJson,
    Value<int>? createdAtMs,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return MissionsCompanion(
      id: id ?? this.id,
      alarmId: alarmId ?? this.alarmId,
      missionType: missionType ?? this.missionType,
      enabled: enabled ?? this.enabled,
      difficulty: difficulty ?? this.difficulty,
      configurationJson: configurationJson ?? this.configurationJson,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<String>(alarmId.value);
    }
    if (missionType.present) {
      map['mission_type'] = Variable<String>(missionType.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (configurationJson.present) {
      map['configuration_json'] = Variable<String>(configurationJson.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionsCompanion(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('missionType: $missionType, ')
          ..write('enabled: $enabled, ')
          ..write('difficulty: $difficulty, ')
          ..write('configurationJson: $configurationJson, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MissionExecutionsTable extends MissionExecutions
    with TableInfo<$MissionExecutionsTable, MissionExecution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionExecutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeSessionIdMeta = const VerificationMeta(
    'wakeSessionId',
  );
  @override
  late final GeneratedColumn<String> wakeSessionId = GeneratedColumn<String>(
    'wake_session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wake_sessions (id)',
    ),
  );
  static const VerificationMeta _missionIdMeta = const VerificationMeta(
    'missionId',
  );
  @override
  late final GeneratedColumn<String> missionId = GeneratedColumn<String>(
    'mission_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES missions (id)',
    ),
  );
  static const VerificationMeta _missionTypeMeta = const VerificationMeta(
    'missionType',
  );
  @override
  late final GeneratedColumn<String> missionType = GeneratedColumn<String>(
    'mission_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptNumberMeta = const VerificationMeta(
    'attemptNumber',
  );
  @override
  late final GeneratedColumn<int> attemptNumber = GeneratedColumn<int>(
    'attempt_number',
    aliasedName,
    false,
    check: () => const CustomExpression('attempt_number > 0'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMsMeta = const VerificationMeta(
    'startedAtMs',
  );
  @override
  late final GeneratedColumn<int> startedAtMs = GeneratedColumn<int>(
    'started_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMsMeta = const VerificationMeta(
    'completedAtMs',
  );
  @override
  late final GeneratedColumn<int> completedAtMs = GeneratedColumn<int>(
    'completed_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _failedAtMsMeta = const VerificationMeta(
    'failedAtMs',
  );
  @override
  late final GeneratedColumn<int> failedAtMs = GeneratedColumn<int>(
    'failed_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _failureReasonMeta = const VerificationMeta(
    'failureReason',
  );
  @override
  late final GeneratedColumn<String> failureReason = GeneratedColumn<String>(
    'failure_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wakeSessionId,
    missionId,
    missionType,
    status,
    attemptNumber,
    startedAtMs,
    completedAtMs,
    failedAtMs,
    failureReason,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_executions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MissionExecution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wake_session_id')) {
      context.handle(
        _wakeSessionIdMeta,
        wakeSessionId.isAcceptableOrUnknown(
          data['wake_session_id']!,
          _wakeSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeSessionIdMeta);
    }
    if (data.containsKey('mission_id')) {
      context.handle(
        _missionIdMeta,
        missionId.isAcceptableOrUnknown(data['mission_id']!, _missionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_missionIdMeta);
    }
    if (data.containsKey('mission_type')) {
      context.handle(
        _missionTypeMeta,
        missionType.isAcceptableOrUnknown(
          data['mission_type']!,
          _missionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_missionTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attempt_number')) {
      context.handle(
        _attemptNumberMeta,
        attemptNumber.isAcceptableOrUnknown(
          data['attempt_number']!,
          _attemptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptNumberMeta);
    }
    if (data.containsKey('started_at_ms')) {
      context.handle(
        _startedAtMsMeta,
        startedAtMs.isAcceptableOrUnknown(
          data['started_at_ms']!,
          _startedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtMsMeta);
    }
    if (data.containsKey('completed_at_ms')) {
      context.handle(
        _completedAtMsMeta,
        completedAtMs.isAcceptableOrUnknown(
          data['completed_at_ms']!,
          _completedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('failed_at_ms')) {
      context.handle(
        _failedAtMsMeta,
        failedAtMs.isAcceptableOrUnknown(
          data['failed_at_ms']!,
          _failedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('failure_reason')) {
      context.handle(
        _failureReasonMeta,
        failureReason.isAcceptableOrUnknown(
          data['failure_reason']!,
          _failureReasonMeta,
        ),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MissionExecution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionExecution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wakeSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_session_id'],
      )!,
      missionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_id'],
      )!,
      missionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attemptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_number'],
      )!,
      startedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_ms'],
      )!,
      completedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_ms'],
      ),
      failedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_at_ms'],
      ),
      failureReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure_reason'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
    );
  }

  @override
  $MissionExecutionsTable createAlias(String alias) {
    return $MissionExecutionsTable(attachedDatabase, alias);
  }
}

class MissionExecution extends DataClass
    implements Insertable<MissionExecution> {
  final String id;
  final String wakeSessionId;
  final String missionId;
  final String missionType;
  final String status;
  final int attemptNumber;
  final int startedAtMs;
  final int? completedAtMs;
  final int? failedAtMs;
  final String? failureReason;
  final String metadataJson;
  const MissionExecution({
    required this.id,
    required this.wakeSessionId,
    required this.missionId,
    required this.missionType,
    required this.status,
    required this.attemptNumber,
    required this.startedAtMs,
    this.completedAtMs,
    this.failedAtMs,
    this.failureReason,
    required this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wake_session_id'] = Variable<String>(wakeSessionId);
    map['mission_id'] = Variable<String>(missionId);
    map['mission_type'] = Variable<String>(missionType);
    map['status'] = Variable<String>(status);
    map['attempt_number'] = Variable<int>(attemptNumber);
    map['started_at_ms'] = Variable<int>(startedAtMs);
    if (!nullToAbsent || completedAtMs != null) {
      map['completed_at_ms'] = Variable<int>(completedAtMs);
    }
    if (!nullToAbsent || failedAtMs != null) {
      map['failed_at_ms'] = Variable<int>(failedAtMs);
    }
    if (!nullToAbsent || failureReason != null) {
      map['failure_reason'] = Variable<String>(failureReason);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    return map;
  }

  MissionExecutionsCompanion toCompanion(bool nullToAbsent) {
    return MissionExecutionsCompanion(
      id: Value(id),
      wakeSessionId: Value(wakeSessionId),
      missionId: Value(missionId),
      missionType: Value(missionType),
      status: Value(status),
      attemptNumber: Value(attemptNumber),
      startedAtMs: Value(startedAtMs),
      completedAtMs: completedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMs),
      failedAtMs: failedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(failedAtMs),
      failureReason: failureReason == null && nullToAbsent
          ? const Value.absent()
          : Value(failureReason),
      metadataJson: Value(metadataJson),
    );
  }

  factory MissionExecution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionExecution(
      id: serializer.fromJson<String>(json['id']),
      wakeSessionId: serializer.fromJson<String>(json['wakeSessionId']),
      missionId: serializer.fromJson<String>(json['missionId']),
      missionType: serializer.fromJson<String>(json['missionType']),
      status: serializer.fromJson<String>(json['status']),
      attemptNumber: serializer.fromJson<int>(json['attemptNumber']),
      startedAtMs: serializer.fromJson<int>(json['startedAtMs']),
      completedAtMs: serializer.fromJson<int?>(json['completedAtMs']),
      failedAtMs: serializer.fromJson<int?>(json['failedAtMs']),
      failureReason: serializer.fromJson<String?>(json['failureReason']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wakeSessionId': serializer.toJson<String>(wakeSessionId),
      'missionId': serializer.toJson<String>(missionId),
      'missionType': serializer.toJson<String>(missionType),
      'status': serializer.toJson<String>(status),
      'attemptNumber': serializer.toJson<int>(attemptNumber),
      'startedAtMs': serializer.toJson<int>(startedAtMs),
      'completedAtMs': serializer.toJson<int?>(completedAtMs),
      'failedAtMs': serializer.toJson<int?>(failedAtMs),
      'failureReason': serializer.toJson<String?>(failureReason),
      'metadataJson': serializer.toJson<String>(metadataJson),
    };
  }

  MissionExecution copyWith({
    String? id,
    String? wakeSessionId,
    String? missionId,
    String? missionType,
    String? status,
    int? attemptNumber,
    int? startedAtMs,
    Value<int?> completedAtMs = const Value.absent(),
    Value<int?> failedAtMs = const Value.absent(),
    Value<String?> failureReason = const Value.absent(),
    String? metadataJson,
  }) => MissionExecution(
    id: id ?? this.id,
    wakeSessionId: wakeSessionId ?? this.wakeSessionId,
    missionId: missionId ?? this.missionId,
    missionType: missionType ?? this.missionType,
    status: status ?? this.status,
    attemptNumber: attemptNumber ?? this.attemptNumber,
    startedAtMs: startedAtMs ?? this.startedAtMs,
    completedAtMs: completedAtMs.present
        ? completedAtMs.value
        : this.completedAtMs,
    failedAtMs: failedAtMs.present ? failedAtMs.value : this.failedAtMs,
    failureReason: failureReason.present
        ? failureReason.value
        : this.failureReason,
    metadataJson: metadataJson ?? this.metadataJson,
  );
  MissionExecution copyWithCompanion(MissionExecutionsCompanion data) {
    return MissionExecution(
      id: data.id.present ? data.id.value : this.id,
      wakeSessionId: data.wakeSessionId.present
          ? data.wakeSessionId.value
          : this.wakeSessionId,
      missionId: data.missionId.present ? data.missionId.value : this.missionId,
      missionType: data.missionType.present
          ? data.missionType.value
          : this.missionType,
      status: data.status.present ? data.status.value : this.status,
      attemptNumber: data.attemptNumber.present
          ? data.attemptNumber.value
          : this.attemptNumber,
      startedAtMs: data.startedAtMs.present
          ? data.startedAtMs.value
          : this.startedAtMs,
      completedAtMs: data.completedAtMs.present
          ? data.completedAtMs.value
          : this.completedAtMs,
      failedAtMs: data.failedAtMs.present
          ? data.failedAtMs.value
          : this.failedAtMs,
      failureReason: data.failureReason.present
          ? data.failureReason.value
          : this.failureReason,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionExecution(')
          ..write('id: $id, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('missionId: $missionId, ')
          ..write('missionType: $missionType, ')
          ..write('status: $status, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('failedAtMs: $failedAtMs, ')
          ..write('failureReason: $failureReason, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wakeSessionId,
    missionId,
    missionType,
    status,
    attemptNumber,
    startedAtMs,
    completedAtMs,
    failedAtMs,
    failureReason,
    metadataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionExecution &&
          other.id == this.id &&
          other.wakeSessionId == this.wakeSessionId &&
          other.missionId == this.missionId &&
          other.missionType == this.missionType &&
          other.status == this.status &&
          other.attemptNumber == this.attemptNumber &&
          other.startedAtMs == this.startedAtMs &&
          other.completedAtMs == this.completedAtMs &&
          other.failedAtMs == this.failedAtMs &&
          other.failureReason == this.failureReason &&
          other.metadataJson == this.metadataJson);
}

class MissionExecutionsCompanion extends UpdateCompanion<MissionExecution> {
  final Value<String> id;
  final Value<String> wakeSessionId;
  final Value<String> missionId;
  final Value<String> missionType;
  final Value<String> status;
  final Value<int> attemptNumber;
  final Value<int> startedAtMs;
  final Value<int?> completedAtMs;
  final Value<int?> failedAtMs;
  final Value<String?> failureReason;
  final Value<String> metadataJson;
  final Value<int> rowid;
  const MissionExecutionsCompanion({
    this.id = const Value.absent(),
    this.wakeSessionId = const Value.absent(),
    this.missionId = const Value.absent(),
    this.missionType = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptNumber = const Value.absent(),
    this.startedAtMs = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    this.failedAtMs = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MissionExecutionsCompanion.insert({
    required String id,
    required String wakeSessionId,
    required String missionId,
    required String missionType,
    required String status,
    required int attemptNumber,
    required int startedAtMs,
    this.completedAtMs = const Value.absent(),
    this.failedAtMs = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wakeSessionId = Value(wakeSessionId),
       missionId = Value(missionId),
       missionType = Value(missionType),
       status = Value(status),
       attemptNumber = Value(attemptNumber),
       startedAtMs = Value(startedAtMs);
  static Insertable<MissionExecution> custom({
    Expression<String>? id,
    Expression<String>? wakeSessionId,
    Expression<String>? missionId,
    Expression<String>? missionType,
    Expression<String>? status,
    Expression<int>? attemptNumber,
    Expression<int>? startedAtMs,
    Expression<int>? completedAtMs,
    Expression<int>? failedAtMs,
    Expression<String>? failureReason,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wakeSessionId != null) 'wake_session_id': wakeSessionId,
      if (missionId != null) 'mission_id': missionId,
      if (missionType != null) 'mission_type': missionType,
      if (status != null) 'status': status,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (startedAtMs != null) 'started_at_ms': startedAtMs,
      if (completedAtMs != null) 'completed_at_ms': completedAtMs,
      if (failedAtMs != null) 'failed_at_ms': failedAtMs,
      if (failureReason != null) 'failure_reason': failureReason,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MissionExecutionsCompanion copyWith({
    Value<String>? id,
    Value<String>? wakeSessionId,
    Value<String>? missionId,
    Value<String>? missionType,
    Value<String>? status,
    Value<int>? attemptNumber,
    Value<int>? startedAtMs,
    Value<int?>? completedAtMs,
    Value<int?>? failedAtMs,
    Value<String?>? failureReason,
    Value<String>? metadataJson,
    Value<int>? rowid,
  }) {
    return MissionExecutionsCompanion(
      id: id ?? this.id,
      wakeSessionId: wakeSessionId ?? this.wakeSessionId,
      missionId: missionId ?? this.missionId,
      missionType: missionType ?? this.missionType,
      status: status ?? this.status,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      completedAtMs: completedAtMs ?? this.completedAtMs,
      failedAtMs: failedAtMs ?? this.failedAtMs,
      failureReason: failureReason ?? this.failureReason,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wakeSessionId.present) {
      map['wake_session_id'] = Variable<String>(wakeSessionId.value);
    }
    if (missionId.present) {
      map['mission_id'] = Variable<String>(missionId.value);
    }
    if (missionType.present) {
      map['mission_type'] = Variable<String>(missionType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptNumber.present) {
      map['attempt_number'] = Variable<int>(attemptNumber.value);
    }
    if (startedAtMs.present) {
      map['started_at_ms'] = Variable<int>(startedAtMs.value);
    }
    if (completedAtMs.present) {
      map['completed_at_ms'] = Variable<int>(completedAtMs.value);
    }
    if (failedAtMs.present) {
      map['failed_at_ms'] = Variable<int>(failedAtMs.value);
    }
    if (failureReason.present) {
      map['failure_reason'] = Variable<String>(failureReason.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionExecutionsCompanion(')
          ..write('id: $id, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('missionId: $missionId, ')
          ..write('missionType: $missionType, ')
          ..write('status: $status, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('failedAtMs: $failedAtMs, ')
          ..write('failureReason: $failureReason, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WakeChecksTable extends WakeChecks
    with TableInfo<$WakeChecksTable, WakeCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WakeChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeSessionIdMeta = const VerificationMeta(
    'wakeSessionId',
  );
  @override
  late final GeneratedColumn<String> wakeSessionId = GeneratedColumn<String>(
    'wake_session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wake_sessions (id)',
    ),
  );
  static const VerificationMeta _attemptNumberMeta = const VerificationMeta(
    'attemptNumber',
  );
  @override
  late final GeneratedColumn<int> attemptNumber = GeneratedColumn<int>(
    'attempt_number',
    aliasedName,
    false,
    check: () => const CustomExpression('attempt_number > 0'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledForMsMeta = const VerificationMeta(
    'scheduledForMs',
  );
  @override
  late final GeneratedColumn<int> scheduledForMs = GeneratedColumn<int>(
    'scheduled_for_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggeredAtMsMeta = const VerificationMeta(
    'triggeredAtMs',
  );
  @override
  late final GeneratedColumn<int> triggeredAtMs = GeneratedColumn<int>(
    'triggered_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstInteractionAtMsMeta =
      const VerificationMeta('firstInteractionAtMs');
  @override
  late final GeneratedColumn<int> firstInteractionAtMs = GeneratedColumn<int>(
    'first_interaction_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMsMeta = const VerificationMeta(
    'completedAtMs',
  );
  @override
  late final GeneratedColumn<int> completedAtMs = GeneratedColumn<int>(
    'completed_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wakeSessionId,
    attemptNumber,
    scheduledForMs,
    triggeredAtMs,
    firstInteractionAtMs,
    completedAtMs,
    status,
    createdAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wake_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<WakeCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wake_session_id')) {
      context.handle(
        _wakeSessionIdMeta,
        wakeSessionId.isAcceptableOrUnknown(
          data['wake_session_id']!,
          _wakeSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeSessionIdMeta);
    }
    if (data.containsKey('attempt_number')) {
      context.handle(
        _attemptNumberMeta,
        attemptNumber.isAcceptableOrUnknown(
          data['attempt_number']!,
          _attemptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptNumberMeta);
    }
    if (data.containsKey('scheduled_for_ms')) {
      context.handle(
        _scheduledForMsMeta,
        scheduledForMs.isAcceptableOrUnknown(
          data['scheduled_for_ms']!,
          _scheduledForMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledForMsMeta);
    }
    if (data.containsKey('triggered_at_ms')) {
      context.handle(
        _triggeredAtMsMeta,
        triggeredAtMs.isAcceptableOrUnknown(
          data['triggered_at_ms']!,
          _triggeredAtMsMeta,
        ),
      );
    }
    if (data.containsKey('first_interaction_at_ms')) {
      context.handle(
        _firstInteractionAtMsMeta,
        firstInteractionAtMs.isAcceptableOrUnknown(
          data['first_interaction_at_ms']!,
          _firstInteractionAtMsMeta,
        ),
      );
    }
    if (data.containsKey('completed_at_ms')) {
      context.handle(
        _completedAtMsMeta,
        completedAtMs.isAcceptableOrUnknown(
          data['completed_at_ms']!,
          _completedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WakeCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WakeCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wakeSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_session_id'],
      )!,
      attemptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_number'],
      )!,
      scheduledForMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_for_ms'],
      )!,
      triggeredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triggered_at_ms'],
      ),
      firstInteractionAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_interaction_at_ms'],
      ),
      completedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_ms'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
    );
  }

  @override
  $WakeChecksTable createAlias(String alias) {
    return $WakeChecksTable(attachedDatabase, alias);
  }
}

class WakeCheck extends DataClass implements Insertable<WakeCheck> {
  final String id;
  final String wakeSessionId;
  final int attemptNumber;
  final int scheduledForMs;
  final int? triggeredAtMs;
  final int? firstInteractionAtMs;
  final int? completedAtMs;
  final String status;
  final int createdAtMs;
  const WakeCheck({
    required this.id,
    required this.wakeSessionId,
    required this.attemptNumber,
    required this.scheduledForMs,
    this.triggeredAtMs,
    this.firstInteractionAtMs,
    this.completedAtMs,
    required this.status,
    required this.createdAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wake_session_id'] = Variable<String>(wakeSessionId);
    map['attempt_number'] = Variable<int>(attemptNumber);
    map['scheduled_for_ms'] = Variable<int>(scheduledForMs);
    if (!nullToAbsent || triggeredAtMs != null) {
      map['triggered_at_ms'] = Variable<int>(triggeredAtMs);
    }
    if (!nullToAbsent || firstInteractionAtMs != null) {
      map['first_interaction_at_ms'] = Variable<int>(firstInteractionAtMs);
    }
    if (!nullToAbsent || completedAtMs != null) {
      map['completed_at_ms'] = Variable<int>(completedAtMs);
    }
    map['status'] = Variable<String>(status);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    return map;
  }

  WakeChecksCompanion toCompanion(bool nullToAbsent) {
    return WakeChecksCompanion(
      id: Value(id),
      wakeSessionId: Value(wakeSessionId),
      attemptNumber: Value(attemptNumber),
      scheduledForMs: Value(scheduledForMs),
      triggeredAtMs: triggeredAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(triggeredAtMs),
      firstInteractionAtMs: firstInteractionAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(firstInteractionAtMs),
      completedAtMs: completedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMs),
      status: Value(status),
      createdAtMs: Value(createdAtMs),
    );
  }

  factory WakeCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WakeCheck(
      id: serializer.fromJson<String>(json['id']),
      wakeSessionId: serializer.fromJson<String>(json['wakeSessionId']),
      attemptNumber: serializer.fromJson<int>(json['attemptNumber']),
      scheduledForMs: serializer.fromJson<int>(json['scheduledForMs']),
      triggeredAtMs: serializer.fromJson<int?>(json['triggeredAtMs']),
      firstInteractionAtMs: serializer.fromJson<int?>(
        json['firstInteractionAtMs'],
      ),
      completedAtMs: serializer.fromJson<int?>(json['completedAtMs']),
      status: serializer.fromJson<String>(json['status']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wakeSessionId': serializer.toJson<String>(wakeSessionId),
      'attemptNumber': serializer.toJson<int>(attemptNumber),
      'scheduledForMs': serializer.toJson<int>(scheduledForMs),
      'triggeredAtMs': serializer.toJson<int?>(triggeredAtMs),
      'firstInteractionAtMs': serializer.toJson<int?>(firstInteractionAtMs),
      'completedAtMs': serializer.toJson<int?>(completedAtMs),
      'status': serializer.toJson<String>(status),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
    };
  }

  WakeCheck copyWith({
    String? id,
    String? wakeSessionId,
    int? attemptNumber,
    int? scheduledForMs,
    Value<int?> triggeredAtMs = const Value.absent(),
    Value<int?> firstInteractionAtMs = const Value.absent(),
    Value<int?> completedAtMs = const Value.absent(),
    String? status,
    int? createdAtMs,
  }) => WakeCheck(
    id: id ?? this.id,
    wakeSessionId: wakeSessionId ?? this.wakeSessionId,
    attemptNumber: attemptNumber ?? this.attemptNumber,
    scheduledForMs: scheduledForMs ?? this.scheduledForMs,
    triggeredAtMs: triggeredAtMs.present
        ? triggeredAtMs.value
        : this.triggeredAtMs,
    firstInteractionAtMs: firstInteractionAtMs.present
        ? firstInteractionAtMs.value
        : this.firstInteractionAtMs,
    completedAtMs: completedAtMs.present
        ? completedAtMs.value
        : this.completedAtMs,
    status: status ?? this.status,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );
  WakeCheck copyWithCompanion(WakeChecksCompanion data) {
    return WakeCheck(
      id: data.id.present ? data.id.value : this.id,
      wakeSessionId: data.wakeSessionId.present
          ? data.wakeSessionId.value
          : this.wakeSessionId,
      attemptNumber: data.attemptNumber.present
          ? data.attemptNumber.value
          : this.attemptNumber,
      scheduledForMs: data.scheduledForMs.present
          ? data.scheduledForMs.value
          : this.scheduledForMs,
      triggeredAtMs: data.triggeredAtMs.present
          ? data.triggeredAtMs.value
          : this.triggeredAtMs,
      firstInteractionAtMs: data.firstInteractionAtMs.present
          ? data.firstInteractionAtMs.value
          : this.firstInteractionAtMs,
      completedAtMs: data.completedAtMs.present
          ? data.completedAtMs.value
          : this.completedAtMs,
      status: data.status.present ? data.status.value : this.status,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WakeCheck(')
          ..write('id: $id, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('scheduledForMs: $scheduledForMs, ')
          ..write('triggeredAtMs: $triggeredAtMs, ')
          ..write('firstInteractionAtMs: $firstInteractionAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('status: $status, ')
          ..write('createdAtMs: $createdAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wakeSessionId,
    attemptNumber,
    scheduledForMs,
    triggeredAtMs,
    firstInteractionAtMs,
    completedAtMs,
    status,
    createdAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WakeCheck &&
          other.id == this.id &&
          other.wakeSessionId == this.wakeSessionId &&
          other.attemptNumber == this.attemptNumber &&
          other.scheduledForMs == this.scheduledForMs &&
          other.triggeredAtMs == this.triggeredAtMs &&
          other.firstInteractionAtMs == this.firstInteractionAtMs &&
          other.completedAtMs == this.completedAtMs &&
          other.status == this.status &&
          other.createdAtMs == this.createdAtMs);
}

class WakeChecksCompanion extends UpdateCompanion<WakeCheck> {
  final Value<String> id;
  final Value<String> wakeSessionId;
  final Value<int> attemptNumber;
  final Value<int> scheduledForMs;
  final Value<int?> triggeredAtMs;
  final Value<int?> firstInteractionAtMs;
  final Value<int?> completedAtMs;
  final Value<String> status;
  final Value<int> createdAtMs;
  final Value<int> rowid;
  const WakeChecksCompanion({
    this.id = const Value.absent(),
    this.wakeSessionId = const Value.absent(),
    this.attemptNumber = const Value.absent(),
    this.scheduledForMs = const Value.absent(),
    this.triggeredAtMs = const Value.absent(),
    this.firstInteractionAtMs = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WakeChecksCompanion.insert({
    required String id,
    required String wakeSessionId,
    required int attemptNumber,
    required int scheduledForMs,
    this.triggeredAtMs = const Value.absent(),
    this.firstInteractionAtMs = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    required String status,
    required int createdAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wakeSessionId = Value(wakeSessionId),
       attemptNumber = Value(attemptNumber),
       scheduledForMs = Value(scheduledForMs),
       status = Value(status),
       createdAtMs = Value(createdAtMs);
  static Insertable<WakeCheck> custom({
    Expression<String>? id,
    Expression<String>? wakeSessionId,
    Expression<int>? attemptNumber,
    Expression<int>? scheduledForMs,
    Expression<int>? triggeredAtMs,
    Expression<int>? firstInteractionAtMs,
    Expression<int>? completedAtMs,
    Expression<String>? status,
    Expression<int>? createdAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wakeSessionId != null) 'wake_session_id': wakeSessionId,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (scheduledForMs != null) 'scheduled_for_ms': scheduledForMs,
      if (triggeredAtMs != null) 'triggered_at_ms': triggeredAtMs,
      if (firstInteractionAtMs != null)
        'first_interaction_at_ms': firstInteractionAtMs,
      if (completedAtMs != null) 'completed_at_ms': completedAtMs,
      if (status != null) 'status': status,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WakeChecksCompanion copyWith({
    Value<String>? id,
    Value<String>? wakeSessionId,
    Value<int>? attemptNumber,
    Value<int>? scheduledForMs,
    Value<int?>? triggeredAtMs,
    Value<int?>? firstInteractionAtMs,
    Value<int?>? completedAtMs,
    Value<String>? status,
    Value<int>? createdAtMs,
    Value<int>? rowid,
  }) {
    return WakeChecksCompanion(
      id: id ?? this.id,
      wakeSessionId: wakeSessionId ?? this.wakeSessionId,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      scheduledForMs: scheduledForMs ?? this.scheduledForMs,
      triggeredAtMs: triggeredAtMs ?? this.triggeredAtMs,
      firstInteractionAtMs: firstInteractionAtMs ?? this.firstInteractionAtMs,
      completedAtMs: completedAtMs ?? this.completedAtMs,
      status: status ?? this.status,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wakeSessionId.present) {
      map['wake_session_id'] = Variable<String>(wakeSessionId.value);
    }
    if (attemptNumber.present) {
      map['attempt_number'] = Variable<int>(attemptNumber.value);
    }
    if (scheduledForMs.present) {
      map['scheduled_for_ms'] = Variable<int>(scheduledForMs.value);
    }
    if (triggeredAtMs.present) {
      map['triggered_at_ms'] = Variable<int>(triggeredAtMs.value);
    }
    if (firstInteractionAtMs.present) {
      map['first_interaction_at_ms'] = Variable<int>(
        firstInteractionAtMs.value,
      );
    }
    if (completedAtMs.present) {
      map['completed_at_ms'] = Variable<int>(completedAtMs.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WakeChecksCompanion(')
          ..write('id: $id, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('scheduledForMs: $scheduledForMs, ')
          ..write('triggeredAtMs: $triggeredAtMs, ')
          ..write('firstInteractionAtMs: $firstInteractionAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('status: $status, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WakeProtocolsTable extends WakeProtocols
    with TableInfo<$WakeProtocolsTable, WakeProtocol> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WakeProtocolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alarmIdMeta = const VerificationMeta(
    'alarmId',
  );
  @override
  late final GeneratedColumn<String> alarmId = GeneratedColumn<String>(
    'alarm_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alarms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => const CustomExpression('version > 0'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialSoundIdMeta = const VerificationMeta(
    'initialSoundId',
  );
  @override
  late final GeneratedColumn<String> initialSoundId = GeneratedColumn<String>(
    'initial_sound_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialSoundFamilyMeta =
      const VerificationMeta('initialSoundFamily');
  @override
  late final GeneratedColumn<String> initialSoundFamily =
      GeneratedColumn<String>(
        'initial_sound_family',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ringtoneUriMeta = const VerificationMeta(
    'ringtoneUri',
  );
  @override
  late final GeneratedColumn<String> ringtoneUri = GeneratedColumn<String>(
    'ringtone_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialVolumePercentMeta =
      const VerificationMeta('initialVolumePercent');
  @override
  late final GeneratedColumn<int> initialVolumePercent = GeneratedColumn<int>(
    'initial_volume_percent',
    aliasedName,
    false,
    check: () =>
        const CustomExpression('initial_volume_percent BETWEEN 0 AND 100'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxVolumePercentMeta = const VerificationMeta(
    'maxVolumePercent',
  );
  @override
  late final GeneratedColumn<int> maxVolumePercent = GeneratedColumn<int>(
    'max_volume_percent',
    aliasedName,
    false,
    check: () => const CustomExpression('max_volume_percent BETWEEN 0 AND 100'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeEscalationEnabledMeta =
      const VerificationMeta('volumeEscalationEnabled');
  @override
  late final GeneratedColumn<bool> volumeEscalationEnabled =
      GeneratedColumn<bool>(
        'volume_escalation_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("volume_escalation_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _volumeEscalationStepPercentMeta =
      const VerificationMeta('volumeEscalationStepPercent');
  @override
  late final GeneratedColumn<int> volumeEscalationStepPercent =
      GeneratedColumn<int>(
        'volume_escalation_step_percent',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _volumeEscalationIntervalSecondsMeta =
      const VerificationMeta('volumeEscalationIntervalSeconds');
  @override
  late final GeneratedColumn<int> volumeEscalationIntervalSeconds =
      GeneratedColumn<int>(
        'volume_escalation_interval_seconds',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _vibrationEnabledMeta = const VerificationMeta(
    'vibrationEnabled',
  );
  @override
  late final GeneratedColumn<bool> vibrationEnabled = GeneratedColumn<bool>(
    'vibration_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibration_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _vibrationPatternMeta = const VerificationMeta(
    'vibrationPattern',
  );
  @override
  late final GeneratedColumn<String> vibrationPattern = GeneratedColumn<String>(
    'vibration_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vibrationEscalationEnabledMeta =
      const VerificationMeta('vibrationEscalationEnabled');
  @override
  late final GeneratedColumn<bool> vibrationEscalationEnabled =
      GeneratedColumn<bool>(
        'vibration_escalation_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("vibration_escalation_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _missionRequiredMeta = const VerificationMeta(
    'missionRequired',
  );
  @override
  late final GeneratedColumn<bool> missionRequired = GeneratedColumn<bool>(
    'mission_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mission_required" IN (0, 1))',
    ),
  );
  static const VerificationMeta _missionTypeMeta = const VerificationMeta(
    'missionType',
  );
  @override
  late final GeneratedColumn<String> missionType = GeneratedColumn<String>(
    'mission_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _missionDifficultyMeta = const VerificationMeta(
    'missionDifficulty',
  );
  @override
  late final GeneratedColumn<String> missionDifficulty =
      GeneratedColumn<String>(
        'mission_difficulty',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _missionConfigurationJsonMeta =
      const VerificationMeta('missionConfigurationJson');
  @override
  late final GeneratedColumn<String> missionConfigurationJson =
      GeneratedColumn<String>(
        'mission_configuration_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _wakeCheckRequiredMeta = const VerificationMeta(
    'wakeCheckRequired',
  );
  @override
  late final GeneratedColumn<bool> wakeCheckRequired = GeneratedColumn<bool>(
    'wake_check_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("wake_check_required" IN (0, 1))',
    ),
  );
  static const VerificationMeta _wakeCheckDelayMinutesMeta =
      const VerificationMeta('wakeCheckDelayMinutes');
  @override
  late final GeneratedColumn<int> wakeCheckDelayMinutes = GeneratedColumn<int>(
    'wake_check_delay_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeCheckHoldMillisecondsMeta =
      const VerificationMeta('wakeCheckHoldMilliseconds');
  @override
  late final GeneratedColumn<int> wakeCheckHoldMilliseconds =
      GeneratedColumn<int>(
        'wake_check_hold_milliseconds',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _maxWakeCheckFailuresMeta =
      const VerificationMeta('maxWakeCheckFailures');
  @override
  late final GeneratedColumn<int> maxWakeCheckFailures = GeneratedColumn<int>(
    'max_wake_check_failures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reactivationSoundPolicyMeta =
      const VerificationMeta('reactivationSoundPolicy');
  @override
  late final GeneratedColumn<String> reactivationSoundPolicy =
      GeneratedColumn<String>(
        'reactivation_sound_policy',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _intensityLevelMeta = const VerificationMeta(
    'intensityLevel',
  );
  @override
  late final GeneratedColumn<int> intensityLevel = GeneratedColumn<int>(
    'intensity_level',
    aliasedName,
    false,
    check: () => const CustomExpression('intensity_level BETWEEN 1 AND 5'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonCodeMeta = const VerificationMeta(
    'reasonCode',
  );
  @override
  late final GeneratedColumn<String> reasonCode = GeneratedColumn<String>(
    'reason_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _technicalExplanationMeta =
      const VerificationMeta('technicalExplanation');
  @override
  late final GeneratedColumn<String> technicalExplanation =
      GeneratedColumn<String>(
        'technical_explanation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _userExplanationMeta = const VerificationMeta(
    'userExplanation',
  );
  @override
  late final GeneratedColumn<String> userExplanation = GeneratedColumn<String>(
    'user_explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basedOnSessionIdMeta = const VerificationMeta(
    'basedOnSessionId',
  );
  @override
  late final GeneratedColumn<String> basedOnSessionId = GeneratedColumn<String>(
    'based_on_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supersedesProtocolIdMeta =
      const VerificationMeta('supersedesProtocolId');
  @override
  late final GeneratedColumn<String> supersedesProtocolId =
      GeneratedColumn<String>(
        'supersedes_protocol_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _settingsSnapshotJsonMeta =
      const VerificationMeta('settingsSnapshotJson');
  @override
  late final GeneratedColumn<String> settingsSnapshotJson =
      GeneratedColumn<String>(
        'settings_snapshot_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveFromMsMeta = const VerificationMeta(
    'effectiveFromMs',
  );
  @override
  late final GeneratedColumn<int> effectiveFromMs = GeneratedColumn<int>(
    'effective_from_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alarmId,
    version,
    source,
    status,
    initialSoundId,
    initialSoundFamily,
    ringtoneUri,
    initialVolumePercent,
    maxVolumePercent,
    volumeEscalationEnabled,
    volumeEscalationStepPercent,
    volumeEscalationIntervalSeconds,
    vibrationEnabled,
    vibrationPattern,
    vibrationEscalationEnabled,
    missionRequired,
    missionType,
    missionDifficulty,
    missionConfigurationJson,
    wakeCheckRequired,
    wakeCheckDelayMinutes,
    wakeCheckHoldMilliseconds,
    maxWakeCheckFailures,
    reactivationSoundPolicy,
    intensityLevel,
    reasonCode,
    technicalExplanation,
    userExplanation,
    basedOnSessionId,
    supersedesProtocolId,
    settingsSnapshotJson,
    createdAtMs,
    effectiveFromMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wake_protocols';
  @override
  VerificationContext validateIntegrity(
    Insertable<WakeProtocol> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('alarm_id')) {
      context.handle(
        _alarmIdMeta,
        alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('initial_sound_id')) {
      context.handle(
        _initialSoundIdMeta,
        initialSoundId.isAcceptableOrUnknown(
          data['initial_sound_id']!,
          _initialSoundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialSoundIdMeta);
    }
    if (data.containsKey('initial_sound_family')) {
      context.handle(
        _initialSoundFamilyMeta,
        initialSoundFamily.isAcceptableOrUnknown(
          data['initial_sound_family']!,
          _initialSoundFamilyMeta,
        ),
      );
    }
    if (data.containsKey('ringtone_uri')) {
      context.handle(
        _ringtoneUriMeta,
        ringtoneUri.isAcceptableOrUnknown(
          data['ringtone_uri']!,
          _ringtoneUriMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ringtoneUriMeta);
    }
    if (data.containsKey('initial_volume_percent')) {
      context.handle(
        _initialVolumePercentMeta,
        initialVolumePercent.isAcceptableOrUnknown(
          data['initial_volume_percent']!,
          _initialVolumePercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialVolumePercentMeta);
    }
    if (data.containsKey('max_volume_percent')) {
      context.handle(
        _maxVolumePercentMeta,
        maxVolumePercent.isAcceptableOrUnknown(
          data['max_volume_percent']!,
          _maxVolumePercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxVolumePercentMeta);
    }
    if (data.containsKey('volume_escalation_enabled')) {
      context.handle(
        _volumeEscalationEnabledMeta,
        volumeEscalationEnabled.isAcceptableOrUnknown(
          data['volume_escalation_enabled']!,
          _volumeEscalationEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_volumeEscalationEnabledMeta);
    }
    if (data.containsKey('volume_escalation_step_percent')) {
      context.handle(
        _volumeEscalationStepPercentMeta,
        volumeEscalationStepPercent.isAcceptableOrUnknown(
          data['volume_escalation_step_percent']!,
          _volumeEscalationStepPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_volumeEscalationStepPercentMeta);
    }
    if (data.containsKey('volume_escalation_interval_seconds')) {
      context.handle(
        _volumeEscalationIntervalSecondsMeta,
        volumeEscalationIntervalSeconds.isAcceptableOrUnknown(
          data['volume_escalation_interval_seconds']!,
          _volumeEscalationIntervalSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_volumeEscalationIntervalSecondsMeta);
    }
    if (data.containsKey('vibration_enabled')) {
      context.handle(
        _vibrationEnabledMeta,
        vibrationEnabled.isAcceptableOrUnknown(
          data['vibration_enabled']!,
          _vibrationEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vibrationEnabledMeta);
    }
    if (data.containsKey('vibration_pattern')) {
      context.handle(
        _vibrationPatternMeta,
        vibrationPattern.isAcceptableOrUnknown(
          data['vibration_pattern']!,
          _vibrationPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vibrationPatternMeta);
    }
    if (data.containsKey('vibration_escalation_enabled')) {
      context.handle(
        _vibrationEscalationEnabledMeta,
        vibrationEscalationEnabled.isAcceptableOrUnknown(
          data['vibration_escalation_enabled']!,
          _vibrationEscalationEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vibrationEscalationEnabledMeta);
    }
    if (data.containsKey('mission_required')) {
      context.handle(
        _missionRequiredMeta,
        missionRequired.isAcceptableOrUnknown(
          data['mission_required']!,
          _missionRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_missionRequiredMeta);
    }
    if (data.containsKey('mission_type')) {
      context.handle(
        _missionTypeMeta,
        missionType.isAcceptableOrUnknown(
          data['mission_type']!,
          _missionTypeMeta,
        ),
      );
    }
    if (data.containsKey('mission_difficulty')) {
      context.handle(
        _missionDifficultyMeta,
        missionDifficulty.isAcceptableOrUnknown(
          data['mission_difficulty']!,
          _missionDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('mission_configuration_json')) {
      context.handle(
        _missionConfigurationJsonMeta,
        missionConfigurationJson.isAcceptableOrUnknown(
          data['mission_configuration_json']!,
          _missionConfigurationJsonMeta,
        ),
      );
    }
    if (data.containsKey('wake_check_required')) {
      context.handle(
        _wakeCheckRequiredMeta,
        wakeCheckRequired.isAcceptableOrUnknown(
          data['wake_check_required']!,
          _wakeCheckRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeCheckRequiredMeta);
    }
    if (data.containsKey('wake_check_delay_minutes')) {
      context.handle(
        _wakeCheckDelayMinutesMeta,
        wakeCheckDelayMinutes.isAcceptableOrUnknown(
          data['wake_check_delay_minutes']!,
          _wakeCheckDelayMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeCheckDelayMinutesMeta);
    }
    if (data.containsKey('wake_check_hold_milliseconds')) {
      context.handle(
        _wakeCheckHoldMillisecondsMeta,
        wakeCheckHoldMilliseconds.isAcceptableOrUnknown(
          data['wake_check_hold_milliseconds']!,
          _wakeCheckHoldMillisecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeCheckHoldMillisecondsMeta);
    }
    if (data.containsKey('max_wake_check_failures')) {
      context.handle(
        _maxWakeCheckFailuresMeta,
        maxWakeCheckFailures.isAcceptableOrUnknown(
          data['max_wake_check_failures']!,
          _maxWakeCheckFailuresMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxWakeCheckFailuresMeta);
    }
    if (data.containsKey('reactivation_sound_policy')) {
      context.handle(
        _reactivationSoundPolicyMeta,
        reactivationSoundPolicy.isAcceptableOrUnknown(
          data['reactivation_sound_policy']!,
          _reactivationSoundPolicyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reactivationSoundPolicyMeta);
    }
    if (data.containsKey('intensity_level')) {
      context.handle(
        _intensityLevelMeta,
        intensityLevel.isAcceptableOrUnknown(
          data['intensity_level']!,
          _intensityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intensityLevelMeta);
    }
    if (data.containsKey('reason_code')) {
      context.handle(
        _reasonCodeMeta,
        reasonCode.isAcceptableOrUnknown(data['reason_code']!, _reasonCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonCodeMeta);
    }
    if (data.containsKey('technical_explanation')) {
      context.handle(
        _technicalExplanationMeta,
        technicalExplanation.isAcceptableOrUnknown(
          data['technical_explanation']!,
          _technicalExplanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_technicalExplanationMeta);
    }
    if (data.containsKey('user_explanation')) {
      context.handle(
        _userExplanationMeta,
        userExplanation.isAcceptableOrUnknown(
          data['user_explanation']!,
          _userExplanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userExplanationMeta);
    }
    if (data.containsKey('based_on_session_id')) {
      context.handle(
        _basedOnSessionIdMeta,
        basedOnSessionId.isAcceptableOrUnknown(
          data['based_on_session_id']!,
          _basedOnSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('supersedes_protocol_id')) {
      context.handle(
        _supersedesProtocolIdMeta,
        supersedesProtocolId.isAcceptableOrUnknown(
          data['supersedes_protocol_id']!,
          _supersedesProtocolIdMeta,
        ),
      );
    }
    if (data.containsKey('settings_snapshot_json')) {
      context.handle(
        _settingsSnapshotJsonMeta,
        settingsSnapshotJson.isAcceptableOrUnknown(
          data['settings_snapshot_json']!,
          _settingsSnapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('effective_from_ms')) {
      context.handle(
        _effectiveFromMsMeta,
        effectiveFromMs.isAcceptableOrUnknown(
          data['effective_from_ms']!,
          _effectiveFromMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WakeProtocol map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WakeProtocol(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      alarmId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alarm_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      initialSoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_sound_id'],
      )!,
      initialSoundFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_sound_family'],
      ),
      ringtoneUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ringtone_uri'],
      )!,
      initialVolumePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_volume_percent'],
      )!,
      maxVolumePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_volume_percent'],
      )!,
      volumeEscalationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}volume_escalation_enabled'],
      )!,
      volumeEscalationStepPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume_escalation_step_percent'],
      )!,
      volumeEscalationIntervalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume_escalation_interval_seconds'],
      )!,
      vibrationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibration_enabled'],
      )!,
      vibrationPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vibration_pattern'],
      )!,
      vibrationEscalationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibration_escalation_enabled'],
      )!,
      missionRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mission_required'],
      )!,
      missionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_type'],
      ),
      missionDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_difficulty'],
      ),
      missionConfigurationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_configuration_json'],
      )!,
      wakeCheckRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}wake_check_required'],
      )!,
      wakeCheckDelayMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_check_delay_minutes'],
      )!,
      wakeCheckHoldMilliseconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_check_hold_milliseconds'],
      )!,
      maxWakeCheckFailures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_wake_check_failures'],
      )!,
      reactivationSoundPolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reactivation_sound_policy'],
      )!,
      intensityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity_level'],
      )!,
      reasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_code'],
      )!,
      technicalExplanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technical_explanation'],
      )!,
      userExplanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_explanation'],
      )!,
      basedOnSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}based_on_session_id'],
      ),
      supersedesProtocolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supersedes_protocol_id'],
      ),
      settingsSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings_snapshot_json'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      effectiveFromMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effective_from_ms'],
      )!,
    );
  }

  @override
  $WakeProtocolsTable createAlias(String alias) {
    return $WakeProtocolsTable(attachedDatabase, alias);
  }
}

class WakeProtocol extends DataClass implements Insertable<WakeProtocol> {
  final String id;
  final String alarmId;
  final int version;
  final String source;
  final String status;
  final String initialSoundId;
  final String? initialSoundFamily;
  final String ringtoneUri;
  final int initialVolumePercent;
  final int maxVolumePercent;
  final bool volumeEscalationEnabled;
  final int volumeEscalationStepPercent;
  final int volumeEscalationIntervalSeconds;
  final bool vibrationEnabled;
  final String vibrationPattern;
  final bool vibrationEscalationEnabled;
  final bool missionRequired;
  final String? missionType;
  final String? missionDifficulty;
  final String missionConfigurationJson;
  final bool wakeCheckRequired;
  final int wakeCheckDelayMinutes;
  final int wakeCheckHoldMilliseconds;
  final int maxWakeCheckFailures;
  final String reactivationSoundPolicy;
  final int intensityLevel;
  final String reasonCode;
  final String technicalExplanation;
  final String userExplanation;
  final String? basedOnSessionId;
  final String? supersedesProtocolId;
  final String settingsSnapshotJson;
  final int createdAtMs;
  final int effectiveFromMs;
  const WakeProtocol({
    required this.id,
    required this.alarmId,
    required this.version,
    required this.source,
    required this.status,
    required this.initialSoundId,
    this.initialSoundFamily,
    required this.ringtoneUri,
    required this.initialVolumePercent,
    required this.maxVolumePercent,
    required this.volumeEscalationEnabled,
    required this.volumeEscalationStepPercent,
    required this.volumeEscalationIntervalSeconds,
    required this.vibrationEnabled,
    required this.vibrationPattern,
    required this.vibrationEscalationEnabled,
    required this.missionRequired,
    this.missionType,
    this.missionDifficulty,
    required this.missionConfigurationJson,
    required this.wakeCheckRequired,
    required this.wakeCheckDelayMinutes,
    required this.wakeCheckHoldMilliseconds,
    required this.maxWakeCheckFailures,
    required this.reactivationSoundPolicy,
    required this.intensityLevel,
    required this.reasonCode,
    required this.technicalExplanation,
    required this.userExplanation,
    this.basedOnSessionId,
    this.supersedesProtocolId,
    required this.settingsSnapshotJson,
    required this.createdAtMs,
    required this.effectiveFromMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['alarm_id'] = Variable<String>(alarmId);
    map['version'] = Variable<int>(version);
    map['source'] = Variable<String>(source);
    map['status'] = Variable<String>(status);
    map['initial_sound_id'] = Variable<String>(initialSoundId);
    if (!nullToAbsent || initialSoundFamily != null) {
      map['initial_sound_family'] = Variable<String>(initialSoundFamily);
    }
    map['ringtone_uri'] = Variable<String>(ringtoneUri);
    map['initial_volume_percent'] = Variable<int>(initialVolumePercent);
    map['max_volume_percent'] = Variable<int>(maxVolumePercent);
    map['volume_escalation_enabled'] = Variable<bool>(volumeEscalationEnabled);
    map['volume_escalation_step_percent'] = Variable<int>(
      volumeEscalationStepPercent,
    );
    map['volume_escalation_interval_seconds'] = Variable<int>(
      volumeEscalationIntervalSeconds,
    );
    map['vibration_enabled'] = Variable<bool>(vibrationEnabled);
    map['vibration_pattern'] = Variable<String>(vibrationPattern);
    map['vibration_escalation_enabled'] = Variable<bool>(
      vibrationEscalationEnabled,
    );
    map['mission_required'] = Variable<bool>(missionRequired);
    if (!nullToAbsent || missionType != null) {
      map['mission_type'] = Variable<String>(missionType);
    }
    if (!nullToAbsent || missionDifficulty != null) {
      map['mission_difficulty'] = Variable<String>(missionDifficulty);
    }
    map['mission_configuration_json'] = Variable<String>(
      missionConfigurationJson,
    );
    map['wake_check_required'] = Variable<bool>(wakeCheckRequired);
    map['wake_check_delay_minutes'] = Variable<int>(wakeCheckDelayMinutes);
    map['wake_check_hold_milliseconds'] = Variable<int>(
      wakeCheckHoldMilliseconds,
    );
    map['max_wake_check_failures'] = Variable<int>(maxWakeCheckFailures);
    map['reactivation_sound_policy'] = Variable<String>(
      reactivationSoundPolicy,
    );
    map['intensity_level'] = Variable<int>(intensityLevel);
    map['reason_code'] = Variable<String>(reasonCode);
    map['technical_explanation'] = Variable<String>(technicalExplanation);
    map['user_explanation'] = Variable<String>(userExplanation);
    if (!nullToAbsent || basedOnSessionId != null) {
      map['based_on_session_id'] = Variable<String>(basedOnSessionId);
    }
    if (!nullToAbsent || supersedesProtocolId != null) {
      map['supersedes_protocol_id'] = Variable<String>(supersedesProtocolId);
    }
    map['settings_snapshot_json'] = Variable<String>(settingsSnapshotJson);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    map['effective_from_ms'] = Variable<int>(effectiveFromMs);
    return map;
  }

  WakeProtocolsCompanion toCompanion(bool nullToAbsent) {
    return WakeProtocolsCompanion(
      id: Value(id),
      alarmId: Value(alarmId),
      version: Value(version),
      source: Value(source),
      status: Value(status),
      initialSoundId: Value(initialSoundId),
      initialSoundFamily: initialSoundFamily == null && nullToAbsent
          ? const Value.absent()
          : Value(initialSoundFamily),
      ringtoneUri: Value(ringtoneUri),
      initialVolumePercent: Value(initialVolumePercent),
      maxVolumePercent: Value(maxVolumePercent),
      volumeEscalationEnabled: Value(volumeEscalationEnabled),
      volumeEscalationStepPercent: Value(volumeEscalationStepPercent),
      volumeEscalationIntervalSeconds: Value(volumeEscalationIntervalSeconds),
      vibrationEnabled: Value(vibrationEnabled),
      vibrationPattern: Value(vibrationPattern),
      vibrationEscalationEnabled: Value(vibrationEscalationEnabled),
      missionRequired: Value(missionRequired),
      missionType: missionType == null && nullToAbsent
          ? const Value.absent()
          : Value(missionType),
      missionDifficulty: missionDifficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(missionDifficulty),
      missionConfigurationJson: Value(missionConfigurationJson),
      wakeCheckRequired: Value(wakeCheckRequired),
      wakeCheckDelayMinutes: Value(wakeCheckDelayMinutes),
      wakeCheckHoldMilliseconds: Value(wakeCheckHoldMilliseconds),
      maxWakeCheckFailures: Value(maxWakeCheckFailures),
      reactivationSoundPolicy: Value(reactivationSoundPolicy),
      intensityLevel: Value(intensityLevel),
      reasonCode: Value(reasonCode),
      technicalExplanation: Value(technicalExplanation),
      userExplanation: Value(userExplanation),
      basedOnSessionId: basedOnSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(basedOnSessionId),
      supersedesProtocolId: supersedesProtocolId == null && nullToAbsent
          ? const Value.absent()
          : Value(supersedesProtocolId),
      settingsSnapshotJson: Value(settingsSnapshotJson),
      createdAtMs: Value(createdAtMs),
      effectiveFromMs: Value(effectiveFromMs),
    );
  }

  factory WakeProtocol.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WakeProtocol(
      id: serializer.fromJson<String>(json['id']),
      alarmId: serializer.fromJson<String>(json['alarmId']),
      version: serializer.fromJson<int>(json['version']),
      source: serializer.fromJson<String>(json['source']),
      status: serializer.fromJson<String>(json['status']),
      initialSoundId: serializer.fromJson<String>(json['initialSoundId']),
      initialSoundFamily: serializer.fromJson<String?>(
        json['initialSoundFamily'],
      ),
      ringtoneUri: serializer.fromJson<String>(json['ringtoneUri']),
      initialVolumePercent: serializer.fromJson<int>(
        json['initialVolumePercent'],
      ),
      maxVolumePercent: serializer.fromJson<int>(json['maxVolumePercent']),
      volumeEscalationEnabled: serializer.fromJson<bool>(
        json['volumeEscalationEnabled'],
      ),
      volumeEscalationStepPercent: serializer.fromJson<int>(
        json['volumeEscalationStepPercent'],
      ),
      volumeEscalationIntervalSeconds: serializer.fromJson<int>(
        json['volumeEscalationIntervalSeconds'],
      ),
      vibrationEnabled: serializer.fromJson<bool>(json['vibrationEnabled']),
      vibrationPattern: serializer.fromJson<String>(json['vibrationPattern']),
      vibrationEscalationEnabled: serializer.fromJson<bool>(
        json['vibrationEscalationEnabled'],
      ),
      missionRequired: serializer.fromJson<bool>(json['missionRequired']),
      missionType: serializer.fromJson<String?>(json['missionType']),
      missionDifficulty: serializer.fromJson<String?>(
        json['missionDifficulty'],
      ),
      missionConfigurationJson: serializer.fromJson<String>(
        json['missionConfigurationJson'],
      ),
      wakeCheckRequired: serializer.fromJson<bool>(json['wakeCheckRequired']),
      wakeCheckDelayMinutes: serializer.fromJson<int>(
        json['wakeCheckDelayMinutes'],
      ),
      wakeCheckHoldMilliseconds: serializer.fromJson<int>(
        json['wakeCheckHoldMilliseconds'],
      ),
      maxWakeCheckFailures: serializer.fromJson<int>(
        json['maxWakeCheckFailures'],
      ),
      reactivationSoundPolicy: serializer.fromJson<String>(
        json['reactivationSoundPolicy'],
      ),
      intensityLevel: serializer.fromJson<int>(json['intensityLevel']),
      reasonCode: serializer.fromJson<String>(json['reasonCode']),
      technicalExplanation: serializer.fromJson<String>(
        json['technicalExplanation'],
      ),
      userExplanation: serializer.fromJson<String>(json['userExplanation']),
      basedOnSessionId: serializer.fromJson<String?>(json['basedOnSessionId']),
      supersedesProtocolId: serializer.fromJson<String?>(
        json['supersedesProtocolId'],
      ),
      settingsSnapshotJson: serializer.fromJson<String>(
        json['settingsSnapshotJson'],
      ),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      effectiveFromMs: serializer.fromJson<int>(json['effectiveFromMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'alarmId': serializer.toJson<String>(alarmId),
      'version': serializer.toJson<int>(version),
      'source': serializer.toJson<String>(source),
      'status': serializer.toJson<String>(status),
      'initialSoundId': serializer.toJson<String>(initialSoundId),
      'initialSoundFamily': serializer.toJson<String?>(initialSoundFamily),
      'ringtoneUri': serializer.toJson<String>(ringtoneUri),
      'initialVolumePercent': serializer.toJson<int>(initialVolumePercent),
      'maxVolumePercent': serializer.toJson<int>(maxVolumePercent),
      'volumeEscalationEnabled': serializer.toJson<bool>(
        volumeEscalationEnabled,
      ),
      'volumeEscalationStepPercent': serializer.toJson<int>(
        volumeEscalationStepPercent,
      ),
      'volumeEscalationIntervalSeconds': serializer.toJson<int>(
        volumeEscalationIntervalSeconds,
      ),
      'vibrationEnabled': serializer.toJson<bool>(vibrationEnabled),
      'vibrationPattern': serializer.toJson<String>(vibrationPattern),
      'vibrationEscalationEnabled': serializer.toJson<bool>(
        vibrationEscalationEnabled,
      ),
      'missionRequired': serializer.toJson<bool>(missionRequired),
      'missionType': serializer.toJson<String?>(missionType),
      'missionDifficulty': serializer.toJson<String?>(missionDifficulty),
      'missionConfigurationJson': serializer.toJson<String>(
        missionConfigurationJson,
      ),
      'wakeCheckRequired': serializer.toJson<bool>(wakeCheckRequired),
      'wakeCheckDelayMinutes': serializer.toJson<int>(wakeCheckDelayMinutes),
      'wakeCheckHoldMilliseconds': serializer.toJson<int>(
        wakeCheckHoldMilliseconds,
      ),
      'maxWakeCheckFailures': serializer.toJson<int>(maxWakeCheckFailures),
      'reactivationSoundPolicy': serializer.toJson<String>(
        reactivationSoundPolicy,
      ),
      'intensityLevel': serializer.toJson<int>(intensityLevel),
      'reasonCode': serializer.toJson<String>(reasonCode),
      'technicalExplanation': serializer.toJson<String>(technicalExplanation),
      'userExplanation': serializer.toJson<String>(userExplanation),
      'basedOnSessionId': serializer.toJson<String?>(basedOnSessionId),
      'supersedesProtocolId': serializer.toJson<String?>(supersedesProtocolId),
      'settingsSnapshotJson': serializer.toJson<String>(settingsSnapshotJson),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'effectiveFromMs': serializer.toJson<int>(effectiveFromMs),
    };
  }

  WakeProtocol copyWith({
    String? id,
    String? alarmId,
    int? version,
    String? source,
    String? status,
    String? initialSoundId,
    Value<String?> initialSoundFamily = const Value.absent(),
    String? ringtoneUri,
    int? initialVolumePercent,
    int? maxVolumePercent,
    bool? volumeEscalationEnabled,
    int? volumeEscalationStepPercent,
    int? volumeEscalationIntervalSeconds,
    bool? vibrationEnabled,
    String? vibrationPattern,
    bool? vibrationEscalationEnabled,
    bool? missionRequired,
    Value<String?> missionType = const Value.absent(),
    Value<String?> missionDifficulty = const Value.absent(),
    String? missionConfigurationJson,
    bool? wakeCheckRequired,
    int? wakeCheckDelayMinutes,
    int? wakeCheckHoldMilliseconds,
    int? maxWakeCheckFailures,
    String? reactivationSoundPolicy,
    int? intensityLevel,
    String? reasonCode,
    String? technicalExplanation,
    String? userExplanation,
    Value<String?> basedOnSessionId = const Value.absent(),
    Value<String?> supersedesProtocolId = const Value.absent(),
    String? settingsSnapshotJson,
    int? createdAtMs,
    int? effectiveFromMs,
  }) => WakeProtocol(
    id: id ?? this.id,
    alarmId: alarmId ?? this.alarmId,
    version: version ?? this.version,
    source: source ?? this.source,
    status: status ?? this.status,
    initialSoundId: initialSoundId ?? this.initialSoundId,
    initialSoundFamily: initialSoundFamily.present
        ? initialSoundFamily.value
        : this.initialSoundFamily,
    ringtoneUri: ringtoneUri ?? this.ringtoneUri,
    initialVolumePercent: initialVolumePercent ?? this.initialVolumePercent,
    maxVolumePercent: maxVolumePercent ?? this.maxVolumePercent,
    volumeEscalationEnabled:
        volumeEscalationEnabled ?? this.volumeEscalationEnabled,
    volumeEscalationStepPercent:
        volumeEscalationStepPercent ?? this.volumeEscalationStepPercent,
    volumeEscalationIntervalSeconds:
        volumeEscalationIntervalSeconds ?? this.volumeEscalationIntervalSeconds,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    vibrationPattern: vibrationPattern ?? this.vibrationPattern,
    vibrationEscalationEnabled:
        vibrationEscalationEnabled ?? this.vibrationEscalationEnabled,
    missionRequired: missionRequired ?? this.missionRequired,
    missionType: missionType.present ? missionType.value : this.missionType,
    missionDifficulty: missionDifficulty.present
        ? missionDifficulty.value
        : this.missionDifficulty,
    missionConfigurationJson:
        missionConfigurationJson ?? this.missionConfigurationJson,
    wakeCheckRequired: wakeCheckRequired ?? this.wakeCheckRequired,
    wakeCheckDelayMinutes: wakeCheckDelayMinutes ?? this.wakeCheckDelayMinutes,
    wakeCheckHoldMilliseconds:
        wakeCheckHoldMilliseconds ?? this.wakeCheckHoldMilliseconds,
    maxWakeCheckFailures: maxWakeCheckFailures ?? this.maxWakeCheckFailures,
    reactivationSoundPolicy:
        reactivationSoundPolicy ?? this.reactivationSoundPolicy,
    intensityLevel: intensityLevel ?? this.intensityLevel,
    reasonCode: reasonCode ?? this.reasonCode,
    technicalExplanation: technicalExplanation ?? this.technicalExplanation,
    userExplanation: userExplanation ?? this.userExplanation,
    basedOnSessionId: basedOnSessionId.present
        ? basedOnSessionId.value
        : this.basedOnSessionId,
    supersedesProtocolId: supersedesProtocolId.present
        ? supersedesProtocolId.value
        : this.supersedesProtocolId,
    settingsSnapshotJson: settingsSnapshotJson ?? this.settingsSnapshotJson,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    effectiveFromMs: effectiveFromMs ?? this.effectiveFromMs,
  );
  WakeProtocol copyWithCompanion(WakeProtocolsCompanion data) {
    return WakeProtocol(
      id: data.id.present ? data.id.value : this.id,
      alarmId: data.alarmId.present ? data.alarmId.value : this.alarmId,
      version: data.version.present ? data.version.value : this.version,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
      initialSoundId: data.initialSoundId.present
          ? data.initialSoundId.value
          : this.initialSoundId,
      initialSoundFamily: data.initialSoundFamily.present
          ? data.initialSoundFamily.value
          : this.initialSoundFamily,
      ringtoneUri: data.ringtoneUri.present
          ? data.ringtoneUri.value
          : this.ringtoneUri,
      initialVolumePercent: data.initialVolumePercent.present
          ? data.initialVolumePercent.value
          : this.initialVolumePercent,
      maxVolumePercent: data.maxVolumePercent.present
          ? data.maxVolumePercent.value
          : this.maxVolumePercent,
      volumeEscalationEnabled: data.volumeEscalationEnabled.present
          ? data.volumeEscalationEnabled.value
          : this.volumeEscalationEnabled,
      volumeEscalationStepPercent: data.volumeEscalationStepPercent.present
          ? data.volumeEscalationStepPercent.value
          : this.volumeEscalationStepPercent,
      volumeEscalationIntervalSeconds:
          data.volumeEscalationIntervalSeconds.present
          ? data.volumeEscalationIntervalSeconds.value
          : this.volumeEscalationIntervalSeconds,
      vibrationEnabled: data.vibrationEnabled.present
          ? data.vibrationEnabled.value
          : this.vibrationEnabled,
      vibrationPattern: data.vibrationPattern.present
          ? data.vibrationPattern.value
          : this.vibrationPattern,
      vibrationEscalationEnabled: data.vibrationEscalationEnabled.present
          ? data.vibrationEscalationEnabled.value
          : this.vibrationEscalationEnabled,
      missionRequired: data.missionRequired.present
          ? data.missionRequired.value
          : this.missionRequired,
      missionType: data.missionType.present
          ? data.missionType.value
          : this.missionType,
      missionDifficulty: data.missionDifficulty.present
          ? data.missionDifficulty.value
          : this.missionDifficulty,
      missionConfigurationJson: data.missionConfigurationJson.present
          ? data.missionConfigurationJson.value
          : this.missionConfigurationJson,
      wakeCheckRequired: data.wakeCheckRequired.present
          ? data.wakeCheckRequired.value
          : this.wakeCheckRequired,
      wakeCheckDelayMinutes: data.wakeCheckDelayMinutes.present
          ? data.wakeCheckDelayMinutes.value
          : this.wakeCheckDelayMinutes,
      wakeCheckHoldMilliseconds: data.wakeCheckHoldMilliseconds.present
          ? data.wakeCheckHoldMilliseconds.value
          : this.wakeCheckHoldMilliseconds,
      maxWakeCheckFailures: data.maxWakeCheckFailures.present
          ? data.maxWakeCheckFailures.value
          : this.maxWakeCheckFailures,
      reactivationSoundPolicy: data.reactivationSoundPolicy.present
          ? data.reactivationSoundPolicy.value
          : this.reactivationSoundPolicy,
      intensityLevel: data.intensityLevel.present
          ? data.intensityLevel.value
          : this.intensityLevel,
      reasonCode: data.reasonCode.present
          ? data.reasonCode.value
          : this.reasonCode,
      technicalExplanation: data.technicalExplanation.present
          ? data.technicalExplanation.value
          : this.technicalExplanation,
      userExplanation: data.userExplanation.present
          ? data.userExplanation.value
          : this.userExplanation,
      basedOnSessionId: data.basedOnSessionId.present
          ? data.basedOnSessionId.value
          : this.basedOnSessionId,
      supersedesProtocolId: data.supersedesProtocolId.present
          ? data.supersedesProtocolId.value
          : this.supersedesProtocolId,
      settingsSnapshotJson: data.settingsSnapshotJson.present
          ? data.settingsSnapshotJson.value
          : this.settingsSnapshotJson,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      effectiveFromMs: data.effectiveFromMs.present
          ? data.effectiveFromMs.value
          : this.effectiveFromMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WakeProtocol(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('version: $version, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('initialSoundId: $initialSoundId, ')
          ..write('initialSoundFamily: $initialSoundFamily, ')
          ..write('ringtoneUri: $ringtoneUri, ')
          ..write('initialVolumePercent: $initialVolumePercent, ')
          ..write('maxVolumePercent: $maxVolumePercent, ')
          ..write('volumeEscalationEnabled: $volumeEscalationEnabled, ')
          ..write('volumeEscalationStepPercent: $volumeEscalationStepPercent, ')
          ..write(
            'volumeEscalationIntervalSeconds: $volumeEscalationIntervalSeconds, ',
          )
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('vibrationPattern: $vibrationPattern, ')
          ..write('vibrationEscalationEnabled: $vibrationEscalationEnabled, ')
          ..write('missionRequired: $missionRequired, ')
          ..write('missionType: $missionType, ')
          ..write('missionDifficulty: $missionDifficulty, ')
          ..write('missionConfigurationJson: $missionConfigurationJson, ')
          ..write('wakeCheckRequired: $wakeCheckRequired, ')
          ..write('wakeCheckDelayMinutes: $wakeCheckDelayMinutes, ')
          ..write('wakeCheckHoldMilliseconds: $wakeCheckHoldMilliseconds, ')
          ..write('maxWakeCheckFailures: $maxWakeCheckFailures, ')
          ..write('reactivationSoundPolicy: $reactivationSoundPolicy, ')
          ..write('intensityLevel: $intensityLevel, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('technicalExplanation: $technicalExplanation, ')
          ..write('userExplanation: $userExplanation, ')
          ..write('basedOnSessionId: $basedOnSessionId, ')
          ..write('supersedesProtocolId: $supersedesProtocolId, ')
          ..write('settingsSnapshotJson: $settingsSnapshotJson, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('effectiveFromMs: $effectiveFromMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    alarmId,
    version,
    source,
    status,
    initialSoundId,
    initialSoundFamily,
    ringtoneUri,
    initialVolumePercent,
    maxVolumePercent,
    volumeEscalationEnabled,
    volumeEscalationStepPercent,
    volumeEscalationIntervalSeconds,
    vibrationEnabled,
    vibrationPattern,
    vibrationEscalationEnabled,
    missionRequired,
    missionType,
    missionDifficulty,
    missionConfigurationJson,
    wakeCheckRequired,
    wakeCheckDelayMinutes,
    wakeCheckHoldMilliseconds,
    maxWakeCheckFailures,
    reactivationSoundPolicy,
    intensityLevel,
    reasonCode,
    technicalExplanation,
    userExplanation,
    basedOnSessionId,
    supersedesProtocolId,
    settingsSnapshotJson,
    createdAtMs,
    effectiveFromMs,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WakeProtocol &&
          other.id == this.id &&
          other.alarmId == this.alarmId &&
          other.version == this.version &&
          other.source == this.source &&
          other.status == this.status &&
          other.initialSoundId == this.initialSoundId &&
          other.initialSoundFamily == this.initialSoundFamily &&
          other.ringtoneUri == this.ringtoneUri &&
          other.initialVolumePercent == this.initialVolumePercent &&
          other.maxVolumePercent == this.maxVolumePercent &&
          other.volumeEscalationEnabled == this.volumeEscalationEnabled &&
          other.volumeEscalationStepPercent ==
              this.volumeEscalationStepPercent &&
          other.volumeEscalationIntervalSeconds ==
              this.volumeEscalationIntervalSeconds &&
          other.vibrationEnabled == this.vibrationEnabled &&
          other.vibrationPattern == this.vibrationPattern &&
          other.vibrationEscalationEnabled == this.vibrationEscalationEnabled &&
          other.missionRequired == this.missionRequired &&
          other.missionType == this.missionType &&
          other.missionDifficulty == this.missionDifficulty &&
          other.missionConfigurationJson == this.missionConfigurationJson &&
          other.wakeCheckRequired == this.wakeCheckRequired &&
          other.wakeCheckDelayMinutes == this.wakeCheckDelayMinutes &&
          other.wakeCheckHoldMilliseconds == this.wakeCheckHoldMilliseconds &&
          other.maxWakeCheckFailures == this.maxWakeCheckFailures &&
          other.reactivationSoundPolicy == this.reactivationSoundPolicy &&
          other.intensityLevel == this.intensityLevel &&
          other.reasonCode == this.reasonCode &&
          other.technicalExplanation == this.technicalExplanation &&
          other.userExplanation == this.userExplanation &&
          other.basedOnSessionId == this.basedOnSessionId &&
          other.supersedesProtocolId == this.supersedesProtocolId &&
          other.settingsSnapshotJson == this.settingsSnapshotJson &&
          other.createdAtMs == this.createdAtMs &&
          other.effectiveFromMs == this.effectiveFromMs);
}

class WakeProtocolsCompanion extends UpdateCompanion<WakeProtocol> {
  final Value<String> id;
  final Value<String> alarmId;
  final Value<int> version;
  final Value<String> source;
  final Value<String> status;
  final Value<String> initialSoundId;
  final Value<String?> initialSoundFamily;
  final Value<String> ringtoneUri;
  final Value<int> initialVolumePercent;
  final Value<int> maxVolumePercent;
  final Value<bool> volumeEscalationEnabled;
  final Value<int> volumeEscalationStepPercent;
  final Value<int> volumeEscalationIntervalSeconds;
  final Value<bool> vibrationEnabled;
  final Value<String> vibrationPattern;
  final Value<bool> vibrationEscalationEnabled;
  final Value<bool> missionRequired;
  final Value<String?> missionType;
  final Value<String?> missionDifficulty;
  final Value<String> missionConfigurationJson;
  final Value<bool> wakeCheckRequired;
  final Value<int> wakeCheckDelayMinutes;
  final Value<int> wakeCheckHoldMilliseconds;
  final Value<int> maxWakeCheckFailures;
  final Value<String> reactivationSoundPolicy;
  final Value<int> intensityLevel;
  final Value<String> reasonCode;
  final Value<String> technicalExplanation;
  final Value<String> userExplanation;
  final Value<String?> basedOnSessionId;
  final Value<String?> supersedesProtocolId;
  final Value<String> settingsSnapshotJson;
  final Value<int> createdAtMs;
  final Value<int> effectiveFromMs;
  final Value<int> rowid;
  const WakeProtocolsCompanion({
    this.id = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.version = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.initialSoundId = const Value.absent(),
    this.initialSoundFamily = const Value.absent(),
    this.ringtoneUri = const Value.absent(),
    this.initialVolumePercent = const Value.absent(),
    this.maxVolumePercent = const Value.absent(),
    this.volumeEscalationEnabled = const Value.absent(),
    this.volumeEscalationStepPercent = const Value.absent(),
    this.volumeEscalationIntervalSeconds = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.vibrationPattern = const Value.absent(),
    this.vibrationEscalationEnabled = const Value.absent(),
    this.missionRequired = const Value.absent(),
    this.missionType = const Value.absent(),
    this.missionDifficulty = const Value.absent(),
    this.missionConfigurationJson = const Value.absent(),
    this.wakeCheckRequired = const Value.absent(),
    this.wakeCheckDelayMinutes = const Value.absent(),
    this.wakeCheckHoldMilliseconds = const Value.absent(),
    this.maxWakeCheckFailures = const Value.absent(),
    this.reactivationSoundPolicy = const Value.absent(),
    this.intensityLevel = const Value.absent(),
    this.reasonCode = const Value.absent(),
    this.technicalExplanation = const Value.absent(),
    this.userExplanation = const Value.absent(),
    this.basedOnSessionId = const Value.absent(),
    this.supersedesProtocolId = const Value.absent(),
    this.settingsSnapshotJson = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.effectiveFromMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WakeProtocolsCompanion.insert({
    required String id,
    required String alarmId,
    required int version,
    required String source,
    required String status,
    required String initialSoundId,
    this.initialSoundFamily = const Value.absent(),
    required String ringtoneUri,
    required int initialVolumePercent,
    required int maxVolumePercent,
    required bool volumeEscalationEnabled,
    required int volumeEscalationStepPercent,
    required int volumeEscalationIntervalSeconds,
    required bool vibrationEnabled,
    required String vibrationPattern,
    required bool vibrationEscalationEnabled,
    required bool missionRequired,
    this.missionType = const Value.absent(),
    this.missionDifficulty = const Value.absent(),
    this.missionConfigurationJson = const Value.absent(),
    required bool wakeCheckRequired,
    required int wakeCheckDelayMinutes,
    required int wakeCheckHoldMilliseconds,
    required int maxWakeCheckFailures,
    required String reactivationSoundPolicy,
    required int intensityLevel,
    required String reasonCode,
    required String technicalExplanation,
    required String userExplanation,
    this.basedOnSessionId = const Value.absent(),
    this.supersedesProtocolId = const Value.absent(),
    this.settingsSnapshotJson = const Value.absent(),
    required int createdAtMs,
    required int effectiveFromMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       alarmId = Value(alarmId),
       version = Value(version),
       source = Value(source),
       status = Value(status),
       initialSoundId = Value(initialSoundId),
       ringtoneUri = Value(ringtoneUri),
       initialVolumePercent = Value(initialVolumePercent),
       maxVolumePercent = Value(maxVolumePercent),
       volumeEscalationEnabled = Value(volumeEscalationEnabled),
       volumeEscalationStepPercent = Value(volumeEscalationStepPercent),
       volumeEscalationIntervalSeconds = Value(volumeEscalationIntervalSeconds),
       vibrationEnabled = Value(vibrationEnabled),
       vibrationPattern = Value(vibrationPattern),
       vibrationEscalationEnabled = Value(vibrationEscalationEnabled),
       missionRequired = Value(missionRequired),
       wakeCheckRequired = Value(wakeCheckRequired),
       wakeCheckDelayMinutes = Value(wakeCheckDelayMinutes),
       wakeCheckHoldMilliseconds = Value(wakeCheckHoldMilliseconds),
       maxWakeCheckFailures = Value(maxWakeCheckFailures),
       reactivationSoundPolicy = Value(reactivationSoundPolicy),
       intensityLevel = Value(intensityLevel),
       reasonCode = Value(reasonCode),
       technicalExplanation = Value(technicalExplanation),
       userExplanation = Value(userExplanation),
       createdAtMs = Value(createdAtMs),
       effectiveFromMs = Value(effectiveFromMs);
  static Insertable<WakeProtocol> custom({
    Expression<String>? id,
    Expression<String>? alarmId,
    Expression<int>? version,
    Expression<String>? source,
    Expression<String>? status,
    Expression<String>? initialSoundId,
    Expression<String>? initialSoundFamily,
    Expression<String>? ringtoneUri,
    Expression<int>? initialVolumePercent,
    Expression<int>? maxVolumePercent,
    Expression<bool>? volumeEscalationEnabled,
    Expression<int>? volumeEscalationStepPercent,
    Expression<int>? volumeEscalationIntervalSeconds,
    Expression<bool>? vibrationEnabled,
    Expression<String>? vibrationPattern,
    Expression<bool>? vibrationEscalationEnabled,
    Expression<bool>? missionRequired,
    Expression<String>? missionType,
    Expression<String>? missionDifficulty,
    Expression<String>? missionConfigurationJson,
    Expression<bool>? wakeCheckRequired,
    Expression<int>? wakeCheckDelayMinutes,
    Expression<int>? wakeCheckHoldMilliseconds,
    Expression<int>? maxWakeCheckFailures,
    Expression<String>? reactivationSoundPolicy,
    Expression<int>? intensityLevel,
    Expression<String>? reasonCode,
    Expression<String>? technicalExplanation,
    Expression<String>? userExplanation,
    Expression<String>? basedOnSessionId,
    Expression<String>? supersedesProtocolId,
    Expression<String>? settingsSnapshotJson,
    Expression<int>? createdAtMs,
    Expression<int>? effectiveFromMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alarmId != null) 'alarm_id': alarmId,
      if (version != null) 'version': version,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (initialSoundId != null) 'initial_sound_id': initialSoundId,
      if (initialSoundFamily != null)
        'initial_sound_family': initialSoundFamily,
      if (ringtoneUri != null) 'ringtone_uri': ringtoneUri,
      if (initialVolumePercent != null)
        'initial_volume_percent': initialVolumePercent,
      if (maxVolumePercent != null) 'max_volume_percent': maxVolumePercent,
      if (volumeEscalationEnabled != null)
        'volume_escalation_enabled': volumeEscalationEnabled,
      if (volumeEscalationStepPercent != null)
        'volume_escalation_step_percent': volumeEscalationStepPercent,
      if (volumeEscalationIntervalSeconds != null)
        'volume_escalation_interval_seconds': volumeEscalationIntervalSeconds,
      if (vibrationEnabled != null) 'vibration_enabled': vibrationEnabled,
      if (vibrationPattern != null) 'vibration_pattern': vibrationPattern,
      if (vibrationEscalationEnabled != null)
        'vibration_escalation_enabled': vibrationEscalationEnabled,
      if (missionRequired != null) 'mission_required': missionRequired,
      if (missionType != null) 'mission_type': missionType,
      if (missionDifficulty != null) 'mission_difficulty': missionDifficulty,
      if (missionConfigurationJson != null)
        'mission_configuration_json': missionConfigurationJson,
      if (wakeCheckRequired != null) 'wake_check_required': wakeCheckRequired,
      if (wakeCheckDelayMinutes != null)
        'wake_check_delay_minutes': wakeCheckDelayMinutes,
      if (wakeCheckHoldMilliseconds != null)
        'wake_check_hold_milliseconds': wakeCheckHoldMilliseconds,
      if (maxWakeCheckFailures != null)
        'max_wake_check_failures': maxWakeCheckFailures,
      if (reactivationSoundPolicy != null)
        'reactivation_sound_policy': reactivationSoundPolicy,
      if (intensityLevel != null) 'intensity_level': intensityLevel,
      if (reasonCode != null) 'reason_code': reasonCode,
      if (technicalExplanation != null)
        'technical_explanation': technicalExplanation,
      if (userExplanation != null) 'user_explanation': userExplanation,
      if (basedOnSessionId != null) 'based_on_session_id': basedOnSessionId,
      if (supersedesProtocolId != null)
        'supersedes_protocol_id': supersedesProtocolId,
      if (settingsSnapshotJson != null)
        'settings_snapshot_json': settingsSnapshotJson,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (effectiveFromMs != null) 'effective_from_ms': effectiveFromMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WakeProtocolsCompanion copyWith({
    Value<String>? id,
    Value<String>? alarmId,
    Value<int>? version,
    Value<String>? source,
    Value<String>? status,
    Value<String>? initialSoundId,
    Value<String?>? initialSoundFamily,
    Value<String>? ringtoneUri,
    Value<int>? initialVolumePercent,
    Value<int>? maxVolumePercent,
    Value<bool>? volumeEscalationEnabled,
    Value<int>? volumeEscalationStepPercent,
    Value<int>? volumeEscalationIntervalSeconds,
    Value<bool>? vibrationEnabled,
    Value<String>? vibrationPattern,
    Value<bool>? vibrationEscalationEnabled,
    Value<bool>? missionRequired,
    Value<String?>? missionType,
    Value<String?>? missionDifficulty,
    Value<String>? missionConfigurationJson,
    Value<bool>? wakeCheckRequired,
    Value<int>? wakeCheckDelayMinutes,
    Value<int>? wakeCheckHoldMilliseconds,
    Value<int>? maxWakeCheckFailures,
    Value<String>? reactivationSoundPolicy,
    Value<int>? intensityLevel,
    Value<String>? reasonCode,
    Value<String>? technicalExplanation,
    Value<String>? userExplanation,
    Value<String?>? basedOnSessionId,
    Value<String?>? supersedesProtocolId,
    Value<String>? settingsSnapshotJson,
    Value<int>? createdAtMs,
    Value<int>? effectiveFromMs,
    Value<int>? rowid,
  }) {
    return WakeProtocolsCompanion(
      id: id ?? this.id,
      alarmId: alarmId ?? this.alarmId,
      version: version ?? this.version,
      source: source ?? this.source,
      status: status ?? this.status,
      initialSoundId: initialSoundId ?? this.initialSoundId,
      initialSoundFamily: initialSoundFamily ?? this.initialSoundFamily,
      ringtoneUri: ringtoneUri ?? this.ringtoneUri,
      initialVolumePercent: initialVolumePercent ?? this.initialVolumePercent,
      maxVolumePercent: maxVolumePercent ?? this.maxVolumePercent,
      volumeEscalationEnabled:
          volumeEscalationEnabled ?? this.volumeEscalationEnabled,
      volumeEscalationStepPercent:
          volumeEscalationStepPercent ?? this.volumeEscalationStepPercent,
      volumeEscalationIntervalSeconds:
          volumeEscalationIntervalSeconds ??
          this.volumeEscalationIntervalSeconds,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      vibrationPattern: vibrationPattern ?? this.vibrationPattern,
      vibrationEscalationEnabled:
          vibrationEscalationEnabled ?? this.vibrationEscalationEnabled,
      missionRequired: missionRequired ?? this.missionRequired,
      missionType: missionType ?? this.missionType,
      missionDifficulty: missionDifficulty ?? this.missionDifficulty,
      missionConfigurationJson:
          missionConfigurationJson ?? this.missionConfigurationJson,
      wakeCheckRequired: wakeCheckRequired ?? this.wakeCheckRequired,
      wakeCheckDelayMinutes:
          wakeCheckDelayMinutes ?? this.wakeCheckDelayMinutes,
      wakeCheckHoldMilliseconds:
          wakeCheckHoldMilliseconds ?? this.wakeCheckHoldMilliseconds,
      maxWakeCheckFailures: maxWakeCheckFailures ?? this.maxWakeCheckFailures,
      reactivationSoundPolicy:
          reactivationSoundPolicy ?? this.reactivationSoundPolicy,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      reasonCode: reasonCode ?? this.reasonCode,
      technicalExplanation: technicalExplanation ?? this.technicalExplanation,
      userExplanation: userExplanation ?? this.userExplanation,
      basedOnSessionId: basedOnSessionId ?? this.basedOnSessionId,
      supersedesProtocolId: supersedesProtocolId ?? this.supersedesProtocolId,
      settingsSnapshotJson: settingsSnapshotJson ?? this.settingsSnapshotJson,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      effectiveFromMs: effectiveFromMs ?? this.effectiveFromMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<String>(alarmId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (initialSoundId.present) {
      map['initial_sound_id'] = Variable<String>(initialSoundId.value);
    }
    if (initialSoundFamily.present) {
      map['initial_sound_family'] = Variable<String>(initialSoundFamily.value);
    }
    if (ringtoneUri.present) {
      map['ringtone_uri'] = Variable<String>(ringtoneUri.value);
    }
    if (initialVolumePercent.present) {
      map['initial_volume_percent'] = Variable<int>(initialVolumePercent.value);
    }
    if (maxVolumePercent.present) {
      map['max_volume_percent'] = Variable<int>(maxVolumePercent.value);
    }
    if (volumeEscalationEnabled.present) {
      map['volume_escalation_enabled'] = Variable<bool>(
        volumeEscalationEnabled.value,
      );
    }
    if (volumeEscalationStepPercent.present) {
      map['volume_escalation_step_percent'] = Variable<int>(
        volumeEscalationStepPercent.value,
      );
    }
    if (volumeEscalationIntervalSeconds.present) {
      map['volume_escalation_interval_seconds'] = Variable<int>(
        volumeEscalationIntervalSeconds.value,
      );
    }
    if (vibrationEnabled.present) {
      map['vibration_enabled'] = Variable<bool>(vibrationEnabled.value);
    }
    if (vibrationPattern.present) {
      map['vibration_pattern'] = Variable<String>(vibrationPattern.value);
    }
    if (vibrationEscalationEnabled.present) {
      map['vibration_escalation_enabled'] = Variable<bool>(
        vibrationEscalationEnabled.value,
      );
    }
    if (missionRequired.present) {
      map['mission_required'] = Variable<bool>(missionRequired.value);
    }
    if (missionType.present) {
      map['mission_type'] = Variable<String>(missionType.value);
    }
    if (missionDifficulty.present) {
      map['mission_difficulty'] = Variable<String>(missionDifficulty.value);
    }
    if (missionConfigurationJson.present) {
      map['mission_configuration_json'] = Variable<String>(
        missionConfigurationJson.value,
      );
    }
    if (wakeCheckRequired.present) {
      map['wake_check_required'] = Variable<bool>(wakeCheckRequired.value);
    }
    if (wakeCheckDelayMinutes.present) {
      map['wake_check_delay_minutes'] = Variable<int>(
        wakeCheckDelayMinutes.value,
      );
    }
    if (wakeCheckHoldMilliseconds.present) {
      map['wake_check_hold_milliseconds'] = Variable<int>(
        wakeCheckHoldMilliseconds.value,
      );
    }
    if (maxWakeCheckFailures.present) {
      map['max_wake_check_failures'] = Variable<int>(
        maxWakeCheckFailures.value,
      );
    }
    if (reactivationSoundPolicy.present) {
      map['reactivation_sound_policy'] = Variable<String>(
        reactivationSoundPolicy.value,
      );
    }
    if (intensityLevel.present) {
      map['intensity_level'] = Variable<int>(intensityLevel.value);
    }
    if (reasonCode.present) {
      map['reason_code'] = Variable<String>(reasonCode.value);
    }
    if (technicalExplanation.present) {
      map['technical_explanation'] = Variable<String>(
        technicalExplanation.value,
      );
    }
    if (userExplanation.present) {
      map['user_explanation'] = Variable<String>(userExplanation.value);
    }
    if (basedOnSessionId.present) {
      map['based_on_session_id'] = Variable<String>(basedOnSessionId.value);
    }
    if (supersedesProtocolId.present) {
      map['supersedes_protocol_id'] = Variable<String>(
        supersedesProtocolId.value,
      );
    }
    if (settingsSnapshotJson.present) {
      map['settings_snapshot_json'] = Variable<String>(
        settingsSnapshotJson.value,
      );
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (effectiveFromMs.present) {
      map['effective_from_ms'] = Variable<int>(effectiveFromMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WakeProtocolsCompanion(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('version: $version, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('initialSoundId: $initialSoundId, ')
          ..write('initialSoundFamily: $initialSoundFamily, ')
          ..write('ringtoneUri: $ringtoneUri, ')
          ..write('initialVolumePercent: $initialVolumePercent, ')
          ..write('maxVolumePercent: $maxVolumePercent, ')
          ..write('volumeEscalationEnabled: $volumeEscalationEnabled, ')
          ..write('volumeEscalationStepPercent: $volumeEscalationStepPercent, ')
          ..write(
            'volumeEscalationIntervalSeconds: $volumeEscalationIntervalSeconds, ',
          )
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('vibrationPattern: $vibrationPattern, ')
          ..write('vibrationEscalationEnabled: $vibrationEscalationEnabled, ')
          ..write('missionRequired: $missionRequired, ')
          ..write('missionType: $missionType, ')
          ..write('missionDifficulty: $missionDifficulty, ')
          ..write('missionConfigurationJson: $missionConfigurationJson, ')
          ..write('wakeCheckRequired: $wakeCheckRequired, ')
          ..write('wakeCheckDelayMinutes: $wakeCheckDelayMinutes, ')
          ..write('wakeCheckHoldMilliseconds: $wakeCheckHoldMilliseconds, ')
          ..write('maxWakeCheckFailures: $maxWakeCheckFailures, ')
          ..write('reactivationSoundPolicy: $reactivationSoundPolicy, ')
          ..write('intensityLevel: $intensityLevel, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('technicalExplanation: $technicalExplanation, ')
          ..write('userExplanation: $userExplanation, ')
          ..write('basedOnSessionId: $basedOnSessionId, ')
          ..write('supersedesProtocolId: $supersedesProtocolId, ')
          ..write('settingsSnapshotJson: $settingsSnapshotJson, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('effectiveFromMs: $effectiveFromMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProtocolEvaluationsTable extends ProtocolEvaluations
    with TableInfo<$ProtocolEvaluationsTable, ProtocolEvaluation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProtocolEvaluationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolIdMeta = const VerificationMeta(
    'protocolId',
  );
  @override
  late final GeneratedColumn<String> protocolId = GeneratedColumn<String>(
    'protocol_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wake_protocols (id)',
    ),
  );
  static const VerificationMeta _wakeSessionIdMeta = const VerificationMeta(
    'wakeSessionId',
  );
  @override
  late final GeneratedColumn<String> wakeSessionId = GeneratedColumn<String>(
    'wake_session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wake_sessions (id)',
    ),
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryFailureModeMeta =
      const VerificationMeta('primaryFailureMode');
  @override
  late final GeneratedColumn<String> primaryFailureMode =
      GeneratedColumn<String>(
        'primary_failure_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _analysisJsonMeta = const VerificationMeta(
    'analysisJson',
  );
  @override
  late final GeneratedColumn<String> analysisJson = GeneratedColumn<String>(
    'analysis_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedRuleIdMeta = const VerificationMeta(
    'selectedRuleId',
  );
  @override
  late final GeneratedColumn<String> selectedRuleId = GeneratedColumn<String>(
    'selected_rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ruleTraceJsonMeta = const VerificationMeta(
    'ruleTraceJson',
  );
  @override
  late final GeneratedColumn<String> ruleTraceJson = GeneratedColumn<String>(
    'rule_trace_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _changesJsonMeta = const VerificationMeta(
    'changesJson',
  );
  @override
  late final GeneratedColumn<String> changesJson = GeneratedColumn<String>(
    'changes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _performanceScoreMeta = const VerificationMeta(
    'performanceScore',
  );
  @override
  late final GeneratedColumn<int> performanceScore = GeneratedColumn<int>(
    'performance_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreVersionMeta = const VerificationMeta(
    'scoreVersion',
  );
  @override
  late final GeneratedColumn<int> scoreVersion = GeneratedColumn<int>(
    'score_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evaluationNotesMeta = const VerificationMeta(
    'evaluationNotes',
  );
  @override
  late final GeneratedColumn<String> evaluationNotes = GeneratedColumn<String>(
    'evaluation_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    protocolId,
    wakeSessionId,
    result,
    primaryFailureMode,
    analysisJson,
    selectedRuleId,
    ruleTraceJson,
    changesJson,
    performanceScore,
    scoreVersion,
    evaluationNotes,
    createdAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'protocol_evaluations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProtocolEvaluation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('protocol_id')) {
      context.handle(
        _protocolIdMeta,
        protocolId.isAcceptableOrUnknown(data['protocol_id']!, _protocolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_protocolIdMeta);
    }
    if (data.containsKey('wake_session_id')) {
      context.handle(
        _wakeSessionIdMeta,
        wakeSessionId.isAcceptableOrUnknown(
          data['wake_session_id']!,
          _wakeSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeSessionIdMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('primary_failure_mode')) {
      context.handle(
        _primaryFailureModeMeta,
        primaryFailureMode.isAcceptableOrUnknown(
          data['primary_failure_mode']!,
          _primaryFailureModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryFailureModeMeta);
    }
    if (data.containsKey('analysis_json')) {
      context.handle(
        _analysisJsonMeta,
        analysisJson.isAcceptableOrUnknown(
          data['analysis_json']!,
          _analysisJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisJsonMeta);
    }
    if (data.containsKey('selected_rule_id')) {
      context.handle(
        _selectedRuleIdMeta,
        selectedRuleId.isAcceptableOrUnknown(
          data['selected_rule_id']!,
          _selectedRuleIdMeta,
        ),
      );
    }
    if (data.containsKey('rule_trace_json')) {
      context.handle(
        _ruleTraceJsonMeta,
        ruleTraceJson.isAcceptableOrUnknown(
          data['rule_trace_json']!,
          _ruleTraceJsonMeta,
        ),
      );
    }
    if (data.containsKey('changes_json')) {
      context.handle(
        _changesJsonMeta,
        changesJson.isAcceptableOrUnknown(
          data['changes_json']!,
          _changesJsonMeta,
        ),
      );
    }
    if (data.containsKey('performance_score')) {
      context.handle(
        _performanceScoreMeta,
        performanceScore.isAcceptableOrUnknown(
          data['performance_score']!,
          _performanceScoreMeta,
        ),
      );
    }
    if (data.containsKey('score_version')) {
      context.handle(
        _scoreVersionMeta,
        scoreVersion.isAcceptableOrUnknown(
          data['score_version']!,
          _scoreVersionMeta,
        ),
      );
    }
    if (data.containsKey('evaluation_notes')) {
      context.handle(
        _evaluationNotesMeta,
        evaluationNotes.isAcceptableOrUnknown(
          data['evaluation_notes']!,
          _evaluationNotesMeta,
        ),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProtocolEvaluation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProtocolEvaluation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      protocolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_id'],
      )!,
      wakeSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_session_id'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      primaryFailureMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_failure_mode'],
      )!,
      analysisJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_json'],
      )!,
      selectedRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_rule_id'],
      ),
      ruleTraceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_trace_json'],
      )!,
      changesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changes_json'],
      )!,
      performanceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}performance_score'],
      ),
      scoreVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_version'],
      ),
      evaluationNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evaluation_notes'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
    );
  }

  @override
  $ProtocolEvaluationsTable createAlias(String alias) {
    return $ProtocolEvaluationsTable(attachedDatabase, alias);
  }
}

class ProtocolEvaluation extends DataClass
    implements Insertable<ProtocolEvaluation> {
  final String id;
  final String protocolId;
  final String wakeSessionId;
  final String result;
  final String primaryFailureMode;
  final String analysisJson;
  final String? selectedRuleId;
  final String ruleTraceJson;
  final String changesJson;
  final int? performanceScore;
  final int? scoreVersion;
  final String evaluationNotes;
  final int createdAtMs;
  const ProtocolEvaluation({
    required this.id,
    required this.protocolId,
    required this.wakeSessionId,
    required this.result,
    required this.primaryFailureMode,
    required this.analysisJson,
    this.selectedRuleId,
    required this.ruleTraceJson,
    required this.changesJson,
    this.performanceScore,
    this.scoreVersion,
    required this.evaluationNotes,
    required this.createdAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['protocol_id'] = Variable<String>(protocolId);
    map['wake_session_id'] = Variable<String>(wakeSessionId);
    map['result'] = Variable<String>(result);
    map['primary_failure_mode'] = Variable<String>(primaryFailureMode);
    map['analysis_json'] = Variable<String>(analysisJson);
    if (!nullToAbsent || selectedRuleId != null) {
      map['selected_rule_id'] = Variable<String>(selectedRuleId);
    }
    map['rule_trace_json'] = Variable<String>(ruleTraceJson);
    map['changes_json'] = Variable<String>(changesJson);
    if (!nullToAbsent || performanceScore != null) {
      map['performance_score'] = Variable<int>(performanceScore);
    }
    if (!nullToAbsent || scoreVersion != null) {
      map['score_version'] = Variable<int>(scoreVersion);
    }
    map['evaluation_notes'] = Variable<String>(evaluationNotes);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    return map;
  }

  ProtocolEvaluationsCompanion toCompanion(bool nullToAbsent) {
    return ProtocolEvaluationsCompanion(
      id: Value(id),
      protocolId: Value(protocolId),
      wakeSessionId: Value(wakeSessionId),
      result: Value(result),
      primaryFailureMode: Value(primaryFailureMode),
      analysisJson: Value(analysisJson),
      selectedRuleId: selectedRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedRuleId),
      ruleTraceJson: Value(ruleTraceJson),
      changesJson: Value(changesJson),
      performanceScore: performanceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(performanceScore),
      scoreVersion: scoreVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreVersion),
      evaluationNotes: Value(evaluationNotes),
      createdAtMs: Value(createdAtMs),
    );
  }

  factory ProtocolEvaluation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProtocolEvaluation(
      id: serializer.fromJson<String>(json['id']),
      protocolId: serializer.fromJson<String>(json['protocolId']),
      wakeSessionId: serializer.fromJson<String>(json['wakeSessionId']),
      result: serializer.fromJson<String>(json['result']),
      primaryFailureMode: serializer.fromJson<String>(
        json['primaryFailureMode'],
      ),
      analysisJson: serializer.fromJson<String>(json['analysisJson']),
      selectedRuleId: serializer.fromJson<String?>(json['selectedRuleId']),
      ruleTraceJson: serializer.fromJson<String>(json['ruleTraceJson']),
      changesJson: serializer.fromJson<String>(json['changesJson']),
      performanceScore: serializer.fromJson<int?>(json['performanceScore']),
      scoreVersion: serializer.fromJson<int?>(json['scoreVersion']),
      evaluationNotes: serializer.fromJson<String>(json['evaluationNotes']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'protocolId': serializer.toJson<String>(protocolId),
      'wakeSessionId': serializer.toJson<String>(wakeSessionId),
      'result': serializer.toJson<String>(result),
      'primaryFailureMode': serializer.toJson<String>(primaryFailureMode),
      'analysisJson': serializer.toJson<String>(analysisJson),
      'selectedRuleId': serializer.toJson<String?>(selectedRuleId),
      'ruleTraceJson': serializer.toJson<String>(ruleTraceJson),
      'changesJson': serializer.toJson<String>(changesJson),
      'performanceScore': serializer.toJson<int?>(performanceScore),
      'scoreVersion': serializer.toJson<int?>(scoreVersion),
      'evaluationNotes': serializer.toJson<String>(evaluationNotes),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
    };
  }

  ProtocolEvaluation copyWith({
    String? id,
    String? protocolId,
    String? wakeSessionId,
    String? result,
    String? primaryFailureMode,
    String? analysisJson,
    Value<String?> selectedRuleId = const Value.absent(),
    String? ruleTraceJson,
    String? changesJson,
    Value<int?> performanceScore = const Value.absent(),
    Value<int?> scoreVersion = const Value.absent(),
    String? evaluationNotes,
    int? createdAtMs,
  }) => ProtocolEvaluation(
    id: id ?? this.id,
    protocolId: protocolId ?? this.protocolId,
    wakeSessionId: wakeSessionId ?? this.wakeSessionId,
    result: result ?? this.result,
    primaryFailureMode: primaryFailureMode ?? this.primaryFailureMode,
    analysisJson: analysisJson ?? this.analysisJson,
    selectedRuleId: selectedRuleId.present
        ? selectedRuleId.value
        : this.selectedRuleId,
    ruleTraceJson: ruleTraceJson ?? this.ruleTraceJson,
    changesJson: changesJson ?? this.changesJson,
    performanceScore: performanceScore.present
        ? performanceScore.value
        : this.performanceScore,
    scoreVersion: scoreVersion.present ? scoreVersion.value : this.scoreVersion,
    evaluationNotes: evaluationNotes ?? this.evaluationNotes,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );
  ProtocolEvaluation copyWithCompanion(ProtocolEvaluationsCompanion data) {
    return ProtocolEvaluation(
      id: data.id.present ? data.id.value : this.id,
      protocolId: data.protocolId.present
          ? data.protocolId.value
          : this.protocolId,
      wakeSessionId: data.wakeSessionId.present
          ? data.wakeSessionId.value
          : this.wakeSessionId,
      result: data.result.present ? data.result.value : this.result,
      primaryFailureMode: data.primaryFailureMode.present
          ? data.primaryFailureMode.value
          : this.primaryFailureMode,
      analysisJson: data.analysisJson.present
          ? data.analysisJson.value
          : this.analysisJson,
      selectedRuleId: data.selectedRuleId.present
          ? data.selectedRuleId.value
          : this.selectedRuleId,
      ruleTraceJson: data.ruleTraceJson.present
          ? data.ruleTraceJson.value
          : this.ruleTraceJson,
      changesJson: data.changesJson.present
          ? data.changesJson.value
          : this.changesJson,
      performanceScore: data.performanceScore.present
          ? data.performanceScore.value
          : this.performanceScore,
      scoreVersion: data.scoreVersion.present
          ? data.scoreVersion.value
          : this.scoreVersion,
      evaluationNotes: data.evaluationNotes.present
          ? data.evaluationNotes.value
          : this.evaluationNotes,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProtocolEvaluation(')
          ..write('id: $id, ')
          ..write('protocolId: $protocolId, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('result: $result, ')
          ..write('primaryFailureMode: $primaryFailureMode, ')
          ..write('analysisJson: $analysisJson, ')
          ..write('selectedRuleId: $selectedRuleId, ')
          ..write('ruleTraceJson: $ruleTraceJson, ')
          ..write('changesJson: $changesJson, ')
          ..write('performanceScore: $performanceScore, ')
          ..write('scoreVersion: $scoreVersion, ')
          ..write('evaluationNotes: $evaluationNotes, ')
          ..write('createdAtMs: $createdAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    protocolId,
    wakeSessionId,
    result,
    primaryFailureMode,
    analysisJson,
    selectedRuleId,
    ruleTraceJson,
    changesJson,
    performanceScore,
    scoreVersion,
    evaluationNotes,
    createdAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProtocolEvaluation &&
          other.id == this.id &&
          other.protocolId == this.protocolId &&
          other.wakeSessionId == this.wakeSessionId &&
          other.result == this.result &&
          other.primaryFailureMode == this.primaryFailureMode &&
          other.analysisJson == this.analysisJson &&
          other.selectedRuleId == this.selectedRuleId &&
          other.ruleTraceJson == this.ruleTraceJson &&
          other.changesJson == this.changesJson &&
          other.performanceScore == this.performanceScore &&
          other.scoreVersion == this.scoreVersion &&
          other.evaluationNotes == this.evaluationNotes &&
          other.createdAtMs == this.createdAtMs);
}

class ProtocolEvaluationsCompanion extends UpdateCompanion<ProtocolEvaluation> {
  final Value<String> id;
  final Value<String> protocolId;
  final Value<String> wakeSessionId;
  final Value<String> result;
  final Value<String> primaryFailureMode;
  final Value<String> analysisJson;
  final Value<String?> selectedRuleId;
  final Value<String> ruleTraceJson;
  final Value<String> changesJson;
  final Value<int?> performanceScore;
  final Value<int?> scoreVersion;
  final Value<String> evaluationNotes;
  final Value<int> createdAtMs;
  final Value<int> rowid;
  const ProtocolEvaluationsCompanion({
    this.id = const Value.absent(),
    this.protocolId = const Value.absent(),
    this.wakeSessionId = const Value.absent(),
    this.result = const Value.absent(),
    this.primaryFailureMode = const Value.absent(),
    this.analysisJson = const Value.absent(),
    this.selectedRuleId = const Value.absent(),
    this.ruleTraceJson = const Value.absent(),
    this.changesJson = const Value.absent(),
    this.performanceScore = const Value.absent(),
    this.scoreVersion = const Value.absent(),
    this.evaluationNotes = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProtocolEvaluationsCompanion.insert({
    required String id,
    required String protocolId,
    required String wakeSessionId,
    required String result,
    required String primaryFailureMode,
    required String analysisJson,
    this.selectedRuleId = const Value.absent(),
    this.ruleTraceJson = const Value.absent(),
    this.changesJson = const Value.absent(),
    this.performanceScore = const Value.absent(),
    this.scoreVersion = const Value.absent(),
    this.evaluationNotes = const Value.absent(),
    required int createdAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       protocolId = Value(protocolId),
       wakeSessionId = Value(wakeSessionId),
       result = Value(result),
       primaryFailureMode = Value(primaryFailureMode),
       analysisJson = Value(analysisJson),
       createdAtMs = Value(createdAtMs);
  static Insertable<ProtocolEvaluation> custom({
    Expression<String>? id,
    Expression<String>? protocolId,
    Expression<String>? wakeSessionId,
    Expression<String>? result,
    Expression<String>? primaryFailureMode,
    Expression<String>? analysisJson,
    Expression<String>? selectedRuleId,
    Expression<String>? ruleTraceJson,
    Expression<String>? changesJson,
    Expression<int>? performanceScore,
    Expression<int>? scoreVersion,
    Expression<String>? evaluationNotes,
    Expression<int>? createdAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (protocolId != null) 'protocol_id': protocolId,
      if (wakeSessionId != null) 'wake_session_id': wakeSessionId,
      if (result != null) 'result': result,
      if (primaryFailureMode != null)
        'primary_failure_mode': primaryFailureMode,
      if (analysisJson != null) 'analysis_json': analysisJson,
      if (selectedRuleId != null) 'selected_rule_id': selectedRuleId,
      if (ruleTraceJson != null) 'rule_trace_json': ruleTraceJson,
      if (changesJson != null) 'changes_json': changesJson,
      if (performanceScore != null) 'performance_score': performanceScore,
      if (scoreVersion != null) 'score_version': scoreVersion,
      if (evaluationNotes != null) 'evaluation_notes': evaluationNotes,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProtocolEvaluationsCompanion copyWith({
    Value<String>? id,
    Value<String>? protocolId,
    Value<String>? wakeSessionId,
    Value<String>? result,
    Value<String>? primaryFailureMode,
    Value<String>? analysisJson,
    Value<String?>? selectedRuleId,
    Value<String>? ruleTraceJson,
    Value<String>? changesJson,
    Value<int?>? performanceScore,
    Value<int?>? scoreVersion,
    Value<String>? evaluationNotes,
    Value<int>? createdAtMs,
    Value<int>? rowid,
  }) {
    return ProtocolEvaluationsCompanion(
      id: id ?? this.id,
      protocolId: protocolId ?? this.protocolId,
      wakeSessionId: wakeSessionId ?? this.wakeSessionId,
      result: result ?? this.result,
      primaryFailureMode: primaryFailureMode ?? this.primaryFailureMode,
      analysisJson: analysisJson ?? this.analysisJson,
      selectedRuleId: selectedRuleId ?? this.selectedRuleId,
      ruleTraceJson: ruleTraceJson ?? this.ruleTraceJson,
      changesJson: changesJson ?? this.changesJson,
      performanceScore: performanceScore ?? this.performanceScore,
      scoreVersion: scoreVersion ?? this.scoreVersion,
      evaluationNotes: evaluationNotes ?? this.evaluationNotes,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (protocolId.present) {
      map['protocol_id'] = Variable<String>(protocolId.value);
    }
    if (wakeSessionId.present) {
      map['wake_session_id'] = Variable<String>(wakeSessionId.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (primaryFailureMode.present) {
      map['primary_failure_mode'] = Variable<String>(primaryFailureMode.value);
    }
    if (analysisJson.present) {
      map['analysis_json'] = Variable<String>(analysisJson.value);
    }
    if (selectedRuleId.present) {
      map['selected_rule_id'] = Variable<String>(selectedRuleId.value);
    }
    if (ruleTraceJson.present) {
      map['rule_trace_json'] = Variable<String>(ruleTraceJson.value);
    }
    if (changesJson.present) {
      map['changes_json'] = Variable<String>(changesJson.value);
    }
    if (performanceScore.present) {
      map['performance_score'] = Variable<int>(performanceScore.value);
    }
    if (scoreVersion.present) {
      map['score_version'] = Variable<int>(scoreVersion.value);
    }
    if (evaluationNotes.present) {
      map['evaluation_notes'] = Variable<String>(evaluationNotes.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProtocolEvaluationsCompanion(')
          ..write('id: $id, ')
          ..write('protocolId: $protocolId, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('result: $result, ')
          ..write('primaryFailureMode: $primaryFailureMode, ')
          ..write('analysisJson: $analysisJson, ')
          ..write('selectedRuleId: $selectedRuleId, ')
          ..write('ruleTraceJson: $ruleTraceJson, ')
          ..write('changesJson: $changesJson, ')
          ..write('performanceScore: $performanceScore, ')
          ..write('scoreVersion: $scoreVersion, ')
          ..write('evaluationNotes: $evaluationNotes, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmAdaptationSettingsTable extends AlarmAdaptationSettings
    with TableInfo<$AlarmAdaptationSettingsTable, AlarmAdaptationSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmAdaptationSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _alarmIdMeta = const VerificationMeta(
    'alarmId',
  );
  @override
  late final GeneratedColumn<String> alarmId = GeneratedColumn<String>(
    'alarm_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alarms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _adaptSoundMeta = const VerificationMeta(
    'adaptSound',
  );
  @override
  late final GeneratedColumn<bool> adaptSound = GeneratedColumn<bool>(
    'adapt_sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adapt_sound" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _adaptVolumeMeta = const VerificationMeta(
    'adaptVolume',
  );
  @override
  late final GeneratedColumn<bool> adaptVolume = GeneratedColumn<bool>(
    'adapt_volume',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adapt_volume" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _adaptVibrationMeta = const VerificationMeta(
    'adaptVibration',
  );
  @override
  late final GeneratedColumn<bool> adaptVibration = GeneratedColumn<bool>(
    'adapt_vibration',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adapt_vibration" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _adaptWakeCheckMeta = const VerificationMeta(
    'adaptWakeCheck',
  );
  @override
  late final GeneratedColumn<bool> adaptWakeCheck = GeneratedColumn<bool>(
    'adapt_wake_check',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adapt_wake_check" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _adaptMissionMeta = const VerificationMeta(
    'adaptMission',
  );
  @override
  late final GeneratedColumn<bool> adaptMission = GeneratedColumn<bool>(
    'adapt_mission',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adapt_mission" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _userMaxVolumePercentMeta =
      const VerificationMeta('userMaxVolumePercent');
  @override
  late final GeneratedColumn<int> userMaxVolumePercent = GeneratedColumn<int>(
    'user_max_volume_percent',
    aliasedName,
    false,
    check: () =>
        const CustomExpression('user_max_volume_percent BETWEEN 30 AND 100'),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    alarmId,
    enabled,
    adaptSound,
    adaptVolume,
    adaptVibration,
    adaptWakeCheck,
    adaptMission,
    userMaxVolumePercent,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarm_adaptation_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlarmAdaptationSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('alarm_id')) {
      context.handle(
        _alarmIdMeta,
        alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('adapt_sound')) {
      context.handle(
        _adaptSoundMeta,
        adaptSound.isAcceptableOrUnknown(data['adapt_sound']!, _adaptSoundMeta),
      );
    }
    if (data.containsKey('adapt_volume')) {
      context.handle(
        _adaptVolumeMeta,
        adaptVolume.isAcceptableOrUnknown(
          data['adapt_volume']!,
          _adaptVolumeMeta,
        ),
      );
    }
    if (data.containsKey('adapt_vibration')) {
      context.handle(
        _adaptVibrationMeta,
        adaptVibration.isAcceptableOrUnknown(
          data['adapt_vibration']!,
          _adaptVibrationMeta,
        ),
      );
    }
    if (data.containsKey('adapt_wake_check')) {
      context.handle(
        _adaptWakeCheckMeta,
        adaptWakeCheck.isAcceptableOrUnknown(
          data['adapt_wake_check']!,
          _adaptWakeCheckMeta,
        ),
      );
    }
    if (data.containsKey('adapt_mission')) {
      context.handle(
        _adaptMissionMeta,
        adaptMission.isAcceptableOrUnknown(
          data['adapt_mission']!,
          _adaptMissionMeta,
        ),
      );
    }
    if (data.containsKey('user_max_volume_percent')) {
      context.handle(
        _userMaxVolumePercentMeta,
        userMaxVolumePercent.isAcceptableOrUnknown(
          data['user_max_volume_percent']!,
          _userMaxVolumePercentMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {alarmId};
  @override
  AlarmAdaptationSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmAdaptationSetting(
      alarmId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alarm_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      adaptSound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adapt_sound'],
      )!,
      adaptVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adapt_volume'],
      )!,
      adaptVibration: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adapt_vibration'],
      )!,
      adaptWakeCheck: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adapt_wake_check'],
      )!,
      adaptMission: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adapt_mission'],
      )!,
      userMaxVolumePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_max_volume_percent'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $AlarmAdaptationSettingsTable createAlias(String alias) {
    return $AlarmAdaptationSettingsTable(attachedDatabase, alias);
  }
}

class AlarmAdaptationSetting extends DataClass
    implements Insertable<AlarmAdaptationSetting> {
  final String alarmId;
  final bool enabled;
  final bool adaptSound;
  final bool adaptVolume;
  final bool adaptVibration;
  final bool adaptWakeCheck;
  final bool adaptMission;
  final int userMaxVolumePercent;
  final int updatedAtMs;
  const AlarmAdaptationSetting({
    required this.alarmId,
    required this.enabled,
    required this.adaptSound,
    required this.adaptVolume,
    required this.adaptVibration,
    required this.adaptWakeCheck,
    required this.adaptMission,
    required this.userMaxVolumePercent,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['alarm_id'] = Variable<String>(alarmId);
    map['enabled'] = Variable<bool>(enabled);
    map['adapt_sound'] = Variable<bool>(adaptSound);
    map['adapt_volume'] = Variable<bool>(adaptVolume);
    map['adapt_vibration'] = Variable<bool>(adaptVibration);
    map['adapt_wake_check'] = Variable<bool>(adaptWakeCheck);
    map['adapt_mission'] = Variable<bool>(adaptMission);
    map['user_max_volume_percent'] = Variable<int>(userMaxVolumePercent);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  AlarmAdaptationSettingsCompanion toCompanion(bool nullToAbsent) {
    return AlarmAdaptationSettingsCompanion(
      alarmId: Value(alarmId),
      enabled: Value(enabled),
      adaptSound: Value(adaptSound),
      adaptVolume: Value(adaptVolume),
      adaptVibration: Value(adaptVibration),
      adaptWakeCheck: Value(adaptWakeCheck),
      adaptMission: Value(adaptMission),
      userMaxVolumePercent: Value(userMaxVolumePercent),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory AlarmAdaptationSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmAdaptationSetting(
      alarmId: serializer.fromJson<String>(json['alarmId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      adaptSound: serializer.fromJson<bool>(json['adaptSound']),
      adaptVolume: serializer.fromJson<bool>(json['adaptVolume']),
      adaptVibration: serializer.fromJson<bool>(json['adaptVibration']),
      adaptWakeCheck: serializer.fromJson<bool>(json['adaptWakeCheck']),
      adaptMission: serializer.fromJson<bool>(json['adaptMission']),
      userMaxVolumePercent: serializer.fromJson<int>(
        json['userMaxVolumePercent'],
      ),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'alarmId': serializer.toJson<String>(alarmId),
      'enabled': serializer.toJson<bool>(enabled),
      'adaptSound': serializer.toJson<bool>(adaptSound),
      'adaptVolume': serializer.toJson<bool>(adaptVolume),
      'adaptVibration': serializer.toJson<bool>(adaptVibration),
      'adaptWakeCheck': serializer.toJson<bool>(adaptWakeCheck),
      'adaptMission': serializer.toJson<bool>(adaptMission),
      'userMaxVolumePercent': serializer.toJson<int>(userMaxVolumePercent),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  AlarmAdaptationSetting copyWith({
    String? alarmId,
    bool? enabled,
    bool? adaptSound,
    bool? adaptVolume,
    bool? adaptVibration,
    bool? adaptWakeCheck,
    bool? adaptMission,
    int? userMaxVolumePercent,
    int? updatedAtMs,
  }) => AlarmAdaptationSetting(
    alarmId: alarmId ?? this.alarmId,
    enabled: enabled ?? this.enabled,
    adaptSound: adaptSound ?? this.adaptSound,
    adaptVolume: adaptVolume ?? this.adaptVolume,
    adaptVibration: adaptVibration ?? this.adaptVibration,
    adaptWakeCheck: adaptWakeCheck ?? this.adaptWakeCheck,
    adaptMission: adaptMission ?? this.adaptMission,
    userMaxVolumePercent: userMaxVolumePercent ?? this.userMaxVolumePercent,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  AlarmAdaptationSetting copyWithCompanion(
    AlarmAdaptationSettingsCompanion data,
  ) {
    return AlarmAdaptationSetting(
      alarmId: data.alarmId.present ? data.alarmId.value : this.alarmId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      adaptSound: data.adaptSound.present
          ? data.adaptSound.value
          : this.adaptSound,
      adaptVolume: data.adaptVolume.present
          ? data.adaptVolume.value
          : this.adaptVolume,
      adaptVibration: data.adaptVibration.present
          ? data.adaptVibration.value
          : this.adaptVibration,
      adaptWakeCheck: data.adaptWakeCheck.present
          ? data.adaptWakeCheck.value
          : this.adaptWakeCheck,
      adaptMission: data.adaptMission.present
          ? data.adaptMission.value
          : this.adaptMission,
      userMaxVolumePercent: data.userMaxVolumePercent.present
          ? data.userMaxVolumePercent.value
          : this.userMaxVolumePercent,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmAdaptationSetting(')
          ..write('alarmId: $alarmId, ')
          ..write('enabled: $enabled, ')
          ..write('adaptSound: $adaptSound, ')
          ..write('adaptVolume: $adaptVolume, ')
          ..write('adaptVibration: $adaptVibration, ')
          ..write('adaptWakeCheck: $adaptWakeCheck, ')
          ..write('adaptMission: $adaptMission, ')
          ..write('userMaxVolumePercent: $userMaxVolumePercent, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    alarmId,
    enabled,
    adaptSound,
    adaptVolume,
    adaptVibration,
    adaptWakeCheck,
    adaptMission,
    userMaxVolumePercent,
    updatedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmAdaptationSetting &&
          other.alarmId == this.alarmId &&
          other.enabled == this.enabled &&
          other.adaptSound == this.adaptSound &&
          other.adaptVolume == this.adaptVolume &&
          other.adaptVibration == this.adaptVibration &&
          other.adaptWakeCheck == this.adaptWakeCheck &&
          other.adaptMission == this.adaptMission &&
          other.userMaxVolumePercent == this.userMaxVolumePercent &&
          other.updatedAtMs == this.updatedAtMs);
}

class AlarmAdaptationSettingsCompanion
    extends UpdateCompanion<AlarmAdaptationSetting> {
  final Value<String> alarmId;
  final Value<bool> enabled;
  final Value<bool> adaptSound;
  final Value<bool> adaptVolume;
  final Value<bool> adaptVibration;
  final Value<bool> adaptWakeCheck;
  final Value<bool> adaptMission;
  final Value<int> userMaxVolumePercent;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const AlarmAdaptationSettingsCompanion({
    this.alarmId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.adaptSound = const Value.absent(),
    this.adaptVolume = const Value.absent(),
    this.adaptVibration = const Value.absent(),
    this.adaptWakeCheck = const Value.absent(),
    this.adaptMission = const Value.absent(),
    this.userMaxVolumePercent = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlarmAdaptationSettingsCompanion.insert({
    required String alarmId,
    this.enabled = const Value.absent(),
    this.adaptSound = const Value.absent(),
    this.adaptVolume = const Value.absent(),
    this.adaptVibration = const Value.absent(),
    this.adaptWakeCheck = const Value.absent(),
    this.adaptMission = const Value.absent(),
    this.userMaxVolumePercent = const Value.absent(),
    required int updatedAtMs,
    this.rowid = const Value.absent(),
  }) : alarmId = Value(alarmId),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<AlarmAdaptationSetting> custom({
    Expression<String>? alarmId,
    Expression<bool>? enabled,
    Expression<bool>? adaptSound,
    Expression<bool>? adaptVolume,
    Expression<bool>? adaptVibration,
    Expression<bool>? adaptWakeCheck,
    Expression<bool>? adaptMission,
    Expression<int>? userMaxVolumePercent,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (alarmId != null) 'alarm_id': alarmId,
      if (enabled != null) 'enabled': enabled,
      if (adaptSound != null) 'adapt_sound': adaptSound,
      if (adaptVolume != null) 'adapt_volume': adaptVolume,
      if (adaptVibration != null) 'adapt_vibration': adaptVibration,
      if (adaptWakeCheck != null) 'adapt_wake_check': adaptWakeCheck,
      if (adaptMission != null) 'adapt_mission': adaptMission,
      if (userMaxVolumePercent != null)
        'user_max_volume_percent': userMaxVolumePercent,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlarmAdaptationSettingsCompanion copyWith({
    Value<String>? alarmId,
    Value<bool>? enabled,
    Value<bool>? adaptSound,
    Value<bool>? adaptVolume,
    Value<bool>? adaptVibration,
    Value<bool>? adaptWakeCheck,
    Value<bool>? adaptMission,
    Value<int>? userMaxVolumePercent,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return AlarmAdaptationSettingsCompanion(
      alarmId: alarmId ?? this.alarmId,
      enabled: enabled ?? this.enabled,
      adaptSound: adaptSound ?? this.adaptSound,
      adaptVolume: adaptVolume ?? this.adaptVolume,
      adaptVibration: adaptVibration ?? this.adaptVibration,
      adaptWakeCheck: adaptWakeCheck ?? this.adaptWakeCheck,
      adaptMission: adaptMission ?? this.adaptMission,
      userMaxVolumePercent: userMaxVolumePercent ?? this.userMaxVolumePercent,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (alarmId.present) {
      map['alarm_id'] = Variable<String>(alarmId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (adaptSound.present) {
      map['adapt_sound'] = Variable<bool>(adaptSound.value);
    }
    if (adaptVolume.present) {
      map['adapt_volume'] = Variable<bool>(adaptVolume.value);
    }
    if (adaptVibration.present) {
      map['adapt_vibration'] = Variable<bool>(adaptVibration.value);
    }
    if (adaptWakeCheck.present) {
      map['adapt_wake_check'] = Variable<bool>(adaptWakeCheck.value);
    }
    if (adaptMission.present) {
      map['adapt_mission'] = Variable<bool>(adaptMission.value);
    }
    if (userMaxVolumePercent.present) {
      map['user_max_volume_percent'] = Variable<int>(
        userMaxVolumePercent.value,
      );
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmAdaptationSettingsCompanion(')
          ..write('alarmId: $alarmId, ')
          ..write('enabled: $enabled, ')
          ..write('adaptSound: $adaptSound, ')
          ..write('adaptVolume: $adaptVolume, ')
          ..write('adaptVibration: $adaptVibration, ')
          ..write('adaptWakeCheck: $adaptWakeCheck, ')
          ..write('adaptMission: $adaptMission, ')
          ..write('userMaxVolumePercent: $userMaxVolumePercent, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WakeExperimentsTable extends WakeExperiments
    with TableInfo<$WakeExperimentsTable, WakeExperimentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WakeExperimentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alarmIdMeta = const VerificationMeta(
    'alarmId',
  );
  @override
  late final GeneratedColumn<String> alarmId = GeneratedColumn<String>(
    'alarm_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hypothesisMeta = const VerificationMeta(
    'hypothesis',
  );
  @override
  late final GeneratedColumn<String> hypothesis = GeneratedColumn<String>(
    'hypothesis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () => const CustomExpression(
      "status IN ('draft','ready','running','paused','completed','cancelled','invalidated')",
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dimensionMeta = const VerificationMeta(
    'dimension',
  );
  @override
  late final GeneratedColumn<String> dimension = GeneratedColumn<String>(
    'dimension',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _controlProtocolIdMeta = const VerificationMeta(
    'controlProtocolId',
  );
  @override
  late final GeneratedColumn<String> controlProtocolId =
      GeneratedColumn<String>(
        'control_protocol_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _controlProtocolVersionMeta =
      const VerificationMeta('controlProtocolVersion');
  @override
  late final GeneratedColumn<int> controlProtocolVersion = GeneratedColumn<int>(
    'control_protocol_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _controlSnapshotJsonMeta =
      const VerificationMeta('controlSnapshotJson');
  @override
  late final GeneratedColumn<String> controlSnapshotJson =
      GeneratedColumn<String>(
        'control_snapshot_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _candidateProtocolIdMeta =
      const VerificationMeta('candidateProtocolId');
  @override
  late final GeneratedColumn<String> candidateProtocolId =
      GeneratedColumn<String>(
        'candidate_protocol_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _candidateProtocolVersionMeta =
      const VerificationMeta('candidateProtocolVersion');
  @override
  late final GeneratedColumn<int> candidateProtocolVersion =
      GeneratedColumn<int>(
        'candidate_protocol_version',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _candidateSnapshotJsonMeta =
      const VerificationMeta('candidateSnapshotJson');
  @override
  late final GeneratedColumn<String> candidateSnapshotJson =
      GeneratedColumn<String>(
        'candidate_snapshot_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _contextKeyMeta = const VerificationMeta(
    'contextKey',
  );
  @override
  late final GeneratedColumn<String> contextKey = GeneratedColumn<String>(
    'context_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumSessionsPerVariantMeta =
      const VerificationMeta('minimumSessionsPerVariant');
  @override
  late final GeneratedColumn<int> minimumSessionsPerVariant =
      GeneratedColumn<int>(
        'minimum_sessions_per_variant',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _preferredSessionsPerVariantMeta =
      const VerificationMeta('preferredSessionsPerVariant');
  @override
  late final GeneratedColumn<int> preferredSessionsPerVariant =
      GeneratedColumn<int>(
        'preferred_sessions_per_variant',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _maximumSessionsPerVariantMeta =
      const VerificationMeta('maximumSessionsPerVariant');
  @override
  late final GeneratedColumn<int> maximumSessionsPerVariant =
      GeneratedColumn<int>(
        'maximum_sessions_per_variant',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('insufficientData'),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('insufficient'),
  );
  static const VerificationMeta _winnerProtocolIdMeta = const VerificationMeta(
    'winnerProtocolId',
  );
  @override
  late final GeneratedColumn<String> winnerProtocolId = GeneratedColumn<String>(
    'winner_protocol_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invalidReasonMeta = const VerificationMeta(
    'invalidReason',
  );
  @override
  late final GeneratedColumn<String> invalidReason = GeneratedColumn<String>(
    'invalid_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMsMeta = const VerificationMeta(
    'startedAtMs',
  );
  @override
  late final GeneratedColumn<int> startedAtMs = GeneratedColumn<int>(
    'started_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMsMeta = const VerificationMeta(
    'completedAtMs',
  );
  @override
  late final GeneratedColumn<int> completedAtMs = GeneratedColumn<int>(
    'completed_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alarmId,
    name,
    hypothesis,
    status,
    dimension,
    controlProtocolId,
    controlProtocolVersion,
    controlSnapshotJson,
    candidateProtocolId,
    candidateProtocolVersion,
    candidateSnapshotJson,
    contextKey,
    minimumSessionsPerVariant,
    preferredSessionsPerVariant,
    maximumSessionsPerVariant,
    result,
    confidence,
    winnerProtocolId,
    invalidReason,
    startedAtMs,
    completedAtMs,
    createdAtMs,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wake_experiments';
  @override
  VerificationContext validateIntegrity(
    Insertable<WakeExperimentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('alarm_id')) {
      context.handle(
        _alarmIdMeta,
        alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hypothesis')) {
      context.handle(
        _hypothesisMeta,
        hypothesis.isAcceptableOrUnknown(data['hypothesis']!, _hypothesisMeta),
      );
    } else if (isInserting) {
      context.missing(_hypothesisMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('dimension')) {
      context.handle(
        _dimensionMeta,
        dimension.isAcceptableOrUnknown(data['dimension']!, _dimensionMeta),
      );
    } else if (isInserting) {
      context.missing(_dimensionMeta);
    }
    if (data.containsKey('control_protocol_id')) {
      context.handle(
        _controlProtocolIdMeta,
        controlProtocolId.isAcceptableOrUnknown(
          data['control_protocol_id']!,
          _controlProtocolIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_controlProtocolIdMeta);
    }
    if (data.containsKey('control_protocol_version')) {
      context.handle(
        _controlProtocolVersionMeta,
        controlProtocolVersion.isAcceptableOrUnknown(
          data['control_protocol_version']!,
          _controlProtocolVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_controlProtocolVersionMeta);
    }
    if (data.containsKey('control_snapshot_json')) {
      context.handle(
        _controlSnapshotJsonMeta,
        controlSnapshotJson.isAcceptableOrUnknown(
          data['control_snapshot_json']!,
          _controlSnapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_controlSnapshotJsonMeta);
    }
    if (data.containsKey('candidate_protocol_id')) {
      context.handle(
        _candidateProtocolIdMeta,
        candidateProtocolId.isAcceptableOrUnknown(
          data['candidate_protocol_id']!,
          _candidateProtocolIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidateProtocolIdMeta);
    }
    if (data.containsKey('candidate_protocol_version')) {
      context.handle(
        _candidateProtocolVersionMeta,
        candidateProtocolVersion.isAcceptableOrUnknown(
          data['candidate_protocol_version']!,
          _candidateProtocolVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidateProtocolVersionMeta);
    }
    if (data.containsKey('candidate_snapshot_json')) {
      context.handle(
        _candidateSnapshotJsonMeta,
        candidateSnapshotJson.isAcceptableOrUnknown(
          data['candidate_snapshot_json']!,
          _candidateSnapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidateSnapshotJsonMeta);
    }
    if (data.containsKey('context_key')) {
      context.handle(
        _contextKeyMeta,
        contextKey.isAcceptableOrUnknown(data['context_key']!, _contextKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_contextKeyMeta);
    }
    if (data.containsKey('minimum_sessions_per_variant')) {
      context.handle(
        _minimumSessionsPerVariantMeta,
        minimumSessionsPerVariant.isAcceptableOrUnknown(
          data['minimum_sessions_per_variant']!,
          _minimumSessionsPerVariantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minimumSessionsPerVariantMeta);
    }
    if (data.containsKey('preferred_sessions_per_variant')) {
      context.handle(
        _preferredSessionsPerVariantMeta,
        preferredSessionsPerVariant.isAcceptableOrUnknown(
          data['preferred_sessions_per_variant']!,
          _preferredSessionsPerVariantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredSessionsPerVariantMeta);
    }
    if (data.containsKey('maximum_sessions_per_variant')) {
      context.handle(
        _maximumSessionsPerVariantMeta,
        maximumSessionsPerVariant.isAcceptableOrUnknown(
          data['maximum_sessions_per_variant']!,
          _maximumSessionsPerVariantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maximumSessionsPerVariantMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('winner_protocol_id')) {
      context.handle(
        _winnerProtocolIdMeta,
        winnerProtocolId.isAcceptableOrUnknown(
          data['winner_protocol_id']!,
          _winnerProtocolIdMeta,
        ),
      );
    }
    if (data.containsKey('invalid_reason')) {
      context.handle(
        _invalidReasonMeta,
        invalidReason.isAcceptableOrUnknown(
          data['invalid_reason']!,
          _invalidReasonMeta,
        ),
      );
    }
    if (data.containsKey('started_at_ms')) {
      context.handle(
        _startedAtMsMeta,
        startedAtMs.isAcceptableOrUnknown(
          data['started_at_ms']!,
          _startedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('completed_at_ms')) {
      context.handle(
        _completedAtMsMeta,
        completedAtMs.isAcceptableOrUnknown(
          data['completed_at_ms']!,
          _completedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WakeExperimentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WakeExperimentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      alarmId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alarm_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hypothesis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hypothesis'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dimension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dimension'],
      )!,
      controlProtocolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}control_protocol_id'],
      )!,
      controlProtocolVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}control_protocol_version'],
      )!,
      controlSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}control_snapshot_json'],
      )!,
      candidateProtocolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_protocol_id'],
      )!,
      candidateProtocolVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}candidate_protocol_version'],
      )!,
      candidateSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_snapshot_json'],
      )!,
      contextKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_key'],
      )!,
      minimumSessionsPerVariant: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_sessions_per_variant'],
      )!,
      preferredSessionsPerVariant: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preferred_sessions_per_variant'],
      )!,
      maximumSessionsPerVariant: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maximum_sessions_per_variant'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      winnerProtocolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_protocol_id'],
      ),
      invalidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invalid_reason'],
      ),
      startedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_ms'],
      ),
      completedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_ms'],
      ),
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $WakeExperimentsTable createAlias(String alias) {
    return $WakeExperimentsTable(attachedDatabase, alias);
  }
}

class WakeExperimentRow extends DataClass
    implements Insertable<WakeExperimentRow> {
  final String id;
  final String alarmId;
  final String name;
  final String hypothesis;
  final String status;
  final String dimension;
  final String controlProtocolId;
  final int controlProtocolVersion;
  final String controlSnapshotJson;
  final String candidateProtocolId;
  final int candidateProtocolVersion;
  final String candidateSnapshotJson;
  final String contextKey;
  final int minimumSessionsPerVariant;
  final int preferredSessionsPerVariant;
  final int maximumSessionsPerVariant;
  final String result;
  final String confidence;
  final String? winnerProtocolId;
  final String? invalidReason;
  final int? startedAtMs;
  final int? completedAtMs;
  final int createdAtMs;
  final int updatedAtMs;
  const WakeExperimentRow({
    required this.id,
    required this.alarmId,
    required this.name,
    required this.hypothesis,
    required this.status,
    required this.dimension,
    required this.controlProtocolId,
    required this.controlProtocolVersion,
    required this.controlSnapshotJson,
    required this.candidateProtocolId,
    required this.candidateProtocolVersion,
    required this.candidateSnapshotJson,
    required this.contextKey,
    required this.minimumSessionsPerVariant,
    required this.preferredSessionsPerVariant,
    required this.maximumSessionsPerVariant,
    required this.result,
    required this.confidence,
    this.winnerProtocolId,
    this.invalidReason,
    this.startedAtMs,
    this.completedAtMs,
    required this.createdAtMs,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['alarm_id'] = Variable<String>(alarmId);
    map['name'] = Variable<String>(name);
    map['hypothesis'] = Variable<String>(hypothesis);
    map['status'] = Variable<String>(status);
    map['dimension'] = Variable<String>(dimension);
    map['control_protocol_id'] = Variable<String>(controlProtocolId);
    map['control_protocol_version'] = Variable<int>(controlProtocolVersion);
    map['control_snapshot_json'] = Variable<String>(controlSnapshotJson);
    map['candidate_protocol_id'] = Variable<String>(candidateProtocolId);
    map['candidate_protocol_version'] = Variable<int>(candidateProtocolVersion);
    map['candidate_snapshot_json'] = Variable<String>(candidateSnapshotJson);
    map['context_key'] = Variable<String>(contextKey);
    map['minimum_sessions_per_variant'] = Variable<int>(
      minimumSessionsPerVariant,
    );
    map['preferred_sessions_per_variant'] = Variable<int>(
      preferredSessionsPerVariant,
    );
    map['maximum_sessions_per_variant'] = Variable<int>(
      maximumSessionsPerVariant,
    );
    map['result'] = Variable<String>(result);
    map['confidence'] = Variable<String>(confidence);
    if (!nullToAbsent || winnerProtocolId != null) {
      map['winner_protocol_id'] = Variable<String>(winnerProtocolId);
    }
    if (!nullToAbsent || invalidReason != null) {
      map['invalid_reason'] = Variable<String>(invalidReason);
    }
    if (!nullToAbsent || startedAtMs != null) {
      map['started_at_ms'] = Variable<int>(startedAtMs);
    }
    if (!nullToAbsent || completedAtMs != null) {
      map['completed_at_ms'] = Variable<int>(completedAtMs);
    }
    map['created_at_ms'] = Variable<int>(createdAtMs);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  WakeExperimentsCompanion toCompanion(bool nullToAbsent) {
    return WakeExperimentsCompanion(
      id: Value(id),
      alarmId: Value(alarmId),
      name: Value(name),
      hypothesis: Value(hypothesis),
      status: Value(status),
      dimension: Value(dimension),
      controlProtocolId: Value(controlProtocolId),
      controlProtocolVersion: Value(controlProtocolVersion),
      controlSnapshotJson: Value(controlSnapshotJson),
      candidateProtocolId: Value(candidateProtocolId),
      candidateProtocolVersion: Value(candidateProtocolVersion),
      candidateSnapshotJson: Value(candidateSnapshotJson),
      contextKey: Value(contextKey),
      minimumSessionsPerVariant: Value(minimumSessionsPerVariant),
      preferredSessionsPerVariant: Value(preferredSessionsPerVariant),
      maximumSessionsPerVariant: Value(maximumSessionsPerVariant),
      result: Value(result),
      confidence: Value(confidence),
      winnerProtocolId: winnerProtocolId == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerProtocolId),
      invalidReason: invalidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(invalidReason),
      startedAtMs: startedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAtMs),
      completedAtMs: completedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMs),
      createdAtMs: Value(createdAtMs),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory WakeExperimentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WakeExperimentRow(
      id: serializer.fromJson<String>(json['id']),
      alarmId: serializer.fromJson<String>(json['alarmId']),
      name: serializer.fromJson<String>(json['name']),
      hypothesis: serializer.fromJson<String>(json['hypothesis']),
      status: serializer.fromJson<String>(json['status']),
      dimension: serializer.fromJson<String>(json['dimension']),
      controlProtocolId: serializer.fromJson<String>(json['controlProtocolId']),
      controlProtocolVersion: serializer.fromJson<int>(
        json['controlProtocolVersion'],
      ),
      controlSnapshotJson: serializer.fromJson<String>(
        json['controlSnapshotJson'],
      ),
      candidateProtocolId: serializer.fromJson<String>(
        json['candidateProtocolId'],
      ),
      candidateProtocolVersion: serializer.fromJson<int>(
        json['candidateProtocolVersion'],
      ),
      candidateSnapshotJson: serializer.fromJson<String>(
        json['candidateSnapshotJson'],
      ),
      contextKey: serializer.fromJson<String>(json['contextKey']),
      minimumSessionsPerVariant: serializer.fromJson<int>(
        json['minimumSessionsPerVariant'],
      ),
      preferredSessionsPerVariant: serializer.fromJson<int>(
        json['preferredSessionsPerVariant'],
      ),
      maximumSessionsPerVariant: serializer.fromJson<int>(
        json['maximumSessionsPerVariant'],
      ),
      result: serializer.fromJson<String>(json['result']),
      confidence: serializer.fromJson<String>(json['confidence']),
      winnerProtocolId: serializer.fromJson<String?>(json['winnerProtocolId']),
      invalidReason: serializer.fromJson<String?>(json['invalidReason']),
      startedAtMs: serializer.fromJson<int?>(json['startedAtMs']),
      completedAtMs: serializer.fromJson<int?>(json['completedAtMs']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'alarmId': serializer.toJson<String>(alarmId),
      'name': serializer.toJson<String>(name),
      'hypothesis': serializer.toJson<String>(hypothesis),
      'status': serializer.toJson<String>(status),
      'dimension': serializer.toJson<String>(dimension),
      'controlProtocolId': serializer.toJson<String>(controlProtocolId),
      'controlProtocolVersion': serializer.toJson<int>(controlProtocolVersion),
      'controlSnapshotJson': serializer.toJson<String>(controlSnapshotJson),
      'candidateProtocolId': serializer.toJson<String>(candidateProtocolId),
      'candidateProtocolVersion': serializer.toJson<int>(
        candidateProtocolVersion,
      ),
      'candidateSnapshotJson': serializer.toJson<String>(candidateSnapshotJson),
      'contextKey': serializer.toJson<String>(contextKey),
      'minimumSessionsPerVariant': serializer.toJson<int>(
        minimumSessionsPerVariant,
      ),
      'preferredSessionsPerVariant': serializer.toJson<int>(
        preferredSessionsPerVariant,
      ),
      'maximumSessionsPerVariant': serializer.toJson<int>(
        maximumSessionsPerVariant,
      ),
      'result': serializer.toJson<String>(result),
      'confidence': serializer.toJson<String>(confidence),
      'winnerProtocolId': serializer.toJson<String?>(winnerProtocolId),
      'invalidReason': serializer.toJson<String?>(invalidReason),
      'startedAtMs': serializer.toJson<int?>(startedAtMs),
      'completedAtMs': serializer.toJson<int?>(completedAtMs),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  WakeExperimentRow copyWith({
    String? id,
    String? alarmId,
    String? name,
    String? hypothesis,
    String? status,
    String? dimension,
    String? controlProtocolId,
    int? controlProtocolVersion,
    String? controlSnapshotJson,
    String? candidateProtocolId,
    int? candidateProtocolVersion,
    String? candidateSnapshotJson,
    String? contextKey,
    int? minimumSessionsPerVariant,
    int? preferredSessionsPerVariant,
    int? maximumSessionsPerVariant,
    String? result,
    String? confidence,
    Value<String?> winnerProtocolId = const Value.absent(),
    Value<String?> invalidReason = const Value.absent(),
    Value<int?> startedAtMs = const Value.absent(),
    Value<int?> completedAtMs = const Value.absent(),
    int? createdAtMs,
    int? updatedAtMs,
  }) => WakeExperimentRow(
    id: id ?? this.id,
    alarmId: alarmId ?? this.alarmId,
    name: name ?? this.name,
    hypothesis: hypothesis ?? this.hypothesis,
    status: status ?? this.status,
    dimension: dimension ?? this.dimension,
    controlProtocolId: controlProtocolId ?? this.controlProtocolId,
    controlProtocolVersion:
        controlProtocolVersion ?? this.controlProtocolVersion,
    controlSnapshotJson: controlSnapshotJson ?? this.controlSnapshotJson,
    candidateProtocolId: candidateProtocolId ?? this.candidateProtocolId,
    candidateProtocolVersion:
        candidateProtocolVersion ?? this.candidateProtocolVersion,
    candidateSnapshotJson: candidateSnapshotJson ?? this.candidateSnapshotJson,
    contextKey: contextKey ?? this.contextKey,
    minimumSessionsPerVariant:
        minimumSessionsPerVariant ?? this.minimumSessionsPerVariant,
    preferredSessionsPerVariant:
        preferredSessionsPerVariant ?? this.preferredSessionsPerVariant,
    maximumSessionsPerVariant:
        maximumSessionsPerVariant ?? this.maximumSessionsPerVariant,
    result: result ?? this.result,
    confidence: confidence ?? this.confidence,
    winnerProtocolId: winnerProtocolId.present
        ? winnerProtocolId.value
        : this.winnerProtocolId,
    invalidReason: invalidReason.present
        ? invalidReason.value
        : this.invalidReason,
    startedAtMs: startedAtMs.present ? startedAtMs.value : this.startedAtMs,
    completedAtMs: completedAtMs.present
        ? completedAtMs.value
        : this.completedAtMs,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  WakeExperimentRow copyWithCompanion(WakeExperimentsCompanion data) {
    return WakeExperimentRow(
      id: data.id.present ? data.id.value : this.id,
      alarmId: data.alarmId.present ? data.alarmId.value : this.alarmId,
      name: data.name.present ? data.name.value : this.name,
      hypothesis: data.hypothesis.present
          ? data.hypothesis.value
          : this.hypothesis,
      status: data.status.present ? data.status.value : this.status,
      dimension: data.dimension.present ? data.dimension.value : this.dimension,
      controlProtocolId: data.controlProtocolId.present
          ? data.controlProtocolId.value
          : this.controlProtocolId,
      controlProtocolVersion: data.controlProtocolVersion.present
          ? data.controlProtocolVersion.value
          : this.controlProtocolVersion,
      controlSnapshotJson: data.controlSnapshotJson.present
          ? data.controlSnapshotJson.value
          : this.controlSnapshotJson,
      candidateProtocolId: data.candidateProtocolId.present
          ? data.candidateProtocolId.value
          : this.candidateProtocolId,
      candidateProtocolVersion: data.candidateProtocolVersion.present
          ? data.candidateProtocolVersion.value
          : this.candidateProtocolVersion,
      candidateSnapshotJson: data.candidateSnapshotJson.present
          ? data.candidateSnapshotJson.value
          : this.candidateSnapshotJson,
      contextKey: data.contextKey.present
          ? data.contextKey.value
          : this.contextKey,
      minimumSessionsPerVariant: data.minimumSessionsPerVariant.present
          ? data.minimumSessionsPerVariant.value
          : this.minimumSessionsPerVariant,
      preferredSessionsPerVariant: data.preferredSessionsPerVariant.present
          ? data.preferredSessionsPerVariant.value
          : this.preferredSessionsPerVariant,
      maximumSessionsPerVariant: data.maximumSessionsPerVariant.present
          ? data.maximumSessionsPerVariant.value
          : this.maximumSessionsPerVariant,
      result: data.result.present ? data.result.value : this.result,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      winnerProtocolId: data.winnerProtocolId.present
          ? data.winnerProtocolId.value
          : this.winnerProtocolId,
      invalidReason: data.invalidReason.present
          ? data.invalidReason.value
          : this.invalidReason,
      startedAtMs: data.startedAtMs.present
          ? data.startedAtMs.value
          : this.startedAtMs,
      completedAtMs: data.completedAtMs.present
          ? data.completedAtMs.value
          : this.completedAtMs,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WakeExperimentRow(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('name: $name, ')
          ..write('hypothesis: $hypothesis, ')
          ..write('status: $status, ')
          ..write('dimension: $dimension, ')
          ..write('controlProtocolId: $controlProtocolId, ')
          ..write('controlProtocolVersion: $controlProtocolVersion, ')
          ..write('controlSnapshotJson: $controlSnapshotJson, ')
          ..write('candidateProtocolId: $candidateProtocolId, ')
          ..write('candidateProtocolVersion: $candidateProtocolVersion, ')
          ..write('candidateSnapshotJson: $candidateSnapshotJson, ')
          ..write('contextKey: $contextKey, ')
          ..write('minimumSessionsPerVariant: $minimumSessionsPerVariant, ')
          ..write('preferredSessionsPerVariant: $preferredSessionsPerVariant, ')
          ..write('maximumSessionsPerVariant: $maximumSessionsPerVariant, ')
          ..write('result: $result, ')
          ..write('confidence: $confidence, ')
          ..write('winnerProtocolId: $winnerProtocolId, ')
          ..write('invalidReason: $invalidReason, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    alarmId,
    name,
    hypothesis,
    status,
    dimension,
    controlProtocolId,
    controlProtocolVersion,
    controlSnapshotJson,
    candidateProtocolId,
    candidateProtocolVersion,
    candidateSnapshotJson,
    contextKey,
    minimumSessionsPerVariant,
    preferredSessionsPerVariant,
    maximumSessionsPerVariant,
    result,
    confidence,
    winnerProtocolId,
    invalidReason,
    startedAtMs,
    completedAtMs,
    createdAtMs,
    updatedAtMs,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WakeExperimentRow &&
          other.id == this.id &&
          other.alarmId == this.alarmId &&
          other.name == this.name &&
          other.hypothesis == this.hypothesis &&
          other.status == this.status &&
          other.dimension == this.dimension &&
          other.controlProtocolId == this.controlProtocolId &&
          other.controlProtocolVersion == this.controlProtocolVersion &&
          other.controlSnapshotJson == this.controlSnapshotJson &&
          other.candidateProtocolId == this.candidateProtocolId &&
          other.candidateProtocolVersion == this.candidateProtocolVersion &&
          other.candidateSnapshotJson == this.candidateSnapshotJson &&
          other.contextKey == this.contextKey &&
          other.minimumSessionsPerVariant == this.minimumSessionsPerVariant &&
          other.preferredSessionsPerVariant ==
              this.preferredSessionsPerVariant &&
          other.maximumSessionsPerVariant == this.maximumSessionsPerVariant &&
          other.result == this.result &&
          other.confidence == this.confidence &&
          other.winnerProtocolId == this.winnerProtocolId &&
          other.invalidReason == this.invalidReason &&
          other.startedAtMs == this.startedAtMs &&
          other.completedAtMs == this.completedAtMs &&
          other.createdAtMs == this.createdAtMs &&
          other.updatedAtMs == this.updatedAtMs);
}

class WakeExperimentsCompanion extends UpdateCompanion<WakeExperimentRow> {
  final Value<String> id;
  final Value<String> alarmId;
  final Value<String> name;
  final Value<String> hypothesis;
  final Value<String> status;
  final Value<String> dimension;
  final Value<String> controlProtocolId;
  final Value<int> controlProtocolVersion;
  final Value<String> controlSnapshotJson;
  final Value<String> candidateProtocolId;
  final Value<int> candidateProtocolVersion;
  final Value<String> candidateSnapshotJson;
  final Value<String> contextKey;
  final Value<int> minimumSessionsPerVariant;
  final Value<int> preferredSessionsPerVariant;
  final Value<int> maximumSessionsPerVariant;
  final Value<String> result;
  final Value<String> confidence;
  final Value<String?> winnerProtocolId;
  final Value<String?> invalidReason;
  final Value<int?> startedAtMs;
  final Value<int?> completedAtMs;
  final Value<int> createdAtMs;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const WakeExperimentsCompanion({
    this.id = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.name = const Value.absent(),
    this.hypothesis = const Value.absent(),
    this.status = const Value.absent(),
    this.dimension = const Value.absent(),
    this.controlProtocolId = const Value.absent(),
    this.controlProtocolVersion = const Value.absent(),
    this.controlSnapshotJson = const Value.absent(),
    this.candidateProtocolId = const Value.absent(),
    this.candidateProtocolVersion = const Value.absent(),
    this.candidateSnapshotJson = const Value.absent(),
    this.contextKey = const Value.absent(),
    this.minimumSessionsPerVariant = const Value.absent(),
    this.preferredSessionsPerVariant = const Value.absent(),
    this.maximumSessionsPerVariant = const Value.absent(),
    this.result = const Value.absent(),
    this.confidence = const Value.absent(),
    this.winnerProtocolId = const Value.absent(),
    this.invalidReason = const Value.absent(),
    this.startedAtMs = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WakeExperimentsCompanion.insert({
    required String id,
    required String alarmId,
    required String name,
    required String hypothesis,
    required String status,
    required String dimension,
    required String controlProtocolId,
    required int controlProtocolVersion,
    required String controlSnapshotJson,
    required String candidateProtocolId,
    required int candidateProtocolVersion,
    required String candidateSnapshotJson,
    required String contextKey,
    required int minimumSessionsPerVariant,
    required int preferredSessionsPerVariant,
    required int maximumSessionsPerVariant,
    this.result = const Value.absent(),
    this.confidence = const Value.absent(),
    this.winnerProtocolId = const Value.absent(),
    this.invalidReason = const Value.absent(),
    this.startedAtMs = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    required int createdAtMs,
    required int updatedAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       alarmId = Value(alarmId),
       name = Value(name),
       hypothesis = Value(hypothesis),
       status = Value(status),
       dimension = Value(dimension),
       controlProtocolId = Value(controlProtocolId),
       controlProtocolVersion = Value(controlProtocolVersion),
       controlSnapshotJson = Value(controlSnapshotJson),
       candidateProtocolId = Value(candidateProtocolId),
       candidateProtocolVersion = Value(candidateProtocolVersion),
       candidateSnapshotJson = Value(candidateSnapshotJson),
       contextKey = Value(contextKey),
       minimumSessionsPerVariant = Value(minimumSessionsPerVariant),
       preferredSessionsPerVariant = Value(preferredSessionsPerVariant),
       maximumSessionsPerVariant = Value(maximumSessionsPerVariant),
       createdAtMs = Value(createdAtMs),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<WakeExperimentRow> custom({
    Expression<String>? id,
    Expression<String>? alarmId,
    Expression<String>? name,
    Expression<String>? hypothesis,
    Expression<String>? status,
    Expression<String>? dimension,
    Expression<String>? controlProtocolId,
    Expression<int>? controlProtocolVersion,
    Expression<String>? controlSnapshotJson,
    Expression<String>? candidateProtocolId,
    Expression<int>? candidateProtocolVersion,
    Expression<String>? candidateSnapshotJson,
    Expression<String>? contextKey,
    Expression<int>? minimumSessionsPerVariant,
    Expression<int>? preferredSessionsPerVariant,
    Expression<int>? maximumSessionsPerVariant,
    Expression<String>? result,
    Expression<String>? confidence,
    Expression<String>? winnerProtocolId,
    Expression<String>? invalidReason,
    Expression<int>? startedAtMs,
    Expression<int>? completedAtMs,
    Expression<int>? createdAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alarmId != null) 'alarm_id': alarmId,
      if (name != null) 'name': name,
      if (hypothesis != null) 'hypothesis': hypothesis,
      if (status != null) 'status': status,
      if (dimension != null) 'dimension': dimension,
      if (controlProtocolId != null) 'control_protocol_id': controlProtocolId,
      if (controlProtocolVersion != null)
        'control_protocol_version': controlProtocolVersion,
      if (controlSnapshotJson != null)
        'control_snapshot_json': controlSnapshotJson,
      if (candidateProtocolId != null)
        'candidate_protocol_id': candidateProtocolId,
      if (candidateProtocolVersion != null)
        'candidate_protocol_version': candidateProtocolVersion,
      if (candidateSnapshotJson != null)
        'candidate_snapshot_json': candidateSnapshotJson,
      if (contextKey != null) 'context_key': contextKey,
      if (minimumSessionsPerVariant != null)
        'minimum_sessions_per_variant': minimumSessionsPerVariant,
      if (preferredSessionsPerVariant != null)
        'preferred_sessions_per_variant': preferredSessionsPerVariant,
      if (maximumSessionsPerVariant != null)
        'maximum_sessions_per_variant': maximumSessionsPerVariant,
      if (result != null) 'result': result,
      if (confidence != null) 'confidence': confidence,
      if (winnerProtocolId != null) 'winner_protocol_id': winnerProtocolId,
      if (invalidReason != null) 'invalid_reason': invalidReason,
      if (startedAtMs != null) 'started_at_ms': startedAtMs,
      if (completedAtMs != null) 'completed_at_ms': completedAtMs,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WakeExperimentsCompanion copyWith({
    Value<String>? id,
    Value<String>? alarmId,
    Value<String>? name,
    Value<String>? hypothesis,
    Value<String>? status,
    Value<String>? dimension,
    Value<String>? controlProtocolId,
    Value<int>? controlProtocolVersion,
    Value<String>? controlSnapshotJson,
    Value<String>? candidateProtocolId,
    Value<int>? candidateProtocolVersion,
    Value<String>? candidateSnapshotJson,
    Value<String>? contextKey,
    Value<int>? minimumSessionsPerVariant,
    Value<int>? preferredSessionsPerVariant,
    Value<int>? maximumSessionsPerVariant,
    Value<String>? result,
    Value<String>? confidence,
    Value<String?>? winnerProtocolId,
    Value<String?>? invalidReason,
    Value<int?>? startedAtMs,
    Value<int?>? completedAtMs,
    Value<int>? createdAtMs,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return WakeExperimentsCompanion(
      id: id ?? this.id,
      alarmId: alarmId ?? this.alarmId,
      name: name ?? this.name,
      hypothesis: hypothesis ?? this.hypothesis,
      status: status ?? this.status,
      dimension: dimension ?? this.dimension,
      controlProtocolId: controlProtocolId ?? this.controlProtocolId,
      controlProtocolVersion:
          controlProtocolVersion ?? this.controlProtocolVersion,
      controlSnapshotJson: controlSnapshotJson ?? this.controlSnapshotJson,
      candidateProtocolId: candidateProtocolId ?? this.candidateProtocolId,
      candidateProtocolVersion:
          candidateProtocolVersion ?? this.candidateProtocolVersion,
      candidateSnapshotJson:
          candidateSnapshotJson ?? this.candidateSnapshotJson,
      contextKey: contextKey ?? this.contextKey,
      minimumSessionsPerVariant:
          minimumSessionsPerVariant ?? this.minimumSessionsPerVariant,
      preferredSessionsPerVariant:
          preferredSessionsPerVariant ?? this.preferredSessionsPerVariant,
      maximumSessionsPerVariant:
          maximumSessionsPerVariant ?? this.maximumSessionsPerVariant,
      result: result ?? this.result,
      confidence: confidence ?? this.confidence,
      winnerProtocolId: winnerProtocolId ?? this.winnerProtocolId,
      invalidReason: invalidReason ?? this.invalidReason,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      completedAtMs: completedAtMs ?? this.completedAtMs,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<String>(alarmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hypothesis.present) {
      map['hypothesis'] = Variable<String>(hypothesis.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dimension.present) {
      map['dimension'] = Variable<String>(dimension.value);
    }
    if (controlProtocolId.present) {
      map['control_protocol_id'] = Variable<String>(controlProtocolId.value);
    }
    if (controlProtocolVersion.present) {
      map['control_protocol_version'] = Variable<int>(
        controlProtocolVersion.value,
      );
    }
    if (controlSnapshotJson.present) {
      map['control_snapshot_json'] = Variable<String>(
        controlSnapshotJson.value,
      );
    }
    if (candidateProtocolId.present) {
      map['candidate_protocol_id'] = Variable<String>(
        candidateProtocolId.value,
      );
    }
    if (candidateProtocolVersion.present) {
      map['candidate_protocol_version'] = Variable<int>(
        candidateProtocolVersion.value,
      );
    }
    if (candidateSnapshotJson.present) {
      map['candidate_snapshot_json'] = Variable<String>(
        candidateSnapshotJson.value,
      );
    }
    if (contextKey.present) {
      map['context_key'] = Variable<String>(contextKey.value);
    }
    if (minimumSessionsPerVariant.present) {
      map['minimum_sessions_per_variant'] = Variable<int>(
        minimumSessionsPerVariant.value,
      );
    }
    if (preferredSessionsPerVariant.present) {
      map['preferred_sessions_per_variant'] = Variable<int>(
        preferredSessionsPerVariant.value,
      );
    }
    if (maximumSessionsPerVariant.present) {
      map['maximum_sessions_per_variant'] = Variable<int>(
        maximumSessionsPerVariant.value,
      );
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (winnerProtocolId.present) {
      map['winner_protocol_id'] = Variable<String>(winnerProtocolId.value);
    }
    if (invalidReason.present) {
      map['invalid_reason'] = Variable<String>(invalidReason.value);
    }
    if (startedAtMs.present) {
      map['started_at_ms'] = Variable<int>(startedAtMs.value);
    }
    if (completedAtMs.present) {
      map['completed_at_ms'] = Variable<int>(completedAtMs.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WakeExperimentsCompanion(')
          ..write('id: $id, ')
          ..write('alarmId: $alarmId, ')
          ..write('name: $name, ')
          ..write('hypothesis: $hypothesis, ')
          ..write('status: $status, ')
          ..write('dimension: $dimension, ')
          ..write('controlProtocolId: $controlProtocolId, ')
          ..write('controlProtocolVersion: $controlProtocolVersion, ')
          ..write('controlSnapshotJson: $controlSnapshotJson, ')
          ..write('candidateProtocolId: $candidateProtocolId, ')
          ..write('candidateProtocolVersion: $candidateProtocolVersion, ')
          ..write('candidateSnapshotJson: $candidateSnapshotJson, ')
          ..write('contextKey: $contextKey, ')
          ..write('minimumSessionsPerVariant: $minimumSessionsPerVariant, ')
          ..write('preferredSessionsPerVariant: $preferredSessionsPerVariant, ')
          ..write('maximumSessionsPerVariant: $maximumSessionsPerVariant, ')
          ..write('result: $result, ')
          ..write('confidence: $confidence, ')
          ..write('winnerProtocolId: $winnerProtocolId, ')
          ..write('invalidReason: $invalidReason, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExperimentSessionsTable extends ExperimentSessions
    with TableInfo<$ExperimentSessionsTable, ExperimentSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExperimentSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experimentIdMeta = const VerificationMeta(
    'experimentId',
  );
  @override
  late final GeneratedColumn<String> experimentId = GeneratedColumn<String>(
    'experiment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wake_experiments (id)',
    ),
  );
  static const VerificationMeta _alarmIdMeta = const VerificationMeta(
    'alarmId',
  );
  @override
  late final GeneratedColumn<String> alarmId = GeneratedColumn<String>(
    'alarm_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTimeMsMeta = const VerificationMeta(
    'scheduledTimeMs',
  );
  @override
  late final GeneratedColumn<int> scheduledTimeMs = GeneratedColumn<int>(
    'scheduled_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignmentIndexMeta = const VerificationMeta(
    'assignmentIndex',
  );
  @override
  late final GeneratedColumn<int> assignmentIndex = GeneratedColumn<int>(
    'assignment_index',
    aliasedName,
    false,
    check: () => const CustomExpression('assignment_index >= 0'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    false,
    check: () => const CustomExpression("variant IN ('control','candidate')"),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolIdMeta = const VerificationMeta(
    'protocolId',
  );
  @override
  late final GeneratedColumn<String> protocolId = GeneratedColumn<String>(
    'protocol_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolVersionMeta = const VerificationMeta(
    'protocolVersion',
  );
  @override
  late final GeneratedColumn<int> protocolVersion = GeneratedColumn<int>(
    'protocol_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextKeyMeta = const VerificationMeta(
    'contextKey',
  );
  @override
  late final GeneratedColumn<String> contextKey = GeneratedColumn<String>(
    'context_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedAtMsMeta = const VerificationMeta(
    'assignedAtMs',
  );
  @override
  late final GeneratedColumn<int> assignedAtMs = GeneratedColumn<int>(
    'assigned_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeSessionIdMeta = const VerificationMeta(
    'wakeSessionId',
  );
  @override
  late final GeneratedColumn<String> wakeSessionId = GeneratedColumn<String>(
    'wake_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMsMeta = const VerificationMeta(
    'completedAtMs',
  );
  @override
  late final GeneratedColumn<int> completedAtMs = GeneratedColumn<int>(
    'completed_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validityMeta = const VerificationMeta(
    'validity',
  );
  @override
  late final GeneratedColumn<String> validity = GeneratedColumn<String>(
    'validity',
    aliasedName,
    false,
    check: () =>
        const CustomExpression("validity IN ('valid','partial','invalid')"),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('partial'),
  );
  static const VerificationMeta _invalidReasonMeta = const VerificationMeta(
    'invalidReason',
  );
  @override
  late final GeneratedColumn<String> invalidReason = GeneratedColumn<String>(
    'invalid_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    experimentId,
    alarmId,
    scheduledTimeMs,
    assignmentIndex,
    variant,
    protocolId,
    protocolVersion,
    contextKey,
    assignedAtMs,
    wakeSessionId,
    completedAtMs,
    validity,
    invalidReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'experiment_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExperimentSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('experiment_id')) {
      context.handle(
        _experimentIdMeta,
        experimentId.isAcceptableOrUnknown(
          data['experiment_id']!,
          _experimentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_experimentIdMeta);
    }
    if (data.containsKey('alarm_id')) {
      context.handle(
        _alarmIdMeta,
        alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alarmIdMeta);
    }
    if (data.containsKey('scheduled_time_ms')) {
      context.handle(
        _scheduledTimeMsMeta,
        scheduledTimeMs.isAcceptableOrUnknown(
          data['scheduled_time_ms']!,
          _scheduledTimeMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTimeMsMeta);
    }
    if (data.containsKey('assignment_index')) {
      context.handle(
        _assignmentIndexMeta,
        assignmentIndex.isAcceptableOrUnknown(
          data['assignment_index']!,
          _assignmentIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignmentIndexMeta);
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    } else if (isInserting) {
      context.missing(_variantMeta);
    }
    if (data.containsKey('protocol_id')) {
      context.handle(
        _protocolIdMeta,
        protocolId.isAcceptableOrUnknown(data['protocol_id']!, _protocolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_protocolIdMeta);
    }
    if (data.containsKey('protocol_version')) {
      context.handle(
        _protocolVersionMeta,
        protocolVersion.isAcceptableOrUnknown(
          data['protocol_version']!,
          _protocolVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolVersionMeta);
    }
    if (data.containsKey('context_key')) {
      context.handle(
        _contextKeyMeta,
        contextKey.isAcceptableOrUnknown(data['context_key']!, _contextKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_contextKeyMeta);
    }
    if (data.containsKey('assigned_at_ms')) {
      context.handle(
        _assignedAtMsMeta,
        assignedAtMs.isAcceptableOrUnknown(
          data['assigned_at_ms']!,
          _assignedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignedAtMsMeta);
    }
    if (data.containsKey('wake_session_id')) {
      context.handle(
        _wakeSessionIdMeta,
        wakeSessionId.isAcceptableOrUnknown(
          data['wake_session_id']!,
          _wakeSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('completed_at_ms')) {
      context.handle(
        _completedAtMsMeta,
        completedAtMs.isAcceptableOrUnknown(
          data['completed_at_ms']!,
          _completedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('validity')) {
      context.handle(
        _validityMeta,
        validity.isAcceptableOrUnknown(data['validity']!, _validityMeta),
      );
    }
    if (data.containsKey('invalid_reason')) {
      context.handle(
        _invalidReasonMeta,
        invalidReason.isAcceptableOrUnknown(
          data['invalid_reason']!,
          _invalidReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExperimentSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExperimentSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      experimentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experiment_id'],
      )!,
      alarmId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alarm_id'],
      )!,
      scheduledTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_time_ms'],
      )!,
      assignmentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assignment_index'],
      )!,
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      )!,
      protocolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_id'],
      )!,
      protocolVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protocol_version'],
      )!,
      contextKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_key'],
      )!,
      assignedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_at_ms'],
      )!,
      wakeSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_session_id'],
      ),
      completedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_ms'],
      ),
      validity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}validity'],
      )!,
      invalidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invalid_reason'],
      ),
    );
  }

  @override
  $ExperimentSessionsTable createAlias(String alias) {
    return $ExperimentSessionsTable(attachedDatabase, alias);
  }
}

class ExperimentSessionRow extends DataClass
    implements Insertable<ExperimentSessionRow> {
  final String id;
  final String experimentId;
  final String alarmId;
  final int scheduledTimeMs;
  final int assignmentIndex;
  final String variant;
  final String protocolId;
  final int protocolVersion;
  final String contextKey;
  final int assignedAtMs;
  final String? wakeSessionId;
  final int? completedAtMs;
  final String validity;
  final String? invalidReason;
  const ExperimentSessionRow({
    required this.id,
    required this.experimentId,
    required this.alarmId,
    required this.scheduledTimeMs,
    required this.assignmentIndex,
    required this.variant,
    required this.protocolId,
    required this.protocolVersion,
    required this.contextKey,
    required this.assignedAtMs,
    this.wakeSessionId,
    this.completedAtMs,
    required this.validity,
    this.invalidReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['experiment_id'] = Variable<String>(experimentId);
    map['alarm_id'] = Variable<String>(alarmId);
    map['scheduled_time_ms'] = Variable<int>(scheduledTimeMs);
    map['assignment_index'] = Variable<int>(assignmentIndex);
    map['variant'] = Variable<String>(variant);
    map['protocol_id'] = Variable<String>(protocolId);
    map['protocol_version'] = Variable<int>(protocolVersion);
    map['context_key'] = Variable<String>(contextKey);
    map['assigned_at_ms'] = Variable<int>(assignedAtMs);
    if (!nullToAbsent || wakeSessionId != null) {
      map['wake_session_id'] = Variable<String>(wakeSessionId);
    }
    if (!nullToAbsent || completedAtMs != null) {
      map['completed_at_ms'] = Variable<int>(completedAtMs);
    }
    map['validity'] = Variable<String>(validity);
    if (!nullToAbsent || invalidReason != null) {
      map['invalid_reason'] = Variable<String>(invalidReason);
    }
    return map;
  }

  ExperimentSessionsCompanion toCompanion(bool nullToAbsent) {
    return ExperimentSessionsCompanion(
      id: Value(id),
      experimentId: Value(experimentId),
      alarmId: Value(alarmId),
      scheduledTimeMs: Value(scheduledTimeMs),
      assignmentIndex: Value(assignmentIndex),
      variant: Value(variant),
      protocolId: Value(protocolId),
      protocolVersion: Value(protocolVersion),
      contextKey: Value(contextKey),
      assignedAtMs: Value(assignedAtMs),
      wakeSessionId: wakeSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(wakeSessionId),
      completedAtMs: completedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMs),
      validity: Value(validity),
      invalidReason: invalidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(invalidReason),
    );
  }

  factory ExperimentSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExperimentSessionRow(
      id: serializer.fromJson<String>(json['id']),
      experimentId: serializer.fromJson<String>(json['experimentId']),
      alarmId: serializer.fromJson<String>(json['alarmId']),
      scheduledTimeMs: serializer.fromJson<int>(json['scheduledTimeMs']),
      assignmentIndex: serializer.fromJson<int>(json['assignmentIndex']),
      variant: serializer.fromJson<String>(json['variant']),
      protocolId: serializer.fromJson<String>(json['protocolId']),
      protocolVersion: serializer.fromJson<int>(json['protocolVersion']),
      contextKey: serializer.fromJson<String>(json['contextKey']),
      assignedAtMs: serializer.fromJson<int>(json['assignedAtMs']),
      wakeSessionId: serializer.fromJson<String?>(json['wakeSessionId']),
      completedAtMs: serializer.fromJson<int?>(json['completedAtMs']),
      validity: serializer.fromJson<String>(json['validity']),
      invalidReason: serializer.fromJson<String?>(json['invalidReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'experimentId': serializer.toJson<String>(experimentId),
      'alarmId': serializer.toJson<String>(alarmId),
      'scheduledTimeMs': serializer.toJson<int>(scheduledTimeMs),
      'assignmentIndex': serializer.toJson<int>(assignmentIndex),
      'variant': serializer.toJson<String>(variant),
      'protocolId': serializer.toJson<String>(protocolId),
      'protocolVersion': serializer.toJson<int>(protocolVersion),
      'contextKey': serializer.toJson<String>(contextKey),
      'assignedAtMs': serializer.toJson<int>(assignedAtMs),
      'wakeSessionId': serializer.toJson<String?>(wakeSessionId),
      'completedAtMs': serializer.toJson<int?>(completedAtMs),
      'validity': serializer.toJson<String>(validity),
      'invalidReason': serializer.toJson<String?>(invalidReason),
    };
  }

  ExperimentSessionRow copyWith({
    String? id,
    String? experimentId,
    String? alarmId,
    int? scheduledTimeMs,
    int? assignmentIndex,
    String? variant,
    String? protocolId,
    int? protocolVersion,
    String? contextKey,
    int? assignedAtMs,
    Value<String?> wakeSessionId = const Value.absent(),
    Value<int?> completedAtMs = const Value.absent(),
    String? validity,
    Value<String?> invalidReason = const Value.absent(),
  }) => ExperimentSessionRow(
    id: id ?? this.id,
    experimentId: experimentId ?? this.experimentId,
    alarmId: alarmId ?? this.alarmId,
    scheduledTimeMs: scheduledTimeMs ?? this.scheduledTimeMs,
    assignmentIndex: assignmentIndex ?? this.assignmentIndex,
    variant: variant ?? this.variant,
    protocolId: protocolId ?? this.protocolId,
    protocolVersion: protocolVersion ?? this.protocolVersion,
    contextKey: contextKey ?? this.contextKey,
    assignedAtMs: assignedAtMs ?? this.assignedAtMs,
    wakeSessionId: wakeSessionId.present
        ? wakeSessionId.value
        : this.wakeSessionId,
    completedAtMs: completedAtMs.present
        ? completedAtMs.value
        : this.completedAtMs,
    validity: validity ?? this.validity,
    invalidReason: invalidReason.present
        ? invalidReason.value
        : this.invalidReason,
  );
  ExperimentSessionRow copyWithCompanion(ExperimentSessionsCompanion data) {
    return ExperimentSessionRow(
      id: data.id.present ? data.id.value : this.id,
      experimentId: data.experimentId.present
          ? data.experimentId.value
          : this.experimentId,
      alarmId: data.alarmId.present ? data.alarmId.value : this.alarmId,
      scheduledTimeMs: data.scheduledTimeMs.present
          ? data.scheduledTimeMs.value
          : this.scheduledTimeMs,
      assignmentIndex: data.assignmentIndex.present
          ? data.assignmentIndex.value
          : this.assignmentIndex,
      variant: data.variant.present ? data.variant.value : this.variant,
      protocolId: data.protocolId.present
          ? data.protocolId.value
          : this.protocolId,
      protocolVersion: data.protocolVersion.present
          ? data.protocolVersion.value
          : this.protocolVersion,
      contextKey: data.contextKey.present
          ? data.contextKey.value
          : this.contextKey,
      assignedAtMs: data.assignedAtMs.present
          ? data.assignedAtMs.value
          : this.assignedAtMs,
      wakeSessionId: data.wakeSessionId.present
          ? data.wakeSessionId.value
          : this.wakeSessionId,
      completedAtMs: data.completedAtMs.present
          ? data.completedAtMs.value
          : this.completedAtMs,
      validity: data.validity.present ? data.validity.value : this.validity,
      invalidReason: data.invalidReason.present
          ? data.invalidReason.value
          : this.invalidReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExperimentSessionRow(')
          ..write('id: $id, ')
          ..write('experimentId: $experimentId, ')
          ..write('alarmId: $alarmId, ')
          ..write('scheduledTimeMs: $scheduledTimeMs, ')
          ..write('assignmentIndex: $assignmentIndex, ')
          ..write('variant: $variant, ')
          ..write('protocolId: $protocolId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('contextKey: $contextKey, ')
          ..write('assignedAtMs: $assignedAtMs, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('validity: $validity, ')
          ..write('invalidReason: $invalidReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    experimentId,
    alarmId,
    scheduledTimeMs,
    assignmentIndex,
    variant,
    protocolId,
    protocolVersion,
    contextKey,
    assignedAtMs,
    wakeSessionId,
    completedAtMs,
    validity,
    invalidReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExperimentSessionRow &&
          other.id == this.id &&
          other.experimentId == this.experimentId &&
          other.alarmId == this.alarmId &&
          other.scheduledTimeMs == this.scheduledTimeMs &&
          other.assignmentIndex == this.assignmentIndex &&
          other.variant == this.variant &&
          other.protocolId == this.protocolId &&
          other.protocolVersion == this.protocolVersion &&
          other.contextKey == this.contextKey &&
          other.assignedAtMs == this.assignedAtMs &&
          other.wakeSessionId == this.wakeSessionId &&
          other.completedAtMs == this.completedAtMs &&
          other.validity == this.validity &&
          other.invalidReason == this.invalidReason);
}

class ExperimentSessionsCompanion
    extends UpdateCompanion<ExperimentSessionRow> {
  final Value<String> id;
  final Value<String> experimentId;
  final Value<String> alarmId;
  final Value<int> scheduledTimeMs;
  final Value<int> assignmentIndex;
  final Value<String> variant;
  final Value<String> protocolId;
  final Value<int> protocolVersion;
  final Value<String> contextKey;
  final Value<int> assignedAtMs;
  final Value<String?> wakeSessionId;
  final Value<int?> completedAtMs;
  final Value<String> validity;
  final Value<String?> invalidReason;
  final Value<int> rowid;
  const ExperimentSessionsCompanion({
    this.id = const Value.absent(),
    this.experimentId = const Value.absent(),
    this.alarmId = const Value.absent(),
    this.scheduledTimeMs = const Value.absent(),
    this.assignmentIndex = const Value.absent(),
    this.variant = const Value.absent(),
    this.protocolId = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.contextKey = const Value.absent(),
    this.assignedAtMs = const Value.absent(),
    this.wakeSessionId = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    this.validity = const Value.absent(),
    this.invalidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExperimentSessionsCompanion.insert({
    required String id,
    required String experimentId,
    required String alarmId,
    required int scheduledTimeMs,
    required int assignmentIndex,
    required String variant,
    required String protocolId,
    required int protocolVersion,
    required String contextKey,
    required int assignedAtMs,
    this.wakeSessionId = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    this.validity = const Value.absent(),
    this.invalidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       experimentId = Value(experimentId),
       alarmId = Value(alarmId),
       scheduledTimeMs = Value(scheduledTimeMs),
       assignmentIndex = Value(assignmentIndex),
       variant = Value(variant),
       protocolId = Value(protocolId),
       protocolVersion = Value(protocolVersion),
       contextKey = Value(contextKey),
       assignedAtMs = Value(assignedAtMs);
  static Insertable<ExperimentSessionRow> custom({
    Expression<String>? id,
    Expression<String>? experimentId,
    Expression<String>? alarmId,
    Expression<int>? scheduledTimeMs,
    Expression<int>? assignmentIndex,
    Expression<String>? variant,
    Expression<String>? protocolId,
    Expression<int>? protocolVersion,
    Expression<String>? contextKey,
    Expression<int>? assignedAtMs,
    Expression<String>? wakeSessionId,
    Expression<int>? completedAtMs,
    Expression<String>? validity,
    Expression<String>? invalidReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (experimentId != null) 'experiment_id': experimentId,
      if (alarmId != null) 'alarm_id': alarmId,
      if (scheduledTimeMs != null) 'scheduled_time_ms': scheduledTimeMs,
      if (assignmentIndex != null) 'assignment_index': assignmentIndex,
      if (variant != null) 'variant': variant,
      if (protocolId != null) 'protocol_id': protocolId,
      if (protocolVersion != null) 'protocol_version': protocolVersion,
      if (contextKey != null) 'context_key': contextKey,
      if (assignedAtMs != null) 'assigned_at_ms': assignedAtMs,
      if (wakeSessionId != null) 'wake_session_id': wakeSessionId,
      if (completedAtMs != null) 'completed_at_ms': completedAtMs,
      if (validity != null) 'validity': validity,
      if (invalidReason != null) 'invalid_reason': invalidReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExperimentSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? experimentId,
    Value<String>? alarmId,
    Value<int>? scheduledTimeMs,
    Value<int>? assignmentIndex,
    Value<String>? variant,
    Value<String>? protocolId,
    Value<int>? protocolVersion,
    Value<String>? contextKey,
    Value<int>? assignedAtMs,
    Value<String?>? wakeSessionId,
    Value<int?>? completedAtMs,
    Value<String>? validity,
    Value<String?>? invalidReason,
    Value<int>? rowid,
  }) {
    return ExperimentSessionsCompanion(
      id: id ?? this.id,
      experimentId: experimentId ?? this.experimentId,
      alarmId: alarmId ?? this.alarmId,
      scheduledTimeMs: scheduledTimeMs ?? this.scheduledTimeMs,
      assignmentIndex: assignmentIndex ?? this.assignmentIndex,
      variant: variant ?? this.variant,
      protocolId: protocolId ?? this.protocolId,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      contextKey: contextKey ?? this.contextKey,
      assignedAtMs: assignedAtMs ?? this.assignedAtMs,
      wakeSessionId: wakeSessionId ?? this.wakeSessionId,
      completedAtMs: completedAtMs ?? this.completedAtMs,
      validity: validity ?? this.validity,
      invalidReason: invalidReason ?? this.invalidReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (experimentId.present) {
      map['experiment_id'] = Variable<String>(experimentId.value);
    }
    if (alarmId.present) {
      map['alarm_id'] = Variable<String>(alarmId.value);
    }
    if (scheduledTimeMs.present) {
      map['scheduled_time_ms'] = Variable<int>(scheduledTimeMs.value);
    }
    if (assignmentIndex.present) {
      map['assignment_index'] = Variable<int>(assignmentIndex.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (protocolId.present) {
      map['protocol_id'] = Variable<String>(protocolId.value);
    }
    if (protocolVersion.present) {
      map['protocol_version'] = Variable<int>(protocolVersion.value);
    }
    if (contextKey.present) {
      map['context_key'] = Variable<String>(contextKey.value);
    }
    if (assignedAtMs.present) {
      map['assigned_at_ms'] = Variable<int>(assignedAtMs.value);
    }
    if (wakeSessionId.present) {
      map['wake_session_id'] = Variable<String>(wakeSessionId.value);
    }
    if (completedAtMs.present) {
      map['completed_at_ms'] = Variable<int>(completedAtMs.value);
    }
    if (validity.present) {
      map['validity'] = Variable<String>(validity.value);
    }
    if (invalidReason.present) {
      map['invalid_reason'] = Variable<String>(invalidReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExperimentSessionsCompanion(')
          ..write('id: $id, ')
          ..write('experimentId: $experimentId, ')
          ..write('alarmId: $alarmId, ')
          ..write('scheduledTimeMs: $scheduledTimeMs, ')
          ..write('assignmentIndex: $assignmentIndex, ')
          ..write('variant: $variant, ')
          ..write('protocolId: $protocolId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('contextKey: $contextKey, ')
          ..write('assignedAtMs: $assignedAtMs, ')
          ..write('wakeSessionId: $wakeSessionId, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('validity: $validity, ')
          ..write('invalidReason: $invalidReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExperimentAuditEventsTable extends ExperimentAuditEvents
    with TableInfo<$ExperimentAuditEventsTable, ExperimentAuditEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExperimentAuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experimentIdMeta = const VerificationMeta(
    'experimentId',
  );
  @override
  late final GeneratedColumn<String> experimentId = GeneratedColumn<String>(
    'experiment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wake_experiments (id)',
    ),
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMsMeta = const VerificationMeta(
    'occurredAtMs',
  );
  @override
  late final GeneratedColumn<int> occurredAtMs = GeneratedColumn<int>(
    'occurred_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _policyVersionMeta = const VerificationMeta(
    'policyVersion',
  );
  @override
  late final GeneratedColumn<int> policyVersion = GeneratedColumn<int>(
    'policy_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    experimentId,
    sequence,
    eventType,
    occurredAtMs,
    detailsJson,
    policyVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'experiment_audit_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExperimentAuditEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('experiment_id')) {
      context.handle(
        _experimentIdMeta,
        experimentId.isAcceptableOrUnknown(
          data['experiment_id']!,
          _experimentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_experimentIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('occurred_at_ms')) {
      context.handle(
        _occurredAtMsMeta,
        occurredAtMs.isAcceptableOrUnknown(
          data['occurred_at_ms']!,
          _occurredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMsMeta);
    }
    if (data.containsKey('details_json')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(
          data['details_json']!,
          _detailsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detailsJsonMeta);
    }
    if (data.containsKey('policy_version')) {
      context.handle(
        _policyVersionMeta,
        policyVersion.isAcceptableOrUnknown(
          data['policy_version']!,
          _policyVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExperimentAuditEventRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExperimentAuditEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      experimentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experiment_id'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      occurredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_ms'],
      )!,
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details_json'],
      )!,
      policyVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}policy_version'],
      )!,
    );
  }

  @override
  $ExperimentAuditEventsTable createAlias(String alias) {
    return $ExperimentAuditEventsTable(attachedDatabase, alias);
  }
}

class ExperimentAuditEventRow extends DataClass
    implements Insertable<ExperimentAuditEventRow> {
  final String id;
  final String experimentId;
  final int sequence;
  final String eventType;
  final int occurredAtMs;
  final String detailsJson;
  final int policyVersion;
  const ExperimentAuditEventRow({
    required this.id,
    required this.experimentId,
    required this.sequence,
    required this.eventType,
    required this.occurredAtMs,
    required this.detailsJson,
    required this.policyVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['experiment_id'] = Variable<String>(experimentId);
    map['sequence'] = Variable<int>(sequence);
    map['event_type'] = Variable<String>(eventType);
    map['occurred_at_ms'] = Variable<int>(occurredAtMs);
    map['details_json'] = Variable<String>(detailsJson);
    map['policy_version'] = Variable<int>(policyVersion);
    return map;
  }

  ExperimentAuditEventsCompanion toCompanion(bool nullToAbsent) {
    return ExperimentAuditEventsCompanion(
      id: Value(id),
      experimentId: Value(experimentId),
      sequence: Value(sequence),
      eventType: Value(eventType),
      occurredAtMs: Value(occurredAtMs),
      detailsJson: Value(detailsJson),
      policyVersion: Value(policyVersion),
    );
  }

  factory ExperimentAuditEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExperimentAuditEventRow(
      id: serializer.fromJson<String>(json['id']),
      experimentId: serializer.fromJson<String>(json['experimentId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      eventType: serializer.fromJson<String>(json['eventType']),
      occurredAtMs: serializer.fromJson<int>(json['occurredAtMs']),
      detailsJson: serializer.fromJson<String>(json['detailsJson']),
      policyVersion: serializer.fromJson<int>(json['policyVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'experimentId': serializer.toJson<String>(experimentId),
      'sequence': serializer.toJson<int>(sequence),
      'eventType': serializer.toJson<String>(eventType),
      'occurredAtMs': serializer.toJson<int>(occurredAtMs),
      'detailsJson': serializer.toJson<String>(detailsJson),
      'policyVersion': serializer.toJson<int>(policyVersion),
    };
  }

  ExperimentAuditEventRow copyWith({
    String? id,
    String? experimentId,
    int? sequence,
    String? eventType,
    int? occurredAtMs,
    String? detailsJson,
    int? policyVersion,
  }) => ExperimentAuditEventRow(
    id: id ?? this.id,
    experimentId: experimentId ?? this.experimentId,
    sequence: sequence ?? this.sequence,
    eventType: eventType ?? this.eventType,
    occurredAtMs: occurredAtMs ?? this.occurredAtMs,
    detailsJson: detailsJson ?? this.detailsJson,
    policyVersion: policyVersion ?? this.policyVersion,
  );
  ExperimentAuditEventRow copyWithCompanion(
    ExperimentAuditEventsCompanion data,
  ) {
    return ExperimentAuditEventRow(
      id: data.id.present ? data.id.value : this.id,
      experimentId: data.experimentId.present
          ? data.experimentId.value
          : this.experimentId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      occurredAtMs: data.occurredAtMs.present
          ? data.occurredAtMs.value
          : this.occurredAtMs,
      detailsJson: data.detailsJson.present
          ? data.detailsJson.value
          : this.detailsJson,
      policyVersion: data.policyVersion.present
          ? data.policyVersion.value
          : this.policyVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExperimentAuditEventRow(')
          ..write('id: $id, ')
          ..write('experimentId: $experimentId, ')
          ..write('sequence: $sequence, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAtMs: $occurredAtMs, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('policyVersion: $policyVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    experimentId,
    sequence,
    eventType,
    occurredAtMs,
    detailsJson,
    policyVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExperimentAuditEventRow &&
          other.id == this.id &&
          other.experimentId == this.experimentId &&
          other.sequence == this.sequence &&
          other.eventType == this.eventType &&
          other.occurredAtMs == this.occurredAtMs &&
          other.detailsJson == this.detailsJson &&
          other.policyVersion == this.policyVersion);
}

class ExperimentAuditEventsCompanion
    extends UpdateCompanion<ExperimentAuditEventRow> {
  final Value<String> id;
  final Value<String> experimentId;
  final Value<int> sequence;
  final Value<String> eventType;
  final Value<int> occurredAtMs;
  final Value<String> detailsJson;
  final Value<int> policyVersion;
  final Value<int> rowid;
  const ExperimentAuditEventsCompanion({
    this.id = const Value.absent(),
    this.experimentId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.eventType = const Value.absent(),
    this.occurredAtMs = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.policyVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExperimentAuditEventsCompanion.insert({
    required String id,
    required String experimentId,
    required int sequence,
    required String eventType,
    required int occurredAtMs,
    required String detailsJson,
    this.policyVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       experimentId = Value(experimentId),
       sequence = Value(sequence),
       eventType = Value(eventType),
       occurredAtMs = Value(occurredAtMs),
       detailsJson = Value(detailsJson);
  static Insertable<ExperimentAuditEventRow> custom({
    Expression<String>? id,
    Expression<String>? experimentId,
    Expression<int>? sequence,
    Expression<String>? eventType,
    Expression<int>? occurredAtMs,
    Expression<String>? detailsJson,
    Expression<int>? policyVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (experimentId != null) 'experiment_id': experimentId,
      if (sequence != null) 'sequence': sequence,
      if (eventType != null) 'event_type': eventType,
      if (occurredAtMs != null) 'occurred_at_ms': occurredAtMs,
      if (detailsJson != null) 'details_json': detailsJson,
      if (policyVersion != null) 'policy_version': policyVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExperimentAuditEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? experimentId,
    Value<int>? sequence,
    Value<String>? eventType,
    Value<int>? occurredAtMs,
    Value<String>? detailsJson,
    Value<int>? policyVersion,
    Value<int>? rowid,
  }) {
    return ExperimentAuditEventsCompanion(
      id: id ?? this.id,
      experimentId: experimentId ?? this.experimentId,
      sequence: sequence ?? this.sequence,
      eventType: eventType ?? this.eventType,
      occurredAtMs: occurredAtMs ?? this.occurredAtMs,
      detailsJson: detailsJson ?? this.detailsJson,
      policyVersion: policyVersion ?? this.policyVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (experimentId.present) {
      map['experiment_id'] = Variable<String>(experimentId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (occurredAtMs.present) {
      map['occurred_at_ms'] = Variable<int>(occurredAtMs.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (policyVersion.present) {
      map['policy_version'] = Variable<int>(policyVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExperimentAuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('experimentId: $experimentId, ')
          ..write('sequence: $sequence, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAtMs: $occurredAtMs, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('policyVersion: $policyVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AlarmsTable alarms = $AlarmsTable(this);
  late final $AlarmSoundsTable alarmSounds = $AlarmSoundsTable(this);
  late final $WakeSessionsTable wakeSessions = $WakeSessionsTable(this);
  late final $WakeEventsTable wakeEvents = $WakeEventsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $MissionsTable missions = $MissionsTable(this);
  late final $MissionExecutionsTable missionExecutions =
      $MissionExecutionsTable(this);
  late final $WakeChecksTable wakeChecks = $WakeChecksTable(this);
  late final $WakeProtocolsTable wakeProtocols = $WakeProtocolsTable(this);
  late final $ProtocolEvaluationsTable protocolEvaluations =
      $ProtocolEvaluationsTable(this);
  late final $AlarmAdaptationSettingsTable alarmAdaptationSettings =
      $AlarmAdaptationSettingsTable(this);
  late final $WakeExperimentsTable wakeExperiments = $WakeExperimentsTable(
    this,
  );
  late final $ExperimentSessionsTable experimentSessions =
      $ExperimentSessionsTable(this);
  late final $ExperimentAuditEventsTable experimentAuditEvents =
      $ExperimentAuditEventsTable(this);
  late final Index wakeEventsSessionSequence = Index(
    'wake_events_session_sequence',
    'CREATE UNIQUE INDEX wake_events_session_sequence ON wake_events (wake_session_id, sequence_number)',
  );
  late final Index missionsAlarmId = Index(
    'missions_alarm_id',
    'CREATE INDEX missions_alarm_id ON missions (alarm_id)',
  );
  late final Index missionExecutionsSessionAttempt = Index(
    'mission_executions_session_attempt',
    'CREATE UNIQUE INDEX mission_executions_session_attempt ON mission_executions (wake_session_id, attempt_number)',
  );
  late final Index wakeChecksSessionAttempt = Index(
    'wake_checks_session_attempt',
    'CREATE UNIQUE INDEX wake_checks_session_attempt ON wake_checks (wake_session_id, attempt_number)',
  );
  late final Index wakeProtocolsAlarmVersion = Index(
    'wake_protocols_alarm_version',
    'CREATE UNIQUE INDEX wake_protocols_alarm_version ON wake_protocols (alarm_id, version)',
  );
  late final Index wakeProtocolsAlarmStatus = Index(
    'wake_protocols_alarm_status',
    'CREATE INDEX wake_protocols_alarm_status ON wake_protocols (alarm_id, status)',
  );
  late final Index protocolEvaluationsSession = Index(
    'protocol_evaluations_session',
    'CREATE UNIQUE INDEX protocol_evaluations_session ON protocol_evaluations (wake_session_id)',
  );
  late final Index wakeExperimentsOneOpen = Index(
    'wake_experiments_one_open',
    'CREATE UNIQUE INDEX wake_experiments_one_open ON wake_experiments (alarm_id) WHERE status IN (\'ready\', \'running\', \'paused\')',
  );
  late final Index experimentSessionsOccurrence = Index(
    'experiment_sessions_occurrence',
    'CREATE UNIQUE INDEX experiment_sessions_occurrence ON experiment_sessions (alarm_id, scheduled_time_ms)',
  );
  late final Index experimentSessionsWake = Index(
    'experiment_sessions_wake',
    'CREATE UNIQUE INDEX experiment_sessions_wake ON experiment_sessions (wake_session_id)',
  );
  late final Index experimentSessionsAssignment = Index(
    'experiment_sessions_assignment',
    'CREATE UNIQUE INDEX experiment_sessions_assignment ON experiment_sessions (experiment_id, assignment_index)',
  );
  late final Index experimentAuditOrder = Index(
    'experiment_audit_order',
    'CREATE UNIQUE INDEX experiment_audit_order ON experiment_audit_events (experiment_id, sequence)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    alarms,
    alarmSounds,
    wakeSessions,
    wakeEvents,
    appSettings,
    missions,
    missionExecutions,
    wakeChecks,
    wakeProtocols,
    protocolEvaluations,
    alarmAdaptationSettings,
    wakeExperiments,
    experimentSessions,
    experimentAuditEvents,
    wakeEventsSessionSequence,
    missionsAlarmId,
    missionExecutionsSessionAttempt,
    wakeChecksSessionAttempt,
    wakeProtocolsAlarmVersion,
    wakeProtocolsAlarmStatus,
    protocolEvaluationsSession,
    wakeExperimentsOneOpen,
    experimentSessionsOccurrence,
    experimentSessionsWake,
    experimentSessionsAssignment,
    experimentAuditOrder,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'alarms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('missions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'alarms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wake_protocols', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'alarms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('alarm_adaptation_settings', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$AlarmsTableCreateCompanionBuilder = AlarmsCompanion Function({
  required String id,
  required int localHour,
  required int localMinute,
  Value<String?> label,
  Value<bool> enabled,
  required String recurrenceType,
  Value<int> repeatDaysMask,
  required String soundId,
  Value<String?> ringtoneUri,
  Value<String?> ringtoneTitle,
  Value<bool> adaptiveSoundRotation,
  Value<bool> increasingVolume,
  Value<bool> vibrationEnabled,
  Value<bool> snoozeEnabled,
  required int snoozeDurationMinutes,
  Value<int> definitionRevision,
  required int createdAtMs,
  required int updatedAtMs,
  Value<int> rowid,
});
typedef $$AlarmsTableUpdateCompanionBuilder = AlarmsCompanion Function({
  Value<String> id,
  Value<int> localHour,
  Value<int> localMinute,
  Value<String?> label,
  Value<bool> enabled,
  Value<String> recurrenceType,
  Value<int> repeatDaysMask,
  Value<String> soundId,
  Value<String?> ringtoneUri,
  Value<String?> ringtoneTitle,
  Value<bool> adaptiveSoundRotation,
  Value<bool> increasingVolume,
  Value<bool> vibrationEnabled,
  Value<bool> snoozeEnabled,
  Value<int> snoozeDurationMinutes,
  Value<int> definitionRevision,
  Value<int> createdAtMs,
  Value<int> updatedAtMs,
  Value<int> rowid,
});

final class $$AlarmsTableReferences
    extends BaseReferences<_$AppDatabase, $AlarmsTable, Alarm> {
  $$AlarmsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MissionsTable, List<Mission>> _missionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.missions,
    aliasName: 'alarms__id__missions__alarm_id',
  );

  $$MissionsTableProcessedTableManager get missionsRefs {
    final manager = $$MissionsTableTableManager(
      $_db,
      $_db.missions,
    ).filter((f) => f.alarmId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_missionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WakeProtocolsTable, List<WakeProtocol>>
  _wakeProtocolsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wakeProtocols,
    aliasName: 'alarms__id__wake_protocols__alarm_id',
  );

  $$WakeProtocolsTableProcessedTableManager get wakeProtocolsRefs {
    final manager = $$WakeProtocolsTableTableManager(
      $_db,
      $_db.wakeProtocols,
    ).filter((f) => f.alarmId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wakeProtocolsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AlarmAdaptationSettingsTable,
    List<AlarmAdaptationSetting>
  >
  _alarmAdaptationSettingsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.alarmAdaptationSettings,
        aliasName: 'alarms__id__alarm_adaptation_settings__alarm_id',
      );

  $$AlarmAdaptationSettingsTableProcessedTableManager
  get alarmAdaptationSettingsRefs {
    final manager = $$AlarmAdaptationSettingsTableTableManager(
      $_db,
      $_db.alarmAdaptationSettings,
    ).filter((f) => f.alarmId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _alarmAdaptationSettingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlarmsTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableFilterComposer({
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

  ColumnFilters<int> get localHour => $composableBuilder(
    column: $table.localHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localMinute => $composableBuilder(
    column: $table.localMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatDaysMask => $composableBuilder(
    column: $table.repeatDaysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soundId => $composableBuilder(
    column: $table.soundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ringtoneUri => $composableBuilder(
    column: $table.ringtoneUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ringtoneTitle => $composableBuilder(
    column: $table.ringtoneTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adaptiveSoundRotation => $composableBuilder(
    column: $table.adaptiveSoundRotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get increasingVolume => $composableBuilder(
    column: $table.increasingVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get snoozeEnabled => $composableBuilder(
    column: $table.snoozeEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoozeDurationMinutes => $composableBuilder(
    column: $table.snoozeDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get definitionRevision => $composableBuilder(
    column: $table.definitionRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> missionsRefs(
    Expression<bool> Function($$MissionsTableFilterComposer f) f,
  ) {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.missions,
      getReferencedColumn: (t) => t.alarmId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionsTableFilterComposer(
            $db: $db,
            $table: $db.missions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wakeProtocolsRefs(
    Expression<bool> Function($$WakeProtocolsTableFilterComposer f) f,
  ) {
    final $$WakeProtocolsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wakeProtocols,
      getReferencedColumn: (t) => t.alarmId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeProtocolsTableFilterComposer(
            $db: $db,
            $table: $db.wakeProtocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> alarmAdaptationSettingsRefs(
    Expression<bool> Function($$AlarmAdaptationSettingsTableFilterComposer f) f,
  ) {
    final $$AlarmAdaptationSettingsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.alarmAdaptationSettings,
          getReferencedColumn: (t) => t.alarmId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AlarmAdaptationSettingsTableFilterComposer(
                $db: $db,
                $table: $db.alarmAdaptationSettings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AlarmsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableOrderingComposer({
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

  ColumnOrderings<int> get localHour => $composableBuilder(
    column: $table.localHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localMinute => $composableBuilder(
    column: $table.localMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatDaysMask => $composableBuilder(
    column: $table.repeatDaysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soundId => $composableBuilder(
    column: $table.soundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ringtoneUri => $composableBuilder(
    column: $table.ringtoneUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ringtoneTitle => $composableBuilder(
    column: $table.ringtoneTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adaptiveSoundRotation => $composableBuilder(
    column: $table.adaptiveSoundRotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get increasingVolume => $composableBuilder(
    column: $table.increasingVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get snoozeEnabled => $composableBuilder(
    column: $table.snoozeEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozeDurationMinutes => $composableBuilder(
    column: $table.snoozeDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get definitionRevision => $composableBuilder(
    column: $table.definitionRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get localHour =>
      $composableBuilder(column: $table.localHour, builder: (column) => column);

  GeneratedColumn<int> get localMinute => $composableBuilder(
    column: $table.localMinute,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatDaysMask => $composableBuilder(
    column: $table.repeatDaysMask,
    builder: (column) => column,
  );

  GeneratedColumn<String> get soundId =>
      $composableBuilder(column: $table.soundId, builder: (column) => column);

  GeneratedColumn<String> get ringtoneUri => $composableBuilder(
    column: $table.ringtoneUri,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ringtoneTitle => $composableBuilder(
    column: $table.ringtoneTitle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adaptiveSoundRotation => $composableBuilder(
    column: $table.adaptiveSoundRotation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get increasingVolume => $composableBuilder(
    column: $table.increasingVolume,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get snoozeEnabled => $composableBuilder(
    column: $table.snoozeEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get snoozeDurationMinutes => $composableBuilder(
    column: $table.snoozeDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get definitionRevision => $composableBuilder(
    column: $table.definitionRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  Expression<T> missionsRefs<T extends Object>(
    Expression<T> Function($$MissionsTableAnnotationComposer a) f,
  ) {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.missions,
      getReferencedColumn: (t) => t.alarmId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.missions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wakeProtocolsRefs<T extends Object>(
    Expression<T> Function($$WakeProtocolsTableAnnotationComposer a) f,
  ) {
    final $$WakeProtocolsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wakeProtocols,
      getReferencedColumn: (t) => t.alarmId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeProtocolsTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeProtocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> alarmAdaptationSettingsRefs<T extends Object>(
    Expression<T> Function($$AlarmAdaptationSettingsTableAnnotationComposer a)
    f,
  ) {
    final $$AlarmAdaptationSettingsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.alarmAdaptationSettings,
          getReferencedColumn: (t) => t.alarmId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AlarmAdaptationSettingsTableAnnotationComposer(
                $db: $db,
                $table: $db.alarmAdaptationSettings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AlarmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmsTable,
          Alarm,
          $$AlarmsTableFilterComposer,
          $$AlarmsTableOrderingComposer,
          $$AlarmsTableAnnotationComposer,
          $$AlarmsTableCreateCompanionBuilder,
          $$AlarmsTableUpdateCompanionBuilder,
          (Alarm, $$AlarmsTableReferences),
          Alarm,
          PrefetchHooks Function({
            bool missionsRefs,
            bool wakeProtocolsRefs,
            bool alarmAdaptationSettingsRefs,
          })
        > {
  $$AlarmsTableTableManager(_$AppDatabase db, $AlarmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> localHour = const Value.absent(),
                Value<int> localMinute = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> recurrenceType = const Value.absent(),
                Value<int> repeatDaysMask = const Value.absent(),
                Value<String> soundId = const Value.absent(),
                Value<String?> ringtoneUri = const Value.absent(),
                Value<String?> ringtoneTitle = const Value.absent(),
                Value<bool> adaptiveSoundRotation = const Value.absent(),
                Value<bool> increasingVolume = const Value.absent(),
                Value<bool> vibrationEnabled = const Value.absent(),
                Value<bool> snoozeEnabled = const Value.absent(),
                Value<int> snoozeDurationMinutes = const Value.absent(),
                Value<int> definitionRevision = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmsCompanion(
                id: id,
                localHour: localHour,
                localMinute: localMinute,
                label: label,
                enabled: enabled,
                recurrenceType: recurrenceType,
                repeatDaysMask: repeatDaysMask,
                soundId: soundId,
                ringtoneUri: ringtoneUri,
                ringtoneTitle: ringtoneTitle,
                adaptiveSoundRotation: adaptiveSoundRotation,
                increasingVolume: increasingVolume,
                vibrationEnabled: vibrationEnabled,
                snoozeEnabled: snoozeEnabled,
                snoozeDurationMinutes: snoozeDurationMinutes,
                definitionRevision: definitionRevision,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int localHour,
                required int localMinute,
                Value<String?> label = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                required String recurrenceType,
                Value<int> repeatDaysMask = const Value.absent(),
                required String soundId,
                Value<String?> ringtoneUri = const Value.absent(),
                Value<String?> ringtoneTitle = const Value.absent(),
                Value<bool> adaptiveSoundRotation = const Value.absent(),
                Value<bool> increasingVolume = const Value.absent(),
                Value<bool> vibrationEnabled = const Value.absent(),
                Value<bool> snoozeEnabled = const Value.absent(),
                required int snoozeDurationMinutes,
                Value<int> definitionRevision = const Value.absent(),
                required int createdAtMs,
                required int updatedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => AlarmsCompanion.insert(
                id: id,
                localHour: localHour,
                localMinute: localMinute,
                label: label,
                enabled: enabled,
                recurrenceType: recurrenceType,
                repeatDaysMask: repeatDaysMask,
                soundId: soundId,
                ringtoneUri: ringtoneUri,
                ringtoneTitle: ringtoneTitle,
                adaptiveSoundRotation: adaptiveSoundRotation,
                increasingVolume: increasingVolume,
                vibrationEnabled: vibrationEnabled,
                snoozeEnabled: snoozeEnabled,
                snoozeDurationMinutes: snoozeDurationMinutes,
                definitionRevision: definitionRevision,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlarmsTable, Alarm>(table),
                  $$AlarmsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                missionsRefs = false,
                wakeProtocolsRefs = false,
                alarmAdaptationSettingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (missionsRefs) db.missions,
                    if (wakeProtocolsRefs) db.wakeProtocols,
                    if (alarmAdaptationSettingsRefs) db.alarmAdaptationSettings,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (missionsRefs)
                        await $_getPrefetchedData<Alarm, $AlarmsTable, Mission>(
                          currentTable: table,
                          referencedTable: $$AlarmsTableReferences
                              ._missionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AlarmsTableReferences(
                                db,
                                table,
                                p0,
                              ).missionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.alarmId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wakeProtocolsRefs)
                        await $_getPrefetchedData<
                          Alarm,
                          $AlarmsTable,
                          WakeProtocol
                        >(
                          currentTable: table,
                          referencedTable: $$AlarmsTableReferences
                              ._wakeProtocolsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AlarmsTableReferences(
                                db,
                                table,
                                p0,
                              ).wakeProtocolsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.alarmId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (alarmAdaptationSettingsRefs)
                        await $_getPrefetchedData<
                          Alarm,
                          $AlarmsTable,
                          AlarmAdaptationSetting
                        >(
                          currentTable: table,
                          referencedTable: $$AlarmsTableReferences
                              ._alarmAdaptationSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AlarmsTableReferences(
                                db,
                                table,
                                p0,
                              ).alarmAdaptationSettingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.alarmId == item.id,
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

typedef $$AlarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmsTable,
      Alarm,
      $$AlarmsTableFilterComposer,
      $$AlarmsTableOrderingComposer,
      $$AlarmsTableAnnotationComposer,
      $$AlarmsTableCreateCompanionBuilder,
      $$AlarmsTableUpdateCompanionBuilder,
      (Alarm, $$AlarmsTableReferences),
      Alarm,
      PrefetchHooks Function({
        bool missionsRefs,
        bool wakeProtocolsRefs,
        bool alarmAdaptationSettingsRefs,
      })
    >;
typedef $$AlarmSoundsTableCreateCompanionBuilder =
    AlarmSoundsCompanion Function({
      required String id,
      required String name,
      required String assetPath,
      required String soundFamily,
      required int intensityLevel,
      Value<bool> enabled,
      Value<int?> lastUsedAtMs,
      Value<int> rowid,
    });
typedef $$AlarmSoundsTableUpdateCompanionBuilder =
    AlarmSoundsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> assetPath,
      Value<String> soundFamily,
      Value<int> intensityLevel,
      Value<bool> enabled,
      Value<int?> lastUsedAtMs,
      Value<int> rowid,
    });

class $$AlarmSoundsTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmSoundsTable> {
  $$AlarmSoundsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soundFamily => $composableBuilder(
    column: $table.soundFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensityLevel => $composableBuilder(
    column: $table.intensityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUsedAtMs => $composableBuilder(
    column: $table.lastUsedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlarmSoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmSoundsTable> {
  $$AlarmSoundsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soundFamily => $composableBuilder(
    column: $table.soundFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensityLevel => $composableBuilder(
    column: $table.intensityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUsedAtMs => $composableBuilder(
    column: $table.lastUsedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmSoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmSoundsTable> {
  $$AlarmSoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get assetPath =>
      $composableBuilder(column: $table.assetPath, builder: (column) => column);

  GeneratedColumn<String> get soundFamily => $composableBuilder(
    column: $table.soundFamily,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intensityLevel => $composableBuilder(
    column: $table.intensityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get lastUsedAtMs => $composableBuilder(
    column: $table.lastUsedAtMs,
    builder: (column) => column,
  );
}

class $$AlarmSoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmSoundsTable,
          AlarmSound,
          $$AlarmSoundsTableFilterComposer,
          $$AlarmSoundsTableOrderingComposer,
          $$AlarmSoundsTableAnnotationComposer,
          $$AlarmSoundsTableCreateCompanionBuilder,
          $$AlarmSoundsTableUpdateCompanionBuilder,
          (
            AlarmSound,
            BaseReferences<_$AppDatabase, $AlarmSoundsTable, AlarmSound>,
          ),
          AlarmSound,
          PrefetchHooks Function()
        > {
  $$AlarmSoundsTableTableManager(_$AppDatabase db, $AlarmSoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmSoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmSoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmSoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> assetPath = const Value.absent(),
                Value<String> soundFamily = const Value.absent(),
                Value<int> intensityLevel = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int?> lastUsedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmSoundsCompanion(
                id: id,
                name: name,
                assetPath: assetPath,
                soundFamily: soundFamily,
                intensityLevel: intensityLevel,
                enabled: enabled,
                lastUsedAtMs: lastUsedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String assetPath,
                required String soundFamily,
                required int intensityLevel,
                Value<bool> enabled = const Value.absent(),
                Value<int?> lastUsedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmSoundsCompanion.insert(
                id: id,
                name: name,
                assetPath: assetPath,
                soundFamily: soundFamily,
                intensityLevel: intensityLevel,
                enabled: enabled,
                lastUsedAtMs: lastUsedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlarmSoundsTable, AlarmSound>(table),
                  BaseReferences<_$AppDatabase, $AlarmSoundsTable, AlarmSound>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlarmSoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmSoundsTable,
      AlarmSound,
      $$AlarmSoundsTableFilterComposer,
      $$AlarmSoundsTableOrderingComposer,
      $$AlarmSoundsTableAnnotationComposer,
      $$AlarmSoundsTableCreateCompanionBuilder,
      $$AlarmSoundsTableUpdateCompanionBuilder,
      (
        AlarmSound,
        BaseReferences<_$AppDatabase, $AlarmSoundsTable, AlarmSound>,
      ),
      AlarmSound,
      PrefetchHooks Function()
    >;
typedef $$WakeSessionsTableCreateCompanionBuilder =
    WakeSessionsCompanion Function({
      required String id,
      required String alarmId,
      required int scheduledTimeMs,
      required int triggeredAtMs,
      required String initialSoundId,
      Value<double?> initialVolume,
      Value<int?> firstInteractionAtMs,
      Value<int?> responseLatencyMs,
      Value<int> snoozeCount,
      Value<int> soundChangeCount,
      Value<int> escalationCount,
      Value<int?> dismissedAtMs,
      required String outcome,
      Value<bool> wakeEnforcementEnabled,
      Value<String> currentWakeFlowState,
      Value<String?> missionType,
      Value<int> missionAttemptCount,
      Value<int> missionFailureCount,
      Value<int> wakeCheckAttemptCount,
      Value<int> wakeCheckFailureCount,
      Value<int?> confirmedAwakeAtMs,
      required int createdAtMs,
      Value<int?> completedAtMs,
      Value<String?> protocolId,
      Value<int?> protocolVersion,
      Value<String?> protocolSnapshotJson,
      Value<String> analysisStatus,
      Value<int> rowid,
    });
typedef $$WakeSessionsTableUpdateCompanionBuilder =
    WakeSessionsCompanion Function({
      Value<String> id,
      Value<String> alarmId,
      Value<int> scheduledTimeMs,
      Value<int> triggeredAtMs,
      Value<String> initialSoundId,
      Value<double?> initialVolume,
      Value<int?> firstInteractionAtMs,
      Value<int?> responseLatencyMs,
      Value<int> snoozeCount,
      Value<int> soundChangeCount,
      Value<int> escalationCount,
      Value<int?> dismissedAtMs,
      Value<String> outcome,
      Value<bool> wakeEnforcementEnabled,
      Value<String> currentWakeFlowState,
      Value<String?> missionType,
      Value<int> missionAttemptCount,
      Value<int> missionFailureCount,
      Value<int> wakeCheckAttemptCount,
      Value<int> wakeCheckFailureCount,
      Value<int?> confirmedAwakeAtMs,
      Value<int> createdAtMs,
      Value<int?> completedAtMs,
      Value<String?> protocolId,
      Value<int?> protocolVersion,
      Value<String?> protocolSnapshotJson,
      Value<String> analysisStatus,
      Value<int> rowid,
    });

final class $$WakeSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $WakeSessionsTable, WakeSession> {
  $$WakeSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MissionExecutionsTable, List<MissionExecution>>
  _missionExecutionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.missionExecutions,
        aliasName: 'wake_sessions__id__mission_executions__wake_session_id',
      );

  $$MissionExecutionsTableProcessedTableManager get missionExecutionsRefs {
    final manager = $$MissionExecutionsTableTableManager(
      $_db,
      $_db.missionExecutions,
    ).filter((f) => f.wakeSessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _missionExecutionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WakeChecksTable, List<WakeCheck>>
  _wakeChecksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wakeChecks,
    aliasName: 'wake_sessions__id__wake_checks__wake_session_id',
  );

  $$WakeChecksTableProcessedTableManager get wakeChecksRefs {
    final manager = $$WakeChecksTableTableManager(
      $_db,
      $_db.wakeChecks,
    ).filter((f) => f.wakeSessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wakeChecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProtocolEvaluationsTable,
    List<ProtocolEvaluation>
  >
  _protocolEvaluationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.protocolEvaluations,
        aliasName: 'wake_sessions__id__protocol_evaluations__wake_session_id',
      );

  $$ProtocolEvaluationsTableProcessedTableManager get protocolEvaluationsRefs {
    final manager = $$ProtocolEvaluationsTableTableManager(
      $_db,
      $_db.protocolEvaluations,
    ).filter((f) => f.wakeSessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _protocolEvaluationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WakeSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WakeSessionsTable> {
  $$WakeSessionsTableFilterComposer({
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

  ColumnFilters<String> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledTimeMs => $composableBuilder(
    column: $table.scheduledTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triggeredAtMs => $composableBuilder(
    column: $table.triggeredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialSoundId => $composableBuilder(
    column: $table.initialSoundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialVolume => $composableBuilder(
    column: $table.initialVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstInteractionAtMs => $composableBuilder(
    column: $table.firstInteractionAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseLatencyMs => $composableBuilder(
    column: $table.responseLatencyMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoozeCount => $composableBuilder(
    column: $table.snoozeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get soundChangeCount => $composableBuilder(
    column: $table.soundChangeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get escalationCount => $composableBuilder(
    column: $table.escalationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dismissedAtMs => $composableBuilder(
    column: $table.dismissedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wakeEnforcementEnabled => $composableBuilder(
    column: $table.wakeEnforcementEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentWakeFlowState => $composableBuilder(
    column: $table.currentWakeFlowState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missionAttemptCount => $composableBuilder(
    column: $table.missionAttemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missionFailureCount => $composableBuilder(
    column: $table.missionFailureCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeCheckAttemptCount => $composableBuilder(
    column: $table.wakeCheckAttemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeCheckFailureCount => $composableBuilder(
    column: $table.wakeCheckFailureCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confirmedAwakeAtMs => $composableBuilder(
    column: $table.confirmedAwakeAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolId => $composableBuilder(
    column: $table.protocolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolSnapshotJson => $composableBuilder(
    column: $table.protocolSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get analysisStatus => $composableBuilder(
    column: $table.analysisStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> missionExecutionsRefs(
    Expression<bool> Function($$MissionExecutionsTableFilterComposer f) f,
  ) {
    final $$MissionExecutionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.missionExecutions,
      getReferencedColumn: (t) => t.wakeSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionExecutionsTableFilterComposer(
            $db: $db,
            $table: $db.missionExecutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wakeChecksRefs(
    Expression<bool> Function($$WakeChecksTableFilterComposer f) f,
  ) {
    final $$WakeChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wakeChecks,
      getReferencedColumn: (t) => t.wakeSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeChecksTableFilterComposer(
            $db: $db,
            $table: $db.wakeChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> protocolEvaluationsRefs(
    Expression<bool> Function($$ProtocolEvaluationsTableFilterComposer f) f,
  ) {
    final $$ProtocolEvaluationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.protocolEvaluations,
      getReferencedColumn: (t) => t.wakeSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProtocolEvaluationsTableFilterComposer(
            $db: $db,
            $table: $db.protocolEvaluations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WakeSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WakeSessionsTable> {
  $$WakeSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledTimeMs => $composableBuilder(
    column: $table.scheduledTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triggeredAtMs => $composableBuilder(
    column: $table.triggeredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialSoundId => $composableBuilder(
    column: $table.initialSoundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialVolume => $composableBuilder(
    column: $table.initialVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstInteractionAtMs => $composableBuilder(
    column: $table.firstInteractionAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseLatencyMs => $composableBuilder(
    column: $table.responseLatencyMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozeCount => $composableBuilder(
    column: $table.snoozeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get soundChangeCount => $composableBuilder(
    column: $table.soundChangeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get escalationCount => $composableBuilder(
    column: $table.escalationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dismissedAtMs => $composableBuilder(
    column: $table.dismissedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wakeEnforcementEnabled => $composableBuilder(
    column: $table.wakeEnforcementEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentWakeFlowState => $composableBuilder(
    column: $table.currentWakeFlowState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missionAttemptCount => $composableBuilder(
    column: $table.missionAttemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missionFailureCount => $composableBuilder(
    column: $table.missionFailureCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeCheckAttemptCount => $composableBuilder(
    column: $table.wakeCheckAttemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeCheckFailureCount => $composableBuilder(
    column: $table.wakeCheckFailureCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confirmedAwakeAtMs => $composableBuilder(
    column: $table.confirmedAwakeAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolId => $composableBuilder(
    column: $table.protocolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolSnapshotJson => $composableBuilder(
    column: $table.protocolSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysisStatus => $composableBuilder(
    column: $table.analysisStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WakeSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WakeSessionsTable> {
  $$WakeSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alarmId =>
      $composableBuilder(column: $table.alarmId, builder: (column) => column);

  GeneratedColumn<int> get scheduledTimeMs => $composableBuilder(
    column: $table.scheduledTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get triggeredAtMs => $composableBuilder(
    column: $table.triggeredAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initialSoundId => $composableBuilder(
    column: $table.initialSoundId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialVolume => $composableBuilder(
    column: $table.initialVolume,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstInteractionAtMs => $composableBuilder(
    column: $table.firstInteractionAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseLatencyMs => $composableBuilder(
    column: $table.responseLatencyMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get snoozeCount => $composableBuilder(
    column: $table.snoozeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get soundChangeCount => $composableBuilder(
    column: $table.soundChangeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get escalationCount => $composableBuilder(
    column: $table.escalationCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dismissedAtMs => $composableBuilder(
    column: $table.dismissedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<bool> get wakeEnforcementEnabled => $composableBuilder(
    column: $table.wakeEnforcementEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentWakeFlowState => $composableBuilder(
    column: $table.currentWakeFlowState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missionAttemptCount => $composableBuilder(
    column: $table.missionAttemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missionFailureCount => $composableBuilder(
    column: $table.missionFailureCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wakeCheckAttemptCount => $composableBuilder(
    column: $table.wakeCheckAttemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wakeCheckFailureCount => $composableBuilder(
    column: $table.wakeCheckFailureCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get confirmedAwakeAtMs => $composableBuilder(
    column: $table.confirmedAwakeAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get protocolId => $composableBuilder(
    column: $table.protocolId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get protocolSnapshotJson => $composableBuilder(
    column: $table.protocolSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get analysisStatus => $composableBuilder(
    column: $table.analysisStatus,
    builder: (column) => column,
  );

  Expression<T> missionExecutionsRefs<T extends Object>(
    Expression<T> Function($$MissionExecutionsTableAnnotationComposer a) f,
  ) {
    final $$MissionExecutionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.missionExecutions,
          getReferencedColumn: (t) => t.wakeSessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MissionExecutionsTableAnnotationComposer(
                $db: $db,
                $table: $db.missionExecutions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> wakeChecksRefs<T extends Object>(
    Expression<T> Function($$WakeChecksTableAnnotationComposer a) f,
  ) {
    final $$WakeChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wakeChecks,
      getReferencedColumn: (t) => t.wakeSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> protocolEvaluationsRefs<T extends Object>(
    Expression<T> Function($$ProtocolEvaluationsTableAnnotationComposer a) f,
  ) {
    final $$ProtocolEvaluationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.protocolEvaluations,
          getReferencedColumn: (t) => t.wakeSessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProtocolEvaluationsTableAnnotationComposer(
                $db: $db,
                $table: $db.protocolEvaluations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WakeSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WakeSessionsTable,
          WakeSession,
          $$WakeSessionsTableFilterComposer,
          $$WakeSessionsTableOrderingComposer,
          $$WakeSessionsTableAnnotationComposer,
          $$WakeSessionsTableCreateCompanionBuilder,
          $$WakeSessionsTableUpdateCompanionBuilder,
          (WakeSession, $$WakeSessionsTableReferences),
          WakeSession,
          PrefetchHooks Function({
            bool missionExecutionsRefs,
            bool wakeChecksRefs,
            bool protocolEvaluationsRefs,
          })
        > {
  $$WakeSessionsTableTableManager(_$AppDatabase db, $WakeSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WakeSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WakeSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WakeSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> alarmId = const Value.absent(),
                Value<int> scheduledTimeMs = const Value.absent(),
                Value<int> triggeredAtMs = const Value.absent(),
                Value<String> initialSoundId = const Value.absent(),
                Value<double?> initialVolume = const Value.absent(),
                Value<int?> firstInteractionAtMs = const Value.absent(),
                Value<int?> responseLatencyMs = const Value.absent(),
                Value<int> snoozeCount = const Value.absent(),
                Value<int> soundChangeCount = const Value.absent(),
                Value<int> escalationCount = const Value.absent(),
                Value<int?> dismissedAtMs = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<bool> wakeEnforcementEnabled = const Value.absent(),
                Value<String> currentWakeFlowState = const Value.absent(),
                Value<String?> missionType = const Value.absent(),
                Value<int> missionAttemptCount = const Value.absent(),
                Value<int> missionFailureCount = const Value.absent(),
                Value<int> wakeCheckAttemptCount = const Value.absent(),
                Value<int> wakeCheckFailureCount = const Value.absent(),
                Value<int?> confirmedAwakeAtMs = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                Value<String?> protocolId = const Value.absent(),
                Value<int?> protocolVersion = const Value.absent(),
                Value<String?> protocolSnapshotJson = const Value.absent(),
                Value<String> analysisStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WakeSessionsCompanion(
                id: id,
                alarmId: alarmId,
                scheduledTimeMs: scheduledTimeMs,
                triggeredAtMs: triggeredAtMs,
                initialSoundId: initialSoundId,
                initialVolume: initialVolume,
                firstInteractionAtMs: firstInteractionAtMs,
                responseLatencyMs: responseLatencyMs,
                snoozeCount: snoozeCount,
                soundChangeCount: soundChangeCount,
                escalationCount: escalationCount,
                dismissedAtMs: dismissedAtMs,
                outcome: outcome,
                wakeEnforcementEnabled: wakeEnforcementEnabled,
                currentWakeFlowState: currentWakeFlowState,
                missionType: missionType,
                missionAttemptCount: missionAttemptCount,
                missionFailureCount: missionFailureCount,
                wakeCheckAttemptCount: wakeCheckAttemptCount,
                wakeCheckFailureCount: wakeCheckFailureCount,
                confirmedAwakeAtMs: confirmedAwakeAtMs,
                createdAtMs: createdAtMs,
                completedAtMs: completedAtMs,
                protocolId: protocolId,
                protocolVersion: protocolVersion,
                protocolSnapshotJson: protocolSnapshotJson,
                analysisStatus: analysisStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String alarmId,
                required int scheduledTimeMs,
                required int triggeredAtMs,
                required String initialSoundId,
                Value<double?> initialVolume = const Value.absent(),
                Value<int?> firstInteractionAtMs = const Value.absent(),
                Value<int?> responseLatencyMs = const Value.absent(),
                Value<int> snoozeCount = const Value.absent(),
                Value<int> soundChangeCount = const Value.absent(),
                Value<int> escalationCount = const Value.absent(),
                Value<int?> dismissedAtMs = const Value.absent(),
                required String outcome,
                Value<bool> wakeEnforcementEnabled = const Value.absent(),
                Value<String> currentWakeFlowState = const Value.absent(),
                Value<String?> missionType = const Value.absent(),
                Value<int> missionAttemptCount = const Value.absent(),
                Value<int> missionFailureCount = const Value.absent(),
                Value<int> wakeCheckAttemptCount = const Value.absent(),
                Value<int> wakeCheckFailureCount = const Value.absent(),
                Value<int?> confirmedAwakeAtMs = const Value.absent(),
                required int createdAtMs,
                Value<int?> completedAtMs = const Value.absent(),
                Value<String?> protocolId = const Value.absent(),
                Value<int?> protocolVersion = const Value.absent(),
                Value<String?> protocolSnapshotJson = const Value.absent(),
                Value<String> analysisStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WakeSessionsCompanion.insert(
                id: id,
                alarmId: alarmId,
                scheduledTimeMs: scheduledTimeMs,
                triggeredAtMs: triggeredAtMs,
                initialSoundId: initialSoundId,
                initialVolume: initialVolume,
                firstInteractionAtMs: firstInteractionAtMs,
                responseLatencyMs: responseLatencyMs,
                snoozeCount: snoozeCount,
                soundChangeCount: soundChangeCount,
                escalationCount: escalationCount,
                dismissedAtMs: dismissedAtMs,
                outcome: outcome,
                wakeEnforcementEnabled: wakeEnforcementEnabled,
                currentWakeFlowState: currentWakeFlowState,
                missionType: missionType,
                missionAttemptCount: missionAttemptCount,
                missionFailureCount: missionFailureCount,
                wakeCheckAttemptCount: wakeCheckAttemptCount,
                wakeCheckFailureCount: wakeCheckFailureCount,
                confirmedAwakeAtMs: confirmedAwakeAtMs,
                createdAtMs: createdAtMs,
                completedAtMs: completedAtMs,
                protocolId: protocolId,
                protocolVersion: protocolVersion,
                protocolSnapshotJson: protocolSnapshotJson,
                analysisStatus: analysisStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WakeSessionsTable, WakeSession>(table),
                  $$WakeSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                missionExecutionsRefs = false,
                wakeChecksRefs = false,
                protocolEvaluationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (missionExecutionsRefs) db.missionExecutions,
                    if (wakeChecksRefs) db.wakeChecks,
                    if (protocolEvaluationsRefs) db.protocolEvaluations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (missionExecutionsRefs)
                        await $_getPrefetchedData<
                          WakeSession,
                          $WakeSessionsTable,
                          MissionExecution
                        >(
                          currentTable: table,
                          referencedTable: $$WakeSessionsTableReferences
                              ._missionExecutionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WakeSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).missionExecutionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wakeSessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wakeChecksRefs)
                        await $_getPrefetchedData<
                          WakeSession,
                          $WakeSessionsTable,
                          WakeCheck
                        >(
                          currentTable: table,
                          referencedTable: $$WakeSessionsTableReferences
                              ._wakeChecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WakeSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).wakeChecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wakeSessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (protocolEvaluationsRefs)
                        await $_getPrefetchedData<
                          WakeSession,
                          $WakeSessionsTable,
                          ProtocolEvaluation
                        >(
                          currentTable: table,
                          referencedTable: $$WakeSessionsTableReferences
                              ._protocolEvaluationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WakeSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).protocolEvaluationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wakeSessionId == item.id,
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

typedef $$WakeSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WakeSessionsTable,
      WakeSession,
      $$WakeSessionsTableFilterComposer,
      $$WakeSessionsTableOrderingComposer,
      $$WakeSessionsTableAnnotationComposer,
      $$WakeSessionsTableCreateCompanionBuilder,
      $$WakeSessionsTableUpdateCompanionBuilder,
      (WakeSession, $$WakeSessionsTableReferences),
      WakeSession,
      PrefetchHooks Function({
        bool missionExecutionsRefs,
        bool wakeChecksRefs,
        bool protocolEvaluationsRefs,
      })
    >;
typedef $$WakeEventsTableCreateCompanionBuilder = WakeEventsCompanion Function({
  required String id,
  required String wakeSessionId,
  required int sequenceNumber,
  required String eventType,
  required int occurredAtMs,
  required String metadataJson,
  required String source,
  Value<int> rowid,
});
typedef $$WakeEventsTableUpdateCompanionBuilder = WakeEventsCompanion Function({
  Value<String> id,
  Value<String> wakeSessionId,
  Value<int> sequenceNumber,
  Value<String> eventType,
  Value<int> occurredAtMs,
  Value<String> metadataJson,
  Value<String> source,
  Value<int> rowid,
});

class $$WakeEventsTableFilterComposer
    extends Composer<_$AppDatabase, $WakeEventsTable> {
  $$WakeEventsTableFilterComposer({
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

  ColumnFilters<String> get wakeSessionId => $composableBuilder(
    column: $table.wakeSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WakeEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $WakeEventsTable> {
  $$WakeEventsTableOrderingComposer({
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

  ColumnOrderings<String> get wakeSessionId => $composableBuilder(
    column: $table.wakeSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WakeEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WakeEventsTable> {
  $$WakeEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wakeSessionId => $composableBuilder(
    column: $table.wakeSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$WakeEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WakeEventsTable,
          WakeEvent,
          $$WakeEventsTableFilterComposer,
          $$WakeEventsTableOrderingComposer,
          $$WakeEventsTableAnnotationComposer,
          $$WakeEventsTableCreateCompanionBuilder,
          $$WakeEventsTableUpdateCompanionBuilder,
          (
            WakeEvent,
            BaseReferences<_$AppDatabase, $WakeEventsTable, WakeEvent>,
          ),
          WakeEvent,
          PrefetchHooks Function()
        > {
  $$WakeEventsTableTableManager(_$AppDatabase db, $WakeEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WakeEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WakeEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WakeEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wakeSessionId = const Value.absent(),
                Value<int> sequenceNumber = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<int> occurredAtMs = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WakeEventsCompanion(
                id: id,
                wakeSessionId: wakeSessionId,
                sequenceNumber: sequenceNumber,
                eventType: eventType,
                occurredAtMs: occurredAtMs,
                metadataJson: metadataJson,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wakeSessionId,
                required int sequenceNumber,
                required String eventType,
                required int occurredAtMs,
                required String metadataJson,
                required String source,
                Value<int> rowid = const Value.absent(),
              }) => WakeEventsCompanion.insert(
                id: id,
                wakeSessionId: wakeSessionId,
                sequenceNumber: sequenceNumber,
                eventType: eventType,
                occurredAtMs: occurredAtMs,
                metadataJson: metadataJson,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WakeEventsTable, WakeEvent>(table),
                  BaseReferences<_$AppDatabase, $WakeEventsTable, WakeEvent>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WakeEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WakeEventsTable,
      WakeEvent,
      $$WakeEventsTableFilterComposer,
      $$WakeEventsTableOrderingComposer,
      $$WakeEventsTableAnnotationComposer,
      $$WakeEventsTableCreateCompanionBuilder,
      $$WakeEventsTableUpdateCompanionBuilder,
      (WakeEvent, BaseReferences<_$AppDatabase, $WakeEventsTable, WakeEvent>),
      WakeEvent,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String valueType,
      required String value,
      required int updatedAtMs,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> valueType,
      Value<String> value,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                valueType: valueType,
                value: value,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String valueType,
                required String value,
                required int updatedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                valueType: valueType,
                value: value,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$MissionsTableCreateCompanionBuilder = MissionsCompanion Function({
  required String id,
  required String alarmId,
  required String missionType,
  Value<bool> enabled,
  required String difficulty,
  Value<String> configurationJson,
  required int createdAtMs,
  required int updatedAtMs,
  Value<int> rowid,
});
typedef $$MissionsTableUpdateCompanionBuilder = MissionsCompanion Function({
  Value<String> id,
  Value<String> alarmId,
  Value<String> missionType,
  Value<bool> enabled,
  Value<String> difficulty,
  Value<String> configurationJson,
  Value<int> createdAtMs,
  Value<int> updatedAtMs,
  Value<int> rowid,
});

final class $$MissionsTableReferences
    extends BaseReferences<_$AppDatabase, $MissionsTable, Mission> {
  $$MissionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AlarmsTable _alarmIdTable(_$AppDatabase db) =>
      db.alarms.createAlias('missions__alarm_id__alarms__id');

  $$AlarmsTableProcessedTableManager get alarmId {
    final $_column = $_itemColumn<String>('alarm_id')!;

    final manager = $$AlarmsTableTableManager(
      $_db,
      $_db.alarms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alarmIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MissionExecutionsTable, List<MissionExecution>>
  _missionExecutionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.missionExecutions,
        aliasName: 'missions__id__mission_executions__mission_id',
      );

  $$MissionExecutionsTableProcessedTableManager get missionExecutionsRefs {
    final manager = $$MissionExecutionsTableTableManager(
      $_db,
      $_db.missionExecutions,
    ).filter((f) => f.missionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _missionExecutionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MissionsTableFilterComposer
    extends Composer<_$AppDatabase, $MissionsTable> {
  $$MissionsTableFilterComposer({
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

  ColumnFilters<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configurationJson => $composableBuilder(
    column: $table.configurationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$AlarmsTableFilterComposer get alarmId {
    final $$AlarmsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableFilterComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> missionExecutionsRefs(
    Expression<bool> Function($$MissionExecutionsTableFilterComposer f) f,
  ) {
    final $$MissionExecutionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.missionExecutions,
      getReferencedColumn: (t) => t.missionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionExecutionsTableFilterComposer(
            $db: $db,
            $table: $db.missionExecutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionsTable> {
  $$MissionsTableOrderingComposer({
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

  ColumnOrderings<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configurationJson => $composableBuilder(
    column: $table.configurationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$AlarmsTableOrderingComposer get alarmId {
    final $$AlarmsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableOrderingComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionsTable> {
  $$MissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get configurationJson => $composableBuilder(
    column: $table.configurationJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  $$AlarmsTableAnnotationComposer get alarmId {
    final $$AlarmsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableAnnotationComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> missionExecutionsRefs<T extends Object>(
    Expression<T> Function($$MissionExecutionsTableAnnotationComposer a) f,
  ) {
    final $$MissionExecutionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.missionExecutions,
          getReferencedColumn: (t) => t.missionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MissionExecutionsTableAnnotationComposer(
                $db: $db,
                $table: $db.missionExecutions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MissionsTable,
          Mission,
          $$MissionsTableFilterComposer,
          $$MissionsTableOrderingComposer,
          $$MissionsTableAnnotationComposer,
          $$MissionsTableCreateCompanionBuilder,
          $$MissionsTableUpdateCompanionBuilder,
          (Mission, $$MissionsTableReferences),
          Mission,
          PrefetchHooks Function({bool alarmId, bool missionExecutionsRefs})
        > {
  $$MissionsTableTableManager(_$AppDatabase db, $MissionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> alarmId = const Value.absent(),
                Value<String> missionType = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> configurationJson = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionsCompanion(
                id: id,
                alarmId: alarmId,
                missionType: missionType,
                enabled: enabled,
                difficulty: difficulty,
                configurationJson: configurationJson,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String alarmId,
                required String missionType,
                Value<bool> enabled = const Value.absent(),
                required String difficulty,
                Value<String> configurationJson = const Value.absent(),
                required int createdAtMs,
                required int updatedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => MissionsCompanion.insert(
                id: id,
                alarmId: alarmId,
                missionType: missionType,
                enabled: enabled,
                difficulty: difficulty,
                configurationJson: configurationJson,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MissionsTable, Mission>(table),
                  $$MissionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({alarmId = false, missionExecutionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (missionExecutionsRefs) db.missionExecutions,
                  ],
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
                        if (alarmId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.alarmId,
                            referencedTable: $$MissionsTableReferences
                                ._alarmIdTable(db),
                            referencedColumn: $$MissionsTableReferences
                                ._alarmIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (missionExecutionsRefs)
                        await $_getPrefetchedData<
                          Mission,
                          $MissionsTable,
                          MissionExecution
                        >(
                          currentTable: table,
                          referencedTable: $$MissionsTableReferences
                              ._missionExecutionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).missionExecutionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.missionId == item.id,
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

typedef $$MissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MissionsTable,
      Mission,
      $$MissionsTableFilterComposer,
      $$MissionsTableOrderingComposer,
      $$MissionsTableAnnotationComposer,
      $$MissionsTableCreateCompanionBuilder,
      $$MissionsTableUpdateCompanionBuilder,
      (Mission, $$MissionsTableReferences),
      Mission,
      PrefetchHooks Function({bool alarmId, bool missionExecutionsRefs})
    >;
typedef $$MissionExecutionsTableCreateCompanionBuilder =
    MissionExecutionsCompanion Function({
      required String id,
      required String wakeSessionId,
      required String missionId,
      required String missionType,
      required String status,
      required int attemptNumber,
      required int startedAtMs,
      Value<int?> completedAtMs,
      Value<int?> failedAtMs,
      Value<String?> failureReason,
      Value<String> metadataJson,
      Value<int> rowid,
    });
typedef $$MissionExecutionsTableUpdateCompanionBuilder =
    MissionExecutionsCompanion Function({
      Value<String> id,
      Value<String> wakeSessionId,
      Value<String> missionId,
      Value<String> missionType,
      Value<String> status,
      Value<int> attemptNumber,
      Value<int> startedAtMs,
      Value<int?> completedAtMs,
      Value<int?> failedAtMs,
      Value<String?> failureReason,
      Value<String> metadataJson,
      Value<int> rowid,
    });

final class $$MissionExecutionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MissionExecutionsTable,
          MissionExecution
        > {
  $$MissionExecutionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WakeSessionsTable _wakeSessionIdTable(_$AppDatabase db) => db
      .wakeSessions
      .createAlias('mission_executions__wake_session_id__wake_sessions__id');

  $$WakeSessionsTableProcessedTableManager get wakeSessionId {
    final $_column = $_itemColumn<String>('wake_session_id')!;

    final manager = $$WakeSessionsTableTableManager(
      $_db,
      $_db.wakeSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wakeSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MissionsTable _missionIdTable(_$AppDatabase db) =>
      db.missions.createAlias('mission_executions__mission_id__missions__id');

  $$MissionsTableProcessedTableManager get missionId {
    final $_column = $_itemColumn<String>('mission_id')!;

    final manager = $$MissionsTableTableManager(
      $_db,
      $_db.missions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_missionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MissionExecutionsTableFilterComposer
    extends Composer<_$AppDatabase, $MissionExecutionsTable> {
  $$MissionExecutionsTableFilterComposer({
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

  ColumnFilters<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedAtMs => $composableBuilder(
    column: $table.failedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  $$WakeSessionsTableFilterComposer get wakeSessionId {
    final $$WakeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MissionsTableFilterComposer get missionId {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.missionId,
      referencedTable: $db.missions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionsTableFilterComposer(
            $db: $db,
            $table: $db.missions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionExecutionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionExecutionsTable> {
  $$MissionExecutionsTableOrderingComposer({
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

  ColumnOrderings<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedAtMs => $composableBuilder(
    column: $table.failedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$WakeSessionsTableOrderingComposer get wakeSessionId {
    final $$WakeSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MissionsTableOrderingComposer get missionId {
    final $$MissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.missionId,
      referencedTable: $db.missions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionsTableOrderingComposer(
            $db: $db,
            $table: $db.missions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionExecutionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionExecutionsTable> {
  $$MissionExecutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedAtMs => $composableBuilder(
    column: $table.failedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  $$WakeSessionsTableAnnotationComposer get wakeSessionId {
    final $$WakeSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MissionsTableAnnotationComposer get missionId {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.missionId,
      referencedTable: $db.missions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.missions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionExecutionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MissionExecutionsTable,
          MissionExecution,
          $$MissionExecutionsTableFilterComposer,
          $$MissionExecutionsTableOrderingComposer,
          $$MissionExecutionsTableAnnotationComposer,
          $$MissionExecutionsTableCreateCompanionBuilder,
          $$MissionExecutionsTableUpdateCompanionBuilder,
          (MissionExecution, $$MissionExecutionsTableReferences),
          MissionExecution,
          PrefetchHooks Function({bool wakeSessionId, bool missionId})
        > {
  $$MissionExecutionsTableTableManager(
    _$AppDatabase db,
    $MissionExecutionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionExecutionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionExecutionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionExecutionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wakeSessionId = const Value.absent(),
                Value<String> missionId = const Value.absent(),
                Value<String> missionType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptNumber = const Value.absent(),
                Value<int> startedAtMs = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                Value<int?> failedAtMs = const Value.absent(),
                Value<String?> failureReason = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionExecutionsCompanion(
                id: id,
                wakeSessionId: wakeSessionId,
                missionId: missionId,
                missionType: missionType,
                status: status,
                attemptNumber: attemptNumber,
                startedAtMs: startedAtMs,
                completedAtMs: completedAtMs,
                failedAtMs: failedAtMs,
                failureReason: failureReason,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wakeSessionId,
                required String missionId,
                required String missionType,
                required String status,
                required int attemptNumber,
                required int startedAtMs,
                Value<int?> completedAtMs = const Value.absent(),
                Value<int?> failedAtMs = const Value.absent(),
                Value<String?> failureReason = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionExecutionsCompanion.insert(
                id: id,
                wakeSessionId: wakeSessionId,
                missionId: missionId,
                missionType: missionType,
                status: status,
                attemptNumber: attemptNumber,
                startedAtMs: startedAtMs,
                completedAtMs: completedAtMs,
                failedAtMs: failedAtMs,
                failureReason: failureReason,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MissionExecutionsTable, MissionExecution>(table),
                  $$MissionExecutionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wakeSessionId = false, missionId = false}) {
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
                    if (wakeSessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wakeSessionId,
                        referencedTable: $$MissionExecutionsTableReferences
                            ._wakeSessionIdTable(db),
                        referencedColumn: $$MissionExecutionsTableReferences
                            ._wakeSessionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (missionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.missionId,
                        referencedTable: $$MissionExecutionsTableReferences
                            ._missionIdTable(db),
                        referencedColumn: $$MissionExecutionsTableReferences
                            ._missionIdTable(db)
                            .id,
                      ) as T;
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

typedef $$MissionExecutionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MissionExecutionsTable,
      MissionExecution,
      $$MissionExecutionsTableFilterComposer,
      $$MissionExecutionsTableOrderingComposer,
      $$MissionExecutionsTableAnnotationComposer,
      $$MissionExecutionsTableCreateCompanionBuilder,
      $$MissionExecutionsTableUpdateCompanionBuilder,
      (MissionExecution, $$MissionExecutionsTableReferences),
      MissionExecution,
      PrefetchHooks Function({bool wakeSessionId, bool missionId})
    >;
typedef $$WakeChecksTableCreateCompanionBuilder = WakeChecksCompanion Function({
  required String id,
  required String wakeSessionId,
  required int attemptNumber,
  required int scheduledForMs,
  Value<int?> triggeredAtMs,
  Value<int?> firstInteractionAtMs,
  Value<int?> completedAtMs,
  required String status,
  required int createdAtMs,
  Value<int> rowid,
});
typedef $$WakeChecksTableUpdateCompanionBuilder = WakeChecksCompanion Function({
  Value<String> id,
  Value<String> wakeSessionId,
  Value<int> attemptNumber,
  Value<int> scheduledForMs,
  Value<int?> triggeredAtMs,
  Value<int?> firstInteractionAtMs,
  Value<int?> completedAtMs,
  Value<String> status,
  Value<int> createdAtMs,
  Value<int> rowid,
});

final class $$WakeChecksTableReferences
    extends BaseReferences<_$AppDatabase, $WakeChecksTable, WakeCheck> {
  $$WakeChecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WakeSessionsTable _wakeSessionIdTable(_$AppDatabase db) => db
      .wakeSessions
      .createAlias('wake_checks__wake_session_id__wake_sessions__id');

  $$WakeSessionsTableProcessedTableManager get wakeSessionId {
    final $_column = $_itemColumn<String>('wake_session_id')!;

    final manager = $$WakeSessionsTableTableManager(
      $_db,
      $_db.wakeSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wakeSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WakeChecksTableFilterComposer
    extends Composer<_$AppDatabase, $WakeChecksTable> {
  $$WakeChecksTableFilterComposer({
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

  ColumnFilters<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledForMs => $composableBuilder(
    column: $table.scheduledForMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triggeredAtMs => $composableBuilder(
    column: $table.triggeredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstInteractionAtMs => $composableBuilder(
    column: $table.firstInteractionAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$WakeSessionsTableFilterComposer get wakeSessionId {
    final $$WakeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WakeChecksTableOrderingComposer
    extends Composer<_$AppDatabase, $WakeChecksTable> {
  $$WakeChecksTableOrderingComposer({
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

  ColumnOrderings<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledForMs => $composableBuilder(
    column: $table.scheduledForMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triggeredAtMs => $composableBuilder(
    column: $table.triggeredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstInteractionAtMs => $composableBuilder(
    column: $table.firstInteractionAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$WakeSessionsTableOrderingComposer get wakeSessionId {
    final $$WakeSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WakeChecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WakeChecksTable> {
  $$WakeChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledForMs => $composableBuilder(
    column: $table.scheduledForMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get triggeredAtMs => $composableBuilder(
    column: $table.triggeredAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstInteractionAtMs => $composableBuilder(
    column: $table.firstInteractionAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  $$WakeSessionsTableAnnotationComposer get wakeSessionId {
    final $$WakeSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WakeChecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WakeChecksTable,
          WakeCheck,
          $$WakeChecksTableFilterComposer,
          $$WakeChecksTableOrderingComposer,
          $$WakeChecksTableAnnotationComposer,
          $$WakeChecksTableCreateCompanionBuilder,
          $$WakeChecksTableUpdateCompanionBuilder,
          (WakeCheck, $$WakeChecksTableReferences),
          WakeCheck,
          PrefetchHooks Function({bool wakeSessionId})
        > {
  $$WakeChecksTableTableManager(_$AppDatabase db, $WakeChecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WakeChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WakeChecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WakeChecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wakeSessionId = const Value.absent(),
                Value<int> attemptNumber = const Value.absent(),
                Value<int> scheduledForMs = const Value.absent(),
                Value<int?> triggeredAtMs = const Value.absent(),
                Value<int?> firstInteractionAtMs = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WakeChecksCompanion(
                id: id,
                wakeSessionId: wakeSessionId,
                attemptNumber: attemptNumber,
                scheduledForMs: scheduledForMs,
                triggeredAtMs: triggeredAtMs,
                firstInteractionAtMs: firstInteractionAtMs,
                completedAtMs: completedAtMs,
                status: status,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wakeSessionId,
                required int attemptNumber,
                required int scheduledForMs,
                Value<int?> triggeredAtMs = const Value.absent(),
                Value<int?> firstInteractionAtMs = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                required String status,
                required int createdAtMs,
                Value<int> rowid = const Value.absent(),
              }) => WakeChecksCompanion.insert(
                id: id,
                wakeSessionId: wakeSessionId,
                attemptNumber: attemptNumber,
                scheduledForMs: scheduledForMs,
                triggeredAtMs: triggeredAtMs,
                firstInteractionAtMs: firstInteractionAtMs,
                completedAtMs: completedAtMs,
                status: status,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WakeChecksTable, WakeCheck>(table),
                  $$WakeChecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wakeSessionId = false}) {
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
                    if (wakeSessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wakeSessionId,
                        referencedTable: $$WakeChecksTableReferences
                            ._wakeSessionIdTable(db),
                        referencedColumn: $$WakeChecksTableReferences
                            ._wakeSessionIdTable(db)
                            .id,
                      ) as T;
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

typedef $$WakeChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WakeChecksTable,
      WakeCheck,
      $$WakeChecksTableFilterComposer,
      $$WakeChecksTableOrderingComposer,
      $$WakeChecksTableAnnotationComposer,
      $$WakeChecksTableCreateCompanionBuilder,
      $$WakeChecksTableUpdateCompanionBuilder,
      (WakeCheck, $$WakeChecksTableReferences),
      WakeCheck,
      PrefetchHooks Function({bool wakeSessionId})
    >;
typedef $$WakeProtocolsTableCreateCompanionBuilder =
    WakeProtocolsCompanion Function({
      required String id,
      required String alarmId,
      required int version,
      required String source,
      required String status,
      required String initialSoundId,
      Value<String?> initialSoundFamily,
      required String ringtoneUri,
      required int initialVolumePercent,
      required int maxVolumePercent,
      required bool volumeEscalationEnabled,
      required int volumeEscalationStepPercent,
      required int volumeEscalationIntervalSeconds,
      required bool vibrationEnabled,
      required String vibrationPattern,
      required bool vibrationEscalationEnabled,
      required bool missionRequired,
      Value<String?> missionType,
      Value<String?> missionDifficulty,
      Value<String> missionConfigurationJson,
      required bool wakeCheckRequired,
      required int wakeCheckDelayMinutes,
      required int wakeCheckHoldMilliseconds,
      required int maxWakeCheckFailures,
      required String reactivationSoundPolicy,
      required int intensityLevel,
      required String reasonCode,
      required String technicalExplanation,
      required String userExplanation,
      Value<String?> basedOnSessionId,
      Value<String?> supersedesProtocolId,
      Value<String> settingsSnapshotJson,
      required int createdAtMs,
      required int effectiveFromMs,
      Value<int> rowid,
    });
typedef $$WakeProtocolsTableUpdateCompanionBuilder =
    WakeProtocolsCompanion Function({
      Value<String> id,
      Value<String> alarmId,
      Value<int> version,
      Value<String> source,
      Value<String> status,
      Value<String> initialSoundId,
      Value<String?> initialSoundFamily,
      Value<String> ringtoneUri,
      Value<int> initialVolumePercent,
      Value<int> maxVolumePercent,
      Value<bool> volumeEscalationEnabled,
      Value<int> volumeEscalationStepPercent,
      Value<int> volumeEscalationIntervalSeconds,
      Value<bool> vibrationEnabled,
      Value<String> vibrationPattern,
      Value<bool> vibrationEscalationEnabled,
      Value<bool> missionRequired,
      Value<String?> missionType,
      Value<String?> missionDifficulty,
      Value<String> missionConfigurationJson,
      Value<bool> wakeCheckRequired,
      Value<int> wakeCheckDelayMinutes,
      Value<int> wakeCheckHoldMilliseconds,
      Value<int> maxWakeCheckFailures,
      Value<String> reactivationSoundPolicy,
      Value<int> intensityLevel,
      Value<String> reasonCode,
      Value<String> technicalExplanation,
      Value<String> userExplanation,
      Value<String?> basedOnSessionId,
      Value<String?> supersedesProtocolId,
      Value<String> settingsSnapshotJson,
      Value<int> createdAtMs,
      Value<int> effectiveFromMs,
      Value<int> rowid,
    });

final class $$WakeProtocolsTableReferences
    extends BaseReferences<_$AppDatabase, $WakeProtocolsTable, WakeProtocol> {
  $$WakeProtocolsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AlarmsTable _alarmIdTable(_$AppDatabase db) =>
      db.alarms.createAlias('wake_protocols__alarm_id__alarms__id');

  $$AlarmsTableProcessedTableManager get alarmId {
    final $_column = $_itemColumn<String>('alarm_id')!;

    final manager = $$AlarmsTableTableManager(
      $_db,
      $_db.alarms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alarmIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ProtocolEvaluationsTable,
    List<ProtocolEvaluation>
  >
  _protocolEvaluationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.protocolEvaluations,
        aliasName: 'wake_protocols__id__protocol_evaluations__protocol_id',
      );

  $$ProtocolEvaluationsTableProcessedTableManager get protocolEvaluationsRefs {
    final manager = $$ProtocolEvaluationsTableTableManager(
      $_db,
      $_db.protocolEvaluations,
    ).filter((f) => f.protocolId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _protocolEvaluationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WakeProtocolsTableFilterComposer
    extends Composer<_$AppDatabase, $WakeProtocolsTable> {
  $$WakeProtocolsTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialSoundId => $composableBuilder(
    column: $table.initialSoundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialSoundFamily => $composableBuilder(
    column: $table.initialSoundFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ringtoneUri => $composableBuilder(
    column: $table.ringtoneUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialVolumePercent => $composableBuilder(
    column: $table.initialVolumePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxVolumePercent => $composableBuilder(
    column: $table.maxVolumePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get volumeEscalationEnabled => $composableBuilder(
    column: $table.volumeEscalationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volumeEscalationStepPercent => $composableBuilder(
    column: $table.volumeEscalationStepPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volumeEscalationIntervalSeconds => $composableBuilder(
    column: $table.volumeEscalationIntervalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vibrationPattern => $composableBuilder(
    column: $table.vibrationPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrationEscalationEnabled => $composableBuilder(
    column: $table.vibrationEscalationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get missionRequired => $composableBuilder(
    column: $table.missionRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missionDifficulty => $composableBuilder(
    column: $table.missionDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missionConfigurationJson => $composableBuilder(
    column: $table.missionConfigurationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wakeCheckRequired => $composableBuilder(
    column: $table.wakeCheckRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeCheckDelayMinutes => $composableBuilder(
    column: $table.wakeCheckDelayMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeCheckHoldMilliseconds => $composableBuilder(
    column: $table.wakeCheckHoldMilliseconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxWakeCheckFailures => $composableBuilder(
    column: $table.maxWakeCheckFailures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reactivationSoundPolicy => $composableBuilder(
    column: $table.reactivationSoundPolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensityLevel => $composableBuilder(
    column: $table.intensityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technicalExplanation => $composableBuilder(
    column: $table.technicalExplanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userExplanation => $composableBuilder(
    column: $table.userExplanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get basedOnSessionId => $composableBuilder(
    column: $table.basedOnSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supersedesProtocolId => $composableBuilder(
    column: $table.supersedesProtocolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingsSnapshotJson => $composableBuilder(
    column: $table.settingsSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effectiveFromMs => $composableBuilder(
    column: $table.effectiveFromMs,
    builder: (column) => ColumnFilters(column),
  );

  $$AlarmsTableFilterComposer get alarmId {
    final $$AlarmsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableFilterComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> protocolEvaluationsRefs(
    Expression<bool> Function($$ProtocolEvaluationsTableFilterComposer f) f,
  ) {
    final $$ProtocolEvaluationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.protocolEvaluations,
      getReferencedColumn: (t) => t.protocolId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProtocolEvaluationsTableFilterComposer(
            $db: $db,
            $table: $db.protocolEvaluations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WakeProtocolsTableOrderingComposer
    extends Composer<_$AppDatabase, $WakeProtocolsTable> {
  $$WakeProtocolsTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialSoundId => $composableBuilder(
    column: $table.initialSoundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialSoundFamily => $composableBuilder(
    column: $table.initialSoundFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ringtoneUri => $composableBuilder(
    column: $table.ringtoneUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialVolumePercent => $composableBuilder(
    column: $table.initialVolumePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxVolumePercent => $composableBuilder(
    column: $table.maxVolumePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get volumeEscalationEnabled => $composableBuilder(
    column: $table.volumeEscalationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volumeEscalationStepPercent => $composableBuilder(
    column: $table.volumeEscalationStepPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volumeEscalationIntervalSeconds =>
      $composableBuilder(
        column: $table.volumeEscalationIntervalSeconds,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vibrationPattern => $composableBuilder(
    column: $table.vibrationPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrationEscalationEnabled => $composableBuilder(
    column: $table.vibrationEscalationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get missionRequired => $composableBuilder(
    column: $table.missionRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missionDifficulty => $composableBuilder(
    column: $table.missionDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missionConfigurationJson => $composableBuilder(
    column: $table.missionConfigurationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wakeCheckRequired => $composableBuilder(
    column: $table.wakeCheckRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeCheckDelayMinutes => $composableBuilder(
    column: $table.wakeCheckDelayMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeCheckHoldMilliseconds => $composableBuilder(
    column: $table.wakeCheckHoldMilliseconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxWakeCheckFailures => $composableBuilder(
    column: $table.maxWakeCheckFailures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reactivationSoundPolicy => $composableBuilder(
    column: $table.reactivationSoundPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensityLevel => $composableBuilder(
    column: $table.intensityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technicalExplanation => $composableBuilder(
    column: $table.technicalExplanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userExplanation => $composableBuilder(
    column: $table.userExplanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get basedOnSessionId => $composableBuilder(
    column: $table.basedOnSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supersedesProtocolId => $composableBuilder(
    column: $table.supersedesProtocolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingsSnapshotJson => $composableBuilder(
    column: $table.settingsSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effectiveFromMs => $composableBuilder(
    column: $table.effectiveFromMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$AlarmsTableOrderingComposer get alarmId {
    final $$AlarmsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableOrderingComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WakeProtocolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WakeProtocolsTable> {
  $$WakeProtocolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get initialSoundId => $composableBuilder(
    column: $table.initialSoundId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initialSoundFamily => $composableBuilder(
    column: $table.initialSoundFamily,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ringtoneUri => $composableBuilder(
    column: $table.ringtoneUri,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initialVolumePercent => $composableBuilder(
    column: $table.initialVolumePercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxVolumePercent => $composableBuilder(
    column: $table.maxVolumePercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get volumeEscalationEnabled => $composableBuilder(
    column: $table.volumeEscalationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get volumeEscalationStepPercent => $composableBuilder(
    column: $table.volumeEscalationStepPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get volumeEscalationIntervalSeconds =>
      $composableBuilder(
        column: $table.volumeEscalationIntervalSeconds,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get vibrationEnabled => $composableBuilder(
    column: $table.vibrationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vibrationPattern => $composableBuilder(
    column: $table.vibrationPattern,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vibrationEscalationEnabled => $composableBuilder(
    column: $table.vibrationEscalationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get missionRequired => $composableBuilder(
    column: $table.missionRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get missionType => $composableBuilder(
    column: $table.missionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get missionDifficulty => $composableBuilder(
    column: $table.missionDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get missionConfigurationJson => $composableBuilder(
    column: $table.missionConfigurationJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wakeCheckRequired => $composableBuilder(
    column: $table.wakeCheckRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wakeCheckDelayMinutes => $composableBuilder(
    column: $table.wakeCheckDelayMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wakeCheckHoldMilliseconds => $composableBuilder(
    column: $table.wakeCheckHoldMilliseconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxWakeCheckFailures => $composableBuilder(
    column: $table.maxWakeCheckFailures,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reactivationSoundPolicy => $composableBuilder(
    column: $table.reactivationSoundPolicy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intensityLevel => $composableBuilder(
    column: $table.intensityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get technicalExplanation => $composableBuilder(
    column: $table.technicalExplanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userExplanation => $composableBuilder(
    column: $table.userExplanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get basedOnSessionId => $composableBuilder(
    column: $table.basedOnSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supersedesProtocolId => $composableBuilder(
    column: $table.supersedesProtocolId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingsSnapshotJson => $composableBuilder(
    column: $table.settingsSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get effectiveFromMs => $composableBuilder(
    column: $table.effectiveFromMs,
    builder: (column) => column,
  );

  $$AlarmsTableAnnotationComposer get alarmId {
    final $$AlarmsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableAnnotationComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> protocolEvaluationsRefs<T extends Object>(
    Expression<T> Function($$ProtocolEvaluationsTableAnnotationComposer a) f,
  ) {
    final $$ProtocolEvaluationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.protocolEvaluations,
          getReferencedColumn: (t) => t.protocolId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProtocolEvaluationsTableAnnotationComposer(
                $db: $db,
                $table: $db.protocolEvaluations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WakeProtocolsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WakeProtocolsTable,
          WakeProtocol,
          $$WakeProtocolsTableFilterComposer,
          $$WakeProtocolsTableOrderingComposer,
          $$WakeProtocolsTableAnnotationComposer,
          $$WakeProtocolsTableCreateCompanionBuilder,
          $$WakeProtocolsTableUpdateCompanionBuilder,
          (WakeProtocol, $$WakeProtocolsTableReferences),
          WakeProtocol,
          PrefetchHooks Function({bool alarmId, bool protocolEvaluationsRefs})
        > {
  $$WakeProtocolsTableTableManager(_$AppDatabase db, $WakeProtocolsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WakeProtocolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WakeProtocolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WakeProtocolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> alarmId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> initialSoundId = const Value.absent(),
                Value<String?> initialSoundFamily = const Value.absent(),
                Value<String> ringtoneUri = const Value.absent(),
                Value<int> initialVolumePercent = const Value.absent(),
                Value<int> maxVolumePercent = const Value.absent(),
                Value<bool> volumeEscalationEnabled = const Value.absent(),
                Value<int> volumeEscalationStepPercent = const Value.absent(),
                Value<int> volumeEscalationIntervalSeconds =
                    const Value.absent(),
                Value<bool> vibrationEnabled = const Value.absent(),
                Value<String> vibrationPattern = const Value.absent(),
                Value<bool> vibrationEscalationEnabled = const Value.absent(),
                Value<bool> missionRequired = const Value.absent(),
                Value<String?> missionType = const Value.absent(),
                Value<String?> missionDifficulty = const Value.absent(),
                Value<String> missionConfigurationJson = const Value.absent(),
                Value<bool> wakeCheckRequired = const Value.absent(),
                Value<int> wakeCheckDelayMinutes = const Value.absent(),
                Value<int> wakeCheckHoldMilliseconds = const Value.absent(),
                Value<int> maxWakeCheckFailures = const Value.absent(),
                Value<String> reactivationSoundPolicy = const Value.absent(),
                Value<int> intensityLevel = const Value.absent(),
                Value<String> reasonCode = const Value.absent(),
                Value<String> technicalExplanation = const Value.absent(),
                Value<String> userExplanation = const Value.absent(),
                Value<String?> basedOnSessionId = const Value.absent(),
                Value<String?> supersedesProtocolId = const Value.absent(),
                Value<String> settingsSnapshotJson = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> effectiveFromMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WakeProtocolsCompanion(
                id: id,
                alarmId: alarmId,
                version: version,
                source: source,
                status: status,
                initialSoundId: initialSoundId,
                initialSoundFamily: initialSoundFamily,
                ringtoneUri: ringtoneUri,
                initialVolumePercent: initialVolumePercent,
                maxVolumePercent: maxVolumePercent,
                volumeEscalationEnabled: volumeEscalationEnabled,
                volumeEscalationStepPercent: volumeEscalationStepPercent,
                volumeEscalationIntervalSeconds:
                    volumeEscalationIntervalSeconds,
                vibrationEnabled: vibrationEnabled,
                vibrationPattern: vibrationPattern,
                vibrationEscalationEnabled: vibrationEscalationEnabled,
                missionRequired: missionRequired,
                missionType: missionType,
                missionDifficulty: missionDifficulty,
                missionConfigurationJson: missionConfigurationJson,
                wakeCheckRequired: wakeCheckRequired,
                wakeCheckDelayMinutes: wakeCheckDelayMinutes,
                wakeCheckHoldMilliseconds: wakeCheckHoldMilliseconds,
                maxWakeCheckFailures: maxWakeCheckFailures,
                reactivationSoundPolicy: reactivationSoundPolicy,
                intensityLevel: intensityLevel,
                reasonCode: reasonCode,
                technicalExplanation: technicalExplanation,
                userExplanation: userExplanation,
                basedOnSessionId: basedOnSessionId,
                supersedesProtocolId: supersedesProtocolId,
                settingsSnapshotJson: settingsSnapshotJson,
                createdAtMs: createdAtMs,
                effectiveFromMs: effectiveFromMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String alarmId,
                required int version,
                required String source,
                required String status,
                required String initialSoundId,
                Value<String?> initialSoundFamily = const Value.absent(),
                required String ringtoneUri,
                required int initialVolumePercent,
                required int maxVolumePercent,
                required bool volumeEscalationEnabled,
                required int volumeEscalationStepPercent,
                required int volumeEscalationIntervalSeconds,
                required bool vibrationEnabled,
                required String vibrationPattern,
                required bool vibrationEscalationEnabled,
                required bool missionRequired,
                Value<String?> missionType = const Value.absent(),
                Value<String?> missionDifficulty = const Value.absent(),
                Value<String> missionConfigurationJson = const Value.absent(),
                required bool wakeCheckRequired,
                required int wakeCheckDelayMinutes,
                required int wakeCheckHoldMilliseconds,
                required int maxWakeCheckFailures,
                required String reactivationSoundPolicy,
                required int intensityLevel,
                required String reasonCode,
                required String technicalExplanation,
                required String userExplanation,
                Value<String?> basedOnSessionId = const Value.absent(),
                Value<String?> supersedesProtocolId = const Value.absent(),
                Value<String> settingsSnapshotJson = const Value.absent(),
                required int createdAtMs,
                required int effectiveFromMs,
                Value<int> rowid = const Value.absent(),
              }) => WakeProtocolsCompanion.insert(
                id: id,
                alarmId: alarmId,
                version: version,
                source: source,
                status: status,
                initialSoundId: initialSoundId,
                initialSoundFamily: initialSoundFamily,
                ringtoneUri: ringtoneUri,
                initialVolumePercent: initialVolumePercent,
                maxVolumePercent: maxVolumePercent,
                volumeEscalationEnabled: volumeEscalationEnabled,
                volumeEscalationStepPercent: volumeEscalationStepPercent,
                volumeEscalationIntervalSeconds:
                    volumeEscalationIntervalSeconds,
                vibrationEnabled: vibrationEnabled,
                vibrationPattern: vibrationPattern,
                vibrationEscalationEnabled: vibrationEscalationEnabled,
                missionRequired: missionRequired,
                missionType: missionType,
                missionDifficulty: missionDifficulty,
                missionConfigurationJson: missionConfigurationJson,
                wakeCheckRequired: wakeCheckRequired,
                wakeCheckDelayMinutes: wakeCheckDelayMinutes,
                wakeCheckHoldMilliseconds: wakeCheckHoldMilliseconds,
                maxWakeCheckFailures: maxWakeCheckFailures,
                reactivationSoundPolicy: reactivationSoundPolicy,
                intensityLevel: intensityLevel,
                reasonCode: reasonCode,
                technicalExplanation: technicalExplanation,
                userExplanation: userExplanation,
                basedOnSessionId: basedOnSessionId,
                supersedesProtocolId: supersedesProtocolId,
                settingsSnapshotJson: settingsSnapshotJson,
                createdAtMs: createdAtMs,
                effectiveFromMs: effectiveFromMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WakeProtocolsTable, WakeProtocol>(table),
                  $$WakeProtocolsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({alarmId = false, protocolEvaluationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (protocolEvaluationsRefs) db.protocolEvaluations,
                  ],
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
                        if (alarmId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.alarmId,
                            referencedTable: $$WakeProtocolsTableReferences
                                ._alarmIdTable(db),
                            referencedColumn: $$WakeProtocolsTableReferences
                                ._alarmIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (protocolEvaluationsRefs)
                        await $_getPrefetchedData<
                          WakeProtocol,
                          $WakeProtocolsTable,
                          ProtocolEvaluation
                        >(
                          currentTable: table,
                          referencedTable: $$WakeProtocolsTableReferences
                              ._protocolEvaluationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WakeProtocolsTableReferences(
                                db,
                                table,
                                p0,
                              ).protocolEvaluationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.protocolId == item.id,
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

typedef $$WakeProtocolsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WakeProtocolsTable,
      WakeProtocol,
      $$WakeProtocolsTableFilterComposer,
      $$WakeProtocolsTableOrderingComposer,
      $$WakeProtocolsTableAnnotationComposer,
      $$WakeProtocolsTableCreateCompanionBuilder,
      $$WakeProtocolsTableUpdateCompanionBuilder,
      (WakeProtocol, $$WakeProtocolsTableReferences),
      WakeProtocol,
      PrefetchHooks Function({bool alarmId, bool protocolEvaluationsRefs})
    >;
typedef $$ProtocolEvaluationsTableCreateCompanionBuilder =
    ProtocolEvaluationsCompanion Function({
      required String id,
      required String protocolId,
      required String wakeSessionId,
      required String result,
      required String primaryFailureMode,
      required String analysisJson,
      Value<String?> selectedRuleId,
      Value<String> ruleTraceJson,
      Value<String> changesJson,
      Value<int?> performanceScore,
      Value<int?> scoreVersion,
      Value<String> evaluationNotes,
      required int createdAtMs,
      Value<int> rowid,
    });
typedef $$ProtocolEvaluationsTableUpdateCompanionBuilder =
    ProtocolEvaluationsCompanion Function({
      Value<String> id,
      Value<String> protocolId,
      Value<String> wakeSessionId,
      Value<String> result,
      Value<String> primaryFailureMode,
      Value<String> analysisJson,
      Value<String?> selectedRuleId,
      Value<String> ruleTraceJson,
      Value<String> changesJson,
      Value<int?> performanceScore,
      Value<int?> scoreVersion,
      Value<String> evaluationNotes,
      Value<int> createdAtMs,
      Value<int> rowid,
    });

final class $$ProtocolEvaluationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProtocolEvaluationsTable,
          ProtocolEvaluation
        > {
  $$ProtocolEvaluationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WakeProtocolsTable _protocolIdTable(_$AppDatabase db) => db
      .wakeProtocols
      .createAlias('protocol_evaluations__protocol_id__wake_protocols__id');

  $$WakeProtocolsTableProcessedTableManager get protocolId {
    final $_column = $_itemColumn<String>('protocol_id')!;

    final manager = $$WakeProtocolsTableTableManager(
      $_db,
      $_db.wakeProtocols,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_protocolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WakeSessionsTable _wakeSessionIdTable(_$AppDatabase db) => db
      .wakeSessions
      .createAlias('protocol_evaluations__wake_session_id__wake_sessions__id');

  $$WakeSessionsTableProcessedTableManager get wakeSessionId {
    final $_column = $_itemColumn<String>('wake_session_id')!;

    final manager = $$WakeSessionsTableTableManager(
      $_db,
      $_db.wakeSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wakeSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProtocolEvaluationsTableFilterComposer
    extends Composer<_$AppDatabase, $ProtocolEvaluationsTable> {
  $$ProtocolEvaluationsTableFilterComposer({
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

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryFailureMode => $composableBuilder(
    column: $table.primaryFailureMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get analysisJson => $composableBuilder(
    column: $table.analysisJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedRuleId => $composableBuilder(
    column: $table.selectedRuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleTraceJson => $composableBuilder(
    column: $table.ruleTraceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get performanceScore => $composableBuilder(
    column: $table.performanceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scoreVersion => $composableBuilder(
    column: $table.scoreVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evaluationNotes => $composableBuilder(
    column: $table.evaluationNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$WakeProtocolsTableFilterComposer get protocolId {
    final $$WakeProtocolsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.protocolId,
      referencedTable: $db.wakeProtocols,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeProtocolsTableFilterComposer(
            $db: $db,
            $table: $db.wakeProtocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WakeSessionsTableFilterComposer get wakeSessionId {
    final $$WakeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProtocolEvaluationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProtocolEvaluationsTable> {
  $$ProtocolEvaluationsTableOrderingComposer({
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

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryFailureMode => $composableBuilder(
    column: $table.primaryFailureMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysisJson => $composableBuilder(
    column: $table.analysisJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedRuleId => $composableBuilder(
    column: $table.selectedRuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleTraceJson => $composableBuilder(
    column: $table.ruleTraceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get performanceScore => $composableBuilder(
    column: $table.performanceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoreVersion => $composableBuilder(
    column: $table.scoreVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evaluationNotes => $composableBuilder(
    column: $table.evaluationNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$WakeProtocolsTableOrderingComposer get protocolId {
    final $$WakeProtocolsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.protocolId,
      referencedTable: $db.wakeProtocols,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeProtocolsTableOrderingComposer(
            $db: $db,
            $table: $db.wakeProtocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WakeSessionsTableOrderingComposer get wakeSessionId {
    final $$WakeSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProtocolEvaluationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProtocolEvaluationsTable> {
  $$ProtocolEvaluationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get primaryFailureMode => $composableBuilder(
    column: $table.primaryFailureMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get analysisJson => $composableBuilder(
    column: $table.analysisJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedRuleId => $composableBuilder(
    column: $table.selectedRuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ruleTraceJson => $composableBuilder(
    column: $table.ruleTraceJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get performanceScore => $composableBuilder(
    column: $table.performanceScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scoreVersion => $composableBuilder(
    column: $table.scoreVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evaluationNotes => $composableBuilder(
    column: $table.evaluationNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  $$WakeProtocolsTableAnnotationComposer get protocolId {
    final $$WakeProtocolsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.protocolId,
      referencedTable: $db.wakeProtocols,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeProtocolsTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeProtocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WakeSessionsTableAnnotationComposer get wakeSessionId {
    final $$WakeSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wakeSessionId,
      referencedTable: $db.wakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProtocolEvaluationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProtocolEvaluationsTable,
          ProtocolEvaluation,
          $$ProtocolEvaluationsTableFilterComposer,
          $$ProtocolEvaluationsTableOrderingComposer,
          $$ProtocolEvaluationsTableAnnotationComposer,
          $$ProtocolEvaluationsTableCreateCompanionBuilder,
          $$ProtocolEvaluationsTableUpdateCompanionBuilder,
          (ProtocolEvaluation, $$ProtocolEvaluationsTableReferences),
          ProtocolEvaluation,
          PrefetchHooks Function({bool protocolId, bool wakeSessionId})
        > {
  $$ProtocolEvaluationsTableTableManager(
    _$AppDatabase db,
    $ProtocolEvaluationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProtocolEvaluationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProtocolEvaluationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProtocolEvaluationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> protocolId = const Value.absent(),
                Value<String> wakeSessionId = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String> primaryFailureMode = const Value.absent(),
                Value<String> analysisJson = const Value.absent(),
                Value<String?> selectedRuleId = const Value.absent(),
                Value<String> ruleTraceJson = const Value.absent(),
                Value<String> changesJson = const Value.absent(),
                Value<int?> performanceScore = const Value.absent(),
                Value<int?> scoreVersion = const Value.absent(),
                Value<String> evaluationNotes = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProtocolEvaluationsCompanion(
                id: id,
                protocolId: protocolId,
                wakeSessionId: wakeSessionId,
                result: result,
                primaryFailureMode: primaryFailureMode,
                analysisJson: analysisJson,
                selectedRuleId: selectedRuleId,
                ruleTraceJson: ruleTraceJson,
                changesJson: changesJson,
                performanceScore: performanceScore,
                scoreVersion: scoreVersion,
                evaluationNotes: evaluationNotes,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String protocolId,
                required String wakeSessionId,
                required String result,
                required String primaryFailureMode,
                required String analysisJson,
                Value<String?> selectedRuleId = const Value.absent(),
                Value<String> ruleTraceJson = const Value.absent(),
                Value<String> changesJson = const Value.absent(),
                Value<int?> performanceScore = const Value.absent(),
                Value<int?> scoreVersion = const Value.absent(),
                Value<String> evaluationNotes = const Value.absent(),
                required int createdAtMs,
                Value<int> rowid = const Value.absent(),
              }) => ProtocolEvaluationsCompanion.insert(
                id: id,
                protocolId: protocolId,
                wakeSessionId: wakeSessionId,
                result: result,
                primaryFailureMode: primaryFailureMode,
                analysisJson: analysisJson,
                selectedRuleId: selectedRuleId,
                ruleTraceJson: ruleTraceJson,
                changesJson: changesJson,
                performanceScore: performanceScore,
                scoreVersion: scoreVersion,
                evaluationNotes: evaluationNotes,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProtocolEvaluationsTable, ProtocolEvaluation>(
                    table,
                  ),
                  $$ProtocolEvaluationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({protocolId = false, wakeSessionId = false}) {
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
                    if (protocolId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.protocolId,
                        referencedTable: $$ProtocolEvaluationsTableReferences
                            ._protocolIdTable(db),
                        referencedColumn: $$ProtocolEvaluationsTableReferences
                            ._protocolIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (wakeSessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wakeSessionId,
                        referencedTable: $$ProtocolEvaluationsTableReferences
                            ._wakeSessionIdTable(db),
                        referencedColumn: $$ProtocolEvaluationsTableReferences
                            ._wakeSessionIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ProtocolEvaluationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProtocolEvaluationsTable,
      ProtocolEvaluation,
      $$ProtocolEvaluationsTableFilterComposer,
      $$ProtocolEvaluationsTableOrderingComposer,
      $$ProtocolEvaluationsTableAnnotationComposer,
      $$ProtocolEvaluationsTableCreateCompanionBuilder,
      $$ProtocolEvaluationsTableUpdateCompanionBuilder,
      (ProtocolEvaluation, $$ProtocolEvaluationsTableReferences),
      ProtocolEvaluation,
      PrefetchHooks Function({bool protocolId, bool wakeSessionId})
    >;
typedef $$AlarmAdaptationSettingsTableCreateCompanionBuilder =
    AlarmAdaptationSettingsCompanion Function({
      required String alarmId,
      Value<bool> enabled,
      Value<bool> adaptSound,
      Value<bool> adaptVolume,
      Value<bool> adaptVibration,
      Value<bool> adaptWakeCheck,
      Value<bool> adaptMission,
      Value<int> userMaxVolumePercent,
      required int updatedAtMs,
      Value<int> rowid,
    });
typedef $$AlarmAdaptationSettingsTableUpdateCompanionBuilder =
    AlarmAdaptationSettingsCompanion Function({
      Value<String> alarmId,
      Value<bool> enabled,
      Value<bool> adaptSound,
      Value<bool> adaptVolume,
      Value<bool> adaptVibration,
      Value<bool> adaptWakeCheck,
      Value<bool> adaptMission,
      Value<int> userMaxVolumePercent,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });

final class $$AlarmAdaptationSettingsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AlarmAdaptationSettingsTable,
          AlarmAdaptationSetting
        > {
  $$AlarmAdaptationSettingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AlarmsTable _alarmIdTable(_$AppDatabase db) =>
      db.alarms.createAlias('alarm_adaptation_settings__alarm_id__alarms__id');

  $$AlarmsTableProcessedTableManager get alarmId {
    final $_column = $_itemColumn<String>('alarm_id')!;

    final manager = $$AlarmsTableTableManager(
      $_db,
      $_db.alarms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alarmIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AlarmAdaptationSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmAdaptationSettingsTable> {
  $$AlarmAdaptationSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adaptSound => $composableBuilder(
    column: $table.adaptSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adaptVolume => $composableBuilder(
    column: $table.adaptVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adaptVibration => $composableBuilder(
    column: $table.adaptVibration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adaptWakeCheck => $composableBuilder(
    column: $table.adaptWakeCheck,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adaptMission => $composableBuilder(
    column: $table.adaptMission,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userMaxVolumePercent => $composableBuilder(
    column: $table.userMaxVolumePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$AlarmsTableFilterComposer get alarmId {
    final $$AlarmsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableFilterComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlarmAdaptationSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmAdaptationSettingsTable> {
  $$AlarmAdaptationSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adaptSound => $composableBuilder(
    column: $table.adaptSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adaptVolume => $composableBuilder(
    column: $table.adaptVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adaptVibration => $composableBuilder(
    column: $table.adaptVibration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adaptWakeCheck => $composableBuilder(
    column: $table.adaptWakeCheck,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adaptMission => $composableBuilder(
    column: $table.adaptMission,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userMaxVolumePercent => $composableBuilder(
    column: $table.userMaxVolumePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$AlarmsTableOrderingComposer get alarmId {
    final $$AlarmsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableOrderingComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlarmAdaptationSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmAdaptationSettingsTable> {
  $$AlarmAdaptationSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get adaptSound => $composableBuilder(
    column: $table.adaptSound,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adaptVolume => $composableBuilder(
    column: $table.adaptVolume,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adaptVibration => $composableBuilder(
    column: $table.adaptVibration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adaptWakeCheck => $composableBuilder(
    column: $table.adaptWakeCheck,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adaptMission => $composableBuilder(
    column: $table.adaptMission,
    builder: (column) => column,
  );

  GeneratedColumn<int> get userMaxVolumePercent => $composableBuilder(
    column: $table.userMaxVolumePercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  $$AlarmsTableAnnotationComposer get alarmId {
    final $$AlarmsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alarmId,
      referencedTable: $db.alarms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlarmsTableAnnotationComposer(
            $db: $db,
            $table: $db.alarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlarmAdaptationSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmAdaptationSettingsTable,
          AlarmAdaptationSetting,
          $$AlarmAdaptationSettingsTableFilterComposer,
          $$AlarmAdaptationSettingsTableOrderingComposer,
          $$AlarmAdaptationSettingsTableAnnotationComposer,
          $$AlarmAdaptationSettingsTableCreateCompanionBuilder,
          $$AlarmAdaptationSettingsTableUpdateCompanionBuilder,
          (AlarmAdaptationSetting, $$AlarmAdaptationSettingsTableReferences),
          AlarmAdaptationSetting,
          PrefetchHooks Function({bool alarmId})
        > {
  $$AlarmAdaptationSettingsTableTableManager(
    _$AppDatabase db,
    $AlarmAdaptationSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmAdaptationSettingsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AlarmAdaptationSettingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AlarmAdaptationSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> alarmId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> adaptSound = const Value.absent(),
                Value<bool> adaptVolume = const Value.absent(),
                Value<bool> adaptVibration = const Value.absent(),
                Value<bool> adaptWakeCheck = const Value.absent(),
                Value<bool> adaptMission = const Value.absent(),
                Value<int> userMaxVolumePercent = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmAdaptationSettingsCompanion(
                alarmId: alarmId,
                enabled: enabled,
                adaptSound: adaptSound,
                adaptVolume: adaptVolume,
                adaptVibration: adaptVibration,
                adaptWakeCheck: adaptWakeCheck,
                adaptMission: adaptMission,
                userMaxVolumePercent: userMaxVolumePercent,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String alarmId,
                Value<bool> enabled = const Value.absent(),
                Value<bool> adaptSound = const Value.absent(),
                Value<bool> adaptVolume = const Value.absent(),
                Value<bool> adaptVibration = const Value.absent(),
                Value<bool> adaptWakeCheck = const Value.absent(),
                Value<bool> adaptMission = const Value.absent(),
                Value<int> userMaxVolumePercent = const Value.absent(),
                required int updatedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => AlarmAdaptationSettingsCompanion.insert(
                alarmId: alarmId,
                enabled: enabled,
                adaptSound: adaptSound,
                adaptVolume: adaptVolume,
                adaptVibration: adaptVibration,
                adaptWakeCheck: adaptWakeCheck,
                adaptMission: adaptMission,
                userMaxVolumePercent: userMaxVolumePercent,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AlarmAdaptationSettingsTable,
                    AlarmAdaptationSetting
                  >(table),
                  $$AlarmAdaptationSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({alarmId = false}) {
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
                    if (alarmId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.alarmId,
                        referencedTable:
                            $$AlarmAdaptationSettingsTableReferences
                                ._alarmIdTable(db),
                        referencedColumn:
                            $$AlarmAdaptationSettingsTableReferences
                                ._alarmIdTable(db)
                                .id,
                      ) as T;
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

typedef $$AlarmAdaptationSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmAdaptationSettingsTable,
      AlarmAdaptationSetting,
      $$AlarmAdaptationSettingsTableFilterComposer,
      $$AlarmAdaptationSettingsTableOrderingComposer,
      $$AlarmAdaptationSettingsTableAnnotationComposer,
      $$AlarmAdaptationSettingsTableCreateCompanionBuilder,
      $$AlarmAdaptationSettingsTableUpdateCompanionBuilder,
      (AlarmAdaptationSetting, $$AlarmAdaptationSettingsTableReferences),
      AlarmAdaptationSetting,
      PrefetchHooks Function({bool alarmId})
    >;
typedef $$WakeExperimentsTableCreateCompanionBuilder =
    WakeExperimentsCompanion Function({
      required String id,
      required String alarmId,
      required String name,
      required String hypothesis,
      required String status,
      required String dimension,
      required String controlProtocolId,
      required int controlProtocolVersion,
      required String controlSnapshotJson,
      required String candidateProtocolId,
      required int candidateProtocolVersion,
      required String candidateSnapshotJson,
      required String contextKey,
      required int minimumSessionsPerVariant,
      required int preferredSessionsPerVariant,
      required int maximumSessionsPerVariant,
      Value<String> result,
      Value<String> confidence,
      Value<String?> winnerProtocolId,
      Value<String?> invalidReason,
      Value<int?> startedAtMs,
      Value<int?> completedAtMs,
      required int createdAtMs,
      required int updatedAtMs,
      Value<int> rowid,
    });
typedef $$WakeExperimentsTableUpdateCompanionBuilder =
    WakeExperimentsCompanion Function({
      Value<String> id,
      Value<String> alarmId,
      Value<String> name,
      Value<String> hypothesis,
      Value<String> status,
      Value<String> dimension,
      Value<String> controlProtocolId,
      Value<int> controlProtocolVersion,
      Value<String> controlSnapshotJson,
      Value<String> candidateProtocolId,
      Value<int> candidateProtocolVersion,
      Value<String> candidateSnapshotJson,
      Value<String> contextKey,
      Value<int> minimumSessionsPerVariant,
      Value<int> preferredSessionsPerVariant,
      Value<int> maximumSessionsPerVariant,
      Value<String> result,
      Value<String> confidence,
      Value<String?> winnerProtocolId,
      Value<String?> invalidReason,
      Value<int?> startedAtMs,
      Value<int?> completedAtMs,
      Value<int> createdAtMs,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });

final class $$WakeExperimentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WakeExperimentsTable,
          WakeExperimentRow
        > {
  $$WakeExperimentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ExperimentSessionsTable,
    List<ExperimentSessionRow>
  >
  _experimentSessionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.experimentSessions,
        aliasName: 'wake_experiments__id__experiment_sessions__experiment_id',
      );

  $$ExperimentSessionsTableProcessedTableManager get experimentSessionsRefs {
    final manager = $$ExperimentSessionsTableTableManager(
      $_db,
      $_db.experimentSessions,
    ).filter((f) => f.experimentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _experimentSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExperimentAuditEventsTable,
    List<ExperimentAuditEventRow>
  >
  _experimentAuditEventsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.experimentAuditEvents,
        aliasName:
            'wake_experiments__id__experiment_audit_events__experiment_id',
      );

  $$ExperimentAuditEventsTableProcessedTableManager
  get experimentAuditEventsRefs {
    final manager = $$ExperimentAuditEventsTableTableManager(
      $_db,
      $_db.experimentAuditEvents,
    ).filter((f) => f.experimentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _experimentAuditEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WakeExperimentsTableFilterComposer
    extends Composer<_$AppDatabase, $WakeExperimentsTable> {
  $$WakeExperimentsTableFilterComposer({
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

  ColumnFilters<String> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hypothesis => $composableBuilder(
    column: $table.hypothesis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dimension => $composableBuilder(
    column: $table.dimension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get controlProtocolId => $composableBuilder(
    column: $table.controlProtocolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get controlProtocolVersion => $composableBuilder(
    column: $table.controlProtocolVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get controlSnapshotJson => $composableBuilder(
    column: $table.controlSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidateProtocolId => $composableBuilder(
    column: $table.candidateProtocolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get candidateProtocolVersion => $composableBuilder(
    column: $table.candidateProtocolVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidateSnapshotJson => $composableBuilder(
    column: $table.candidateSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextKey => $composableBuilder(
    column: $table.contextKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumSessionsPerVariant => $composableBuilder(
    column: $table.minimumSessionsPerVariant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preferredSessionsPerVariant => $composableBuilder(
    column: $table.preferredSessionsPerVariant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maximumSessionsPerVariant => $composableBuilder(
    column: $table.maximumSessionsPerVariant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get winnerProtocolId => $composableBuilder(
    column: $table.winnerProtocolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> experimentSessionsRefs(
    Expression<bool> Function($$ExperimentSessionsTableFilterComposer f) f,
  ) {
    final $$ExperimentSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.experimentSessions,
      getReferencedColumn: (t) => t.experimentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExperimentSessionsTableFilterComposer(
            $db: $db,
            $table: $db.experimentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> experimentAuditEventsRefs(
    Expression<bool> Function($$ExperimentAuditEventsTableFilterComposer f) f,
  ) {
    final $$ExperimentAuditEventsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.experimentAuditEvents,
          getReferencedColumn: (t) => t.experimentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExperimentAuditEventsTableFilterComposer(
                $db: $db,
                $table: $db.experimentAuditEvents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WakeExperimentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WakeExperimentsTable> {
  $$WakeExperimentsTableOrderingComposer({
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

  ColumnOrderings<String> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hypothesis => $composableBuilder(
    column: $table.hypothesis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dimension => $composableBuilder(
    column: $table.dimension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get controlProtocolId => $composableBuilder(
    column: $table.controlProtocolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get controlProtocolVersion => $composableBuilder(
    column: $table.controlProtocolVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get controlSnapshotJson => $composableBuilder(
    column: $table.controlSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidateProtocolId => $composableBuilder(
    column: $table.candidateProtocolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get candidateProtocolVersion => $composableBuilder(
    column: $table.candidateProtocolVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidateSnapshotJson => $composableBuilder(
    column: $table.candidateSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextKey => $composableBuilder(
    column: $table.contextKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumSessionsPerVariant => $composableBuilder(
    column: $table.minimumSessionsPerVariant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preferredSessionsPerVariant => $composableBuilder(
    column: $table.preferredSessionsPerVariant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maximumSessionsPerVariant => $composableBuilder(
    column: $table.maximumSessionsPerVariant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerProtocolId => $composableBuilder(
    column: $table.winnerProtocolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WakeExperimentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WakeExperimentsTable> {
  $$WakeExperimentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alarmId =>
      $composableBuilder(column: $table.alarmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get hypothesis => $composableBuilder(
    column: $table.hypothesis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dimension =>
      $composableBuilder(column: $table.dimension, builder: (column) => column);

  GeneratedColumn<String> get controlProtocolId => $composableBuilder(
    column: $table.controlProtocolId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get controlProtocolVersion => $composableBuilder(
    column: $table.controlProtocolVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get controlSnapshotJson => $composableBuilder(
    column: $table.controlSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get candidateProtocolId => $composableBuilder(
    column: $table.candidateProtocolId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get candidateProtocolVersion => $composableBuilder(
    column: $table.candidateProtocolVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get candidateSnapshotJson => $composableBuilder(
    column: $table.candidateSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextKey => $composableBuilder(
    column: $table.contextKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumSessionsPerVariant => $composableBuilder(
    column: $table.minimumSessionsPerVariant,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preferredSessionsPerVariant => $composableBuilder(
    column: $table.preferredSessionsPerVariant,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maximumSessionsPerVariant => $composableBuilder(
    column: $table.maximumSessionsPerVariant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get winnerProtocolId => $composableBuilder(
    column: $table.winnerProtocolId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  Expression<T> experimentSessionsRefs<T extends Object>(
    Expression<T> Function($$ExperimentSessionsTableAnnotationComposer a) f,
  ) {
    final $$ExperimentSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.experimentSessions,
          getReferencedColumn: (t) => t.experimentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExperimentSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.experimentSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> experimentAuditEventsRefs<T extends Object>(
    Expression<T> Function($$ExperimentAuditEventsTableAnnotationComposer a) f,
  ) {
    final $$ExperimentAuditEventsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.experimentAuditEvents,
          getReferencedColumn: (t) => t.experimentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExperimentAuditEventsTableAnnotationComposer(
                $db: $db,
                $table: $db.experimentAuditEvents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WakeExperimentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WakeExperimentsTable,
          WakeExperimentRow,
          $$WakeExperimentsTableFilterComposer,
          $$WakeExperimentsTableOrderingComposer,
          $$WakeExperimentsTableAnnotationComposer,
          $$WakeExperimentsTableCreateCompanionBuilder,
          $$WakeExperimentsTableUpdateCompanionBuilder,
          (WakeExperimentRow, $$WakeExperimentsTableReferences),
          WakeExperimentRow,
          PrefetchHooks Function({
            bool experimentSessionsRefs,
            bool experimentAuditEventsRefs,
          })
        > {
  $$WakeExperimentsTableTableManager(
    _$AppDatabase db,
    $WakeExperimentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WakeExperimentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WakeExperimentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WakeExperimentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> alarmId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> hypothesis = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> dimension = const Value.absent(),
                Value<String> controlProtocolId = const Value.absent(),
                Value<int> controlProtocolVersion = const Value.absent(),
                Value<String> controlSnapshotJson = const Value.absent(),
                Value<String> candidateProtocolId = const Value.absent(),
                Value<int> candidateProtocolVersion = const Value.absent(),
                Value<String> candidateSnapshotJson = const Value.absent(),
                Value<String> contextKey = const Value.absent(),
                Value<int> minimumSessionsPerVariant = const Value.absent(),
                Value<int> preferredSessionsPerVariant = const Value.absent(),
                Value<int> maximumSessionsPerVariant = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<String?> winnerProtocolId = const Value.absent(),
                Value<String?> invalidReason = const Value.absent(),
                Value<int?> startedAtMs = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WakeExperimentsCompanion(
                id: id,
                alarmId: alarmId,
                name: name,
                hypothesis: hypothesis,
                status: status,
                dimension: dimension,
                controlProtocolId: controlProtocolId,
                controlProtocolVersion: controlProtocolVersion,
                controlSnapshotJson: controlSnapshotJson,
                candidateProtocolId: candidateProtocolId,
                candidateProtocolVersion: candidateProtocolVersion,
                candidateSnapshotJson: candidateSnapshotJson,
                contextKey: contextKey,
                minimumSessionsPerVariant: minimumSessionsPerVariant,
                preferredSessionsPerVariant: preferredSessionsPerVariant,
                maximumSessionsPerVariant: maximumSessionsPerVariant,
                result: result,
                confidence: confidence,
                winnerProtocolId: winnerProtocolId,
                invalidReason: invalidReason,
                startedAtMs: startedAtMs,
                completedAtMs: completedAtMs,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String alarmId,
                required String name,
                required String hypothesis,
                required String status,
                required String dimension,
                required String controlProtocolId,
                required int controlProtocolVersion,
                required String controlSnapshotJson,
                required String candidateProtocolId,
                required int candidateProtocolVersion,
                required String candidateSnapshotJson,
                required String contextKey,
                required int minimumSessionsPerVariant,
                required int preferredSessionsPerVariant,
                required int maximumSessionsPerVariant,
                Value<String> result = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<String?> winnerProtocolId = const Value.absent(),
                Value<String?> invalidReason = const Value.absent(),
                Value<int?> startedAtMs = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                required int createdAtMs,
                required int updatedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => WakeExperimentsCompanion.insert(
                id: id,
                alarmId: alarmId,
                name: name,
                hypothesis: hypothesis,
                status: status,
                dimension: dimension,
                controlProtocolId: controlProtocolId,
                controlProtocolVersion: controlProtocolVersion,
                controlSnapshotJson: controlSnapshotJson,
                candidateProtocolId: candidateProtocolId,
                candidateProtocolVersion: candidateProtocolVersion,
                candidateSnapshotJson: candidateSnapshotJson,
                contextKey: contextKey,
                minimumSessionsPerVariant: minimumSessionsPerVariant,
                preferredSessionsPerVariant: preferredSessionsPerVariant,
                maximumSessionsPerVariant: maximumSessionsPerVariant,
                result: result,
                confidence: confidence,
                winnerProtocolId: winnerProtocolId,
                invalidReason: invalidReason,
                startedAtMs: startedAtMs,
                completedAtMs: completedAtMs,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WakeExperimentsTable, WakeExperimentRow>(table),
                  $$WakeExperimentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                experimentSessionsRefs = false,
                experimentAuditEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (experimentSessionsRefs) db.experimentSessions,
                    if (experimentAuditEventsRefs) db.experimentAuditEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (experimentSessionsRefs)
                        await $_getPrefetchedData<
                          WakeExperimentRow,
                          $WakeExperimentsTable,
                          ExperimentSessionRow
                        >(
                          currentTable: table,
                          referencedTable: $$WakeExperimentsTableReferences
                              ._experimentSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WakeExperimentsTableReferences(
                                db,
                                table,
                                p0,
                              ).experimentSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.experimentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (experimentAuditEventsRefs)
                        await $_getPrefetchedData<
                          WakeExperimentRow,
                          $WakeExperimentsTable,
                          ExperimentAuditEventRow
                        >(
                          currentTable: table,
                          referencedTable: $$WakeExperimentsTableReferences
                              ._experimentAuditEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WakeExperimentsTableReferences(
                                db,
                                table,
                                p0,
                              ).experimentAuditEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.experimentId == item.id,
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

typedef $$WakeExperimentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WakeExperimentsTable,
      WakeExperimentRow,
      $$WakeExperimentsTableFilterComposer,
      $$WakeExperimentsTableOrderingComposer,
      $$WakeExperimentsTableAnnotationComposer,
      $$WakeExperimentsTableCreateCompanionBuilder,
      $$WakeExperimentsTableUpdateCompanionBuilder,
      (WakeExperimentRow, $$WakeExperimentsTableReferences),
      WakeExperimentRow,
      PrefetchHooks Function({
        bool experimentSessionsRefs,
        bool experimentAuditEventsRefs,
      })
    >;
typedef $$ExperimentSessionsTableCreateCompanionBuilder =
    ExperimentSessionsCompanion Function({
      required String id,
      required String experimentId,
      required String alarmId,
      required int scheduledTimeMs,
      required int assignmentIndex,
      required String variant,
      required String protocolId,
      required int protocolVersion,
      required String contextKey,
      required int assignedAtMs,
      Value<String?> wakeSessionId,
      Value<int?> completedAtMs,
      Value<String> validity,
      Value<String?> invalidReason,
      Value<int> rowid,
    });
typedef $$ExperimentSessionsTableUpdateCompanionBuilder =
    ExperimentSessionsCompanion Function({
      Value<String> id,
      Value<String> experimentId,
      Value<String> alarmId,
      Value<int> scheduledTimeMs,
      Value<int> assignmentIndex,
      Value<String> variant,
      Value<String> protocolId,
      Value<int> protocolVersion,
      Value<String> contextKey,
      Value<int> assignedAtMs,
      Value<String?> wakeSessionId,
      Value<int?> completedAtMs,
      Value<String> validity,
      Value<String?> invalidReason,
      Value<int> rowid,
    });

final class $$ExperimentSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExperimentSessionsTable,
          ExperimentSessionRow
        > {
  $$ExperimentSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WakeExperimentsTable _experimentIdTable(_$AppDatabase db) => db
      .wakeExperiments
      .createAlias('experiment_sessions__experiment_id__wake_experiments__id');

  $$WakeExperimentsTableProcessedTableManager get experimentId {
    final $_column = $_itemColumn<String>('experiment_id')!;

    final manager = $$WakeExperimentsTableTableManager(
      $_db,
      $_db.wakeExperiments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_experimentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExperimentSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExperimentSessionsTable> {
  $$ExperimentSessionsTableFilterComposer({
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

  ColumnFilters<String> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledTimeMs => $composableBuilder(
    column: $table.scheduledTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignmentIndex => $composableBuilder(
    column: $table.assignmentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolId => $composableBuilder(
    column: $table.protocolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextKey => $composableBuilder(
    column: $table.contextKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignedAtMs => $composableBuilder(
    column: $table.assignedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wakeSessionId => $composableBuilder(
    column: $table.wakeSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validity => $composableBuilder(
    column: $table.validity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => ColumnFilters(column),
  );

  $$WakeExperimentsTableFilterComposer get experimentId {
    final $$WakeExperimentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.experimentId,
      referencedTable: $db.wakeExperiments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeExperimentsTableFilterComposer(
            $db: $db,
            $table: $db.wakeExperiments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExperimentSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExperimentSessionsTable> {
  $$ExperimentSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledTimeMs => $composableBuilder(
    column: $table.scheduledTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignmentIndex => $composableBuilder(
    column: $table.assignmentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolId => $composableBuilder(
    column: $table.protocolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextKey => $composableBuilder(
    column: $table.contextKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignedAtMs => $composableBuilder(
    column: $table.assignedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wakeSessionId => $composableBuilder(
    column: $table.wakeSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validity => $composableBuilder(
    column: $table.validity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => ColumnOrderings(column),
  );

  $$WakeExperimentsTableOrderingComposer get experimentId {
    final $$WakeExperimentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.experimentId,
      referencedTable: $db.wakeExperiments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeExperimentsTableOrderingComposer(
            $db: $db,
            $table: $db.wakeExperiments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExperimentSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExperimentSessionsTable> {
  $$ExperimentSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alarmId =>
      $composableBuilder(column: $table.alarmId, builder: (column) => column);

  GeneratedColumn<int> get scheduledTimeMs => $composableBuilder(
    column: $table.scheduledTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assignmentIndex => $composableBuilder(
    column: $table.assignmentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<String> get protocolId => $composableBuilder(
    column: $table.protocolId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextKey => $composableBuilder(
    column: $table.contextKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assignedAtMs => $composableBuilder(
    column: $table.assignedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wakeSessionId => $composableBuilder(
    column: $table.wakeSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validity =>
      $composableBuilder(column: $table.validity, builder: (column) => column);

  GeneratedColumn<String> get invalidReason => $composableBuilder(
    column: $table.invalidReason,
    builder: (column) => column,
  );

  $$WakeExperimentsTableAnnotationComposer get experimentId {
    final $$WakeExperimentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.experimentId,
      referencedTable: $db.wakeExperiments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeExperimentsTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeExperiments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExperimentSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExperimentSessionsTable,
          ExperimentSessionRow,
          $$ExperimentSessionsTableFilterComposer,
          $$ExperimentSessionsTableOrderingComposer,
          $$ExperimentSessionsTableAnnotationComposer,
          $$ExperimentSessionsTableCreateCompanionBuilder,
          $$ExperimentSessionsTableUpdateCompanionBuilder,
          (ExperimentSessionRow, $$ExperimentSessionsTableReferences),
          ExperimentSessionRow,
          PrefetchHooks Function({bool experimentId})
        > {
  $$ExperimentSessionsTableTableManager(
    _$AppDatabase db,
    $ExperimentSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExperimentSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExperimentSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExperimentSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> experimentId = const Value.absent(),
                Value<String> alarmId = const Value.absent(),
                Value<int> scheduledTimeMs = const Value.absent(),
                Value<int> assignmentIndex = const Value.absent(),
                Value<String> variant = const Value.absent(),
                Value<String> protocolId = const Value.absent(),
                Value<int> protocolVersion = const Value.absent(),
                Value<String> contextKey = const Value.absent(),
                Value<int> assignedAtMs = const Value.absent(),
                Value<String?> wakeSessionId = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                Value<String> validity = const Value.absent(),
                Value<String?> invalidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExperimentSessionsCompanion(
                id: id,
                experimentId: experimentId,
                alarmId: alarmId,
                scheduledTimeMs: scheduledTimeMs,
                assignmentIndex: assignmentIndex,
                variant: variant,
                protocolId: protocolId,
                protocolVersion: protocolVersion,
                contextKey: contextKey,
                assignedAtMs: assignedAtMs,
                wakeSessionId: wakeSessionId,
                completedAtMs: completedAtMs,
                validity: validity,
                invalidReason: invalidReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String experimentId,
                required String alarmId,
                required int scheduledTimeMs,
                required int assignmentIndex,
                required String variant,
                required String protocolId,
                required int protocolVersion,
                required String contextKey,
                required int assignedAtMs,
                Value<String?> wakeSessionId = const Value.absent(),
                Value<int?> completedAtMs = const Value.absent(),
                Value<String> validity = const Value.absent(),
                Value<String?> invalidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExperimentSessionsCompanion.insert(
                id: id,
                experimentId: experimentId,
                alarmId: alarmId,
                scheduledTimeMs: scheduledTimeMs,
                assignmentIndex: assignmentIndex,
                variant: variant,
                protocolId: protocolId,
                protocolVersion: protocolVersion,
                contextKey: contextKey,
                assignedAtMs: assignedAtMs,
                wakeSessionId: wakeSessionId,
                completedAtMs: completedAtMs,
                validity: validity,
                invalidReason: invalidReason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExperimentSessionsTable, ExperimentSessionRow>(
                    table,
                  ),
                  $$ExperimentSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({experimentId = false}) {
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
                    if (experimentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.experimentId,
                        referencedTable: $$ExperimentSessionsTableReferences
                            ._experimentIdTable(db),
                        referencedColumn: $$ExperimentSessionsTableReferences
                            ._experimentIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ExperimentSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExperimentSessionsTable,
      ExperimentSessionRow,
      $$ExperimentSessionsTableFilterComposer,
      $$ExperimentSessionsTableOrderingComposer,
      $$ExperimentSessionsTableAnnotationComposer,
      $$ExperimentSessionsTableCreateCompanionBuilder,
      $$ExperimentSessionsTableUpdateCompanionBuilder,
      (ExperimentSessionRow, $$ExperimentSessionsTableReferences),
      ExperimentSessionRow,
      PrefetchHooks Function({bool experimentId})
    >;
typedef $$ExperimentAuditEventsTableCreateCompanionBuilder =
    ExperimentAuditEventsCompanion Function({
      required String id,
      required String experimentId,
      required int sequence,
      required String eventType,
      required int occurredAtMs,
      required String detailsJson,
      Value<int> policyVersion,
      Value<int> rowid,
    });
typedef $$ExperimentAuditEventsTableUpdateCompanionBuilder =
    ExperimentAuditEventsCompanion Function({
      Value<String> id,
      Value<String> experimentId,
      Value<int> sequence,
      Value<String> eventType,
      Value<int> occurredAtMs,
      Value<String> detailsJson,
      Value<int> policyVersion,
      Value<int> rowid,
    });

final class $$ExperimentAuditEventsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExperimentAuditEventsTable,
          ExperimentAuditEventRow
        > {
  $$ExperimentAuditEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WakeExperimentsTable _experimentIdTable(_$AppDatabase db) =>
      db.wakeExperiments.createAlias(
        'experiment_audit_events__experiment_id__wake_experiments__id',
      );

  $$WakeExperimentsTableProcessedTableManager get experimentId {
    final $_column = $_itemColumn<String>('experiment_id')!;

    final manager = $$WakeExperimentsTableTableManager(
      $_db,
      $_db.wakeExperiments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_experimentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExperimentAuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ExperimentAuditEventsTable> {
  $$ExperimentAuditEventsTableFilterComposer({
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

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get policyVersion => $composableBuilder(
    column: $table.policyVersion,
    builder: (column) => ColumnFilters(column),
  );

  $$WakeExperimentsTableFilterComposer get experimentId {
    final $$WakeExperimentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.experimentId,
      referencedTable: $db.wakeExperiments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeExperimentsTableFilterComposer(
            $db: $db,
            $table: $db.wakeExperiments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExperimentAuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExperimentAuditEventsTable> {
  $$ExperimentAuditEventsTableOrderingComposer({
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

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get policyVersion => $composableBuilder(
    column: $table.policyVersion,
    builder: (column) => ColumnOrderings(column),
  );

  $$WakeExperimentsTableOrderingComposer get experimentId {
    final $$WakeExperimentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.experimentId,
      referencedTable: $db.wakeExperiments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeExperimentsTableOrderingComposer(
            $db: $db,
            $table: $db.wakeExperiments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExperimentAuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExperimentAuditEventsTable> {
  $$ExperimentAuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get policyVersion => $composableBuilder(
    column: $table.policyVersion,
    builder: (column) => column,
  );

  $$WakeExperimentsTableAnnotationComposer get experimentId {
    final $$WakeExperimentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.experimentId,
      referencedTable: $db.wakeExperiments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WakeExperimentsTableAnnotationComposer(
            $db: $db,
            $table: $db.wakeExperiments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExperimentAuditEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExperimentAuditEventsTable,
          ExperimentAuditEventRow,
          $$ExperimentAuditEventsTableFilterComposer,
          $$ExperimentAuditEventsTableOrderingComposer,
          $$ExperimentAuditEventsTableAnnotationComposer,
          $$ExperimentAuditEventsTableCreateCompanionBuilder,
          $$ExperimentAuditEventsTableUpdateCompanionBuilder,
          (ExperimentAuditEventRow, $$ExperimentAuditEventsTableReferences),
          ExperimentAuditEventRow,
          PrefetchHooks Function({bool experimentId})
        > {
  $$ExperimentAuditEventsTableTableManager(
    _$AppDatabase db,
    $ExperimentAuditEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExperimentAuditEventsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ExperimentAuditEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExperimentAuditEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> experimentId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<int> occurredAtMs = const Value.absent(),
                Value<String> detailsJson = const Value.absent(),
                Value<int> policyVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExperimentAuditEventsCompanion(
                id: id,
                experimentId: experimentId,
                sequence: sequence,
                eventType: eventType,
                occurredAtMs: occurredAtMs,
                detailsJson: detailsJson,
                policyVersion: policyVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String experimentId,
                required int sequence,
                required String eventType,
                required int occurredAtMs,
                required String detailsJson,
                Value<int> policyVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExperimentAuditEventsCompanion.insert(
                id: id,
                experimentId: experimentId,
                sequence: sequence,
                eventType: eventType,
                occurredAtMs: occurredAtMs,
                detailsJson: detailsJson,
                policyVersion: policyVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ExperimentAuditEventsTable,
                    ExperimentAuditEventRow
                  >(table),
                  $$ExperimentAuditEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({experimentId = false}) {
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
                    if (experimentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.experimentId,
                        referencedTable: $$ExperimentAuditEventsTableReferences
                            ._experimentIdTable(db),
                        referencedColumn: $$ExperimentAuditEventsTableReferences
                            ._experimentIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ExperimentAuditEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExperimentAuditEventsTable,
      ExperimentAuditEventRow,
      $$ExperimentAuditEventsTableFilterComposer,
      $$ExperimentAuditEventsTableOrderingComposer,
      $$ExperimentAuditEventsTableAnnotationComposer,
      $$ExperimentAuditEventsTableCreateCompanionBuilder,
      $$ExperimentAuditEventsTableUpdateCompanionBuilder,
      (ExperimentAuditEventRow, $$ExperimentAuditEventsTableReferences),
      ExperimentAuditEventRow,
      PrefetchHooks Function({bool experimentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AlarmsTableTableManager get alarms =>
      $$AlarmsTableTableManager(_db, _db.alarms);
  $$AlarmSoundsTableTableManager get alarmSounds =>
      $$AlarmSoundsTableTableManager(_db, _db.alarmSounds);
  $$WakeSessionsTableTableManager get wakeSessions =>
      $$WakeSessionsTableTableManager(_db, _db.wakeSessions);
  $$WakeEventsTableTableManager get wakeEvents =>
      $$WakeEventsTableTableManager(_db, _db.wakeEvents);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$MissionsTableTableManager get missions =>
      $$MissionsTableTableManager(_db, _db.missions);
  $$MissionExecutionsTableTableManager get missionExecutions =>
      $$MissionExecutionsTableTableManager(_db, _db.missionExecutions);
  $$WakeChecksTableTableManager get wakeChecks =>
      $$WakeChecksTableTableManager(_db, _db.wakeChecks);
  $$WakeProtocolsTableTableManager get wakeProtocols =>
      $$WakeProtocolsTableTableManager(_db, _db.wakeProtocols);
  $$ProtocolEvaluationsTableTableManager get protocolEvaluations =>
      $$ProtocolEvaluationsTableTableManager(_db, _db.protocolEvaluations);
  $$AlarmAdaptationSettingsTableTableManager get alarmAdaptationSettings =>
      $$AlarmAdaptationSettingsTableTableManager(
        _db,
        _db.alarmAdaptationSettings,
      );
  $$WakeExperimentsTableTableManager get wakeExperiments =>
      $$WakeExperimentsTableTableManager(_db, _db.wakeExperiments);
  $$ExperimentSessionsTableTableManager get experimentSessions =>
      $$ExperimentSessionsTableTableManager(_db, _db.experimentSessions);
  $$ExperimentAuditEventsTableTableManager get experimentAuditEvents =>
      $$ExperimentAuditEventsTableTableManager(_db, _db.experimentAuditEvents);
}
