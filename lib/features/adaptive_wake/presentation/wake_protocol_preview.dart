import 'package:flutter/material.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/presentation/wake_plan_copy.dart';

class WakeProtocolPreview extends StatelessWidget {
  const WakeProtocolPreview({super.key, required this.protocol, this.policy});
  final WakeProtocol protocol;
  final AlarmAdaptationPolicy? policy;

  @override
  Widget build(BuildContext context) {
    final p = protocol;
    String mode(AdaptiveMode? m) => policy == null
        ? ''
        : policy!.enabled && m == AdaptiveMode.adaptive
        ? ' Ryser may adjust this for future alarms.'
        : ' Stays as you set it.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alarm strength: ${p.intensity.index + 1} of 5'),
        const Text('This describes the settings, not how deeply you sleep.'),
        const SizedBox(height: 10),
        Text(
          'Sound: ${soundLabel(p.initialSoundFamily)}.${mode(policy?.sound)}',
        ),
        Text(
          'Volume starts at ${p.initialVolumePercent}% of your phone\'s alarm volume, with a ${p.maxVolumePercent}% limit.${mode(policy?.volume)}',
        ),
        Text(
          p.volumeEscalationEnabled
              ? 'While ringing, volume rises by ${p.volumeEscalationStepPercent} percentage points every ${p.volumeEscalationIntervalSeconds} seconds, up to that limit.'
              : 'The volume stays steady while ringing.',
        ),
        Text(
          'Vibration: ${p.vibrationEnabled ? vibrationLabel(p.vibrationPattern) : 'Off'}.${mode(policy?.vibration)}',
        ),
        Text('To stop the alarm: ${missionLabel(p)}.${mode(policy?.mission)}'),
        Text(
          p.wakeCheckRequired
              ? 'After dismissal, Ryser checks again in ${p.wakeCheckDelayMinutes} minutes. Hold the confirmation button for ${secondsLabel(p.wakeCheckHoldMilliseconds)} seconds to say you are still awake.${mode(policy?.wakeCheck)}'
              : 'No follow-up wake check.${mode(policy?.wakeCheck)}',
        ),
        if (p.wakeCheckRequired)
          Text(
            'A missed check makes the alarm ring again. After ${p.maxWakeCheckFailures} missed checks, Ryser stops scheduling more follow-up checks. You still need to stop the ringing alarm.',
          ),
      ],
    );
  }
}
