import 'dart:convert';

import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

/// Presentation only. Stored decisions and machine-readable audit data stay intact.
String planStatus(WakeProtocolStatus status) => switch (status) {
  WakeProtocolStatus.active => 'Current plan',
  WakeProtocolStatus.superseded => 'Earlier plan',
  WakeProtocolStatus.reverted => 'Replaced after a setback',
  WakeProtocolStatus.archived => 'Saved past plan',
};

String planReason(AdaptiveReasonCode reason) => switch (reason) {
  AdaptiveReasonCode.v2Migration =>
    'Your previous alarm settings were carried over to this wake-up plan.',
  AdaptiveReasonCode.slowResponseRepeated =>
    'You took longer to respond to several recent alarms.',
  AdaptiveReasonCode.noResponse => 'No response was recorded for the alarm.',
  AdaptiveReasonCode.highSnoozeCount =>
    'You snoozed repeatedly, so Ryser reviewed your alarm settings.',
  AdaptiveReasonCode.soundEffectivenessDecline =>
    'You have been responding more slowly to this sound.',
  AdaptiveReasonCode.wakeCheckFailureRepeated =>
    'You missed several follow-up checks after dismissing the alarm.',
  AdaptiveReasonCode.missionFailureRepeated =>
    'You had difficulty finishing the wake-up task on several occasions.',
  AdaptiveReasonCode.successStreak => 'You completed several wake-ups successfully, so Ryser reviewed whether a gentler alarm would be enough.',
  AdaptiveReasonCode.excessiveProtocolIntensity =>
    'Ryser reviewed whether the alarm settings were stronger than needed.',
  AdaptiveReasonCode.emergencyBypassRepeated => 'You used the emergency stop repeatedly, so Ryser reviewed the wake-up task.',
  AdaptiveReasonCode.insufficientData => 'There is not enough comparable wake-up history, or no permitted adjustment is available yet.',
  AdaptiveReasonCode.manualUserOverride =>
    'You saved your own alarm settings. This plan reflects your choices.',
  AdaptiveReasonCode.manualReset => 'You reset automatic adjustments. Your own alarm settings are being used again.',
  AdaptiveReasonCode.performanceWorsened => 'Recent wake-ups became harder after a change, so Ryser reviewed the earlier settings.',
};

String vibrationLabel(VibrationPattern pattern) => switch (pattern) {
  VibrationPattern.standard => 'Regular pulses',
  VibrationPattern.doublePulse => 'Two short pulses',
  VibrationPattern.longShortShort => 'One long pulse, then two short pulses',
  VibrationPattern.ramping => 'Increasing pulses',
  VibrationPattern.strongPulse => 'Strong pulses',
};

String soundLabel(Object? value) => switch (value?.toString().toLowerCase()) {
  'pulse' || 'pulse-a' => 'Pulsing sound',
  'melodic' || 'melodic-a' => 'Melody',
  'urgent' || 'urgent-a' => 'Urgent sound',
  _ => 'Your selected audio',
};

String missionLabel(WakeProtocol p) {
  if (!p.missionRequired) return 'No task required';
  Map<String, dynamic> config;
  try {
    config = jsonDecode(p.missionConfigurationJson) as Map<String, dynamic>;
  } catch (_) {
    config = {};
  }
  final count =
      config[p.missionType == 'movement' ? 'requiredSteps' : 'requiredJumps'];
  final validCount = count is num && count > 0;
  return switch (p.missionType) {
    'movement' =>
      validCount ? 'Walk $count steps' : 'Complete your walking task',
    'jumping' =>
      validCount ? 'Do $count light jumps' : 'Complete your light-jump task',
    'qr' => 'Scan your registered QR code',
    _ => 'Complete your chosen wake-up task',
  };
}

String secondsLabel(num milliseconds) {
  final seconds = milliseconds / 1000;
  return seconds == seconds.roundToDouble()
      ? seconds.toInt().toString()
      : seconds.toStringAsFixed(1);
}

const planFieldLabels = <String, String>{
  'sound': 'Alarm sound',
  'soundFamily': 'Sound style',
  'initialVolumePercent': 'Starting volume',
  'maxVolumePercent': 'Volume limit',
  'volumeEscalationEnabled': 'Gradually increase volume',
  'volumeEscalationStepPercent': 'Volume increase each time',
  'volumeEscalationIntervalSeconds': 'Time between volume increases',
  'vibrationEnabled': 'Vibration',
  'vibrationPattern': 'Vibration pattern',
  'missionRequired': 'Wake-up task required',
  'missionType': 'Wake-up task',
  'missionDifficulty': 'Task difficulty',
  'missionSteps': 'Steps to walk',
  'missionJumps': 'Light jumps',
  'wakeCheckRequired': 'Follow-up wake check',
  'wakeCheckDelayMinutes': 'Wait before checking again',
  'wakeCheckHoldMilliseconds': 'Hold time to confirm you are awake',
  'maxWakeCheckFailures': 'Limit on missed follow-up checks',
  'reactivationSoundPolicy': 'Sound when the alarm rings again',
  'intensityLevel': 'Overall alarm strength',
};

String planFieldValue(String field, Object? value) {
  if (value == null) return 'Not set';
  if (value is bool) return value ? 'On' : 'Off';
  if (field == 'sound' || field == 'soundFamily') return soundLabel(value);
  if (field.endsWith('Percent')) return '$value%';
  if (field == 'wakeCheckHoldMilliseconds' && value is num) {
    return '${secondsLabel(value)} seconds';
  }
  if (field.endsWith('Seconds')) return '$value seconds';
  if (field.endsWith('Minutes')) return '$value minutes';
  if (field == 'intensityLevel') return '$value of 5';
  if (field == 'vibrationPattern') {
    final pattern = VibrationPattern.values
        .where((p) => p.name == value)
        .firstOrNull;
    return pattern == null ? 'Selected pattern' : vibrationLabel(pattern);
  }
  return switch (value) {
    'movement' => 'Walking',
    'jumping' => 'Light jumps',
    'qr' => 'QR code scan',
    'keep' => 'Keep the same sound',
    'alternateSound' => 'Use another sound',
    'alternateFamily' => 'Use a different sound style',
    'easy' => 'Easy',
    'normal' => 'Normal',
    'hard' => 'Hard',
    _ => value is num ? '$value' : 'Selected setting',
  };
}
