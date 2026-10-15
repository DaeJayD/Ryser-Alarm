package com.ryser.ryser.wakecheck

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context

class WakeCheckScheduler(private val context: Context) {
    fun schedule(
        alarmId: String,
        sessionId: String,
        triggerAtMs: Long,
        scheduledAtMs: Long,
        ringtoneUri: String,
        protocolId: String,
        protocolVersion: Long,
        protocolSnapshotJson: String,
    ) {
        val intent = WakeCheckActivity.createIntent(
            context, alarmId, sessionId, triggerAtMs, scheduledAtMs, ringtoneUri,
            protocolId, protocolVersion, protocolSnapshotJson,
        )
        val pending = PendingIntent.getActivity(
            context,
            sessionId.hashCode() and Int.MAX_VALUE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        context.getSystemService(AlarmManager::class.java).setAlarmClock(
            AlarmManager.AlarmClockInfo(triggerAtMs, pending),
            pending,
        )
    }
}
