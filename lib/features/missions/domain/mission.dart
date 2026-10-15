enum MissionType { none, qr, movement, jumping }

enum MissionDifficulty { easy, normal, hard }

enum MissionExecutionStatus {
  pending,
  active,
  completed,
  failed,
  timedOut,
  bypassed,
  cancelled,
}

class Mission {
  const Mission({
    required this.id,
    required this.alarmId,
    required this.type,
    required this.enabled,
    required this.difficulty,
    required this.configurationJson,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String alarmId;
  final MissionType type;
  final bool enabled;
  final MissionDifficulty difficulty;
  final String configurationJson;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class MissionExecution {
  const MissionExecution({
    required this.id,
    required this.wakeSessionId,
    required this.missionId,
    required this.type,
    required this.status,
    required this.attemptNumber,
    required this.startedAt,
    this.completedAt,
    this.failedAt,
    this.failureReason,
    this.metadataJson = '{}',
  });

  final String id;
  final String wakeSessionId;
  final String missionId;
  final MissionType type;
  final MissionExecutionStatus status;
  final int attemptNumber;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime? failedAt;
  final String? failureReason;
  final String metadataJson;
}
