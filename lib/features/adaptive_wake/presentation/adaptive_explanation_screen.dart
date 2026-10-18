import 'package:flutter/material.dart';
import 'package:ryser/core/widgets/ryser_panel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_diff.dart';
import 'package:ryser/features/adaptive_wake/presentation/protocol_evidence_view.dart';
import 'package:ryser/features/adaptive_wake/presentation/wake_plan_copy.dart';
import 'package:ryser/features/adaptive_wake/presentation/wake_protocol_preview.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

final wakePlanHistoryProvider = FutureProvider.autoDispose
    .family<List<WakeProtocol>, String>(
      (ref, alarmId) =>
          ref.watch(wakeProtocolRepositoryProvider).historyForAlarm(alarmId),
    );

class AdaptiveExplanationScreen extends ConsumerWidget {
  const AdaptiveExplanationScreen({super.key, required this.alarmId});

  final String alarmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(wakePlanHistoryProvider(alarmId));
    return Scaffold(
      appBar: AppBar(title: const Text('Your wake-up plan')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(wakePlanHistoryProvider(alarmId)),
            child: const Text('Could not load your plans. Tap to retry.'),
          ),
        ),
        data: (protocols) {
          if (protocols.isEmpty) {
            return const Center(child: Text('No saved wake-up plans yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: protocols.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final protocol = protocols[index];
              final previous = protocols
                  .where((p) => p.id == protocol.supersedesProtocolId)
                  .firstOrNull;
              final diffs = previous == null
                  ? const []
                  : protocolDiff(previous, protocol, protocol.userExplanation);
              return RyserPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${planStatus(protocol.status)} · Update ${protocol.version}',
                      style: const TextStyle(color: RyserColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      MaterialLocalizations.of(context)
                          .formatMediumDate(protocol.createdAt.toLocal()),
                    ),
                    const SizedBox(height: 8),
                    Text(planReason(protocol.reasonCode)),
                    const SizedBox(height: 12),
                    if (previous == null)
                      const Text(
                        'This is the saved starting point for this plan.',
                      )
                    else if (diffs.isEmpty)
                      const Text('The alarm settings stayed the same.')
                    else
                      const Text('What changed:'),
                    for (final change in diffs)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          change.field == 'sound'
                              ? 'Alarm sound: a different audio selection is now used.'
                              : '${planFieldLabels[change.field] ?? 'Setting'}: ${planFieldValue(change.field ?? '', change.oldValue)} → ${planFieldValue(change.field ?? '', change.newValue)}',
                        ),
                      ),
                    if (diffs.isNotEmpty)
                      const Text('Other settings stayed the same.'),
                    const SizedBox(height: 12),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text('What this alarm will do'),
                      children: [WakeProtocolPreview(protocol: protocol)],
                    ),
                    if (protocol.basedOnSessionId != null)
                      ProtocolEvidenceView(
                        sessionId: protocol.basedOnSessionId!,
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
