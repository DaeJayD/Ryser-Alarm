enum ExperimentStatus {
  draft,
  ready,
  running,
  paused,
  completed,
  cancelled,
  invalidated,
}

enum ExperimentDimension {
  sound,
  soundFamily,
  initialVolume,
  volumeEscalation,
  vibrationPattern,
  wakeCheckDelay,
  wakeCheckHold,
  missionType,
  missionDifficulty,
  reactivationPolicy,
}

enum ExperimentVariant { control, candidate }

enum ExperimentOutcome {
  controlBetter,
  candidateBetter,
  noClearWinner,
  insufficientData,
  invalidated,
}

enum ExperimentConfidence { insufficient, limited, adequate }

enum SessionValidity { valid, partial, invalid }

class WakeExperiment {
  const WakeExperiment({
    required this.id,
    required this.alarmId,
    required this.name,
    required this.hypothesis,
    required this.status,
    required this.dimension,
    required this.controlProtocolId,
    required this.controlProtocolVersion,
    required this.controlSnapshotJson,
    required this.candidateProtocolId,
    required this.candidateProtocolVersion,
    required this.candidateSnapshotJson,
    required this.contextKey,
    required this.minimumSessionsPerVariant,
    required this.preferredSessionsPerVariant,
    required this.maximumSessionsPerVariant,
    required this.result,
    required this.confidence,
    required this.winnerProtocolId,
    required this.createdAtMs,
    required this.updatedAtMs,
    this.startedAtMs,
    this.completedAtMs,
    this.invalidReason,
  });

  final String id, alarmId, name, hypothesis, contextKey;
  final ExperimentStatus status;
  final ExperimentDimension dimension;
  final String controlProtocolId, candidateProtocolId;
  final int controlProtocolVersion, candidateProtocolVersion;
  final String controlSnapshotJson, candidateSnapshotJson;
  final int minimumSessionsPerVariant,
      preferredSessionsPerVariant,
      maximumSessionsPerVariant;
  final ExperimentOutcome result;
  final ExperimentConfidence confidence;
  final String? winnerProtocolId, invalidReason;
  final int createdAtMs, updatedAtMs;
  final int? startedAtMs, completedAtMs;
}

/// Reserved before native execution; the native session is attached on import.
class ExperimentSession {
  const ExperimentSession({
    required this.id,
    required this.experimentId,
    required this.alarmId,
    required this.scheduledTimeMs,
    required this.assignmentIndex,
    required this.variant,
    required this.protocolId,
    required this.protocolVersion,
    required this.contextKey,
    required this.assignedAtMs,
    required this.validity,
    this.wakeSessionId,
    this.completedAtMs,
    this.invalidReason,
  });
  final String id, experimentId, alarmId, protocolId, contextKey;
  final int scheduledTimeMs, assignmentIndex, protocolVersion, assignedAtMs;
  final ExperimentVariant variant;
  final SessionValidity validity;
  final String? wakeSessionId, invalidReason;
  final int? completedAtMs;
}

ExperimentVariant variantForAssignment(int zeroBasedIndex) {
  if (zeroBasedIndex < 0) {
    throw ArgumentError.value(zeroBasedIndex, 'zeroBasedIndex');
  }
  return zeroBasedIndex.isEven
      ? ExperimentVariant.control
      : ExperimentVariant.candidate;
}

bool canTransitionExperiment(ExperimentStatus from, ExperimentStatus to) =>
    switch (from) {
      ExperimentStatus.draft => {
        ExperimentStatus.ready,
        ExperimentStatus.cancelled,
        ExperimentStatus.invalidated,
      }.contains(to),
      ExperimentStatus.ready => {
        ExperimentStatus.running,
        ExperimentStatus.cancelled,
        ExperimentStatus.invalidated,
      }.contains(to),
      ExperimentStatus.running => {
        ExperimentStatus.paused,
        ExperimentStatus.completed,
        ExperimentStatus.cancelled,
        ExperimentStatus.invalidated,
      }.contains(to),
      ExperimentStatus.paused => {
        ExperimentStatus.running,
        ExperimentStatus.cancelled,
        ExperimentStatus.invalidated,
      }.contains(to),
      _ => false,
    };
