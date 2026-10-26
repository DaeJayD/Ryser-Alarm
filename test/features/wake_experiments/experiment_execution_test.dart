import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart' hide WakeProtocol;
import 'package:ryser/features/adaptive_wake/data/adaptive_wake_coordinator.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/sounds/data/sound_performance_repository.dart';
import 'package:ryser/features/wake_experiments/data/experiment_execution_coordinator.dart';
import 'package:ryser/features/wake_experiments/data/experiment_execution_settings.dart';
import 'package:ryser/features/wake_experiments/data/experiment_session_reconciler.dart';
import 'package:ryser/features/wake_experiments/data/experiment_scheduling_service.dart';
import 'package:ryser/features/wake_experiments/data/wake_experiment_repository.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';
import 'package:ryser/features/wake_sessions/data/runtime_event_reconciler.dart';

import '../adaptive_wake/adaptive_test_fixtures.dart';

class _NativeApi extends AlarmRuntimeApi {
  final List<AlarmScheduleDto> schedules = [];
  List<RuntimeEventDto> events = [];
  bool reject = false;
  final Set<String> missingSounds = {};
  @override
  Future<bool> isSoundAvailable(String uri) async =>
      !missingSounds.contains(uri);
  @override
  Future<bool> canVibrate() async => true;
  @override
  Future<bool> isMissionAvailable(String type) async => true;
  @override
  Future<AlarmApplyResult> scheduleAlarm(AlarmScheduleDto schedule) async {
    schedules.add(schedule);
    return AlarmApplyResult(
      scheduled: !reject,
      errorCode: reject ? 'fixture_rejection' : null,
    );
  }

  @override
  Future<List<RuntimeEventDto>> getRuntimeEvents() async => events;
  @override
  Future<void> acknowledgeRuntimeEvents(List<String> eventIds) async {}
}

