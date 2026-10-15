package com.ryser.ryser.scheduling

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.ryser.ryser.alarm.AlarmRingingActivity
import com.ryser.ryser.bridge.AlarmScheduleDto
import com.ryser.ryser.receivers.AlarmTriggerReceiver
import com.ryser.ryser.runtime.ScheduleStore
import com.ryser.ryser.runtime.SoundRotationSelector
import com.ryser.ryser.notifications.ArmedAlarmNotification
import java.util.Calendar

class AlarmScheduler(private val context: Context) {
    private val alarmManager = context.getSystemService(AlarmManager::class.java)

    fun schedule(schedule: AlarmScheduleDto, persist: Boolean = true) {
        require(schedule.triggerAtMs > System.currentTimeMillis()) {
            "Alarm trigger must be in the future."
        }
        val triggerIntent = PendingIntent.getBroadcast(
            context,
            requestCode(schedule.alarmId),
            AlarmTriggerReceiver.createIntent(context, schedule),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val showIntent = PendingIntent.getActivity(
            context,
            requestCode(schedule.alarmId) xor SHOW_INTENT_MASK,
            AlarmRingingActivity.createIntent(
                context, schedule.alarmId, schedule.label,
                schedule.sessionId.ifBlank { "${schedule.alarmId}-${schedule.triggerAtMs}" },
                schedule.triggerAtMs, schedule.ringtoneUri,
                schedule.snoozeEnabled, schedule.snoozeDurationMinutes.toInt(),
                schedule.adaptiveSoundRotation, schedule.snoozeCount.toInt(),
                schedule.increasingVolume, schedule.vibrationEnabled,
                schedule.protocolId, schedule.protocolVersion,
                schedule.protocolSnapshotJson, schedule.initialVolumePercent.toInt(),
                schedule.maxVolumePercent.toInt(),
                schedule.volumeEscalationStepPercent.toInt(),
                schedule.volumeEscalationIntervalSeconds.toInt(),
                schedule.vibrationPattern,
            ),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        alarmManager.setAlarmClock(
            AlarmManager.AlarmClockInfo(schedule.triggerAtMs, showIntent),
            triggerIntent,
        )
        if (persist) {
            ScheduleStore(context).upsert(schedule)
            ArmedAlarmNotification(context).refresh()
        }
    }

    fun cancel(alarmId: String) {
        val pending = PendingIntent.getBroadcast(
            context,
            requestCode(alarmId),
            Intent(context, AlarmTriggerReceiver::class.java),
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        )
        if (pending != null) {
            alarmManager.cancel(pending)
            pending.cancel()
        }
        ScheduleStore(context).delete(alarmId)
        ArmedAlarmNotification(context).refresh()
    }

    fun onAlarmTriggered(alarmId: String) {
        val store = ScheduleStore(context)
        val current = store.get(alarmId) ?: return
        if (current.recurrenceType == "oneTime") {
            store.delete(alarmId)
            ArmedAlarmNotification(context).refresh()
            return
        }
        val next = current.copy(
            triggerAtMs = nextOccurrence(current, System.currentTimeMillis()),
            // A versioned protocol owns the next occurrence's initial sound.
            // V2 rotation remains available after snoozing that occurrence.
            ringtoneUri = if (current.adaptiveSoundRotation && current.protocolId.isBlank()) {
                SoundRotationSelector(context).select(current.alarmId, current.ringtoneUri)
            } else current.ringtoneUri,
            sessionId = "",
            snoozeCount = 0,
        )
        schedule(next, persist = true)
    }

    fun recoverAll() {
        val now = System.currentTimeMillis()
        val store = ScheduleStore(context)
        store.all().forEach { saved ->
            val triggerAt = if (saved.triggerAtMs > now) saved.triggerAtMs
                else if (saved.recurrenceType == "oneTime") {
                    store.delete(saved.alarmId)
                    return@forEach
                }
                else nextOccurrence(saved, now)
            schedule(saved.copy(triggerAtMs = triggerAt, sessionId = "", snoozeCount = 0), persist = true)
        }
        ArmedAlarmNotification(context).refresh()
    }

    private fun nextOccurrence(schedule: AlarmScheduleDto, afterMs: Long): Long {
        val candidate = Calendar.getInstance().apply {
            timeInMillis = afterMs
            set(Calendar.HOUR_OF_DAY, schedule.localHour.toInt())
            set(Calendar.MINUTE, schedule.localMinute.toInt())
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        if (schedule.recurrenceType == "daily") {
            if (candidate.timeInMillis <= afterMs) candidate.add(Calendar.DAY_OF_YEAR, 1)
            return candidate.timeInMillis
        }
        for (offset in 0..7) {
            val day = (Calendar.getInstance().apply { timeInMillis = afterMs }.get(Calendar.DAY_OF_WEEK) + offset - 2 + 7) % 7
            candidate.timeInMillis = afterMs
            candidate.add(Calendar.DAY_OF_YEAR, offset)
            candidate.set(Calendar.HOUR_OF_DAY, schedule.localHour.toInt())
            candidate.set(Calendar.MINUTE, schedule.localMinute.toInt())
            candidate.set(Calendar.SECOND, 0)
            candidate.set(Calendar.MILLISECOND, 0)
            if (schedule.repeatDaysMask.toInt() and (1 shl day) != 0 && candidate.timeInMillis > afterMs) {
                return candidate.timeInMillis
            }
        }
        error("No enabled recurrence day")
    }

    private fun requestCode(alarmId: String): Int = alarmId.hashCode() and Int.MAX_VALUE

    private companion object {
        const val SHOW_INTENT_MASK = 0x4A71
    }
}
