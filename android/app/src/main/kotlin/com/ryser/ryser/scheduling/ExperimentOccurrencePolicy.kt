package com.ryser.ryser.scheduling

import com.ryser.ryser.bridge.AlarmScheduleDto

/** An experiment authorizes one original occurrence, never later recurrence. */
object ExperimentOccurrencePolicy {
    fun forOccurrence(
        schedule: AlarmScheduleDto,
        occurrenceAtMs: Long,
        restoreStable: (AlarmScheduleDto) -> AlarmScheduleDto,
        forceStable: Boolean = false,
    ): AlarmScheduleDto {
        val assignment = schedule.experiment
        val hasExperiment = assignment != null || schedule.stableProtocolSnapshotJson != null
        if (!hasExperiment) return schedule.copy(triggerAtMs = occurrenceAtMs)
        val matches = assignment != null &&
            !schedule.stableProtocolSnapshotJson.isNullOrBlank() &&
            assignment.experimentId.isNotBlank() && assignment.assignmentId.isNotBlank() &&
            assignment.contextKey.isNotBlank() && assignment.variant in setOf("control", "candidate") &&
            assignment.assignedAtMs >= 0 && assignment.assignedAtMs < assignment.occurrenceAtMs &&
            assignment.occurrenceAtMs == occurrenceAtMs
        if (!forceStable && matches) return schedule.copy(triggerAtMs = occurrenceAtMs)
        return restoreStable(schedule).copy(
            triggerAtMs = occurrenceAtMs, experiment = null, stableProtocolSnapshotJson = null,
        )
    }
}
