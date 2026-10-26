import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart' as db;
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_validator.dart';
import 'package:ryser/features/sounds/domain/bundled_sound_catalog.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_safety_policy.dart';
import 'package:uuid/uuid.dart';

class WakeProtocolRepository {
  WakeProtocolRepository(
    this._database, {
    DateTime Function()? clock,
    String Function()? idFactory,
    this.soundAvailable,
    this.vibrationAvailable,
    this.missionAvailable,
  }) : _clock = clock ?? DateTime.now,
       _idFactory = idFactory ?? const Uuid().v4;

  final db.AppDatabase _database;
  final DateTime Function() _clock;
  final String Function() _idFactory;
  final Future<bool> Function(String)? soundAvailable;
  final Future<bool> Function()? vibrationAvailable;
  final Future<bool> Function(String)? missionAvailable;

  Future<bool> isValid(WakeProtocol p) async {
    final policy = await policyForAlarm(p.alarmId);
    final enabledMission =
        await (_database.select(_database.missions)..where(
              (r) => r.alarmId.equals(p.alarmId) & r.enabled.equals(true),
            ))
            .getSingleOrNull();
    return const WakeProtocolValidator()
        .validate(
          p,
          policy: policy,
          soundExists:
              await soundAvailable?.call(p.ringtoneUri) ??
              p.ringtoneUri.isNotEmpty,
          vibrationSupported: await vibrationAvailable?.call() ?? true,
          missionAvailable:
              !p.missionRequired ||
              (enabledMission != null &&
                  (await missionAvailable?.call(p.missionType ?? '') ?? true)),
        )
        .isValid;
  }

  /// Resolve the last executable snapshot; never mutate historical settings.
  Future<WakeProtocol?> resolveForAlarm(String alarmId) async {
    final rows =
        await (_database.select(_database.wakeProtocols)
              ..where((r) => r.alarmId.equals(alarmId))
              ..orderBy([(r) => OrderingTerm.desc(r.version)]))
            .get();
    for (final row in rows) {
      if (row.status == 'reverted' ||
          row.status == 'archived' ||
          row.effectiveFromMs > _clock().millisecondsSinceEpoch) {
        continue;
      }
      try {
        final candidate = _toDomain(row);
        if (await isValid(candidate)) return candidate;
      } on ArgumentError {
        continue;
      } on FormatException {
        continue;
      }
    }
    return null;
  }

