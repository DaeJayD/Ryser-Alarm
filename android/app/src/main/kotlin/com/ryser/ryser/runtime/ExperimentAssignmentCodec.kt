package com.ryser.ryser.runtime

import com.ryser.ryser.bridge.AlarmScheduleDto
import com.ryser.ryser.bridge.ExperimentAssignmentDto
import org.json.JSONObject

/** SQLite/Intent serialization only; Pigeon remains the typed bridge contract. */
object ExperimentAssignmentCodec {
    fun encode(value: ExperimentAssignmentDto?): String = if (value == null) "" else JSONObject().apply {
        put("experimentId", value.experimentId)
        put("assignmentId", value.assignmentId)
        put("variant", value.variant)
        put("contextKey", value.contextKey)
        put("occurrenceAtMs", value.occurrenceAtMs)
        put("assignedAtMs", value.assignedAtMs)
    }.toString()

    fun decode(raw: String?): ExperimentAssignmentDto? {
        if (raw.isNullOrBlank()) return null
        return try {
            val p = JSONObject(raw)
            ExperimentAssignmentDto(p.getString("experimentId"), p.getString("assignmentId"),
                p.getString("variant"), p.getString("contextKey"),
                p.getLong("occurrenceAtMs"), p.getLong("assignedAtMs"))
        } catch (_: Exception) {
            // Retain a marker so recovery knows to restore the stable snapshot.
            ExperimentAssignmentDto("", "", "", "", -1, -1)
        }
    }

    fun restoreStable(schedule: AlarmScheduleDto): AlarmScheduleDto = try {
        val p = JSONObject(requireNotNull(schedule.stableProtocolSnapshotJson))
        val id = p.getString("id")
        val version = p.getLong("version")
        val uri = p.getString("ringtoneUri")
        val initial = p.getLong("initialVolumePercent")
        val maximum = p.getLong("maxVolumePercent")
        val ramp = p.getBoolean("volumeEscalationEnabled")
        val step = p.getLong("volumeEscalationStepPercent")
        val interval = p.getLong("volumeEscalationIntervalSeconds")
        val vibration = p.getString("vibrationPattern")
        require(id.isNotBlank() && version > 0 && uri.isNotBlank())
        require(initial in 30..100 && maximum in initial..100)
        require(!ramp || (step in 5..25 && interval in 5..60))
        require(vibration in setOf("standard", "doublePulse", "longShortShort", "ramping", "strongPulse"))
        schedule.copy(protocolId = id, protocolVersion = version,
            protocolSnapshotJson = p.toString(), ringtoneUri = uri,
            initialVolumePercent = initial, maxVolumePercent = maximum,
            increasingVolume = ramp, volumeEscalationStepPercent = step,
            volumeEscalationIntervalSeconds = interval,
            vibrationEnabled = p.getBoolean("vibrationEnabled"), vibrationPattern = vibration)
    } catch (_: Exception) {
        // Malformed learning data must still leave a locally executable alarm.
        val cap = schedule.maxVolumePercent.coerceIn(30L, 100L)
        schedule.copy(protocolId = "", protocolVersion = 0, protocolSnapshotJson = "{}",
            ringtoneUri = "android.resource://com.ryser.ryser/raw/pulse_a",
            initialVolumePercent = schedule.initialVolumePercent.coerceIn(30L, cap),
            maxVolumePercent = cap, increasingVolume = false)
    }
}
