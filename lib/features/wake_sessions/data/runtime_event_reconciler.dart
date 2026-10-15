import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/wake_sessions/domain/response_latency.dart';

class RuntimeEventReconciler {
  RuntimeEventReconciler(this._database, this._gateway);

  final AppDatabase _database;
  final AlarmRuntimeGateway _gateway;

  Future<int> reconcile() async {
    final events = await _gateway.getRuntimeEvents();
    if (events.isEmpty) return 0;
    await _database.transaction(() async {
      for (final event in events) {
        await _apply(event);
      }
    });
    await _gateway.acknowledgeRuntimeEvents(
      events.map((event) => event.id).toList(),
    );
    return events.length;
  }

  Future<void> _apply(RuntimeEventDto event) async {
    final alreadyApplied = await (_database.select(
      _database.wakeEvents,
    )..where((row) => row.id.equals(event.id))).getSingleOrNull();
    if (alreadyApplied != null) return;
    final existing = await (_database.select(
      _database.wakeSessions,
    )..where((row) => row.id.equals(event.sessionId))).getSingleOrNull();

    if (event.eventType == 'ALARM_TRIGGERED') {
      await _database
          .into(_database.wakeSessions)
          .insert(
            WakeSessionsCompanion.insert(
              id: event.sessionId,
              alarmId: event.alarmId,
              scheduledTimeMs: event.scheduledAtMs,
              triggeredAtMs: event.occurredAtMs,
              initialSoundId: event.ringtoneUri,
              outcome: 'active',
              currentWakeFlowState: const Value('alarmActive'),
              protocolId: event.protocolId.isEmpty
                  ? const Value.absent()
                  : Value(event.protocolId),
              protocolVersion: event.protocolVersion <= 0
                  ? const Value.absent()
                  : Value(event.protocolVersion),
              protocolSnapshotJson: event.protocolSnapshotJson == '{}'
                  ? const Value.absent()
                  : Value(event.protocolSnapshotJson),
              createdAtMs: event.occurredAtMs,
            ),
            mode: InsertMode.insertOrIgnore,
          );
      final alarm = await (_database.select(
        _database.alarms,
      )..where((row) => row.id.equals(event.alarmId))).getSingleOrNull();
      if (alarm?.recurrenceType == 'oneTime') {
        await (_database.update(_database.alarms)
              ..where((row) => row.id.equals(event.alarmId)))
            .write(const AlarmsCompanion(enabled: Value(false)));
      }
    } else if (event.eventType == 'DISMISS_REQUESTED' && existing != null) {
      if (existing.firstInteractionAtMs == null) {
        await (_database.update(
          _database.wakeSessions,
        )..where((row) => row.id.equals(event.sessionId))).write(
          WakeSessionsCompanion(
            firstInteractionAtMs: Value(event.occurredAtMs),
            responseLatencyMs: Value(
              calculateResponseLatencyMs(
                triggeredAtMs: existing.triggeredAtMs,
                interactionAtMs: event.occurredAtMs,
              ),
            ),
          ),
        );
      }
    } else if (event.eventType == 'ALARM_DISMISSED') {
      final triggeredAt = existing?.triggeredAtMs ?? event.scheduledAtMs;
      final firstInteraction =
          existing?.firstInteractionAtMs ?? event.occurredAtMs;
      final latency =
          existing?.responseLatencyMs ??
          calculateResponseLatencyMs(
            triggeredAtMs: triggeredAt,
            interactionAtMs: firstInteraction,
          );
      if (existing == null) {
        await _database
            .into(_database.wakeSessions)
            .insert(
              WakeSessionsCompanion.insert(
                id: event.sessionId,
                alarmId: event.alarmId,
                scheduledTimeMs: event.scheduledAtMs,
                triggeredAtMs: triggeredAt,
                initialSoundId: event.ringtoneUri,
                firstInteractionAtMs: Value(event.occurredAtMs),
                responseLatencyMs: Value(latency),
                dismissedAtMs: Value(event.occurredAtMs),
                outcome: 'dismissed',
                createdAtMs: triggeredAt,
                completedAtMs: Value(event.occurredAtMs),
              ),
            );
      } else {
        final preserveBypass = existing.outcome == 'bypassed';
        await (_database.update(
          _database.wakeSessions,
        )..where((row) => row.id.equals(event.sessionId))).write(
          WakeSessionsCompanion(
            firstInteractionAtMs: Value(firstInteraction),
            responseLatencyMs: Value(latency),
            dismissedAtMs: Value(event.occurredAtMs),
            outcome: preserveBypass
                ? const Value.absent()
                : const Value('dismissed'),
            completedAtMs: Value(event.occurredAtMs),
          ),
        );
      }
    } else if (event.eventType == 'SNOOZED' && existing != null) {
      final firstInteractionAt = existing.firstInteractionAtMs;
      final latency = firstInteractionAt == null
          ? calculateResponseLatencyMs(
              triggeredAtMs: existing.triggeredAtMs,
              interactionAtMs: event.occurredAtMs,
            )
          : null;
      await (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(event.sessionId))).write(
        WakeSessionsCompanion(
          snoozeCount: Value(existing.snoozeCount + 1),
          firstInteractionAtMs: firstInteractionAt == null
              ? Value(event.occurredAtMs)
              : const Value.absent(),
          responseLatencyMs: latency == null
              ? const Value.absent()
              : Value(latency),
        ),
      );
    } else if (event.eventType == 'SOUND_CHANGED' && existing != null) {
      await (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(event.sessionId))).write(
        WakeSessionsCompanion(
          soundChangeCount: Value(existing.soundChangeCount + 1),
        ),
      );
    } else if (event.eventType == 'WAKE_CHECK_TRIGGERED' && existing != null) {
      final check = await _latestWakeCheck(event.sessionId);
      if (check != null) {
        await (_database.update(
          _database.wakeChecks,
        )..where((row) => row.id.equals(check.id))).write(
          WakeChecksCompanion(
            status: const Value('triggered'),
            triggeredAtMs: Value(event.occurredAtMs),
          ),
        );
      }
      await (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(event.sessionId))).write(
        const WakeSessionsCompanion(
          currentWakeFlowState: Value('wakeCheckActive'),
        ),
      );
    } else if (event.eventType == 'WAKE_CHECK_INTERACTION' &&
        existing != null) {
      final check = await _latestWakeCheck(event.sessionId);
      if (check != null && check.firstInteractionAtMs == null) {
        await (_database.update(
          _database.wakeChecks,
        )..where((row) => row.id.equals(check.id))).write(
          WakeChecksCompanion(firstInteractionAtMs: Value(event.occurredAtMs)),
        );
      }
    } else if (event.eventType == 'WAKE_CHECK_PASSED' && existing != null) {
      final check = await _latestWakeCheck(event.sessionId);
      if (check != null) {
        await (_database.update(
          _database.wakeChecks,
        )..where((row) => row.id.equals(check.id))).write(
          WakeChecksCompanion(
            status: const Value('passed'),
            completedAtMs: Value(event.occurredAtMs),
          ),
        );
      }
      await (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(event.sessionId))).write(
        WakeSessionsCompanion(
          currentWakeFlowState: const Value('completed'),
          confirmedAwakeAtMs: Value(event.occurredAtMs),
          completedAtMs: Value(event.occurredAtMs),
          outcome: const Value('wakeConfirmed'),
        ),
      );
    } else if ((event.eventType == 'WAKE_CHECK_MISSED' ||
            event.eventType == 'WAKE_CHECK_FAILED') &&
        existing != null) {
      final check = await _latestWakeCheck(event.sessionId);
      if (check != null) {
        await (_database.update(
          _database.wakeChecks,
        )..where((row) => row.id.equals(check.id))).write(
          WakeChecksCompanion(
            status: Value(
              event.eventType == 'WAKE_CHECK_MISSED' ? 'missed' : 'failed',
            ),
            completedAtMs: Value(event.occurredAtMs),
          ),
        );
      }
      await (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(event.sessionId))).write(
        WakeSessionsCompanion(
          currentWakeFlowState: const Value('alarmActive'),
          wakeCheckFailureCount: Value(existing.wakeCheckFailureCount + 1),
          escalationCount: Value(existing.escalationCount + 1),
        ),
      );
    }

    final priorEvents = await (_database.select(
      _database.wakeEvents,
    )..where((row) => row.wakeSessionId.equals(event.sessionId))).get();
    final sequence = priorEvents.length;
    await _database
        .into(_database.wakeEvents)
        .insert(
          WakeEventsCompanion.insert(
            id: event.id,
            wakeSessionId: event.sessionId,
            sequenceNumber: sequence,
            eventType: event.eventType,
            occurredAtMs: event.occurredAtMs,
            metadataJson: event.metadataJson == '{}'
                ? jsonEncode({
                    'scheduledAtMs': event.scheduledAtMs,
                    'ringtoneUri': event.ringtoneUri,
                  })
                : event.metadataJson,
            source: 'native_android',
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<WakeCheck?> _latestWakeCheck(String sessionId) {
    return (_database.select(_database.wakeChecks)
          ..where((row) => row.wakeSessionId.equals(sessionId))
          ..orderBy([(row) => OrderingTerm.desc(row.attemptNumber)])
          ..limit(1))
        .getSingleOrNull();
  }
}