void main() {
  late AppDatabase database;
  late _NativeApi native;
  late WakeProtocolRepository protocols;
  late WakeExperimentRepository experiments;
  late ExperimentExecutionSettingsRepository settings;
  late ExperimentExecutionCoordinator coordinator;
  late AlarmRuntimeGateway gateway;
  late DateTime now;
  final first = DateTime(2026, 10, 26, 7);
  final control = protocol();
  final candidate = control.copyWith(
    id: 'candidate',
    version: 2,
    initialSoundId: 'melodic-a',
    initialSoundFamily: 'MELODIC',
    ringtoneUri: 'content://sound/2',
  );

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    native = _NativeApi();
    now = first.subtract(const Duration(hours: 1));
    final capabilities = AlarmRuntimeGateway(api: native);
    protocols = WakeProtocolRepository(
      database,
      soundAvailable: capabilities.isSoundAvailable,
      vibrationAvailable: capabilities.canVibrate,
      missionAvailable: capabilities.isMissionAvailable,
      clock: () => now,
    );
    experiments = WakeExperimentRepository(
      database,
      protocols,
      clock: () => now,
    );
    settings = ExperimentExecutionSettingsRepository(database);
    coordinator = ExperimentExecutionCoordinator(
      experiments,
      protocols,
      settings,
    );
    gateway = AlarmRuntimeGateway(
      api: native,
      prepareSchedule: coordinator.prepare,
      didSchedule: coordinator.didSchedule,
    );
    await database
        .into(database.alarms)
        .insert(
          AlarmsCompanion.insert(
            id: 'alarm-1',
            enabled: const Value(true),
            localHour: 7,
            localMinute: 0,
            recurrenceType: 'daily',
            soundId: control.initialSoundId,
            ringtoneUri: Value(control.ringtoneUri),
            snoozeDurationMinutes: 5,
            createdAtMs: now.millisecondsSinceEpoch,
            updatedAtMs: now.millisecondsSinceEpoch,
          ),
        );
    await protocols.savePolicy('alarm-1', adaptivePolicy);
    await protocols.insertAndActivate(control);
  });
  tearDown(() => database.close());

  Future<WakeExperiment> start({
    bool enabled = true,
    bool critical = false,
  }) async {
    await settings.save(
      'alarm-1',
      ExperimentExecutionSettings(enabled: enabled, critical: critical),
    );
    final experiment = await experiments.create(
      name: 'Try a melody',
      hypothesis: 'Melody improves response for the weekday 07:00 alarm.',
      control: control,
      candidate: candidate,
      dimension: ExperimentDimension.soundFamily,
      contextKey: scheduledExperimentContext('alarm-1', first),
    );
    await experiments.changeStatus(
      experiment.id,
      ExperimentStatus.ready,
      reason: 'Valid fixtures',
    );
    await experiments.changeStatus(
      experiment.id,
      ExperimentStatus.running,
      reason: 'Explicit opt-in',
    );
    return experiment;
  }

  Future<AlarmApplyResult> schedule(
    DateTime at, {
    AlarmRuntimeGateway? runtime,
    WakeProtocol? selected,
  }) => (runtime ?? gateway).schedule(
    alarmId: 'alarm-1',
    triggerAt: at,
    label: 'Morning',
    ringtoneUri: control.ringtoneUri,
    vibrationEnabled: true,
    snoozeEnabled: true,
    snoozeDurationMinutes: 5,
    adaptiveSoundRotation: true,
    increasingVolume: true,
    localHour: at.hour,
    localMinute: at.minute,
    recurrenceType: 'daily',
    repeatDaysMask: 0,
    protocol: selected ?? control,
  );

  RuntimeEventDto event(
    AlarmScheduleDto run,
    String id,
    String type,
    int delta, {
    bool includeAssignment = true,
    String? snapshot,
    int? scheduledAtMs,
  }) => RuntimeEventDto(
    id: id,
    sessionId: 'wake-${run.triggerAtMs}',
    alarmId: run.alarmId,
    eventType: type,
    occurredAtMs: run.triggerAtMs + delta,
    scheduledAtMs: scheduledAtMs ?? run.triggerAtMs,
    ringtoneUri: run.ringtoneUri,
    metadataJson: '{}',
    protocolId: run.protocolId,
    protocolVersion: run.protocolVersion,
    protocolSnapshotJson: snapshot ?? run.protocolSnapshotJson,
    experiment: includeAssignment ? run.experiment : null,
  );

  Future<void> importEvents() => RuntimeEventReconciler(
    database,
    gateway,
    experiments: experiments,
  ).reconcile();

  test('control and candidate cross the bridge, reconcile and keep the active plan stable', () async {
    final experiment = await start();
    for (var i = 0; i < 6; i++) {
      // Keep all six observations in the same weekday context.
      final at = first.add(Duration(days: i == 5 ? 7 : i));
      now = at.subtract(const Duration(hours: 1));
      expect((await schedule(at)).scheduled, isTrue);
      final run = native.schedules.last;
      expect(run.protocolId, i.isEven ? control.id : candidate.id);
      expect(run.experiment!.variant, i.isEven ? 'control' : 'candidate');
      expect(run.stableProtocolSnapshotJson, experiment.controlSnapshotJson);
      native.events = [
        event(run, 'trigger-$i', 'ALARM_TRIGGERED', 1),
        event(
          run,
          'dismiss-$i',
          'ALARM_DISMISSED',
          20000,
          includeAssignment: false,
        ),
      ];
      await importEvents();
      now = at.add(const Duration(minutes: 1));
      expect(
        await ExperimentSessionReconciler(
          database,
          experiments,
        ).processPending(),
        1,
      );
      final auditCount = (await experiments.audit(experiment.id)).length;
      await importEvents();
      expect(
        await ExperimentSessionReconciler(
          database,
          experiments,
        ).processPending(),
        0,
      );
      expect((await experiments.audit(experiment.id)).length, auditCount);
    }
    final rows = await experiments.sessions(experiment.id);
    expect(rows.map((r) => r.validity), everyElement(SessionValidity.valid));
    expect(
      rows.where((r) => r.variant == ExperimentVariant.control),
      hasLength(3),
    );
    expect(
      rows.where((r) => r.variant == ExperimentVariant.candidate),
      hasLength(3),
    );
    expect((await protocols.activeForAlarm('alarm-1'))!.id, control.id);
    expect(
      (await protocols.findById(candidate.id))!.status,
      WakeProtocolStatus.archived,
    );
    expect(
      await AdaptiveWakeCoordinator(
        database,
        protocols,
        gateway,
      ).processPending(),
      6,
    );
    expect(
      await database.select(database.protocolEvaluations).get(),
      isEmpty,
      reason:
          'Experiment outcomes do not independently trigger V3 rule changes.',
    );
    expect(
      await SoundPerformanceRepository(database).load(excludeExperiments: true),
      isEmpty,
    );
    expect(await SoundPerformanceRepository(database).load(), hasLength(2));
    final savedEvent = await (database.select(
      database.wakeEvents,
    )..where((r) => r.id.equals('trigger-1'))).getSingle();
    expect(
      (jsonDecode(savedEvent.metadataJson) as Map)['experiment']['variant'],
      'candidate',
    );
  });

  test('native rejection is auditable and retry reuses the same pre-run reservation', () async {
    final experiment = await start();
    native.reject = true;
    expect((await schedule(first)).scheduled, isFalse);
    final original = native.schedules.last.experiment!.assignmentId;
    native.reject = false;
    expect((await schedule(first)).scheduled, isTrue);
    expect(native.schedules.last.experiment!.assignmentId, original);
    expect(await experiments.sessions(experiment.id), hasLength(1));
    expect(
      (await experiments.audit(experiment.id)).map((r) => r.eventType),
      containsAllInOrder([
        'assigned',
        'nativeScheduleRejected',
        'nativeScheduleAccepted',
      ]),
    );
  });

  test(
    'snooze uses one original occurrence and does not attach a new assignment',
    () async {
      final experiment = await start();
      await schedule(first);
      final run = native.schedules.last;
      native.events = [
        event(run, 't', 'ALARM_TRIGGERED', 1),
        event(run, 's', 'SNOOZED', 20000, includeAssignment: false),
        event(
          run,
          'r',
          'SOUND_CHANGED',
          320000,
          includeAssignment: false,
          scheduledAtMs: run.triggerAtMs + 320000,
        ),
        event(
          run,
          'd',
          'ALARM_DISMISSED',
          330000,
          includeAssignment: false,
          scheduledAtMs: run.triggerAtMs + 320000,
        ),
      ];
      await importEvents();
      final wake = await database.select(database.wakeSessions).getSingle();
      expect(wake.scheduledTimeMs, run.triggerAtMs);
      expect(wake.snoozeCount, 1);
      await ExperimentSessionReconciler(database, experiments).processPending();
      expect(
        (await experiments.sessions(experiment.id)).single.wakeSessionId,
        wake.id,
      );
      expect(
        (await experiments.sessions(experiment.id)).single.validity,
        SessionValidity.valid,
      );
    },
  );

  test('missing or wrong snapshots preserve history but cannot get experiment credit', () async {
    final experiment = await start();
    await schedule(first);
    final run = native.schedules.last;
    native.events = [event(run, 'bad', 'ALARM_TRIGGERED', 1, snapshot: '{}')];
    await importEvents();
    expect(await database.select(database.wakeSessions).get(), hasLength(1));
    expect(
      (await experiments.sessions(experiment.id)).single.validity,
      SessionValidity.invalid,
    );
    expect(
      (await experiments.sessions(experiment.id)).single.wakeSessionId,
      isNull,
    );
  });

  test(
    'disabled and critical alarms schedule stable and reserve no trial',
    () async {
      final experiment = await start(critical: true);
      await schedule(first);
      expect(native.schedules.last.experiment, isNull);
      expect(native.schedules.last.protocolId, control.id);
      expect(await experiments.sessions(experiment.id), isEmpty);
      expect(
        (await experiments.findById(experiment.id))!.status,
        ExperimentStatus.invalidated,
      );
      final second = await start(enabled: false);
      await schedule(first);
      expect(native.schedules.last.experiment, isNull);
      expect(await experiments.sessions(second.id), isEmpty);
    },
  );

  test(
    'a changed context uses stable without consuming an A/B assignment',
    () async {
      final experiment = await start();
      await schedule(first.add(const Duration(hours: 1)));
      expect(native.schedules.last.experiment, isNull);
      expect(await experiments.sessions(experiment.id), isEmpty);
      expect(
        (await experiments.findById(experiment.id))!.status,
        ExperimentStatus.running,
      );
    },
  );

  test(
    'missing candidate capability invalidates the trial and uses control',
    () async {
      final experiment = await start();
      native.missingSounds.add(candidate.ringtoneUri);
      await schedule(first);
      expect(native.schedules.last.experiment, isNull);
      expect(native.schedules.last.protocolId, control.id);
      expect(
        (await experiments.findById(experiment.id))!.status,
        ExperimentStatus.invalidated,
      );
    },
  );

  test(
    'lowered volume cap cannot be bypassed by a stale caller protocol',
    () async {
      final experiment = await start();
      await protocols.savePolicy(
        'alarm-1',
        const AlarmAdaptationPolicy(
          enabled: true,
          sound: AdaptiveMode.adaptive,
          volume: AdaptiveMode.adaptive,
          vibration: AdaptiveMode.adaptive,
          wakeCheck: AdaptiveMode.adaptive,
          mission: AdaptiveMode.fixed,
          userMaxVolumePercent: 40,
        ),
      );
      await schedule(first);
      expect(native.schedules.last.experiment, isNull);
      expect(native.schedules.last.maxVolumePercent, lessThanOrEqualTo(40));
      expect(
        (await experiments.findById(experiment.id))!.status,
        ExperimentStatus.invalidated,
      );
    },
  );

  test('V3 adaptation waits while an experiment owns the alarm', () async {
    await start();
    await database
        .into(database.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: 'unassigned',
            alarmId: 'alarm-1',
            scheduledTimeMs: 100,
            triggeredAtMs: 101,
            initialSoundId: control.initialSoundId,
            outcome: 'wakeConfirmed',
            createdAtMs: 101,
            completedAtMs: const Value(1000),
            protocolId: Value(control.id),
            protocolVersion: Value(control.version),
          ),
        );
    expect(
      await AdaptiveWakeCoordinator(
        database,
        protocols,
        gateway,
      ).processPending(),
      0,
    );
    expect(
      (await database.select(database.wakeSessions).getSingle()).analysisStatus,
      'pending',
    );
    expect(await database.select(database.protocolEvaluations).get(), isEmpty);
  });

  test(
    'learning preparation and audit faults cannot prevent native scheduling',
    () async {
      final broken = AlarmRuntimeGateway(
        api: native,
        prepareSchedule: (_) async => throw StateError('storage failed'),
        didSchedule: (_, _) async => throw StateError('audit failed'),
      );
      expect((await schedule(first, runtime: broken)).scheduled, isTrue);
      expect(native.schedules.last.protocolId, control.id);
      expect(native.schedules.last.experiment, isNull);
    },
  );

  test(
    'settings default off and corrupt critical state fails closed',
    () async {
      expect((await settings.load('alarm-1')).enabled, isFalse);
      await database
          .into(database.appSettings)
          .insert(
            AppSettingsCompanion.insert(
              key: 'wake_experiments.critical.alarm-1',
              valueType: 'string',
              value: 'broken',
              updatedAtMs: 100,
            ),
          );
      expect((await settings.load('alarm-1')).critical, isTrue);
    },
  );

  test(
    'production provider graph prepares schedules without a construction cycle',
    () async {
      await start(enabled: false);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          alarmRuntimeApiProvider.overrideWithValue(native),
        ],
      );
      addTearDown(container.dispose);
      expect(
        (await schedule(
          first,
          runtime: container.read(alarmRuntimeGatewayProvider),
        )).scheduled,
        isTrue,
      );
      expect(native.schedules.last.experiment, isNull);
      expect(native.schedules.last.protocolId, control.id);
    },
  );

  test('manual protocol versions invalidate a test before another candidate is scheduled', () async {
    final experiment = await start();
    final manual = await protocols.createUserDefinedVersion('alarm-1');
    await schedule(first, selected: manual);
    expect(native.schedules.last.experiment, isNull);
    expect(native.schedules.last.protocolId, manual.id);
    expect(
      (await experiments.findById(experiment.id))!.status,
      ExperimentStatus.invalidated,
    );
  });

  test('app resumption arms the next variant and pausing restores stable recurrence', () async {
    final experiment = await start();
    final service = ExperimentSchedulingService(
      database,
      protocols,
      gateway,
      clock: () => now,
    );
    expect(await service.rearmNextOccurrences(), 1);
    final firstRun = native.schedules.last;
    expect(firstRun.experiment!.variant, 'control');
    native.events = [event(firstRun, 'resume-trigger', 'ALARM_TRIGGERED', 1)];
    await importEvents();
    now = first.add(const Duration(minutes: 1));
    expect(await service.rearmNextOccurrences(), 1);
    expect(
      native.schedules.last.triggerAtMs,
      first.add(const Duration(days: 1)).millisecondsSinceEpoch,
    );
    expect(native.schedules.last.experiment!.variant, 'candidate');
    await experiments.changeStatus(
      experiment.id,
      ExperimentStatus.paused,
      reason: 'Pause test',
    );
    expect(await service.rearmNextOccurrences(), 1);
    expect(native.schedules.last.experiment, isNull);
    expect(native.schedules.last.protocolId, control.id);
    expect(await experiments.sessions(experiment.id), hasLength(2));
  });

  test('cancelled future assignments are replaced and disabled alarms stay disabled', () async {
    final experiment = await start();
    final service = ExperimentSchedulingService(
      database,
      protocols,
      gateway,
      clock: () => now,
    );
    await service.rearmNextOccurrences();
    await experiments.changeStatus(
      experiment.id,
      ExperimentStatus.cancelled,
      reason: 'Stop testing',
    );
    expect(await service.rearmNextOccurrences(), 1);
    expect(native.schedules.last.experiment, isNull);
    await (database.update(database.alarms)
          ..where((r) => r.id.equals('alarm-1')))
        .write(const AlarmsCompanion(enabled: Value(false)));
    final calls = native.schedules.length;
    expect(await service.rearmNextOccurrences(), 0);
    expect(native.schedules, hasLength(calls));
  });
}
