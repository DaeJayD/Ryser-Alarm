import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/app/app.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart' hide WakeProtocol;
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/wake_experiments/data/experiment_comparison_service.dart';
import 'package:ryser/features/wake_experiments/data/experiment_lifecycle_service.dart';
import 'package:ryser/features/wake_experiments/data/experiment_restoration_ledger.dart';
import 'package:ryser/features/wake_experiments/data/experiment_restoration_service.dart';
import 'package:ryser/features/wake_experiments/data/experiment_scheduling_service.dart';
import 'package:ryser/features/wake_experiments/data/wake_experiment_repository.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

import '../adaptive_wake/adaptive_test_fixtures.dart';

class _Native extends AlarmRuntimeApi {
  final schedules = <AlarmScheduleDto>[];
  bool reject = false, fail = false;
  bool failOutbox = false;
  Future<void> Function()? beforeVibrationCheck;
  @override
  Future<bool> isSoundAvailable(String uri) async => true;
  @override
  Future<bool> canVibrate() async {
    await beforeVibrationCheck?.call();
    return true;
  }

  @override
  Future<bool> isMissionAvailable(String type) async => true;
  @override
  Future<List<RuntimeEventDto>> getRuntimeEvents() async {
    if (failOutbox) throw StateError('Outbox unavailable');
    return [];
  }

  @override
  Future<AlarmApplyResult> scheduleAlarm(AlarmScheduleDto schedule) async {
    schedules.add(schedule);
    if (fail) throw StateError('Native unavailable');
    return AlarmApplyResult(scheduled: !reject);
  }
}

