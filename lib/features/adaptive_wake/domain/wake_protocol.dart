enum WakeProtocolSource { userDefined, defaultValue, adaptiveEngine, recovery }

enum WakeProtocolStatus { active, superseded, reverted, archived }

enum WakeIntensity { light, standard, resistant, heavy, extreme }

enum VibrationPattern {
  standard,
  doublePulse,
  longShortShort,
  ramping,
  strongPulse,
}

enum ReactivationSoundPolicy { keep, alternateSound, alternateFamily }

enum AdaptiveDimension { sound, volume, vibration, mission, wakeCheck }

enum AdaptiveMode { fixed, adaptive }

enum AdaptiveReasonCode {
  v2Migration,
  slowResponseRepeated,
  noResponse,
  highSnoozeCount,
  soundEffectivenessDecline,
  wakeCheckFailureRepeated,
  missionFailureRepeated,
  successStreak,
  excessiveProtocolIntensity,
  emergencyBypassRepeated,
  insufficientData,
  manualUserOverride,
  manualReset,
  performanceWorsened,
}

class WakeProtocol {
  const WakeProtocol({
    required this.id,
    required this.alarmId,
    required this.version,
    required this.source,
    required this.status,
    required this.initialSoundId,
    required this.initialSoundFamily,
    required this.ringtoneUri,
    required this.initialVolumePercent,
    required this.maxVolumePercent,
    required this.volumeEscalationEnabled,
    required this.volumeEscalationStepPercent,
    required this.volumeEscalationIntervalSeconds,
    required this.vibrationEnabled,
    required this.vibrationPattern,
    required this.vibrationEscalationEnabled,
    required this.missionRequired,
    required this.missionType,
    required this.missionDifficulty,
    required this.missionConfigurationJson,
    required this.wakeCheckRequired,
    required this.wakeCheckDelayMinutes,
    required this.wakeCheckHoldMilliseconds,
    required this.maxWakeCheckFailures,
    required this.reactivationSoundPolicy,
    required this.intensity,
    required this.reasonCode,
    required this.technicalExplanation,
    required this.userExplanation,
    required this.basedOnSessionId,
    required this.supersedesProtocolId,
    required this.createdAt,
    required this.effectiveFrom,
  });

  final String id;
  final String alarmId;
  final int version;
  final WakeProtocolSource source;
  final WakeProtocolStatus status;
  final String initialSoundId;
  final String? initialSoundFamily;
  final String ringtoneUri;
  final int initialVolumePercent;
  final int maxVolumePercent;
  final bool volumeEscalationEnabled;
  final int volumeEscalationStepPercent;
  final int volumeEscalationIntervalSeconds;
  final bool vibrationEnabled;
  final VibrationPattern vibrationPattern;
  final bool vibrationEscalationEnabled;
  final bool missionRequired;
  final String? missionType;
  final String? missionDifficulty;
  final String missionConfigurationJson;
  final bool wakeCheckRequired;
  final int wakeCheckDelayMinutes;
  final int wakeCheckHoldMilliseconds;
  final int maxWakeCheckFailures;
  final ReactivationSoundPolicy reactivationSoundPolicy;
  final WakeIntensity intensity;
  final AdaptiveReasonCode reasonCode;
  final String technicalExplanation;
  final String userExplanation;
  final String? basedOnSessionId;
  final String? supersedesProtocolId;
  final DateTime createdAt;
  final DateTime effectiveFrom;

