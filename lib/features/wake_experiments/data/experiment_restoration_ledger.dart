import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';
import 'package:uuid/uuid.dart';

class StableRestorationRequest {
  const StableRestorationRequest(this.id, this.experimentId, this.alarmId);
  final String id, experimentId, alarmId;
}

/// Existing append-only audit doubles as a durable, replayable recovery outbox.
class ExperimentRestorationLedger {
  ExperimentRestorationLedger(
    this._database, {
    DateTime Function()? clock,
    String Function()? idFactory,
  }) : _clock = clock ?? DateTime.now,
       _idFactory = idFactory ?? const Uuid().v4;
  final AppDatabase _database;
  final DateTime Function() _clock;
  final String Function() _idFactory;

  Future<List<StableRestorationRequest>> pending() async {
    final rows = await _database.customSelect('''
      SELECT r.id, r.experiment_id, e.alarm_id
      FROM experiment_audit_events r
      JOIN wake_experiments e ON e.id = r.experiment_id
      WHERE r.event_type = 'stableRestoreRequested'
        AND NOT EXISTS (
          SELECT 1 FROM experiment_audit_events a
          WHERE a.experiment_id = r.experiment_id
            AND a.event_type IN ('stableRestoreAccepted', 'stableRestoreSkipped')
            AND CASE WHEN json_valid(a.details_json)
              THEN json_extract(a.details_json, '\$.requestId') END = r.id
        )
      ORDER BY r.occurred_at_ms, r.experiment_id, r.sequence
    ''').get();
    return rows
        .map(
          (r) => StableRestorationRequest(
            r.read<String>('id'),
            r.read<String>('experiment_id'),
            r.read<String>('alarm_id'),
          ),
        )
        .toList(growable: false);
  }

  Future<bool> blocks(String alarmId) async =>
      (await pending()).any((r) => r.alarmId == alarmId);

  Future<bool> hasActiveWake(String alarmId) async =>
      await (_database.select(_database.wakeSessions)
            ..where(
              (r) =>
                  r.alarmId.equals(alarmId) &
                  r.currentWakeFlowState.equals('completed').not(),
            )
            ..limit(1))
          .getSingleOrNull() !=
      null;

  /// Call within the transaction that owns the state change it describes.
  Future<String> append(
    String experimentId,
    String type,
    Map<String, Object?> details, {
    int policyVersion = 1,
  }) async {
    final previous =
        await (_database.select(_database.experimentAuditEvents)
              ..where((r) => r.experimentId.equals(experimentId))
              ..orderBy([(r) => OrderingTerm.desc(r.sequence)])
              ..limit(1))
            .getSingleOrNull();
    final id = _idFactory();
    await _database
        .into(_database.experimentAuditEvents)
        .insert(
          ExperimentAuditEventsCompanion.insert(
            id: id,
            experimentId: experimentId,
            sequence: (previous?.sequence ?? -1) + 1,
            eventType: type,
            occurredAtMs: _clock().millisecondsSinceEpoch,
            detailsJson: jsonEncode(details),
            policyVersion: Value(policyVersion),
          ),
        );
    return id;
  }

  Future<bool> acknowledge(
    StableRestorationRequest request, {
    required bool scheduled,
    String? skipReason,
  }) => _database.transaction(() async {
    if (!(await pending()).any(
      (r) => r.id == request.id && r.experimentId == request.experimentId,
    )) {
      return false;
    }
    if (!scheduled && (skipReason == null || skipReason.isEmpty)) {
      throw ArgumentError('A skipped recovery needs an explicit reason.');
    }
    await append(
      request.experimentId,
      scheduled ? 'stableRestoreAccepted' : 'stableRestoreSkipped',
      {
        'requestId': request.id,
        'alarmId': request.alarmId,
        'reason': ?skipReason,
      },
    );
    return true;
  });
}
