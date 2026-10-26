import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart' as db;
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_safety_policy.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';
import 'package:uuid/uuid.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart'
    show RuntimeEventDto;

/// Storage foundation only. Reservation must precede native scheduling; this
/// repository never activates protocols or starts alarm playback.
class WakeExperimentRepository {
  WakeExperimentRepository(
    this._database,
    this._protocols, {
    DateTime Function()? clock,
    String Function()? idFactory,
  }) : _clock = clock ?? DateTime.now,
       _idFactory = idFactory ?? const Uuid().v4;

  final db.AppDatabase _database;
  final WakeProtocolRepository _protocols;
  final DateTime Function() _clock;
  final String Function() _idFactory;

  Future<WakeExperiment> create({
    required String name,
    required String hypothesis,
    required WakeProtocol control,
    required WakeProtocol candidate,
    required ExperimentDimension dimension,
    required String contextKey,
    int minimumSessionsPerVariant = 3,
    int preferredSessionsPerVariant = 5,
    int maximumSessionsPerVariant = 10,
  }) => _database.transaction(() async {
    if (name.trim().isEmpty ||
        hypothesis.trim().isEmpty ||
        contextKey.trim().isEmpty) {
      throw ArgumentError(
        'Name, a concrete hypothesis and context are required.',
      );
    }
    if (minimumSessionsPerVariant < 3 ||
        preferredSessionsPerVariant < minimumSessionsPerVariant ||
        maximumSessionsPerVariant < preferredSessionsPerVariant ||
        maximumSessionsPerVariant > 100) {
      throw ArgumentError(
        'Require 3 <= minimum <= preferred <= maximum <= 100.',
      );
    }
    final alarm = await (_database.select(
      _database.alarms,
    )..where((r) => r.id.equals(control.alarmId))).getSingleOrNull();
    if (alarm == null) throw StateError('Alarm does not exist.');
    final policy = await _protocols.policyForAlarm(control.alarmId);
    final errors = const ExperimentSafetyPolicy().validate(
      control: control,
      candidate: candidate,
      dimension: dimension,
      policy: policy,
      controlSoundAvailable: await _protocols.isValid(control),
      candidateSoundAvailable: await _protocols.isValid(candidate),
      missionAvailable: true,
    );
    if (errors.isNotEmpty) throw StateError(errors.join(', '));
    final id = _idFactory(), now = _now;
    await _database
        .into(_database.wakeExperiments)
        .insert(
          db.WakeExperimentsCompanion.insert(
            id: id,
            alarmId: control.alarmId,
            name: name.trim(),
            hypothesis: hypothesis.trim(),
            status: ExperimentStatus.draft.name,
            dimension: dimension.name,
            controlProtocolId: control.id,
            controlProtocolVersion: control.version,
            controlSnapshotJson: encodeWakeProtocolSnapshot(control),
            candidateProtocolId: candidate.id,
            candidateProtocolVersion: candidate.version,
            candidateSnapshotJson: encodeWakeProtocolSnapshot(candidate),
            contextKey: contextKey,
            minimumSessionsPerVariant: minimumSessionsPerVariant,
            preferredSessionsPerVariant: preferredSessionsPerVariant,
            maximumSessionsPerVariant: maximumSessionsPerVariant,
            createdAtMs: now,
            updatedAtMs: now,
          ),
        );
    await _audit(id, 'created', {
      'dimension': dimension.name,
      'contextKey': contextKey,
    });
    return (await findById(id))!;
  });