  WakeProtocol copyWith({
    String? id,
    int? version,
    WakeProtocolSource? source,
    WakeProtocolStatus? status,
    String? initialSoundId,
    String? initialSoundFamily,
    bool clearInitialSoundFamily = false,
    String? ringtoneUri,
    int? initialVolumePercent,
    int? maxVolumePercent,
    bool? volumeEscalationEnabled,
    int? volumeEscalationStepPercent,
    int? volumeEscalationIntervalSeconds,
    bool? vibrationEnabled,
    VibrationPattern? vibrationPattern,
    bool? vibrationEscalationEnabled,
    bool? missionRequired,
    String? missionType,
    String? missionDifficulty,
    String? missionConfigurationJson,
    bool? wakeCheckRequired,
    int? wakeCheckDelayMinutes,
    int? wakeCheckHoldMilliseconds,
    int? maxWakeCheckFailures,
    ReactivationSoundPolicy? reactivationSoundPolicy,
    WakeIntensity? intensity,
    AdaptiveReasonCode? reasonCode,
    String? technicalExplanation,
    String? userExplanation,
    String? basedOnSessionId,
    String? supersedesProtocolId,
    DateTime? createdAt,
    DateTime? effectiveFrom,
  }) => WakeProtocol(
    id: id ?? this.id,
    alarmId: alarmId,
    version: version ?? this.version,
    source: source ?? this.source,
    status: status ?? this.status,
    initialSoundId: initialSoundId ?? this.initialSoundId,
    initialSoundFamily: clearInitialSoundFamily
        ? null
        : initialSoundFamily ?? this.initialSoundFamily,
    ringtoneUri: ringtoneUri ?? this.ringtoneUri,
    initialVolumePercent: initialVolumePercent ?? this.initialVolumePercent,
    maxVolumePercent: maxVolumePercent ?? this.maxVolumePercent,
    volumeEscalationEnabled:
        volumeEscalationEnabled ?? this.volumeEscalationEnabled,
    volumeEscalationStepPercent:
        volumeEscalationStepPercent ?? this.volumeEscalationStepPercent,
    volumeEscalationIntervalSeconds:
        volumeEscalationIntervalSeconds ?? this.volumeEscalationIntervalSeconds,
    vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    vibrationPattern: vibrationPattern ?? this.vibrationPattern,
    vibrationEscalationEnabled:
        vibrationEscalationEnabled ?? this.vibrationEscalationEnabled,
    missionRequired: missionRequired ?? this.missionRequired,
    missionType: missionType ?? this.missionType,
    missionDifficulty: missionDifficulty ?? this.missionDifficulty,
    missionConfigurationJson:
        missionConfigurationJson ?? this.missionConfigurationJson,
    wakeCheckRequired: wakeCheckRequired ?? this.wakeCheckRequired,
    wakeCheckDelayMinutes: wakeCheckDelayMinutes ?? this.wakeCheckDelayMinutes,
    wakeCheckHoldMilliseconds:
        wakeCheckHoldMilliseconds ?? this.wakeCheckHoldMilliseconds,
    maxWakeCheckFailures: maxWakeCheckFailures ?? this.maxWakeCheckFailures,
    reactivationSoundPolicy:
        reactivationSoundPolicy ?? this.reactivationSoundPolicy,
    intensity: intensity ?? this.intensity,
    reasonCode: reasonCode ?? this.reasonCode,
    technicalExplanation: technicalExplanation ?? this.technicalExplanation,
    userExplanation: userExplanation ?? this.userExplanation,
    basedOnSessionId: basedOnSessionId ?? this.basedOnSessionId,
    supersedesProtocolId: supersedesProtocolId ?? this.supersedesProtocolId,
    createdAt: createdAt ?? this.createdAt,
    effectiveFrom: effectiveFrom ?? this.effectiveFrom,
  );
}

class AlarmAdaptationPolicy {
  const AlarmAdaptationPolicy({
    required this.enabled,
    required this.sound,
    required this.volume,
    required this.vibration,
    required this.wakeCheck,
    required this.mission,
    required this.userMaxVolumePercent,
  });

  final bool enabled;
  final AdaptiveMode sound;
  final AdaptiveMode volume;
  final AdaptiveMode vibration;
  final AdaptiveMode wakeCheck;
  final AdaptiveMode mission;
  final int userMaxVolumePercent;
}

/// Explainable configuration bands; this is not a physiological sleep score.
WakeIntensity calculateWakeIntensity(WakeProtocol p) {
  var score = p.initialVolumePercent >= 80
      ? 3
      : p.initialVolumePercent >= 50
      ? 2
      : 1;
  if (p.vibrationEnabled && p.vibrationPattern != VibrationPattern.standard) {
    score++;
  }
  if (p.missionRequired) score++;
  if (p.wakeCheckRequired &&
      (p.wakeCheckHoldMilliseconds >= 3000 ||
          p.reactivationSoundPolicy ==
              ReactivationSoundPolicy.alternateFamily)) {
    score++;
  }
  return WakeIntensity.values[(score.clamp(1, 5) - 1)];
}
