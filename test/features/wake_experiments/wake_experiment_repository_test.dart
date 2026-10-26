import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/wake_experiments/data/wake_experiment_repository.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

import '../adaptive_wake/adaptive_test_fixtures.dart';

void main() {
  late AppDatabase database;
  late WakeProtocolRepository protocols;
  late WakeExperimentRepository repository;
  var now = 1000;
  final control = protocol();
  final candidate = control.copyWith(
    id: 'protocol-2',
    version: 2,
    initialSoundId: 'melodic-a',
    initialSoundFamily: 'MELODIC',
    ringtoneUri: 'content://sound/2',
  );
  const context = 'v1:alarm-1:early-weekday';

  void connect(AppDatabase db) {
    database = db;
    protocols = WakeProtocolRepository(database);
    repository = WakeExperimentRepository(
      database,
      protocols,
      clock: () => DateTime.fromMillisecondsSinceEpoch(now),
    );
  }

  Future<void> seed() async {
    await database
        .into(database.alarms)
        .insert(
          AlarmsCompanion.insert(
            id: 'alarm-1',
            localHour: 7,
            localMinute: 0,
            recurrenceType: 'daily',
            soundId: 'pulse-a',
            snoozeDurationMinutes: 5,
            createdAtMs: 100,
            updatedAtMs: 100,
          ),
        );
    await protocols.savePolicy('alarm-1', adaptivePolicy);
  }

  Future<WakeExperiment> create() => repository.create(
    name: 'Try melody',
    hypothesis: 'Melody reduces response time for this weekday alarm.',
    control: control,
    candidate: candidate,
    dimension: ExperimentDimension.soundFamily,
    contextKey: context,
  );
  Future<WakeExperiment> start() async {
    final e = await create();
    await repository.changeStatus(
      e.id,
      ExperimentStatus.ready,
      reason: 'Validated',
    );
    await repository.changeStatus(
      e.id,
      ExperimentStatus.running,
      reason: 'Start comparison',
    );
    return e;
  }

  Future<void> observed(
    ExperimentSession a,
    String id, {
    String outcome = 'wakeConfirmed',
    bool completed = true,
    String? snapshot,
    int? triggeredAtMs,
  }) async {
    final p = a.variant == ExperimentVariant.control ? control : candidate;
    await database
        .into(database.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: id,
            alarmId: a.alarmId,
            scheduledTimeMs: a.scheduledTimeMs,
            triggeredAtMs: triggeredAtMs ?? a.scheduledTimeMs,
            initialSoundId: p.initialSoundId,
            outcome: outcome,
            createdAtMs: a.scheduledTimeMs,
            completedAtMs: completed
                ? Value(a.scheduledTimeMs + 20000)
                : const Value.absent(),
            protocolId: Value(p.id),
            protocolVersion: Value(p.version),
            protocolSnapshotJson: Value(
              snapshot ?? encodeWakeProtocolSnapshot(p),
            ),
          ),
        );
  }

  setUp(() async {
    now = 1000;
    connect(AppDatabase.forTesting(NativeDatabase.memory()));
    await seed();
  });
  tearDown(() => database.close());

  test(
    'six pre-run reservations alternate and repeat without changing audit',
    () async {
      final e = await start();
      for (var i = 0; i < 6; i++) {
        final a = await repository.reserve(
          e.id,
          scheduledTimeMs: 5000 + i * 1000,
          contextKey: context,
        );
        expect(a.assignmentIndex, i);
        expect(a.variant, variantForAssignment(i));
        final before = (await repository.audit(e.id)).length;
        final replay = await repository.reserve(
          e.id,
          scheduledTimeMs: a.scheduledTimeMs,
          contextKey: context,
        );
        expect(replay.id, a.id);
        expect((await repository.audit(e.id)).length, before);
      }
      expect(
        (await repository.audit(e.id)).map((a) => a.sequence),
        List.generate(9, (i) => i),
      );
      expect(
        await database.select(database.wakeProtocols).get(),
        isEmpty,
        reason:
            'Creating an experiment must not activate a candidate protocol.',
      );
    },
  );

  test(
    'wrong context, past wakes and invalid lifecycle do not create assignments',
    () async {
      final e = await create();
      await expectLater(
        repository.reserve(e.id, scheduledTimeMs: 5000, contextKey: context),
        throwsStateError,
      );
      await expectLater(
        repository.changeStatus(e.id, ExperimentStatus.running, reason: 'skip'),
        throwsStateError,
      );
      await repository.changeStatus(
        e.id,
        ExperimentStatus.ready,
        reason: 'ready',
      );
      await repository.changeStatus(
        e.id,
        ExperimentStatus.running,
        reason: 'start',
      );
      await expectLater(
        repository.reserve(e.id, scheduledTimeMs: 5000, contextKey: 'other'),
        throwsStateError,
      );
      await expectLater(
        repository.reserve(e.id, scheduledTimeMs: now, contextKey: context),
        throwsStateError,
      );
      expect(await repository.sessions(e.id), isEmpty);
      await expectLater(
        repository.changeStatus(
          e.id,
          ExperimentStatus.completed,
          reason: 'too early',
        ),
        throwsStateError,
      );
    },
  );

  test(
    'unique open experiment and immutable variants enforced by database',
    () async {
      final first = await start();
      final other = await create();
      await expectLater(
        repository.changeStatus(
          other.id,
          ExperimentStatus.ready,
          reason: 'duplicate',
        ),
        throwsA(anything),
      );
      expect(
        (await repository.findById(other.id))!.status,
        ExperimentStatus.draft,
      );
      expect(
        (await repository.audit(other.id)),
        hasLength(1),
        reason: 'State and audit rollback together.',
      );
      await expectLater(
        (database.update(
          database.wakeExperiments,
        )..where((r) => r.id.equals(first.id))).write(
          const WakeExperimentsCompanion(candidateSnapshotJson: Value('{}')),
        ),
        throwsA(anything),
      );
      await expectLater(
        database.customStatement(
          "UPDATE experiment_audit_events SET details_json = '{}'",
        ),
        throwsA(anything),
      );
      await expectLater(
        database.customStatement('DELETE FROM experiment_audit_events'),
        throwsA(anything),
      );
    },
  );

  test('attach verifies execution and cannot give another session the same reservation', () async {
    final e = await start();
    final a = await repository.reserve(
      e.id,
      scheduledTimeMs: 5000,
      contextKey: context,
    );
    await observed(a, 'wrong', snapshot: '{}');
    await expectLater(repository.attach(a.id, 'wrong'), throwsStateError);
    await observed(a, 'correct');
    await repository.attach(a.id, 'correct');
    await repository.attach(a.id, 'correct');
    await expectLater(repository.attach(a.id, 'wrong'), throwsStateError);
    await expectLater(
      (database.update(
        database.experimentSessions,
      )..where((r) => r.id.equals(a.id))).write(
        const ExperimentSessionsCompanion(variant: Value('candidate')),
      ),
      throwsA(anything),
    );
    await repository.finishSession(a.id, validity: SessionValidity.valid);
    await repository.finishSession(a.id, validity: SessionValidity.valid);
    await expectLater(
      repository.finishSession(
        a.id,
        validity: SessionValidity.invalid,
        invalidReason: 'rewrite',
      ),
      throwsStateError,
    );
    expect(
      (await repository.sessions(e.id)).single.validity,
      SessionValidity.valid,
    );
    expect(
      (await repository.audit(e.id))
          .where((r) => r.eventType == 'sessionAttached'),
      hasLength(1),
    );
  });

  test('incomplete evidence excluded; bypass remains adverse evidence; invalidity never rerolls', () async {
    final e = await start();
    final a = await repository.reserve(
      e.id,
      scheduledTimeMs: 5000,
      contextKey: context,
    );
    await observed(a, 'partial', outcome: 'active', completed: false);
    await repository.attach(a.id, 'partial');
    await expectLater(
      repository.finishSession(a.id, validity: SessionValidity.valid),
      throwsStateError,
    );
    await repository.finishSession(
      a.id,
      validity: SessionValidity.invalid,
      invalidReason: 'Incomplete execution',
    );
    await expectLater(
      repository.reserve(e.id, scheduledTimeMs: 5000, contextKey: context),
      throwsStateError,
    );
    final b = await repository.reserve(
      e.id,
      scheduledTimeMs: 6000,
      contextKey: context,
    );
    expect(b.variant, ExperimentVariant.candidate);
    await observed(b, 'bypass', outcome: 'bypassed');
    await repository.attach(b.id, 'bypass');
    await repository.finishSession(b.id, validity: SessionValidity.valid);
    expect((await repository.sessions(e.id)).map((s) => s.validity), [
      SessionValidity.invalid,
      SessionValidity.valid,
    ]);
  });

  test(
    'no retrospective assignment even if supplied scheduled time is in future',
    () async {
      final e = await start();
      await database
          .into(database.wakeSessions)
          .insert(
            WakeSessionsCompanion.insert(
              id: 'already-observed',
              alarmId: 'alarm-1',
              scheduledTimeMs: 9000,
              triggeredAtMs: 500,
              initialSoundId: 'pulse-a',
              outcome: 'wakeConfirmed',
              createdAtMs: 500,
              completedAtMs: const Value(900),
            ),
          );
      await expectLater(
        repository.reserve(e.id, scheduledTimeMs: 9000, contextKey: context),
        throwsStateError,
      );
      expect(await repository.sessions(e.id), isEmpty);
    },
  );

  test('invalidation preserves completed evidence and forbids unfinished reservations', () async {
    final e = await start();
    final a = await repository.reserve(
      e.id,
      scheduledTimeMs: 5000,
      contextKey: context,
    );
    final b = await repository.reserve(
      e.id,
      scheduledTimeMs: 6000,
      contextKey: context,
    );
    await observed(a, 'completed');
    await repository.attach(a.id, 'completed');
    await repository.finishSession(a.id, validity: SessionValidity.valid);
    await repository.changeStatus(
      e.id,
      ExperimentStatus.invalidated,
      reason: 'User changed sound',
    );
    final assignments = await repository.sessions(e.id);
    expect(assignments.first.validity, SessionValidity.valid);
    expect(assignments.last.validity, SessionValidity.invalid);
    await expectLater(repository.attach(b.id, 'completed'), throwsStateError);
    await expectLater(
      repository.changeStatus(e.id, ExperimentStatus.running, reason: 'reopen'),
      throwsStateError,
    );
    expect(
      (await repository.findById(e.id))!.result,
      ExperimentOutcome.invalidated,
    );
  });

  test(
    'transactional reservations survive database close and reopen',
    () async {
      await database.close();
      final temporary = await Directory.systemTemp.createTemp(
        'ryser-experiment-',
      );
      final file = File('${temporary.path}/test.sqlite');
      try {
        connect(AppDatabase.forTesting(NativeDatabase(file)));
        await seed();
        final e = await start();
        final a = await repository.reserve(
          e.id,
          scheduledTimeMs: 5000,
          contextKey: context,
        );
        final auditCount = (await repository.audit(e.id)).length;
        await database.close();
        connect(AppDatabase.forTesting(NativeDatabase(file)));
        final replay = await repository.reserve(
          e.id,
          scheduledTimeMs: 5000,
          contextKey: context,
        );
        expect(replay.id, a.id);
        expect((await repository.audit(e.id)).length, auditCount);
        expect(
          (await repository.findById(e.id))!.candidateSnapshotJson,
          encodeWakeProtocolSnapshot(candidate),
        );
        expect(
          (await repository.reserve(
            e.id,
            scheduledTimeMs: 6000,
            contextKey: context,
          )).variant,
          ExperimentVariant.candidate,
        );
      } finally {
        await database.close();
        await temporary.delete(recursive: true);
        // tearDown owns the final live test connection.
        connect(AppDatabase.forTesting(NativeDatabase.memory()));
      }
    },
  );

  test(
    'locking a setting or lowering its cap also blocks reservation replay',
    () async {
      final e = await start();
      await repository.reserve(
        e.id,
        scheduledTimeMs: 5000,
        contextKey: context,
      );
      await (database.update(
        database.alarmAdaptationSettings,
      )..where((r) => r.alarmId.equals('alarm-1'))).write(
        const AlarmAdaptationSettingsCompanion(adaptSound: Value(false)),
      );
      await expectLater(
        repository.reserve(e.id, scheduledTimeMs: 5000, contextKey: context),
        throwsStateError,
      );
      await (database.update(
        database.alarmAdaptationSettings,
      )..where((r) => r.alarmId.equals('alarm-1'))).write(
        const AlarmAdaptationSettingsCompanion(
          adaptSound: Value(true),
          userMaxVolumePercent: Value(50),
        ),
      );
      await expectLater(
        repository.reserve(e.id, scheduledTimeMs: 5000, contextKey: context),
        throwsStateError,
      );
      expect(await repository.sessions(e.id), hasLength(1));
    },
  );

  test(
    'simultaneous reservation requests cannot consume two assignments',
    () async {
      final e = await start();
      final result = await Future.wait(
        List.generate(
          3,
          (_) => repository.reserve(
            e.id,
            scheduledTimeMs: 5000,
            contextKey: context,
          ),
        ),
      );
      expect(result.map((a) => a.id).toSet(), hasLength(1));
      expect(await repository.sessions(e.id), hasLength(1));
      expect(
        (await repository.audit(e.id)).where((r) => r.eventType == 'assigned'),
        hasLength(1),
      );
    },
  );

  test(
    'session uniqueness and provenance remain enforced when finalizing',
    () async {
      final e = await start();
      final a = await repository.reserve(
        e.id,
        scheduledTimeMs: 5000,
        contextKey: context,
      );
      final b = await repository.reserve(
        e.id,
        scheduledTimeMs: 6000,
        contextKey: context,
      );
      await observed(a, 'session');
      await repository.attach(a.id, 'session');
      await expectLater(
        (database.update(
          database.experimentSessions,
        )..where((r) => r.id.equals(b.id))).write(
          const ExperimentSessionsCompanion(wakeSessionId: Value('session')),
        ),
        throwsA(anything),
      );
      await (database.update(
        database.wakeSessions,
      )..where((r) => r.id.equals('session'))).write(
        const WakeSessionsCompanion(protocolSnapshotJson: Value('{}')),
      );
      await expectLater(
        repository.finishSession(a.id, validity: SessionValidity.valid),
        throwsStateError,
      );
      await repository.finishSession(
        a.id,
        validity: SessionValidity.invalid,
        invalidReason: 'Executed snapshot changed',
      );
      await expectLater(
        (database.update(
          database.experimentSessions,
        )..where((r) => r.id.equals(a.id))).write(
          const ExperimentSessionsCompanion(
            validity: Value('valid'),
            invalidReason: Value(null),
          ),
        ),
        throwsA(anything),
      );
    },
  );
}
