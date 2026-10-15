import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

class WakeProtocolPreview extends StatelessWidget {
  const WakeProtocolPreview({super.key, required this.protocol, this.policy});
  final WakeProtocol protocol;
  final AlarmAdaptationPolicy? policy;

  @override
  Widget build(BuildContext context) {
    final p = protocol;
    String mode(AdaptiveMode? m) =>
        policy?.enabled != true || m == AdaptiveMode.fixed
        ? 'Fixed'
        : 'Adaptive';
    Map<String, dynamic> mission;
    try {
      mission = jsonDecode(p.missionConfigurationJson) as Map<String, dynamic>;
    } catch (_) {
      mission = {};
    }
    final task = p.missionType == 'movement'
        ? '${mission['requiredSteps']} steps'
        : p.missionType == 'jumping'
        ? '${mission['requiredJumps']} light jumps'
        : 'Registered QR code';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Level ${p.intensity.index + 1} • ${p.intensity.name}'),
        Text(
          'Sound: ${p.initialSoundFamily ?? 'Selected audio'} • ${mode(policy?.sound)}',
        ),
        Text(
          'Playback: ${p.initialVolumePercent}%–${p.maxVolumePercent}% • ${mode(policy?.volume)}',
        ),
        Text(
          p.volumeEscalationEnabled
              ? 'Rise: ${p.volumeEscalationStepPercent}% every ${p.volumeEscalationIntervalSeconds}s'
              : 'Volume rise: off',
        ),
        Text(
          'Vibration: ${p.vibrationEnabled ? p.vibrationPattern.name : 'off'} • ${mode(policy?.vibration)}',
        ),
        Text(
          'Mission: ${p.missionRequired ? task : 'off'} • ${mode(policy?.mission)}',
        ),
        Text(
          'Wake Check: ${p.wakeCheckRequired ? '${p.wakeCheckDelayMinutes} min, hold ${p.wakeCheckHoldMilliseconds / 1000}s, up to ${p.maxWakeCheckFailures} missed checks' : 'off'} • ${mode(policy?.wakeCheck)}',
        ),
      ],
    );
  }
}
