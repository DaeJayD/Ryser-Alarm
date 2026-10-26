import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/wake_experiments/data/experiment_execution_settings.dart';
import 'package:ryser/features/wake_experiments/data/wake_experiment_repository.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_safety_policy.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

/// Optional preparation outside the native critical trigger path.
class ExperimentExecutionCoordinator {
  ExperimentExecutionCoordinator(
    this._experiments,
    this._protocols,
    this._settings,
  );
  final WakeExperimentRepository _experiments;
  final WakeProtocolRepository _protocols;
  final ExperimentExecutionSettingsRepository _settings;

  Future<AlarmScheduleDto> prepare(AlarmScheduleDto stable) async {
    final experiment = await _experiments.runningForAlarm(stable.alarmId);
    if (experiment == null) return stable;
    var fallback = stable;
    try {
      if (stable.protocolId.isEmpty) {
        await _experiments.invalidateForAlarm(stable.alarmId, 'Alarm edited.');
        return stable;
      }
      final current = await _protocols.ensureDefault(stable.alarmId);
      fallback = _withProtocol(stable, current);
      final settings = await _settings.load(stable.alarmId);
      if (!settings.enabled || settings.critical) {
        await _experiments.invalidateForAlarm(
          stable.alarmId,
          settings.critical
              ? 'Critical alarm: use your usual plan.'
              : 'Testing disabled or alarm edited.',
        );
        return fallback;
      }
      final context = scheduledExperimentContext(
        stable.alarmId,
        DateTime.fromMillisecondsSinceEpoch(stable.triggerAtMs),
      );
      if (context != experiment.contextKey) return fallback;
      if (current.id != experiment.controlProtocolId ||
          current.version != experiment.controlProtocolVersion ||
          !sameExperimentSettings(
            encodeWakeProtocolSnapshot(current),
            experiment.controlSnapshotJson,
          )) {
        await _experiments.invalidateForAlarm(
          stable.alarmId,
          'Your usual alarm settings changed.',
        );
        return fallback;
      }
      // First execution slice supports one initial sound-family variable only.
      if (experiment.dimension != ExperimentDimension.soundFamily) {
        return fallback;
      }
      final created = DateTime.fromMillisecondsSinceEpoch(
        experiment.createdAtMs,
      );
      final control = decodeExperimentProtocolSnapshot(
        experiment.controlSnapshotJson,
        alarmId: experiment.alarmId,
        createdAt: created,
      );
      final candidate = decodeExperimentProtocolSnapshot(
        experiment.candidateSnapshotJson,
        alarmId: experiment.alarmId,
        createdAt: created,
      );
      final policy = await _protocols.policyForAlarm(experiment.alarmId);
      final errors = const ExperimentSafetyPolicy().validate(
        control: control,
        candidate: candidate,
        dimension: experiment.dimension,
        policy: policy,
        controlSoundAvailable: await _protocols.isValid(control),
        candidateSoundAvailable: await _protocols.isValid(candidate),
        missionAvailable: true,
      );
      if (errors.isNotEmpty) throw StateError(errors.join(', '));
      await _protocols.registerExperimentVariant(candidate);
      final assignment = await _experiments.reserve(
        experiment.id,
        scheduledTimeMs: stable.triggerAtMs,
        contextKey: context,
      );
      final selected = assignment.variant == ExperimentVariant.control
          ? control
          : candidate;
      return _withProtocol(
        stable,
        selected,
        stableSnapshot: experiment.controlSnapshotJson,
        experiment: ExperimentAssignmentDto(
          experimentId: experiment.id,
          assignmentId: assignment.id,
          variant: assignment.variant.name,
          contextKey: assignment.contextKey,
          occurrenceAtMs: assignment.scheduledTimeMs,
          assignedAtMs: assignment.assignedAtMs,
        ),
      );
    } on StateError catch (error) {
      await _experiments.invalidateForAlarm(
        stable.alarmId,
        error.message.toString(),
      );
      return fallback;
    } on FormatException {
      await _experiments.invalidateForAlarm(
        stable.alarmId,
        'The saved test settings could not be read.',
      );
      return fallback;
    }
  }

  AlarmScheduleDto _withProtocol(
    AlarmScheduleDto stable,
    WakeProtocol selected, {
    String? stableSnapshot,
    ExperimentAssignmentDto? experiment,
  }) => AlarmScheduleDto(
    alarmId: stable.alarmId,
    triggerAtMs: stable.triggerAtMs,
    label: stable.label,
    ringtoneUri: selected.ringtoneUri,
    vibrationEnabled: selected.vibrationEnabled,
    snoozeEnabled: stable.snoozeEnabled,
    snoozeDurationMinutes: stable.snoozeDurationMinutes,
    adaptiveSoundRotation: stable.adaptiveSoundRotation,
    increasingVolume: selected.volumeEscalationEnabled,
    protocolId: selected.id,
    protocolVersion: selected.version,
    protocolSnapshotJson: encodeWakeProtocolSnapshot(selected),
    initialVolumePercent: selected.initialVolumePercent,
    maxVolumePercent: selected.maxVolumePercent,
    volumeEscalationStepPercent: selected.volumeEscalationStepPercent,
    volumeEscalationIntervalSeconds: selected.volumeEscalationIntervalSeconds,
    vibrationPattern: selected.vibrationPattern.name,
    sessionId: stable.sessionId,
    snoozeCount: stable.snoozeCount,
    localHour: stable.localHour,
    localMinute: stable.localMinute,
    recurrenceType: stable.recurrenceType,
    repeatDaysMask: stable.repeatDaysMask,
    stableProtocolSnapshotJson: stableSnapshot,
    experiment: experiment,
  );

  Future<void> didSchedule(
    AlarmScheduleDto schedule,
    AlarmApplyResult result,
  ) async {
    final assignment = schedule.experiment;
    if (assignment != null) {
      await _experiments.recordNativeSchedule(
        assignment.assignmentId,
        result.scheduled,
        result.errorCode,
      );
    }
  }
}
