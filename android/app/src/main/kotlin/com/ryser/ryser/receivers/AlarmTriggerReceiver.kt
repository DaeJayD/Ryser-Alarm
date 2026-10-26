package com.ryser.ryser.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import com.ryser.ryser.bridge.AlarmScheduleDto
import com.ryser.ryser.service.AlarmPlaybackService
import com.ryser.ryser.runtime.RuntimeEventStore
import com.ryser.ryser.runtime.ScheduleStore
import com.ryser.ryser.scheduling.AlarmScheduler
import com.ryser.ryser.runtime.ExperimentAssignmentCodec
import android.util.Log

class AlarmTriggerReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val alarmId = intent.getStringExtra(EXTRA_ALARM_ID) ?: return
        val scheduledAtMs = intent.getLongExtra(EXTRA_SCHEDULED_AT_MS, System.currentTimeMillis())
        val ringtoneUri = intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty()
        val snoozeCount = intent.getIntExtra(EXTRA_SNOOZE_COUNT, 0)
        val sessionId = intent.getStringExtra(EXTRA_SESSION_ID).orEmpty()
            .ifBlank { "$alarmId-$scheduledAtMs" }
        try { ScheduleStore(context).recordSoundUse(alarmId, ringtoneUri, System.currentTimeMillis()) }
        catch (error: Exception) { Log.e("RyserAlarm", "Sound usage could not be recorded", error) }
        try {
          RuntimeEventStore(context).append(
            sessionId = sessionId,
            alarmId = alarmId,
            eventType = if (snoozeCount == 0) {
                RuntimeEventStore.EVENT_TRIGGERED
            } else {
                RuntimeEventStore.EVENT_SOUND_CHANGED
            },
            occurredAtMs = System.currentTimeMillis(),
            scheduledAtMs = scheduledAtMs,
            ringtoneUri = ringtoneUri,
            metadataJson = if (snoozeCount == 0) "{\"stage\":\"initial\"}" else "{\"stage\":\"snooze\"}",
            protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
            protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
            protocolSnapshotJson = intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
            experiment = ExperimentAssignmentCodec.decode(intent.getStringExtra(EXTRA_EXPERIMENT)),
          )
        } catch (error: Exception) {
            Log.e("RyserAlarm", "Alarm evidence could not be written", error)
        }
        if (snoozeCount == 0) {
            try { AlarmScheduler(context).onAlarmTriggered(alarmId) }
            catch (error: Exception) { Log.e("RyserAlarm", "Next occurrence could not be scheduled", error) }
        }
        ContextCompat.startForegroundService(
            context,
            AlarmPlaybackService.createStartIntent(
                context = context,
                alarmId = alarmId,
                label = intent.getStringExtra(EXTRA_LABEL).orEmpty(),
                ringtoneUri = ringtoneUri,
                vibrationEnabled = intent.getBooleanExtra(EXTRA_VIBRATION, true),
                sessionId = sessionId,
                scheduledAtMs = scheduledAtMs,
                snoozeEnabled = intent.getBooleanExtra(EXTRA_SNOOZE_ENABLED, true),
                snoozeDurationMinutes = intent.getIntExtra(EXTRA_SNOOZE_DURATION, 5),
                adaptiveSoundRotation = intent.getBooleanExtra(EXTRA_ADAPTIVE_ROTATION, true),
                increasingVolume = intent.getBooleanExtra(EXTRA_INCREASING_VOLUME, false),
                snoozeCount = snoozeCount,
                protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                protocolSnapshotJson = intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
                initialVolumePercent = intent.getIntExtra(EXTRA_INITIAL_VOLUME, 100),
                maxVolumePercent = intent.getIntExtra(EXTRA_MAX_VOLUME, 100),
                volumeEscalationStepPercent = intent.getIntExtra(EXTRA_VOLUME_STEP, 10),
                volumeEscalationIntervalSeconds = intent.getIntExtra(EXTRA_VOLUME_INTERVAL, 5),
                vibrationPattern = intent.getStringExtra(EXTRA_VIBRATION_PATTERN).orEmpty().ifBlank { "standard" },
            ),
        )
    }

    companion object {
        private const val EXTRA_ALARM_ID = "alarm_id"
        private const val EXTRA_LABEL = "label"
        private const val EXTRA_RINGTONE_URI = "ringtone_uri"
        private const val EXTRA_VIBRATION = "vibration"
        private const val EXTRA_SCHEDULED_AT_MS = "scheduled_at_ms"
        private const val EXTRA_SNOOZE_ENABLED = "snooze_enabled"
        private const val EXTRA_SNOOZE_DURATION = "snooze_duration"
        private const val EXTRA_ADAPTIVE_ROTATION = "adaptive_rotation"
        private const val EXTRA_INCREASING_VOLUME = "increasing_volume"
        private const val EXTRA_SESSION_ID = "session_id"
        private const val EXTRA_SNOOZE_COUNT = "snooze_count"
        private const val EXTRA_PROTOCOL_ID = "protocol_id"
        private const val EXTRA_PROTOCOL_VERSION = "protocol_version"
        private const val EXTRA_PROTOCOL_SNAPSHOT = "protocol_snapshot"
        private const val EXTRA_INITIAL_VOLUME = "initial_volume_percent"
        private const val EXTRA_MAX_VOLUME = "max_volume_percent"
        private const val EXTRA_VOLUME_STEP = "volume_step_percent"
        private const val EXTRA_VOLUME_INTERVAL = "volume_interval_seconds"
        private const val EXTRA_VIBRATION_PATTERN = "vibration_pattern"
        private const val EXTRA_EXPERIMENT = "experiment_assignment"

        fun createIntent(context: Context, schedule: AlarmScheduleDto): Intent {
            return Intent(context, AlarmTriggerReceiver::class.java).apply {
                putExtra(EXTRA_ALARM_ID, schedule.alarmId)
                putExtra(EXTRA_LABEL, schedule.label)
                putExtra(EXTRA_RINGTONE_URI, schedule.ringtoneUri)
                putExtra(EXTRA_VIBRATION, schedule.vibrationEnabled)
                putExtra(EXTRA_SCHEDULED_AT_MS, schedule.triggerAtMs)
                putExtra(EXTRA_SNOOZE_ENABLED, schedule.snoozeEnabled)
                putExtra(EXTRA_SNOOZE_DURATION, schedule.snoozeDurationMinutes.toInt())
                putExtra(EXTRA_ADAPTIVE_ROTATION, schedule.adaptiveSoundRotation)
                putExtra(EXTRA_INCREASING_VOLUME, schedule.increasingVolume)
                putExtra(EXTRA_SESSION_ID, schedule.sessionId)
                putExtra(EXTRA_SNOOZE_COUNT, schedule.snoozeCount.toInt())
                putExtra(EXTRA_PROTOCOL_ID, schedule.protocolId)
                putExtra(EXTRA_PROTOCOL_VERSION, schedule.protocolVersion)
                putExtra(EXTRA_PROTOCOL_SNAPSHOT, schedule.protocolSnapshotJson)
                putExtra(EXTRA_INITIAL_VOLUME, schedule.initialVolumePercent.toInt())
                putExtra(EXTRA_MAX_VOLUME, schedule.maxVolumePercent.toInt())
                putExtra(EXTRA_VOLUME_STEP, schedule.volumeEscalationStepPercent.toInt())
                putExtra(EXTRA_VOLUME_INTERVAL, schedule.volumeEscalationIntervalSeconds.toInt())
                putExtra(EXTRA_VIBRATION_PATTERN, schedule.vibrationPattern)
                putExtra(EXTRA_EXPERIMENT, ExperimentAssignmentCodec.encode(schedule.experiment))
            }
        }
    }
}