  Future<WakeProtocol?> activeForAlarm(String alarmId) async {
    final row =
        await (_database.select(_database.wakeProtocols)
              ..where(
                (item) =>
                    item.alarmId.equals(alarmId) & item.status.equals('active'),
              )
              ..orderBy([(item) => OrderingTerm.desc(item.version)])
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<AlarmAdaptationPolicy> policyForAlarm(String alarmId) async {
    final row = await (_database.select(
      _database.alarmAdaptationSettings,
    )..where((item) => item.alarmId.equals(alarmId))).getSingleOrNull();
    if (row == null) {
      return const AlarmAdaptationPolicy(
        enabled: false,
        sound: AdaptiveMode.adaptive,
        volume: AdaptiveMode.adaptive,
        vibration: AdaptiveMode.adaptive,
        wakeCheck: AdaptiveMode.adaptive,
        mission: AdaptiveMode.fixed,
        userMaxVolumePercent: 100,
      );
    }
    return AlarmAdaptationPolicy(
      enabled: row.enabled,
      sound: row.adaptSound ? AdaptiveMode.adaptive : AdaptiveMode.fixed,
      volume: row.adaptVolume ? AdaptiveMode.adaptive : AdaptiveMode.fixed,
      vibration: row.adaptVibration
          ? AdaptiveMode.adaptive
          : AdaptiveMode.fixed,
      wakeCheck: row.adaptWakeCheck
          ? AdaptiveMode.adaptive
          : AdaptiveMode.fixed,
      mission: row.adaptMission ? AdaptiveMode.adaptive : AdaptiveMode.fixed,
      userMaxVolumePercent: row.userMaxVolumePercent,
    );
  }

  Future<void> savePolicy(String alarmId, AlarmAdaptationPolicy policy) {
    return _database
        .into(_database.alarmAdaptationSettings)
        .insertOnConflictUpdate(
          db.AlarmAdaptationSettingsCompanion.insert(
            alarmId: alarmId,
            enabled: Value(policy.enabled),
            adaptSound: Value(policy.sound == AdaptiveMode.adaptive),
            adaptVolume: Value(policy.volume == AdaptiveMode.adaptive),
            adaptVibration: Value(policy.vibration == AdaptiveMode.adaptive),
            adaptWakeCheck: Value(policy.wakeCheck == AdaptiveMode.adaptive),
            adaptMission: Value(policy.mission == AdaptiveMode.adaptive),
            userMaxVolumePercent: Value(policy.userMaxVolumePercent),
            updatedAtMs: _clock().millisecondsSinceEpoch,
          ),
        );
  }

  Future<WakeProtocol> ensureDefault(String alarmId) async {
    final existing = await resolveForAlarm(alarmId);
    if (existing != null) return existing;
    final alarm = await (_database.select(
      _database.alarms,
    )..where((item) => item.id.equals(alarmId))).getSingle();
    final mission = await (_database.select(
      _database.missions,
    )..where((item) => item.alarmId.equals(alarmId))).getSingleOrNull();
    final fallback =
        BundledSoundCatalog.byId(alarm.soundId) ??
        BundledSoundCatalog.sounds.first;
    final selectedUri = alarm.ringtoneUri ?? fallback.uri;
    final selectedAvailable =
        await soundAvailable?.call(selectedUri) ?? selectedUri.isNotEmpty;
    final sound = BundledSoundCatalog.byUri(
      selectedAvailable ? selectedUri : fallback.uri,
    );
    final policy = await policyForAlarm(alarmId);
    final now = _clock();
    final missionJson = mission?.configurationJson ?? '{}';
    final missionConfiguration =
        jsonDecode(missionJson) as Map<String, dynamic>;
    final latestRow =
        await (_database.select(_database.wakeProtocols)
              ..where((p) => p.alarmId.equals(alarmId))
              ..orderBy([(p) => OrderingTerm.desc(p.version)])
              ..limit(1))
            .getSingleOrNull();
    final protocol = WakeProtocol(
      id: _idFactory(),
      alarmId: alarmId,
      version: (latestRow?.version ?? 0) + 1,
      source: WakeProtocolSource.defaultValue,
      status: WakeProtocolStatus.active,
      initialSoundId: selectedAvailable ? alarm.soundId : fallback.id,
      initialSoundFamily: sound?.family,
      ringtoneUri: selectedAvailable ? selectedUri : fallback.uri,
      initialVolumePercent: alarm.increasingVolume
          ? 30.clamp(0, policy.userMaxVolumePercent)
          : policy.userMaxVolumePercent,
      maxVolumePercent: policy.userMaxVolumePercent,
      volumeEscalationEnabled: alarm.increasingVolume,
      volumeEscalationStepPercent: 10,
      volumeEscalationIntervalSeconds: 5,
      vibrationEnabled:
          alarm.vibrationEnabled && (await vibrationAvailable?.call() ?? true),
      vibrationPattern: VibrationPattern.standard,
      vibrationEscalationEnabled: false,
      missionRequired: mission?.enabled ?? false,
      missionType: mission?.missionType,
      missionDifficulty: mission?.difficulty,
      missionConfigurationJson: missionJson,
      wakeCheckRequired: mission?.enabled ?? false,
      wakeCheckDelayMinutes:
          missionConfiguration['wakeCheckDelayMinutes'] as int? ?? 5,
      wakeCheckHoldMilliseconds: 2000,
      maxWakeCheckFailures: 2,
      reactivationSoundPolicy: ReactivationSoundPolicy.alternateSound,
      intensity: mission?.enabled == true
          ? WakeIntensity.resistant
          : WakeIntensity.standard,
      reasonCode: AdaptiveReasonCode.v2Migration,
      technicalExplanation: 'Created from the existing V2 alarm settings.',
      userExplanation: 'Your current alarm settings were preserved.',
      basedOnSessionId: null,
      supersedesProtocolId: null,
      createdAt: now,
      effectiveFrom: now,
    );
    final prepared = protocol.copyWith(
      intensity: calculateWakeIntensity(protocol),
    );
    await insertAndActivate(prepared);
    return prepared;
  }

  Future<WakeProtocol> createUserDefinedVersion(
    String alarmId, {
    bool resetLearning = false,
  }) async {
    final current = await ensureDefault(alarmId);
    final versions = await historyForAlarm(alarmId);
    final alarm = await (_database.select(
      _database.alarms,
    )..where((item) => item.id.equals(alarmId))).getSingle();
    final mission = await (_database.select(
      _database.missions,
    )..where((item) => item.alarmId.equals(alarmId))).getSingleOrNull();
    final policy = await policyForAlarm(alarmId);
    final missionJson = mission?.configurationJson ?? '{}';
    final missionConfiguration =
        jsonDecode(missionJson) as Map<String, dynamic>;
    final now = _clock();
    final next = current.copyWith(
      id: _idFactory(),
      version: versions.isEmpty
          ? current.version + 1
          : versions.first.version + 1,
      source: WakeProtocolSource.userDefined,
      status: WakeProtocolStatus.active,
      initialSoundId: alarm.soundId,
      initialSoundFamily: BundledSoundCatalog.byUri(alarm.ringtoneUri)?.family,
      clearInitialSoundFamily:
          BundledSoundCatalog.byUri(alarm.ringtoneUri) == null,
      ringtoneUri: alarm.ringtoneUri ?? current.ringtoneUri,
      initialVolumePercent: alarm.increasingVolume
          ? 30.clamp(0, policy.userMaxVolumePercent)
          : policy.userMaxVolumePercent,
      maxVolumePercent: policy.userMaxVolumePercent,
      volumeEscalationEnabled: alarm.increasingVolume,
      vibrationEnabled: alarm.vibrationEnabled,
      missionRequired: mission?.enabled ?? false,
      missionType: mission?.missionType,
      missionDifficulty: mission?.difficulty,
      missionConfigurationJson: missionJson,
      wakeCheckRequired: mission?.enabled ?? false,
      wakeCheckDelayMinutes:
          missionConfiguration['wakeCheckDelayMinutes'] as int? ?? 5,
      reasonCode: resetLearning
          ? AdaptiveReasonCode.manualReset
          : AdaptiveReasonCode.manualUserOverride,
      technicalExplanation: resetLearning
          ? 'The user reset adaptive learning to the configured alarm settings.'
          : 'The user changed the alarm configuration.',
      userExplanation: resetLearning
          ? 'Adaptive learning was reset. Past wake history is preserved.'
          : 'Your manual alarm settings are now active.',
      supersedesProtocolId: current.id,
      createdAt: now,
      effectiveFrom: now,
    );
    final prepared = next.copyWith(intensity: calculateWakeIntensity(next));
    await insertAndActivate(prepared);
    return prepared;
  }

  Future<void> insertAndActivate(WakeProtocol protocol) async {
    if (!await isValid(protocol)) {
      throw StateError('Protocol is not executable.');
    }
    final policy = await policyForAlarm(protocol.alarmId);
    await _database.transaction(() async {
      await (_database.update(_database.wakeProtocols)..where(
            (item) =>
                item.alarmId.equals(protocol.alarmId) &
                item.status.equals('active'),
          ))
          .write(const db.WakeProtocolsCompanion(status: Value('superseded')));
      await _database
          .into(_database.wakeProtocols)
          .insert(
            _toCompanion(protocol).copyWith(
              settingsSnapshotJson: Value(
                jsonEncode({
                  'enabled': policy.enabled,
                  'sound': policy.sound.name,
                  'volume': policy.volume.name,
                  'vibration': policy.vibration.name,
                  'mission': policy.mission.name,
                  'wakeCheck': policy.wakeCheck.name,
                  'userMaxVolumePercent': policy.userMaxVolumePercent,
                }),
              ),
            ),
          );
    });
  }

  /// Make a candidate resolvable by session ID without activating it globally.
  Future<void> registerExperimentVariant(WakeProtocol protocol) async {
    if (!await isValid(protocol)) {
      throw StateError('Experiment variant is not executable.');
    }
    final existing = await findById(protocol.id);
    if (existing != null) {
      if (existing.alarmId != protocol.alarmId ||
          existing.version != protocol.version ||
          !sameExperimentSettings(
            encodeWakeProtocolSnapshot(existing),
            encodeWakeProtocolSnapshot(protocol),
          )) {
        throw StateError('Protocol identity has different immutable settings.');
      }
      return;
    }
    await _database
        .into(_database.wakeProtocols)
        .insert(
          _toCompanion(protocol.copyWith(status: WakeProtocolStatus.archived)),
        );
  }

  Future<List<WakeProtocol>> historyForAlarm(String alarmId) async {
    final rows =
        await (_database.select(_database.wakeProtocols)
              ..where((item) => item.alarmId.equals(alarmId))
              ..orderBy([(item) => OrderingTerm.desc(item.version)]))
            .get();
    final result = <WakeProtocol>[];
    for (final row in rows) {
      try {
        result.add(_toDomain(row));
      } on ArgumentError {
        continue;
      }
    }
    return result;
  }

  Future<WakeProtocol?> findById(String id) async {
    final row = await (_database.select(
      _database.wakeProtocols,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  db.WakeProtocolsCompanion _toCompanion(WakeProtocol value) =>
      db.WakeProtocolsCompanion.insert(
        id: value.id,
        alarmId: value.alarmId,
        version: value.version,
        source: value.source.name,
        status: value.status.name,
        initialSoundId: value.initialSoundId,
        initialSoundFamily: Value(value.initialSoundFamily),
        ringtoneUri: value.ringtoneUri,
        initialVolumePercent: value.initialVolumePercent,
        maxVolumePercent: value.maxVolumePercent,
        volumeEscalationEnabled: value.volumeEscalationEnabled,
        volumeEscalationStepPercent: value.volumeEscalationStepPercent,
        volumeEscalationIntervalSeconds: value.volumeEscalationIntervalSeconds,
        vibrationEnabled: value.vibrationEnabled,
        vibrationPattern: value.vibrationPattern.name,
        vibrationEscalationEnabled: value.vibrationEscalationEnabled,
        missionRequired: value.missionRequired,
        missionType: Value(value.missionType),
        missionDifficulty: Value(value.missionDifficulty),
        missionConfigurationJson: Value(value.missionConfigurationJson),
        wakeCheckRequired: value.wakeCheckRequired,
        wakeCheckDelayMinutes: value.wakeCheckDelayMinutes,
        wakeCheckHoldMilliseconds: value.wakeCheckHoldMilliseconds,
        maxWakeCheckFailures: value.maxWakeCheckFailures,
        reactivationSoundPolicy: value.reactivationSoundPolicy.name,
        intensityLevel: value.intensity.index + 1,
        reasonCode: value.reasonCode.name,
        technicalExplanation: value.technicalExplanation,
        userExplanation: value.userExplanation,
        basedOnSessionId: Value(value.basedOnSessionId),
        supersedesProtocolId: Value(value.supersedesProtocolId),
        settingsSnapshotJson: const Value('{}'),
        createdAtMs: value.createdAt.millisecondsSinceEpoch,
        effectiveFromMs: value.effectiveFrom.millisecondsSinceEpoch,
      );

  WakeProtocol _toDomain(db.WakeProtocol row) => WakeProtocol(
    id: row.id,
    alarmId: row.alarmId,
    version: row.version,
    source: WakeProtocolSource.values.byName(row.source),
    status: WakeProtocolStatus.values.byName(row.status),
    initialSoundId: row.initialSoundId,
    initialSoundFamily: row.initialSoundFamily,
    ringtoneUri: row.ringtoneUri,
    initialVolumePercent: row.initialVolumePercent,
    maxVolumePercent: row.maxVolumePercent,
    volumeEscalationEnabled: row.volumeEscalationEnabled,
    volumeEscalationStepPercent: row.volumeEscalationStepPercent,
    volumeEscalationIntervalSeconds: row.volumeEscalationIntervalSeconds,
    vibrationEnabled: row.vibrationEnabled,
    vibrationPattern: VibrationPattern.values.byName(row.vibrationPattern),
    vibrationEscalationEnabled: row.vibrationEscalationEnabled,
    missionRequired: row.missionRequired,
    missionType: row.missionType,
    missionDifficulty: row.missionDifficulty,
    missionConfigurationJson: row.missionConfigurationJson,
    wakeCheckRequired: row.wakeCheckRequired,
    wakeCheckDelayMinutes: row.wakeCheckDelayMinutes,
    wakeCheckHoldMilliseconds: row.wakeCheckHoldMilliseconds,
    maxWakeCheckFailures: row.maxWakeCheckFailures,
    reactivationSoundPolicy: ReactivationSoundPolicy.values.byName(
      row.reactivationSoundPolicy,
    ),
    intensity: WakeIntensity.values[row.intensityLevel - 1],
    reasonCode: AdaptiveReasonCode.values.byName(row.reasonCode),
    technicalExplanation: row.technicalExplanation,
    userExplanation: row.userExplanation,
    basedOnSessionId: row.basedOnSessionId,
    supersedesProtocolId: row.supersedesProtocolId,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtMs),
    effectiveFrom: DateTime.fromMillisecondsSinceEpoch(row.effectiveFromMs),
  );
}
