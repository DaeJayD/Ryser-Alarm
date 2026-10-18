import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';

class ProtocolEvidenceView extends ConsumerWidget {
  const ProtocolEvidenceView({super.key, required this.sessionId});
  final String sessionId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    return FutureBuilder(
      future: (db.select(
        db.protocolEvaluations,
      )..where((e) => e.wakeSessionId.equals(sessionId))).getSingleOrNull(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Recorded evidence is temporarily unavailable.');
        }
        final row = snapshot.data;
        if (row == null) {
          return const Text('No adaptive evaluation is recorded yet.');
        }
        Map<String, dynamic> evidence;
        try {
          evidence = jsonDecode(row.analysisJson) as Map<String, dynamic>;
        } catch (_) {
          evidence = {};
        }
        final ids = evidence['comparisonSessionIds'];
        final through = evidence['evidenceThroughMs'];
        final count = ids is List ? ids.length : 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Based on $count similar wake-ups${through is int ? ' recorded up to ${MaterialLocalizations.of(context).formatMediumDate(DateTime.fromMillisecondsSinceEpoch(through).toLocal())}' : ''}.',
            ),
            if (evidence.containsKey('responseLatencyMs'))
              Text(
                'For this alarm: ${evidence['responseLatencyMs'] is num ? 'your first response was after ${((evidence['responseLatencyMs'] as num) / 1000).round()} seconds' : 'no response time was recorded'}.',
              ),
            if (evidence['snoozeCount'] is num)
              Text('Times snoozed: ${evidence['snoozeCount']}.'),
            if (evidence['missionFailureCount'] is num)
              Text(
                'Unsuccessful task attempts: ${evidence['missionFailureCount']}.',
              ),
            if (evidence['wakeCheckFailureCount'] is num)
              Text(
                'Missed follow-up checks: ${evidence['wakeCheckFailureCount']}.',
              ),
          ],
        );
      },
    );
  }
}
