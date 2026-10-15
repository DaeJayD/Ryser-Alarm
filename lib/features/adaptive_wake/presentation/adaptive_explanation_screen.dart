import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_diff.dart';
import 'package:ryser/features/adaptive_wake/presentation/protocol_evidence_view.dart';

class AdaptiveExplanationScreen extends ConsumerWidget {
  const AdaptiveExplanationScreen({super.key, required this.alarmId});

  final String alarmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref
        .read(wakeProtocolRepositoryProvider)
        .historyForAlarm(alarmId);
    return Scaffold(
      appBar: AppBar(title: const Text('WHY RYSER CHANGED THIS')),
      body: FutureBuilder(
        future: history,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Protocol history is temporarily unavailable.'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final protocols = snapshot.data!;
          if (protocols.isEmpty) {
            return const Center(child: Text('NO PROTOCOL HISTORY'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: protocols.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final protocol = protocols[index];
              final previous = protocols
                  .where((p) => p.id == protocol.supersedesProtocolId)
                  .firstOrNull;
              final changed = <String>[
                if (previous != null &&
                    previous.initialSoundId != protocol.initialSoundId)
                  'Sound',
                if (previous != null &&
                    previous.initialVolumePercent !=
                        protocol.initialVolumePercent)
                  'Initial playback level',
                if (previous != null &&
                    previous.vibrationPattern != protocol.vibrationPattern)
                  'Vibration',
                if (previous != null &&
                    previous.wakeCheckDelayMinutes !=
                        protocol.wakeCheckDelayMinutes)
                  'Wake Check delay',
                if (previous != null &&
                    previous.missionConfigurationJson !=
                        protocol.missionConfigurationJson)
                  'Mission',
              ];
              final diffs = previous == null
                  ? const []
                  : protocolDiff(previous, protocol, protocol.userExplanation);
              final currentValues = protocolDisplayValues(protocol);
              final unchanged = previous == null
                  ? const <String>[]
                  : currentValues.keys
                        .where(
                          (key) =>
                              currentValues[key] ==
                              protocolDisplayValues(previous)[key],
                        )
                        .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROTOCOL V${protocol.version} — ${protocol.status.name.toUpperCase()}',
                    style: const TextStyle(color: RyserColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(protocol.userExplanation),
                  for (final change in diffs)
                    Text(
                      '${change.field}: ${change.oldValue} → ${change.newValue}',
                    ),
                  if (unchanged.isNotEmpty)
                    Text('Unchanged: ${unchanged.join(', ')}'),
                  const SizedBox(height: 8),
                  Text(
                    'CHANGED: ${changed.isEmpty ? 'No automatic change' : changed.join(', ')}',
                  ),
                  Text('REASON: ${protocol.reasonCode.name}'),
                  if (protocol.basedOnSessionId != null)
                    ProtocolEvidenceView(sessionId: protocol.basedOnSessionId!),
                  if (protocol.missionRequired)
                    Text('MISSION: ${protocol.missionType ?? 'UNKNOWN'}'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
