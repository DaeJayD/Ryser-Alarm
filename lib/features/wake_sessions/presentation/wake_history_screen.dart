import 'package:drift/drift.dart' hide Column;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/app/theme/ryser_spacing.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/adaptive_wake/presentation/protocol_evidence_view.dart';
import 'package:ryser/features/sounds/data/sound_performance_repository.dart';

class WakeHistoryScreen extends ConsumerWidget {
  const WakeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(wakeSessionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('WAKE HISTORY'),
        actions: [
          IconButton(
            tooltip: 'Weekly wake profile',
            icon: const Icon(Icons.insights),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const _WeeklyWakeProfileScreen(),
              ),
            ),
          ),
        ],
      ),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('HISTORY READ FAILURE')),
        data: (items) => items.isEmpty
            ? const Center(
                child: Text(
                  '> NO WAKE SESSIONS RECORDED',
                  style: TextStyle(color: RyserColors.primaryDim),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(RyserSpacing.md),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: RyserSpacing.sm),
                itemBuilder: (_, index) => _SessionModule(
                  items[index],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _SessionDetail(items[index]),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _SessionModule extends StatelessWidget {
  const _SessionModule(this.session, {required this.onTap});

  final WakeSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final triggered = DateTime.fromMillisecondsSinceEpoch(
      session.triggeredAtMs,
    );
    final latency = session.responseLatencyMs;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(RyserSpacing.md),
        decoration: BoxDecoration(
          color: RyserColors.surface,
          border: Border.all(color: RyserColors.muted),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(triggered),
              style: const TextStyle(
                color: RyserColors.primaryDim,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            if (latency != null) ...[
              const SizedBox(height: RyserSpacing.xs),
              Text(
                'SNOOZES: ${session.snoozeCount}  //  SOUND CHANGES: ${session.soundChangeCount}',
                style: const TextStyle(
                  color: RyserColors.primaryDim,
                  fontSize: 9,
                  letterSpacing: 0.7,
                ),
              ),
            ],
            const SizedBox(height: RyserSpacing.xs),
            Text(
              'Alarm: ${_formatTime(DateTime.fromMillisecondsSinceEpoch(session.scheduledTimeMs))}',
            ),
            Text('Final result: ${session.outcome}'),
            Text(
              'Mission: ${session.missionType ?? 'not required'} • ${session.missionAttemptCount} attempts',
            ),
            Text(
              'Wake Check: ${session.wakeCheckAttemptCount} attempts • ${session.wakeCheckFailureCount} missed',
            ),
            Text(
              'Awake confirmed: ${session.confirmedAwakeAtMs == null ? 'not recorded' : _formatTime(DateTime.fromMillisecondsSinceEpoch(session.confirmedAwakeAtMs!))}',
            ),
            Text(
              _formatTime(triggered),
              style: const TextStyle(
                color: RyserColors.primary,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: RyserColors.primary, blurRadius: 10)],
              ),
            ),
            const SizedBox(height: RyserSpacing.sm),
            Text(
              'OUTCOME: ${session.outcome.toUpperCase()}',
              style: const TextStyle(
                color: RyserColors.textSecondary,
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
            if (session.protocolVersion != null)
              Text(
                'WAKE PROTOCOL V${session.protocolVersion}',
                style: const TextStyle(
                  color: RyserColors.primaryDim,
                  fontSize: 10,
                ),
              ),
            if (session.wakeEnforcementEnabled) ...[
              const SizedBox(height: RyserSpacing.xs),
              Text(
                'MISSION: ${(session.missionType ?? 'UNKNOWN').toUpperCase()}  //  '
                'ATTEMPTS: ${session.missionAttemptCount}  //  '
                'FAILURES: ${session.missionFailureCount}',
                style: const TextStyle(
                  color: RyserColors.primaryDim,
                  fontSize: 9,
                ),
              ),
              Text(
                'WAKE CHECKS: ${session.wakeCheckAttemptCount}  //  '
                'FAILED: ${session.wakeCheckFailureCount}  //  '
                'REACTIVATIONS: ${session.escalationCount}',
                style: const TextStyle(
                  color: RyserColors.primaryDim,
                  fontSize: 9,
                ),
              ),
              if (session.confirmedAwakeAtMs != null)
                Text(
                  'AWAKE CONFIRMED: ${_formatTime(DateTime.fromMillisecondsSinceEpoch(session.confirmedAwakeAtMs!))}',
                  style: const TextStyle(
                    color: RyserColors.primary,
                    fontSize: 10,
                  ),
                ),
            ],
            if (latency != null)
              Text(
                'INITIAL RESPONSE: ${_formatLatency(latency)}',
                style: const TextStyle(
                  color: RyserColors.textSecondary,
                  fontSize: 9,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SessionDetail extends ConsumerWidget {
  const _SessionDetail(this.session);

  final WakeSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    final query = database.select(database.wakeEvents)
      ..where((row) => row.wakeSessionId.equals(session.id))
      ..orderBy([(row) => OrderingTerm.asc(row.sequenceNumber)]);
    return Scaffold(
      appBar: AppBar(title: const Text('MORNING REPORT')),
      body: StreamBuilder<List<WakeEvent>>(
        stream: query.watch(),
        builder: (context, snapshot) {
          final events = snapshot.data ?? const <WakeEvent>[];
          return ListView.separated(
            padding: const EdgeInsets.all(RyserSpacing.md),
            itemCount: events.length + 1,
            separatorBuilder: (_, _) =>
                const Divider(color: RyserColors.inactive),
            itemBuilder: (_, index) {
              if (index == 0) {
                return _ProtocolSummary(session: session);
              }
              final event = events[index - 1];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  event.sequenceNumber.toString().padLeft(2, '0'),
                  style: const TextStyle(color: RyserColors.primary),
                ),
                title: Text(event.eventType),
                subtitle: Text(
                  '${_formatTime(DateTime.fromMillisecondsSinceEpoch(event.occurredAtMs))}\n'
                  '${_formatEventDetails(event)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProtocolSummary extends ConsumerWidget {
  const _ProtocolSummary({required this.session});

  final WakeSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    final evaluation = (database.select(
      database.protocolEvaluations,
    )..where((row) => row.wakeSessionId.equals(session.id))).getSingleOrNull();
    return FutureBuilder<ProtocolEvaluation?>(
      future: evaluation,
      builder: (context, snapshot) {
        final item = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PROTOCOL ${session.protocolVersion == null ? 'LEGACY / UNKNOWN' : 'V${session.protocolVersion}'}',
              style: const TextStyle(color: RyserColors.primary),
            ),
            const SizedBox(height: RyserSpacing.xs),
            Text(
              'Alarm: ${_formatTime(DateTime.fromMillisecondsSinceEpoch(session.scheduledTimeMs))}',
            ),
            Text('Final result: ${session.outcome}'),
            Text(
              'Awake confirmed: ${session.confirmedAwakeAtMs == null ? 'not recorded' : _formatTime(DateTime.fromMillisecondsSinceEpoch(session.confirmedAwakeAtMs!))}',
            ),
            Text(
              'FIRST RESPONSE: ${session.responseLatencyMs == null ? 'NOT RECORDED' : _formatLatency(session.responseLatencyMs!)}  //  '
              'SNOOZES: ${session.snoozeCount}',
            ),
            Text(
              'MISSION FAILURES: ${session.missionFailureCount}  //  WAKE CHECK FAILURES: ${session.wakeCheckFailureCount}',
            ),
            if (item != null) ...[
              ProtocolEvidenceView(sessionId: session.id),
              Text('ANALYSIS: ${item.primaryFailureMode.toUpperCase()}'),
              Text('NEXT ACTION: ${item.result.toUpperCase()}'),
              if (item.result == 'changed')
                FutureBuilder<WakeProtocol?>(
                  future:
                      (database.select(database.wakeProtocols)..where(
                            (row) => row.basedOnSessionId.equals(session.id),
                          ))
                          .getSingleOrNull(),
                  builder: (_, protocolSnapshot) => Text(
                    protocolSnapshot.data?.userExplanation ??
                        'A protocol change is recorded for the next alarm.',
                  ),
                )
              else
                const Text('No automatic protocol change is planned.'),
              if (item.selectedRuleId != null)
                Text('RULE: ${item.selectedRuleId}'),
              if (item.changesJson != '[]')
                Text('PROTOCOL DIFF: ${_formatChanges(item.changesJson)}'),
            ],
            const SizedBox(height: RyserSpacing.md),
          ],
        );
      },
    );
  }
}

String _formatChanges(String encoded) {
  try {
    final changes = jsonDecode(encoded) as List<dynamic>;
    return changes
        .map((entry) {
          final change = entry as Map<String, dynamic>;
          return '${change['dimension']}: ${change['oldValue']} → ${change['newValue']}';
        })
        .join(' • ');
  } catch (_) {
    return 'Unavailable';
  }
}

class _WeeklyWakeProfileScreen extends ConsumerWidget {
  const _WeeklyWakeProfileScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final since = DateTime.now().subtract(const Duration(days: 7));
    final database = ref.watch(appDatabaseProvider);
    final query = database.select(database.wakeSessions)
      ..where(
        (row) => row.triggeredAtMs.isBiggerOrEqualValue(
          since.millisecondsSinceEpoch,
        ),
      );
    return Scaffold(
      appBar: AppBar(title: const Text('WEEKLY WAKE PROFILE')),
      body: StreamBuilder<List<WakeSession>>(
        stream: query.watch(),
        builder: (context, snapshot) {
          final sessions = snapshot.data ?? const <WakeSession>[];
          final complete = sessions
              .where(
                (item) =>
                    item.completedAtMs != null &&
                    !const {
                      'cancelled',
                      'incomplete',
                      'bypassed',
                      'manualTermination',
                    }.contains(item.outcome),
              )
              .toList();
          final confirmed = complete
              .where((item) => item.outcome == 'wakeConfirmed')
              .length;
          final snoozed = complete.where((item) => item.snoozeCount > 0).length;
          final checksMissed = complete
              .where((item) => item.wakeCheckFailureCount > 0)
              .length;
          final responseTimes =
              complete
                  .where((item) => item.responseLatencyMs != null)
                  .map((item) => item.responseLatencyMs!)
                  .toList()
                ..sort();
          final median = responseTimes.isEmpty
              ? null
              : responseTimes.length.isOdd
              ? responseTimes[responseTimes.length ~/ 2]
              : (responseTimes[responseTimes.length ~/ 2 - 1] +
                        responseTimes[responseTimes.length ~/ 2]) ~/
                    2;
          return ListView(
            padding: const EdgeInsets.all(RyserSpacing.md),
            children: [
              const Text(
                'LAST 7 DAYS',
                style: TextStyle(color: RyserColors.primary),
              ),
              const SizedBox(height: RyserSpacing.md),
              Text('Completed sessions: ${complete.length}'),
              Text('Confirmed wakes: $confirmed'),
              Text('Successful wakes: $confirmed / ${complete.length}'),
              Text(
                'Average response: ${responseTimes.isEmpty ? 'not recorded' : _formatLatency(responseTimes.reduce((a, b) => a + b) ~/ responseTimes.length)}',
              ),
              Text(
                'Average snoozes: ${complete.isEmpty ? 'not recorded' : (complete.fold(0, (sum, s) => sum + s.snoozeCount) / complete.length).toStringAsFixed(1)}',
              ),
              Text(
                'Mission failure rate: ${complete.isEmpty ? 'not recorded' : '${(100 * complete.where((s) => s.missionFailureCount > 0).length / complete.length).toStringAsFixed(0)}%'}',
              ),
              Text(
                'Wake Check failure rate: ${complete.isEmpty ? 'not recorded' : '${(100 * checksMissed / complete.length).toStringAsFixed(0)}%'}',
              ),
              Text('Sessions with snoozes: $snoozed'),
              Text('Sessions with missed Wake Checks: $checksMissed'),
              Text(
                'Median first response: ${median == null ? 'Not enough recorded responses' : _formatLatency(median)}',
              ),
              const SizedBox(height: RyserSpacing.md),
              _WeeklyAdaptiveDetails(sessions: complete),
              const Text(
                'These are observed sessions, not a sleep-quality score. '
                'Incomplete and older sessions may have missing evidence.',
                style: TextStyle(color: RyserColors.textSecondary),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WeeklyAdaptiveDetails extends ConsumerWidget {
  const _WeeklyAdaptiveDetails({required this.sessions});
  final List<WakeSession> sessions;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    return FutureBuilder(
      future: () async {
        final evaluations =
            await (db.select(db.protocolEvaluations)..where(
                  (e) =>
                      e.wakeSessionId.isIn(sessions.map((s) => s.id).toList()),
                ))
                .get();
        final protocols = await (db.select(
          db.wakeProtocols,
        )..where((p) => p.status.equals('active'))).get();
        final sounds = await SoundPerformanceRepository(db).load();
        return (evaluations, protocols, sounds);
      }(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading adaptive summary…');
        final (evaluations, protocols, sounds) = snapshot.data!;
        final ranked =
            sounds
                .where(
                  (s) =>
                      s.timesUsed >= 3 &&
                      s.recentMedianResponseLatencyMs != null,
                )
                .toList()
              ..sort(
                (a, b) => a.recentMedianResponseLatencyMs!.compareTo(
                  b.recentMedianResponseLatencyMs!,
                ),
              );
        final counts = <String, int>{};
        for (final e in evaluations) {
          counts.update(e.primaryFailureMode, (n) => n + 1, ifAbsent: () => 1);
        }
        final failures = counts.keys.where((key) => key != 'none').toList()
          ..sort((a, b) {
            final difference = counts[b]!.compareTo(counts[a]!);
            return difference != 0 ? difference : a.compareTo(b);
          });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protocol changes this week: ${evaluations.where((e) => e.result == 'changed').length}',
            ),
            Text(
              'Current intensity: ${protocols.isEmpty ? 'not set' : protocols.map((p) => 'level ${p.intensityLevel}').join(', ')}',
            ),
            Text(
              'Most common failure: ${failures.firstOrNull ?? 'none recorded'}',
            ),
            Text(
              'Most effective sound (recorded history): ${ranked.isEmpty ? 'more uses needed' : _soundName(ranked.first.soundUri)}',
            ),
            Text(
              'Weakest recent sound: ${ranked.isEmpty ? 'more uses needed' : _soundName(ranked.last.soundUri)}',
            ),
            Text(
              'Possible sound-effectiveness decline: ${sounds.any((s) => s.effectivenessDeclining) ? 'detected in repeated response evidence' : 'not detected'}',
            ),
          ],
        );
      },
    );
  }
}

String _soundName(String uri) => uri.contains('/raw/')
    ? uri.split('/').last.replaceAll('_', ' ')
    : 'Selected device audio';

String _formatEventDetails(WakeEvent event) {
  try {
    final data = jsonDecode(event.metadataJson) as Map<String, dynamic>;
    final details = <String>[];
    final scheduled = data['scheduledAtMs'] as num?;
    if (scheduled != null) {
      details.add(
        'Scheduled ${_formatTime(DateTime.fromMillisecondsSinceEpoch(scheduled.toInt()))}',
      );
    }
    final mission = data['missionType'];
    if (mission != null) {
      details.add('Mission: ${mission.toString().toUpperCase()}');
    }
    final attempt = data['attempt'];
    if (attempt != null) details.add('Attempt $attempt');
    final reason = data['reason'];
    if (reason != null) details.add(_friendlyReason(reason.toString()));
    final uri = data['ringtoneUri']?.toString();
    if (uri != null && uri.isNotEmpty) details.add('Alarm sound recorded');
    return details.isEmpty
        ? _friendlyEvent(event.eventType)
        : details.join(' • ');
  } catch (_) {
    return _friendlyEvent(event.eventType);
  }
}

String _friendlyEvent(String event) => switch (event) {
  'ALARM_TRIGGERED' => 'Alarm started',
  'SNOOZED' => 'Alarm snoozed',
  'SOUND_CHANGED' => 'Alarm sound changed',
  'DISMISS_REQUESTED' => 'Dismiss requested',
  'MISSION_PREPARED' => 'Mission prepared',
  'MISSION_STARTED' => 'Mission started',
  'MISSION_COMPLETED' => 'Mission completed',
  'MISSION_BYPASSED' => 'Emergency stop used',
  'MISSION_TIMED_OUT' => 'Mission timed out',
  'WAKE_CHECK_PASSED' => 'Wake Check confirmed',
  'WAKE_CHECK_MISSED' => 'Wake Check missed',
  _ => event.replaceAll('_', ' ').toLowerCase(),
};

String _friendlyReason(String reason) => switch (reason) {
  'emergency_hold' => 'Emergency stop used',
  'timeout' => 'Timed out',
  _ => 'Reason: ${reason.replaceAll('_', ' ')}',
};

String _formatDate(DateTime value) =>
    '${value.year}-${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

String _formatTime(DateTime value) =>
    '${value.hour.toString().padLeft(2, '0')}:'
    '${value.minute.toString().padLeft(2, '0')}:'
    '${value.second.toString().padLeft(2, '0')}';

String _formatLatency(int milliseconds) {
  final seconds = milliseconds / 1000;
  return '${seconds.toStringAsFixed(3)}S';
}
