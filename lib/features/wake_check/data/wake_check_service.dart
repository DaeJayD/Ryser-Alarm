import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/wake_enforcement/domain/wake_flow.dart';
import 'package:uuid/uuid.dart';

class WakeCheckService {
  WakeCheckService(this._database);

  final AppDatabase _database;

  Future<void> schedule({
    required String wakeSessionId,
    required DateTime triggerAt,
  }) {
    return _database.transaction(() async {
      final session = await (_database.select(
        _database.wakeSessions,
      )..where((row) => row.id.equals(wakeSessionId))).getSingle();
      final nextState = WakeFlowReducer().transition(
        WakeFlowState.values.byName(session.currentWakeFlowState),
        WakeFlowState.wakeCheckPending,
      );
      final attempt = session.wakeCheckAttemptCount + 1;
      final now = DateTime.now().millisecondsSinceEpoch;
      await _database
          .into(_database.wakeChecks)
          .insert(
            WakeChecksCompanion.insert(
              id: const Uuid().v4(),
              wakeSessionId: wakeSessionId,
              attemptNumber: attempt,
              scheduledForMs: triggerAt.millisecondsSinceEpoch,
              status: 'pending',
              createdAtMs: now,
            ),
          );
      await (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(wakeSessionId))).write(
        WakeSessionsCompanion(
          currentWakeFlowState: Value(nextState.name),
          wakeCheckAttemptCount: Value(attempt),
        ),
      );
      final prior = await (_database.select(
        _database.wakeEvents,
      )..where((row) => row.wakeSessionId.equals(wakeSessionId))).get();
      await _database
          .into(_database.wakeEvents)
          .insert(
            WakeEventsCompanion.insert(
              id: const Uuid().v4(),
              wakeSessionId: wakeSessionId,
              sequenceNumber: prior.length,
              eventType: 'WAKE_CHECK_SCHEDULED',
              occurredAtMs: now,
              metadataJson: jsonEncode({
                'attempt': attempt,
                'scheduledForMs': triggerAt.millisecondsSinceEpoch,
              }),
              source: 'flutter',
            ),
          );
    });
  }
}
