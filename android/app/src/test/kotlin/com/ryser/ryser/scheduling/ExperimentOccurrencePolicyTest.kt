package com.ryser.ryser.scheduling

import com.ryser.ryser.bridge.AlarmScheduleDto
import com.ryser.ryser.bridge.ExperimentAssignmentDto
import org.junit.Assert.*
import org.junit.Test

class ExperimentOccurrencePolicyTest {
    private fun schedule() = AlarmScheduleDto(
        alarmId = "alarm", triggerAtMs = 5000, label = "Morning", ringtoneUri = "candidate",
        vibrationEnabled = true, snoozeEnabled = true, snoozeDurationMinutes = 5,
        adaptiveSoundRotation = true, increasingVolume = true,
        protocolId = "candidate", protocolVersion = 2, protocolSnapshotJson = "candidate snapshot",
        initialVolumePercent = 50, maxVolumePercent = 90,
        volumeEscalationStepPercent = 10, volumeEscalationIntervalSeconds = 5,
        vibrationPattern = "standard", sessionId = "", snoozeCount = 0,
        localHour = 7, localMinute = 0, recurrenceType = "daily", repeatDaysMask = 0,
        experiment = ExperimentAssignmentDto("experiment", "assignment", "candidate", "context", 5000, 1000),
        stableProtocolSnapshotJson = "control snapshot",
    )

    private fun restore(value: AlarmScheduleDto) = value.copy(
        protocolId = "control", protocolVersion = 1, ringtoneUri = "control",
        protocolSnapshotJson = "control snapshot", initialVolumePercent = 40,
    )

    @Test fun assignedOccurrenceAndRebootUseExactlyTheReservedVariant() {
        val original = schedule()
        val recovered = ExperimentOccurrencePolicy.forOccurrence(original, 5000, ::restore)
        assertEquals(original, recovered)
    }

    @Test fun nextOccurrenceAndOverdueRecoveryRestoreControlAndClearAssignment() {
        val next = ExperimentOccurrencePolicy.forOccurrence(schedule(), 9000, ::restore)
        assertEquals("control", next.protocolId)
        assertEquals(1L, next.protocolVersion)
        assertEquals(40L, next.initialVolumePercent)
        assertEquals(9000L, next.triggerAtMs)
        assertNull(next.experiment)
        assertNull(next.stableProtocolSnapshotJson)
    }

    @Test fun clockOrTimezoneChangeForcesStableEvenAtTheSameTimestamp() {
        val result = ExperimentOccurrencePolicy.forOccurrence(schedule(), 5000, ::restore, forceStable = true)
        assertEquals("control", result.ringtoneUri)
        assertNull(result.experiment)
    }

    @Test fun corruptOrLostMetadataCannotRepeatTheCandidate() {
        val current = schedule()
        for (assignment in listOf(null, current.experiment!!.copy(variant = "unknown"),
            current.experiment!!.copy(assignedAtMs = 6000), current.experiment!!.copy(assignmentId = ""))) {
            val result = ExperimentOccurrencePolicy.forOccurrence(current.copy(experiment = assignment), 5000, ::restore)
            assertEquals("control", result.protocolId)
            assertNull(result.experiment)
        }
        assertEquals("control", ExperimentOccurrencePolicy.forOccurrence(
            current.copy(stableProtocolSnapshotJson = ""), 5000, ::restore).protocolId)
    }

    @Test fun ordinaryAlarmsAndSnoozesRetainTheirSessionAndProtocol() {
        val snooze = schedule().copy(experiment = null, stableProtocolSnapshotJson = null,
            sessionId = "original-session", snoozeCount = 1, recurrenceType = "oneTime")
        val result = ExperimentOccurrencePolicy.forOccurrence(snooze, 8000, ::restore)
        assertEquals("candidate", result.protocolId)
        assertEquals("original-session", result.sessionId)
        assertEquals(1L, result.snoozeCount)
        assertNull(result.experiment)
    }
}