  Future<WakeExperiment?> findById(String id) async {
    final row = await (_database.select(
      _database.wakeExperiments,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    return row == null ? null : _experiment(row);
  }

  Future<WakeExperiment?> runningForAlarm(String alarmId) async =>
      (await historyForAlarm(alarmId))
          .where((r) => r.status == ExperimentStatus.running)
          .firstOrNull;

  Future<void> invalidateForAlarm(String alarmId, String reason) async {
    for (final experiment in await historyForAlarm(alarmId)) {
      if ({
        ExperimentStatus.draft,
        ExperimentStatus.ready,
        ExperimentStatus.running,
        ExperimentStatus.paused,
      }.contains(experiment.status)) {
        await changeStatus(
          experiment.id,
          ExperimentStatus.invalidated,
          reason: reason,
        );
      }
    }
  }

  Future<void> recordNativeSchedule(
    String assignmentId,
    bool scheduled,
    String? errorCode,
  ) => _database.transaction(() async {
    final assignment = await _assignment(assignmentId);
    await _audit(
      assignment.experimentId,
      scheduled ? 'nativeScheduleAccepted' : 'nativeScheduleRejected',
      {'assignmentId': assignmentId, 'errorCode': ?errorCode},
    );
  });

  Future<void> invalidateAssignment(String assignmentId, String reason) =>
      _database.transaction(() async {
        final assignment = await _assignment(assignmentId);
        if (assignment.completedAtMs != null ||
            assignment.validity == SessionValidity.invalid) {
          return;
        }
        if (reason.trim().isEmpty) {
          throw ArgumentError('An invalidation reason is required.');
        }
        await (_database.update(
          _database.experimentSessions,
        )..where((r) => r.id.equals(assignmentId))).write(
          db.ExperimentSessionsCompanion(
            validity: const Value('invalid'),
            invalidReason: Value(reason),
            completedAtMs: Value(_now),
          ),
        );
        await _audit(assignment.experimentId, 'assignmentInvalidated', {
          'assignmentId': assignmentId,
          'reason': reason,
        });
      });

  /// Only a pre-existing reservation can receive native execution evidence.
  Future<void> reconcileTriggered(RuntimeEventDto event) async {
    final row =
        await (_database.select(_database.experimentSessions)..where(
              (r) =>
                  r.alarmId.equals(event.alarmId) &
                  r.scheduledTimeMs.equals(event.scheduledAtMs),
            ))
            .getSingleOrNull();
    if (row == null || row.validity == 'invalid') return;
    final assignment = event.experiment;
    if (assignment == null ||
        assignment.assignmentId != row.id ||
        assignment.experimentId != row.experimentId ||
        assignment.variant != row.variant ||
        assignment.contextKey != row.contextKey ||
        assignment.occurrenceAtMs != row.scheduledTimeMs ||
        assignment.assignedAtMs != row.assignedAtMs) {
      await invalidateAssignment(
        row.id,
        'Native assignment identity is missing or does not match.',
      );
      return;
    }
    try {
      await attach(row.id, event.sessionId);
    } on StateError {
      await invalidateAssignment(
        row.id,
        'Native protocol does not match the pre-run assignment.',
      );
    }
  }

  Future<List<WakeExperiment>> historyForAlarm(String alarmId) async =>
      (await (_database.select(_database.wakeExperiments)
                ..where((r) => r.alarmId.equals(alarmId))
                ..orderBy([
                  (r) => OrderingTerm.asc(r.createdAtMs),
                  (r) => OrderingTerm.asc(r.id),
                ]))
              .get())
          .map(_experiment)
          .toList(growable: false);

  Stream<List<WakeExperiment>> watchForAlarm(String alarmId) =>
      (_database.select(_database.wakeExperiments)
            ..where((r) => r.alarmId.equals(alarmId))
            ..orderBy([
              (r) => OrderingTerm.desc(r.createdAtMs),
              (r) => OrderingTerm.asc(r.id),
            ]))
          .watch()
          .map((rows) => rows.map(_experiment).toList(growable: false));

  Future<void> changeStatus(
    String id,
    ExperimentStatus status, {
    required String reason,
  }) => _database.transaction(() async {
    final current = await _require(id);
    if (reason.trim().isEmpty) {
      throw ArgumentError('A transition reason is required.');
    }
    if (!canTransitionExperiment(current.status, status) ||
        status == ExperimentStatus.completed) {
      throw StateError(
        'Invalid transition; completion requires the comparison evaluator.',
      );
    }
    if ({ExperimentStatus.ready, ExperimentStatus.running}.contains(status)) {
      final policy = await _protocols.policyForAlarm(current.alarmId);
      if (!policy.enabled) throw StateError('Adaptation is disabled.');
      final alarm = await (_database.select(
        _database.alarms,
      )..where((r) => r.id.equals(current.alarmId))).getSingleOrNull();
      if (alarm == null) throw StateError('Alarm no longer exists.');
    }
    final terminal = {
      ExperimentStatus.cancelled,
      ExperimentStatus.invalidated,
    }.contains(status);
    await (_database.update(
      _database.wakeExperiments,
    )..where((r) => r.id.equals(id))).write(
      db.WakeExperimentsCompanion(
        status: Value(status.name),
        updatedAtMs: Value(_now),
        startedAtMs:
            status == ExperimentStatus.running && current.startedAtMs == null
            ? Value(_now)
            : const Value.absent(),
        completedAtMs: terminal ? Value(_now) : const Value.absent(),
        invalidReason: status == ExperimentStatus.invalidated
            ? Value(reason.trim())
            : const Value.absent(),
        result: status == ExperimentStatus.invalidated
            ? Value(ExperimentOutcome.invalidated.name)
            : const Value.absent(),
      ),
    );
    if (terminal) {
      // Invalidate unfinished reservations; never rewrite finished evidence.
      await (_database.update(_database.experimentSessions)..where(
            (r) =>
                r.experimentId.equals(id) &
                r.completedAtMs.isNull() &
                r.validity.equals('partial'),
          ))
          .write(
            db.ExperimentSessionsCompanion(
              validity: const Value('invalid'),
              invalidReason: Value(
                'experiment_${status.name}: ${reason.trim()}',
              ),
            ),
          );
    }
    await _audit(id, 'statusChanged', {
      'from': current.status.name,
      'to': status.name,
      'reason': reason.trim(),
    });
  });

  /// An idempotency key is the alarm's original scheduled occurrence, not snooze.
  Future<ExperimentSession> reserve(
    String experimentId, {
    required int scheduledTimeMs,
    required String contextKey,
  }) => _database.transaction(() async {
    final experiment = await _require(experimentId);
    if (experiment.status != ExperimentStatus.running ||
        experiment.contextKey != contextKey) {
      throw StateError('Experiment is not running in this context.');
    }
    await _validateCurrentBounds(experiment);
    final existing =
        await (_database.select(_database.experimentSessions)..where(
              (r) =>
                  r.alarmId.equals(experiment.alarmId) &
                  r.scheduledTimeMs.equals(scheduledTimeMs),
            ))
            .getSingleOrNull();
    if (existing != null) {
      if (existing.experimentId != experimentId ||
          existing.contextKey != contextKey) {
        throw StateError(
          'Occurrence already belongs to a different assignment.',
        );
      }
      if (existing.validity == SessionValidity.invalid.name) {
        throw StateError('Occurrence assignment was invalidated.');
      }
      return _session(existing);
    }
    final now = _now;
    if (scheduledTimeMs <= now) {
      throw StateError('Assignment must precede the scheduled occurrence.');
    }
    // Outcomes must never affect a newly manufactured assignment for an old run.
    final observed =
        await (_database.select(_database.wakeSessions)..where(
              (r) =>
                  r.alarmId.equals(experiment.alarmId) &
                  r.scheduledTimeMs.equals(scheduledTimeMs),
            ))
            .get();
    if (observed.isNotEmpty) {
      throw StateError('This occurrence has already run.');
    }
    final rows = await sessions(experimentId);
    if (rows.length >= experiment.maximumSessionsPerVariant * 2) {
      throw StateError(
        'Experiment attempt budget exhausted; pause and review incomplete evidence.',
      );
    }
    final index = rows.length, variant = variantForAssignment(rows.length);
    final control = variant == ExperimentVariant.control;
    final id = _idFactory();
    await _database
        .into(_database.experimentSessions)
        .insert(
          db.ExperimentSessionsCompanion.insert(
            id: id,
            experimentId: experimentId,
            alarmId: experiment.alarmId,
            scheduledTimeMs: scheduledTimeMs,
            assignmentIndex: index,
            variant: variant.name,
            protocolId: control
                ? experiment.controlProtocolId
                : experiment.candidateProtocolId,
            protocolVersion: control
                ? experiment.controlProtocolVersion
                : experiment.candidateProtocolVersion,
            contextKey: contextKey,
            assignedAtMs: now,
          ),
        );
    await _audit(experimentId, 'assigned', {
      'assignmentId': id,
      'scheduledTimeMs': scheduledTimeMs,
      'index': index,
      'variant': variant.name,
    });
    return (await sessions(experimentId)).firstWhere((r) => r.id == id);
  });

  /// Import may occur after completion, but the durable assignment must predate
  /// triggering. Missing/mismatched snapshots never acquire experimental credit.
  Future<void> attach(String assignmentId, String wakeSessionId) =>
      _database.transaction(() async {
        final assignment = await _assignment(assignmentId);
        if (assignment.wakeSessionId != null) {
          if (assignment.wakeSessionId == wakeSessionId) return;
          throw StateError('Assignment already has a wake session.');
        }
        if (assignment.validity == SessionValidity.invalid) {
          throw StateError('Assignment was invalidated.');
        }
        final experiment = await _require(assignment.experimentId);
        final session = await (_database.select(
          _database.wakeSessions,
        )..where((r) => r.id.equals(wakeSessionId))).getSingleOrNull();
        if (session == null ||
            !_matchesAssignment(assignment, experiment, session)) {
          throw StateError(
            'Observed execution does not match the pre-run assignment.',
          );
        }
        await (_database.update(
          _database.experimentSessions,
        )..where((r) => r.id.equals(assignmentId))).write(
          db.ExperimentSessionsCompanion(wakeSessionId: Value(wakeSessionId)),
        );
        await _audit(assignment.experimentId, 'sessionAttached', {
          'assignmentId': assignmentId,
          'wakeSessionId': wakeSessionId,
        });
      });

  /// A later classifier supplies validity; failed outcomes may still be valid.
  /// This layer independently enforces completed provenance and immutability.
  Future<void> finishSession(
    String assignmentId, {
    required SessionValidity validity,
    String? invalidReason,
  }) => _database.transaction(() async {
    if (validity == SessionValidity.partial) {
      throw ArgumentError('Cannot finalize as partial.');
    }
    if (validity == SessionValidity.invalid &&
        (invalidReason == null || invalidReason.trim().isEmpty)) {
      throw ArgumentError('Invalid evidence requires a reason.');
    }
    final assignment = await _assignment(assignmentId);
    final reason = validity == SessionValidity.invalid
        ? invalidReason!.trim()
        : null;
    if (assignment.completedAtMs != null) {
      if (assignment.validity == validity &&
          assignment.invalidReason == reason) {
        return;
      }
      throw StateError('Completed evidence cannot be rewritten.');
    }
    if (assignment.validity == SessionValidity.invalid) {
      throw StateError('Assignment was invalidated.');
    }
    final session = assignment.wakeSessionId == null
        ? null
        : await (_database.select(_database.wakeSessions)
                ..where((r) => r.id.equals(assignment.wakeSessionId!)))
              .getSingleOrNull();
    final experiment = await _require(assignment.experimentId);
    if (validity == SessionValidity.valid &&
        (session == null ||
            !_matchesAssignment(assignment, experiment, session) ||
            session.completedAtMs == null ||
            session.completedAtMs! < session.triggeredAtMs ||
            !{
              'wakeConfirmed',
              'dismissed',
              'noResponse',
              'bypassed',
            }.contains(session.outcome))) {
      throw StateError('Valid evidence requires an observed completed wake.');
    }
    await (_database.update(
      _database.experimentSessions,
    )..where((r) => r.id.equals(assignmentId))).write(
      db.ExperimentSessionsCompanion(
        validity: Value(validity.name),
        completedAtMs: Value(session?.completedAtMs ?? _now),
        invalidReason: Value(reason),
      ),
    );
    await _audit(assignment.experimentId, 'sessionCompleted', {
      'assignmentId': assignmentId,
      'validity': validity.name,
      'reason': ?reason,
    });
  });

  Future<List<ExperimentSession>> sessions(String experimentId) async =>
      (await (_database.select(_database.experimentSessions)
                ..where((r) => r.experimentId.equals(experimentId))
                ..orderBy([(r) => OrderingTerm.asc(r.assignmentIndex)]))
              .get())
          .map(_session)
          .toList(growable: false);

  Future<List<db.ExperimentAuditEventRow>> audit(String experimentId) =>
      (_database.select(_database.experimentAuditEvents)
            ..where((r) => r.experimentId.equals(experimentId))
            ..orderBy([(r) => OrderingTerm.asc(r.sequence)]))
          .get();

  int get _now => _clock().millisecondsSinceEpoch;

  Future<void> _validateCurrentBounds(WakeExperiment experiment) async {
    final alarm = await (_database.select(
      _database.alarms,
    )..where((r) => r.id.equals(experiment.alarmId))).getSingleOrNull();
    final policy = await _protocols.policyForAlarm(experiment.alarmId);
    if (alarm == null || !policy.enabled) {
      throw StateError('Alarm or adaptation is unavailable.');
    }
    if (!const ExperimentSafetyPolicy().dimensionAllowed(
      experiment.dimension,
      policy,
    )) {
      throw StateError('The tested setting is now fixed.');
    }
    for (final snapshot in [
      experiment.controlSnapshotJson,
      experiment.candidateSnapshotJson,
    ]) {
      final values = jsonDecode(snapshot) as Map<String, dynamic>;
      if ((values['maxVolumePercent'] as int) > policy.userMaxVolumePercent ||
          (values['initialVolumePercent'] as int) >
              policy.userMaxVolumePercent) {
        throw StateError('The experiment exceeds the current volume limit.');
      }
    }
  }

  bool _matchesAssignment(
    ExperimentSession assignment,
    WakeExperiment experiment,
    db.WakeSession session,
  ) {
    final expected = assignment.variant == ExperimentVariant.control
        ? experiment.controlSnapshotJson
        : experiment.candidateSnapshotJson;
    return session.alarmId == assignment.alarmId &&
        session.scheduledTimeMs == assignment.scheduledTimeMs &&
        session.protocolId == assignment.protocolId &&
        session.protocolVersion == assignment.protocolVersion &&
        session.triggeredAtMs >= assignment.assignedAtMs &&
        session.protocolSnapshotJson != null &&
        sameExperimentSettings(expected, session.protocolSnapshotJson!);
  }

  Future<WakeExperiment> _require(String id) async =>
      await findById(id) ?? (throw StateError('Experiment does not exist.'));
  Future<ExperimentSession> _assignment(String id) async {
    final row = await (_database.select(
      _database.experimentSessions,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (row == null) throw StateError('Assignment does not exist.');
    return _session(row);
  }

  Future<void> _audit(
    String experimentId,
    String type,
    Map<String, Object?> details,
  ) async {
    final previous =
        await (_database.select(_database.experimentAuditEvents)
              ..where((r) => r.experimentId.equals(experimentId))
              ..orderBy([(r) => OrderingTerm.desc(r.sequence)])
              ..limit(1))
            .getSingleOrNull();
    await _database
        .into(_database.experimentAuditEvents)
        .insert(
          db.ExperimentAuditEventsCompanion.insert(
            id: _idFactory(),
            experimentId: experimentId,
            sequence: (previous?.sequence ?? -1) + 1,
            eventType: type,
            occurredAtMs: _now,
            detailsJson: jsonEncode(details),
          ),
        );
  }

  WakeExperiment _experiment(db.WakeExperimentRow r) => WakeExperiment(
    id: r.id,
    alarmId: r.alarmId,
    name: r.name,
    hypothesis: r.hypothesis,
    status: ExperimentStatus.values.byName(r.status),
    dimension: ExperimentDimension.values.byName(r.dimension),
    controlProtocolId: r.controlProtocolId,
    controlProtocolVersion: r.controlProtocolVersion,
    controlSnapshotJson: r.controlSnapshotJson,
    candidateProtocolId: r.candidateProtocolId,
    candidateProtocolVersion: r.candidateProtocolVersion,
    candidateSnapshotJson: r.candidateSnapshotJson,
    contextKey: r.contextKey,
    minimumSessionsPerVariant: r.minimumSessionsPerVariant,
    preferredSessionsPerVariant: r.preferredSessionsPerVariant,
    maximumSessionsPerVariant: r.maximumSessionsPerVariant,
    result: ExperimentOutcome.values.byName(r.result),
    confidence: ExperimentConfidence.values.byName(r.confidence),
    winnerProtocolId: r.winnerProtocolId,
    invalidReason: r.invalidReason,
    startedAtMs: r.startedAtMs,
    completedAtMs: r.completedAtMs,
    createdAtMs: r.createdAtMs,
    updatedAtMs: r.updatedAtMs,
  );

  ExperimentSession _session(db.ExperimentSessionRow r) => ExperimentSession(
    id: r.id,
    experimentId: r.experimentId,
    alarmId: r.alarmId,
    scheduledTimeMs: r.scheduledTimeMs,
    assignmentIndex: r.assignmentIndex,
    variant: ExperimentVariant.values.byName(r.variant),
    protocolId: r.protocolId,
    protocolVersion: r.protocolVersion,
    contextKey: r.contextKey,
    assignedAtMs: r.assignedAtMs,
    validity: SessionValidity.values.byName(r.validity),
    wakeSessionId: r.wakeSessionId,
    completedAtMs: r.completedAtMs,
    invalidReason: r.invalidReason,
  );
}
