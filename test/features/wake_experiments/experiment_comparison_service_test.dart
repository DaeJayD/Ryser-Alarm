import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/wake_experiments/data/experiment_comparison_service.dart';
import 'package:ryser/features/wake_experiments/data/wake_experiment_repository.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_evaluator.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

import '../adaptive_wake/adaptive_test_fixtures.dart';

void main() {
  late AppDatabase database;
  late WakeExperimentRepository experiments;
  late ExperimentComparisonService comparisons;
  late WakeExperiment experiment;
  var occurrence = 0;
  const context = 'context';
  final control = protocol();
  final candidate = control.copyWith(
    id: 'new',
    version: 2,
    initialSoundId: 'melody',
    initialSoundFamily: 'MELODIC',
    ringtoneUri: 'content://melody',
  );

  setUp(() async {
    occurrence = 0;
    database = AppDatabase.forTesting(NativeDatabase.memory());
    final protocols = WakeProtocolRepository(database);
    experiments = WakeExperimentRepository(
      database,
      protocols,
      clock: () => DateTime.fromMillisecondsSinceEpoch(1000),
    );
    comparisons = ExperimentComparisonService(database, experiments);
    await database
        .into(database.alarms)
        .insert(
          AlarmsCompanion.insert(
            id: 'alarm-1',
            localHour: 7,
            localMinute: 0,
            recurrenceType: 'daily',
            soundId: 'pulse',
            snoozeDurationMinutes: 5,
            createdAtMs: 1,
            updatedAtMs: 1,
          ),
        );
    await protocols.savePolicy('alarm-1', adaptivePolicy);
    experiment = await experiments.create(
      name: 'Melody',
      hypothesis: 'Try melody',
      control: control,
      candidate: candidate,
      dimension: ExperimentDimension.soundFamily,
      contextKey: context,
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
  });
  tearDown(() => database.close());

  Future<ExperimentSession> addWake({
    String outcome = 'wakeConfirmed',
    bool finalize = true,
    int? latency,
    int checkFailures = 0,
    int snoozes = 0,
    bool trigger = true,
  }) async {
    final a = await experiments.reserve(
      experiment.id,
      scheduledTimeMs: 5000 + occurrence++ * 200000,
      contextKey: context,
    );
    final p = a.variant == ExperimentVariant.control ? control : candidate;
    await database
        .into(database.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: 'wake-${a.id}',
            alarmId: a.alarmId,
            scheduledTimeMs: a.scheduledTimeMs,
            triggeredAtMs: a.scheduledTimeMs,
            initialSoundId: p.initialSoundId,
            outcome: outcome,
            createdAtMs: a.scheduledTimeMs,
            completedAtMs: Value(a.scheduledTimeMs + 120000),
            responseLatencyMs: Value(
              latency ??
                  (a.variant == ExperimentVariant.control ? 40000 : 10000),
            ),
            wakeCheckFailureCount: Value(checkFailures),
            snoozeCount: Value(snoozes),
            protocolId: Value(p.id),
            protocolVersion: Value(p.version),
            protocolSnapshotJson: Value(encodeWakeProtocolSnapshot(p)),
          ),
        );
    if (trigger) {
      await database
          .into(database.wakeEvents)
          .insert(
            WakeEventsCompanion.insert(
              id: 'event-${a.id}',
              wakeSessionId: 'wake-${a.id}',
              sequenceNumber: 0,
              eventType: 'ALARM_TRIGGERED',
              occurredAtMs: a.scheduledTimeMs,
              metadataJson: '{}',
              source: 'fixture',
            ),
          );
    }
    await experiments.attach(a.id, 'wake-${a.id}');
    if (finalize) {
      await experiments.finishSession(a.id, validity: SessionValidity.valid);
    }
    return a;
  }

  test(
    'six saved wakes produce a repeatable read without promoting or writing',
    () async {
      for (var i = 0; i < 6; i++) {
        await addWake();
      }
      final auditBefore = (await experiments.audit(experiment.id)).length;
      final assignmentsBefore = await database
          .select(database.experimentSessions)
          .get();
      final r = await comparisons.load(experiment.id);
      expect(r.outcome, ExperimentOutcome.candidateBetter);
      expect(r.control.validSessions, 3);
      expect(r.candidate.validSessions, 3);
      expect(r.candidate.meanConfiguredIntensity, 2);
      expect(
        jsonEncode((await comparisons.load(experiment.id)).toJson()),
        jsonEncode(r.toJson()),
      );
      final stored = (await experiments.findById(experiment.id))!;
      expect(stored.status, ExperimentStatus.running);
      expect(stored.winnerProtocolId, isNull);
      expect(stored.result, ExperimentOutcome.insufficientData);
      expect((await experiments.audit(experiment.id)).length, auditBefore);
      expect(
        await database.select(database.experimentSessions).get(),
        assignmentsBefore,
      );
      expect(await database.select(database.wakeProtocols).get(), isEmpty);
    },
  );

  test(
    'unfinalized wakes stay partial even if they have a completion timestamp',
    () async {
      await addWake(finalize: false);
      final r = await comparisons.load(experiment.id);
      expect(r.control.partialSessions, 1);
      expect(r.control.validSessions, 0);
    },
  );

  test(
    'a fully observed bypass is a failure, not an excluded sample',
    () async {
      await addWake();
      await addWake(outcome: 'bypassed');
      final r = await comparisons.load(experiment.id);
      expect(r.recommendation, ExperimentRecommendation.stopCandidate);
      expect(r.candidate.validSessions, 1);
      expect(r.candidate.successRate, 0);
      expect(r.candidate.bypassRate, 1);
    },
  );

  test(
    'missing trigger or changed executed snapshot cannot count as valid',
    () async {
      await addWake(trigger: false);
      final a = await addWake();
      await (database.update(
        database.wakeSessions,
      )..where((w) => w.id.equals('wake-${a.id}'))).write(
        const WakeSessionsCompanion(protocolSnapshotJson: Value('{broken')),
      );
      final r = await comparisons.load(experiment.id);
      expect(r.control.validSessions, 0);
      expect(r.candidate.validSessions, 0);
      expect(r.control.excludedSessions, 1);
      expect(r.candidate.excludedSessions, 1);
      expect(
        (await experiments.sessions(experiment.id))
            .every((s) => s.validity == SessionValidity.valid),
        isTrue,
        reason: 'Read-only classification never rewrites finalized evidence.',
      );
    },
  );

  test(
    'an unfinished follow-up check excludes an otherwise finalized wake',
    () async {
      final a = await addWake();
      await database
          .into(database.wakeChecks)
          .insert(
            WakeChecksCompanion.insert(
              id: 'pending',
              wakeSessionId: 'wake-${a.id}',
              attemptNumber: 1,
              scheduledForMs: a.scheduledTimeMs + 180000,
              status: 'pending',
              createdAtMs: a.scheduledTimeMs,
            ),
          );
      expect((await comparisons.load(experiment.id)).control.validSessions, 0);
    },
  );

  test(
    'raw failed checks and reactivations cannot be hidden by summary counters',
    () async {
      final a = await addWake();
      await database
          .into(database.wakeChecks)
          .insert(
            WakeChecksCompanion.insert(
              id: 'failed',
              wakeSessionId: 'wake-${a.id}',
              attemptNumber: 1,
              scheduledForMs: a.scheduledTimeMs + 1000,
              status: 'failed',
              createdAtMs: a.scheduledTimeMs,
              completedAtMs: Value(a.scheduledTimeMs + 2000),
            ),
          );
      await database
          .into(database.wakeEvents)
          .insert(
            WakeEventsCompanion.insert(
              id: 'retry',
              wakeSessionId: 'wake-${a.id}',
              sequenceNumber: 1,
              eventType: 'ALARM_REACTIVATED',
              occurredAtMs: a.scheduledTimeMs + 3000,
              metadataJson: '{}',
              source: 'fixture',
            ),
          );
      final r = await comparisons.load(experiment.id);
      expect(r.control.validSessions, 1);
      expect(r.control.checkFailureRate, 1);
      expect(r.control.reactivationRate, 1);
    },
  );

  test(
    'out of order or post-completion events do not become successful samples',
    () async {
      final a = await addWake();
      final b = await addWake();
      for (final row in [
        (a, a.scheduledTimeMs - 1),
        (b, b.scheduledTimeMs + 120001),
      ]) {
        await database
            .into(database.wakeEvents)
            .insert(
              WakeEventsCompanion.insert(
                id: 'bad-${row.$1.id}',
                wakeSessionId: 'wake-${row.$1.id}',
                sequenceNumber: 1,
                eventType: 'DISMISS_REQUESTED',
                occurredAtMs: row.$2,
                metadataJson: '{}',
                source: 'fixture',
              ),
            );
      }
      final r = await comparisons.load(experiment.id);
      expect(r.control.validSessions + r.candidate.validSessions, 0);
    },
  );

  test('negative counters and impossible response latency are rejected, not clamped', () async {
    await addWake(checkFailures: -1);
    await addWake(latency: 120001);
    final r = await comparisons.load(experiment.id);
    expect(r.control.validSessions + r.candidate.validSessions, 0);
  });

  test('later edits to completion timestamps cannot silently change the comparison', () async {
    final a = await addWake();
    await (database.update(
      database.wakeSessions,
    )..where((w) => w.id.equals('wake-${a.id}'))).write(
      WakeSessionsCompanion(completedAtMs: Value(a.scheduledTimeMs + 130000)),
    );
    expect((await comparisons.load(experiment.id)).control.excludedSessions, 1);
  });

  test(
    'a raw task bypass remains adverse even without its event or summary',
    () async {
      await addWake();
      final a = await addWake();
      await database
          .into(database.missions)
          .insert(
            MissionsCompanion.insert(
              id: 'task',
              alarmId: a.alarmId,
              missionType: 'movement',
              difficulty: 'easy',
              createdAtMs: 1,
              updatedAtMs: 1,
            ),
          );
      await database
          .into(database.missionExecutions)
          .insert(
            MissionExecutionsCompanion.insert(
              id: 'bypass',
              wakeSessionId: 'wake-${a.id}',
              missionId: 'task',
              missionType: 'movement',
              status: 'bypassed',
              attemptNumber: 1,
              startedAtMs: a.scheduledTimeMs + 1000,
              completedAtMs: Value(a.scheduledTimeMs + 2000),
            ),
          );
      final r = await comparisons.load(experiment.id);
      expect(r.recommendation, ExperimentRecommendation.stopCandidate);
      expect(r.candidate.successRate, 0);
      expect(r.candidate.bypassRate, 1);
    },
  );

  test(
    'a trigger recorded at the wrong time cannot prove original execution',
    () async {
      final a = await addWake();
      await (database.update(
        database.wakeEvents,
      )..where((e) => e.id.equals('event-${a.id}'))).write(
        WakeEventsCompanion(occurredAtMs: Value(a.scheduledTimeMs + 1)),
      );
      expect(
        (await comparisons.load(experiment.id)).control.excludedSessions,
        1,
      );
    },
  );

  test('cancelled tests cannot supply a winner and unknown tests are explicit errors', () async {
    await experiments.changeStatus(
      experiment.id,
      ExperimentStatus.cancelled,
      reason: 'User stopped',
    );
    await expectLater(comparisons.load(experiment.id), throwsStateError);
    await expectLater(comparisons.load('missing'), throwsStateError);
  });
}
