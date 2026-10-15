package com.ryser.ryser.notifications

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import androidx.core.app.NotificationCompat
import com.ryser.ryser.MainActivity
import com.ryser.ryser.R
import com.ryser.ryser.runtime.ScheduleStore
import java.text.DateFormat
import java.util.Date

class ArmedAlarmNotification(private val context: Context) {
    private val manager = context.getSystemService(NotificationManager::class.java)

    fun refresh() {
        val schedules = ScheduleStore(context).all()
        if (schedules.isEmpty()) {
            manager.cancel(NOTIFICATION_ID)
            return
        }
        createChannel()
        val next = schedules.minBy { it.triggerAtMs }
        val time = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT)
            .format(Date(next.triggerAtMs))
        val openApp = PendingIntent.getActivity(
            context,
            OPEN_REQUEST_CODE,
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_status_orb)
            .setColor(Color.rgb(0, 255, 65))
            .setContentTitle("Ryser alarm armed")
            .setContentText("Next alarm: $time")
            .setContentIntent(openApp)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
        manager.notify(NOTIFICATION_ID, notification)
    }

    private fun createChannel() {
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                "Armed alarm indicator",
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = "Shows the glowing Ryser orb while an alarm is armed"
                setSound(null, null)
                enableVibration(false)
                setShowBadge(false)
            },
        )
    }

    companion object {
        private const val CHANNEL_ID = "ryser_armed_alarm"
        private const val NOTIFICATION_ID = 4704
        private const val OPEN_REQUEST_CODE = 4704
    }
}