void main() {
  late AppDatabase db;
  late WakeProtocolRepository protocols;
  late WakeExperimentRepository experiments;
  late ExperimentLifecycleService lifecycle;
  late ExperimentRestorationLedger ledger;
  late ExperimentRestorationService restoration;
  late _Native native;
  late DateTime now;
  late WakeExperiment experiment;
  var occurrence = 0, preparations = 0;
  final control = protocol();
  final candidate = control.copyWith(
    id: 'candidate',
    version: 2,
    initialSoundId: 'melodic-a',
    initialSoundFamily: 'MELODIC',
    ringtoneUri: 'content://candidate',
  );

  void connect(AppDatabase database) {
    db = database;
    protocols = WakeProtocolRepository(
      db,
      clock: () => now,
      soundAvailable: native.isSoundAvailable,
      vibrationAvailable: native.canVibrate,
      missionAvailable: native.isMissionAvailable,
    );
    experiments = WakeExperimentRepository(db, protocols, clock: () => now);
    ledger = ExperimentRestorationLedger(db, clock: () => now);
    lifecycle = ExperimentLifecycleService(
      db,
      ExperimentComparisonService(db, experiments),
      ledger,
      clock: () => now,
    );
    final gateway = AlarmRuntimeGateway(
      api: native,
      prepareSchedule: (value) async {
        preparations++;
        throw StateError('Recovery must bypass experiment preparation');
      },
    );
    restoration = ExperimentRestorationService(
      ledger,
      ExperimentSchedulingService(db, protocols, gateway, clock: () => now),
    );
  }

  Future<void> seed({int maximum = 10}) async {
    await db
        .into(db.alarms)
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
            createdAtMs: 1,
            updatedAtMs: 1,
          ),
        );
    await protocols.savePolicy('alarm-1', adaptivePolicy);
    await protocols.insertAndActivate(control);
    experiment = await experiments.create(
      name: 'Try melody',
      hypothesis: 'Quicker response',
      control: control,
      candidate: candidate,
      dimension: ExperimentDimension.soundFamily,
      contextKey: 'context',
      preferredSessionsPerVariant: maximum == 3 ? 3 : 5,
      maximumSessionsPerVariant: maximum,
    );
    await experiments.changeStatus(
      experiment.id,
      ExperimentStatus.ready,
      reason: 'Prepared',
    );
    await experiments.changeStatus(
      experiment.id,
      ExperimentStatus.running,
      reason: 'Started',
    );
  }

  Future<ExperimentSession> add({
    String outcome = 'wakeConfirmed',
    int checks = 0,
    int? latency,
  }) async {
    final at = now.add(const Duration(minutes: 1));
    final a = await experiments.reserve(
      experiment.id,
      scheduledTimeMs: at.millisecondsSinceEpoch,
      contextKey: 'context',
    );
    final p = a.variant == ExperimentVariant.control ? control : candidate;
    final wakeId = 'wake-${occurrence++}';
    await db
        .into(db.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: wakeId,
            alarmId: a.alarmId,
            scheduledTimeMs: a.scheduledTimeMs,
            triggeredAtMs: a.scheduledTimeMs,
            initialSoundId: p.initialSoundId,
            outcome: outcome,
            createdAtMs: a.scheduledTimeMs,
            completedAtMs: Value(a.scheduledTimeMs + 90000),
            responseLatencyMs: Value(
              latency ??
                  (a.variant == ExperimentVariant.control ? 40000 : 10000),
            ),
            wakeCheckFailureCount: Value(checks),
            protocolId: Value(p.id),
            protocolVersion: Value(p.version),
            protocolSnapshotJson: Value(encodeWakeProtocolSnapshot(p)),
          ),
        );
    await db
        .into(db.wakeEvents)
        .insert(
          WakeEventsCompanion.insert(
            id: 'trigger-$wakeId',
            wakeSessionId: wakeId,
            sequenceNumber: 0,
            eventType: 'ALARM_TRIGGERED',
            occurredAtMs: a.scheduledTimeMs,
            metadataJson: '{}',
            source: 'fixture',
          ),
        );
    await experiments.attach(a.id, wakeId);
    await experiments.finishSession(a.id, validity: SessionValidity.valid);
    now = at.add(const Duration(minutes: 2));
    return a;
  }

  Future<void> stopCandidate() async {
    await add();
    await add(outcome: 'bypassed');
  }

  Future<List<ExperimentAuditEventRow>> decisions() async =>
      (await experiments.audit(experiment.id))
          .where((a) => a.eventType == 'comparisonApplied')
          .toList();

  setUp(() async {
    now = DateTime(2026, 10, 30, 6);
    occurrence = 0;
    preparations = 0;
    native = _Native();
    connect(AppDatabase.forTesting(NativeDatabase.memory()));
    await seed();
  });
  tearDown(() => db.close());

  test('not enough evidence makes no lifecycle or audit writes', () async {
    final count = (await experiments.audit(experiment.id)).length;
    expect(await lifecycle.processPending(), 0);
    expect((await experiments.audit(experiment.id)).length, count);
    expect(await ledger.pending(), isEmpty);
  });

  test(
    'winner is recorded once without activating or scheduling a candidate',
    () async {
      for (var i = 0; i < 6; i++) {
        await add();
      }
      final assignments = await db.select(db.experimentSessions).get();
      expect(await lifecycle.processPending(), 1);
      final stored = (await experiments.findById(experiment.id))!;
      expect(stored.status, ExperimentStatus.completed);
      expect(stored.result, ExperimentOutcome.candidateBetter);
      expect(stored.winnerProtocolId, candidate.id);
      expect((await protocols.activeForAlarm('alarm-1'))!.id, control.id);
      expect(await db.select(db.experimentSessions).get(), assignments);
      expect(native.schedules, isEmpty);
      expect(await ledger.pending(), hasLength(1));
      expect(await lifecycle.processPending(), 0);
      expect(await decisions(), hasLength(1));
    },
  );

  test(
    'candidate safety stop precedes sample minimum and revokes future trials',
    () async {
      await stopCandidate();
      final future = await experiments.reserve(
        experiment.id,
        scheduledTimeMs: now
            .add(const Duration(days: 1))
            .millisecondsSinceEpoch,
        contextKey: 'context',
      );
      expect(await lifecycle.processPending(), 1);
      final stored = (await experiments.findById(experiment.id))!;
      expect(stored.status, ExperimentStatus.completed);
      expect(stored.result, ExperimentOutcome.insufficientData);
      expect(stored.winnerProtocolId, isNull);
      expect(
        (await experiments.sessions(experiment.id))
            .singleWhere((a) => a.id == future.id)
            .validity,
        SessionValidity.invalid,
      );
      expect(
        jsonDecode((await decisions()).single.detailsJson)['recommendation'],
        'stopCandidate',
      );
    },
  );

  test(
    'serious control failure pauses rather than promoting the candidate',
    () async {
      await add(checks: 2);
      await lifecycle.processPending();
      expect(
        (await experiments.findById(experiment.id))!.status,
        ExperimentStatus.paused,
      );
      expect(
        (await experiments.findById(experiment.id))!.winnerProtocolId,
        isNull,
      );
      expect(await ledger.pending(), hasLength(1));
    },
  );

  test(
    'failed audit rolls back status, revoked assignments and recovery request',
    () async {
      await stopCandidate();
      final future = await experiments.reserve(
        experiment.id,
        scheduledTimeMs: now
            .add(const Duration(days: 1))
            .millisecondsSinceEpoch,
        contextKey: 'context',
      );
      await db.customStatement(
        "CREATE TRIGGER reject_restore BEFORE INSERT ON experiment_audit_events WHEN NEW.event_type = 'stableRestoreRequested' BEGIN SELECT RAISE(ABORT, 'fixture'); END",
      );
      await expectLater(lifecycle.processPending(), throwsA(anything));
      expect(
        (await experiments.findById(experiment.id))!.status,
        ExperimentStatus.running,
      );
      expect(
        (await experiments.sessions(experiment.id))
            .singleWhere((a) => a.id == future.id)
            .validity,
        SessionValidity.partial,
      );
      expect(await decisions(), isEmpty);
      expect(await ledger.pending(), isEmpty);
      await db.customStatement('DROP TRIGGER reject_restore');
      expect(await lifecycle.processPending(), 1);
    },
  );

  test('concurrent processing yields a single result and request', () async {
    await stopCandidate();
    expect(
      (await Future.wait([
        lifecycle.processPending(),
        lifecycle.processPending(),
      ])).reduce((a, b) => a + b),
      1,
    );
    expect(await decisions(), hasLength(1));
    expect(await ledger.pending(), hasLength(1));
  });

  test(
    'native rejection and exceptions leave a durable retry until acceptance',
    () async {
      await stopCandidate();
      await lifecycle.processPending();
      native.reject = true;
      expect(await restoration.retryPending(), 0);
      expect(await ledger.pending(), hasLength(1));
      native.reject = false;
      native.fail = true;
      expect(await restoration.retryPending(), 0);
      expect(await ledger.pending(), hasLength(1));
      native.fail = false;
      expect(await restoration.retryPending(), 1);
      expect(await ledger.pending(), isEmpty);
      expect(await restoration.retryPending(), 0);
      expect(preparations, 0);
      expect(native.schedules.last.experiment, isNull);
      expect(native.schedules.last.protocolId, control.id);
      expect(native.schedules.last.sessionId, isEmpty);
    },
  );

  test(
    'failed acceptance audit retries idempotent native scheduling',
    () async {
      await stopCandidate();
      await lifecycle.processPending();
      await db.customStatement(
        "CREATE TRIGGER reject_ack BEFORE INSERT ON experiment_audit_events WHEN NEW.event_type = 'stableRestoreAccepted' BEGIN SELECT RAISE(ABORT, 'fixture'); END",
      );
      expect(await restoration.retryPending(), 0);
      expect(await ledger.pending(), hasLength(1));
      await db.customStatement('DROP TRIGGER reject_ack');
      expect(await restoration.retryPending(), 1);
      expect(native.schedules, hasLength(2));
    },
  );

  test(
    'disabled or deleted alarms are explicitly skipped without scheduling',
    () async {
      await stopCandidate();
      await lifecycle.processPending();
      await (db.update(db.alarms)..where((a) => a.id.equals('alarm-1'))).write(
        const AlarmsCompanion(enabled: Value(false)),
      );
      expect(await restoration.retryPending(), 1);
      expect(native.schedules, isEmpty);
      expect(
        (await experiments.audit(experiment.id)).last.eventType,
        'stableRestoreSkipped',
      );
      expect(
        (await experiments.audit(experiment.id)).last.detailsJson,
        contains('disabled'),
      );
    },
  );

  test('lowered cap is honored at recovery time instead of restoring an old snapshot', () async {
    await stopCandidate();
    await lifecycle.processPending();
    await (db.update(
      db.alarmAdaptationSettings,
    )..where((r) => r.alarmId.equals('alarm-1'))).write(
      const AlarmAdaptationSettingsCompanion(userMaxVolumePercent: Value(40)),
    );
    expect(await restoration.retryPending(), 1);
    expect(native.schedules.single.maxVolumePercent, lessThanOrEqualTo(40));
    expect(native.schedules.single.initialVolumePercent, lessThanOrEqualTo(40));
  });

  test(
    'active wake defers recovery and leaves its immutable snapshot untouched',
    () async {
      await stopCandidate();
      final at = now.add(const Duration(minutes: 1));
      final a = await experiments.reserve(
        experiment.id,
        scheduledTimeMs: at.millisecondsSinceEpoch,
        contextKey: 'context',
      );
      await db
          .into(db.wakeSessions)
          .insert(
            WakeSessionsCompanion.insert(
              id: 'in-flight',
              alarmId: 'alarm-1',
              scheduledTimeMs: a.scheduledTimeMs,
              triggeredAtMs: a.scheduledTimeMs,
              initialSoundId: control.initialSoundId,
              outcome: 'active',
              currentWakeFlowState: const Value('missionActive'),
              createdAtMs: a.scheduledTimeMs,
              protocolId: Value(control.id),
              protocolVersion: Value(control.version),
              protocolSnapshotJson: Value(encodeWakeProtocolSnapshot(control)),
            ),
          );
      await experiments.attach(a.id, 'in-flight');
      now = at.add(const Duration(seconds: 10));
      final before = await (db.select(
        db.wakeSessions,
      )..where((s) => s.id.equals('in-flight'))).getSingle();
      await lifecycle.processPending();
      expect(await restoration.retryPending(), 0);
      expect(native.schedules, isEmpty);
      expect(
        (await experiments.sessions(experiment.id)).last.validity,
        SessionValidity.partial,
      );
      expect(
        await (db.select(
          db.wakeSessions,
        )..where((s) => s.id.equals('in-flight'))).getSingle(),
        before,
      );
      expect(await ledger.pending(), hasLength(1));
    },
  );

  test('pending recovery blocks new experiment reservations', () async {
    await stopCandidate();
    await lifecycle.processPending();
    final next = await experiments.create(
      name: 'Another comparison',
      hypothesis: 'Same setting',
      control: control,
      candidate: candidate,
      dimension: ExperimentDimension.soundFamily,
      contextKey: 'context',
    );
    await experiments.changeStatus(
      next.id,
      ExperimentStatus.ready,
      reason: 'Prepared',
    );
    await experiments.changeStatus(
      next.id,
      ExperimentStatus.running,
      reason: 'Start',
    );
    await expectLater(
      experiments.reserve(
        next.id,
        scheduledTimeMs: now
            .add(const Duration(days: 1))
            .millisecondsSinceEpoch,
        contextKey: 'context',
      ),
      throwsStateError,
    );
    expect(await experiments.sessions(next.id), isEmpty);
  });

  test('deleted alarms are skipped without recreating them', () async {
    await stopCandidate();
    await lifecycle.processPending();
    await (db.delete(db.alarms)..where((a) => a.id.equals('alarm-1'))).go();
    expect(await restoration.retryPending(), 1);
    expect(native.schedules, isEmpty);
    expect(await db.select(db.alarms).get(), isEmpty);
    expect(
      (await experiments.audit(experiment.id)).last.detailsJson,
      contains('deleted'),
    );
  });

  test('ties complete at the attempt budget without a winner', () async {
    for (var i = 0; i < 20; i++) {
      await add(latency: 20000);
    }
    expect(await lifecycle.processPending(), 1);
    final stored = (await experiments.findById(experiment.id))!;
    expect(stored.status, ExperimentStatus.completed);
    expect(stored.result, ExperimentOutcome.noClearWinner);
    expect(stored.winnerProtocolId, isNull);
    expect(await ledger.pending(), hasLength(1));
  });

  test('attempt budget with missing wakes pauses for review', () async {
    for (var i = 0; i < 20; i++) {
      await experiments.reserve(
        experiment.id,
        scheduledTimeMs: now
            .add(Duration(minutes: i + 1))
            .millisecondsSinceEpoch,
        contextKey: 'context',
      );
    }
    expect(await lifecycle.processPending(), 1);
    expect(
      (await experiments.findById(experiment.id))!.status,
      ExperimentStatus.paused,
    );
    expect(
      (await experiments.findById(experiment.id))!.result,
      ExperimentOutcome.insufficientData,
    );
    expect(
      jsonDecode((await decisions()).single.detailsJson)['recommendation'],
      'reviewRequired',
    );
  });

  test(
    'ordinary rearming cannot bypass a pending restoration request',
    () async {
      await stopCandidate();
      await lifecycle.processPending();
      final scheduling = ExperimentSchedulingService(
        db,
        protocols,
        AlarmRuntimeGateway(api: native),
        clock: () => now,
      );
      expect(await scheduling.rearmNextOccurrences(), 0);
      expect(native.schedules, isEmpty);
    },
  );

  test(
    'concurrent recovery calls share one native request and acknowledgement',
    () async {
      await stopCandidate();
      await lifecycle.processPending();
      await Future.wait([
        restoration.retryPending(),
        restoration.retryPending(),
      ]);
      expect(native.schedules, hasLength(1));
      expect(await ledger.pending(), isEmpty);
      expect(
        (await experiments.audit(experiment.id))
            .where((a) => a.eventType == 'stableRestoreAccepted'),
        hasLength(1),
      );
    },
  );

  test('malformed acknowledgement cannot hide a pending request', () async {
    await stopCandidate();
    await lifecycle.processPending();
    await db
        .into(db.experimentAuditEvents)
        .insert(
          ExperimentAuditEventsCompanion.insert(
            id: 'corrupt-ack',
            experimentId: experiment.id,
            sequence: 1000,
            eventType: 'stableRestoreAccepted',
            occurredAtMs: now.millisecondsSinceEpoch,
            detailsJson: '{broken',
          ),
        );
    expect(await ledger.pending(), hasLength(1));
    expect(await restoration.retryPending(), 1);
  });

  test(
    'production recovery providers construct without a dependency cycle',
    () async {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          alarmRuntimeApiProvider.overrideWithValue(native),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(experimentLifecycleServiceProvider),
        isA<ExperimentLifecycleService>(),
      );
      expect(
        container.read(experimentRestorationServiceProvider),
        isA<ExperimentRestorationService>(),
      );
      expect(
        await container
            .read(experimentRestorationServiceProvider)
            .retryPending(),
        0,
      );
    },
  );

  test('settings changed during validation defer recovery instead of restoring a stale plan', () async {
    await stopCandidate();
    await lifecycle.processPending();
    native.beforeVibrationCheck = () async {
      native.beforeVibrationCheck = null;
      await protocols.insertAndActivate(
        control.copyWith(
          id: 'manual-edit',
          version: 3,
          initialVolumePercent: 60,
        ),
      );
    };
    expect(await restoration.retryPending(), 0);
    expect(native.schedules, isEmpty);
    expect(await ledger.pending(), hasLength(1));
    expect(await restoration.retryPending(), 1);
    expect(native.schedules.single.protocolId, 'manual-edit');
  });

  testWidgets(
    'failed native import skips recovery but still reaches mission handling',
    (tester) async {
      await stopCandidate();
      await lifecycle.processPending();
      native.failOutbox = true;
      var missionChecked = false;
      const channel = MethodChannel('ryser/wake_enforcement');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        if (call.method == 'takePendingMission') missionChecked = true;
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            alarmRuntimeApiProvider.overrideWithValue(native),
          ],
          child: const RyserApp(),
        ),
      );
      for (var i = 0; i < 30 && !missionChecked; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(missionChecked, isTrue);
      expect(native.schedules, isEmpty);
      expect(await ledger.pending(), hasLength(1));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    },
  );

  test('recovery request survives database close and reopen', () async {
    final directory = await Directory.systemTemp.createTemp(
      'ryser-restoration-',
    );
    final file = File('${directory.path}/fixture.sqlite');
    await db.close();
    connect(AppDatabase.forTesting(NativeDatabase(file)));
    await seed();
    await stopCandidate();
    await lifecycle.processPending();
    await db.close();
    connect(AppDatabase.forTesting(NativeDatabase(file)));
    expect(await ledger.pending(), hasLength(1));
    expect(await restoration.retryPending(), 1);
    expect(await ledger.pending(), isEmpty);
    await db.close();
    connect(AppDatabase.forTesting(NativeDatabase.memory()));
    await directory.delete(recursive: true);
  });
}
