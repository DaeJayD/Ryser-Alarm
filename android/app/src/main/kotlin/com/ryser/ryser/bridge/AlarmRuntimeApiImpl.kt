package com.ryser.ryser.bridge

import android.Manifest
import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.RingtoneManager
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.os.Vibrator
import android.hardware.Sensor
import android.hardware.SensorManager
import android.provider.Settings
import android.provider.OpenableColumns
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.ryser.ryser.MainActivity
import com.ryser.ryser.R
import com.ryser.ryser.scheduling.AlarmScheduler
import com.ryser.ryser.runtime.RuntimeEventStore

class AlarmRuntimeApiImpl(
    private val activity: MainActivity,
) : AlarmRuntimeApi {
    private val scheduler = AlarmScheduler(activity.applicationContext)

    override fun isSoundAvailable(uri: String): Boolean = try {
        activity.contentResolver.openAssetFileDescriptor(Uri.parse(uri), "r")?.use {
            it.length != 0L
        } ?: false
    } catch (_: Exception) { false }

    override fun canVibrate(): Boolean =
        activity.getSystemService(Vibrator::class.java)?.hasVibrator() == true

    override fun isMissionAvailable(missionType: String): Boolean {
        val sensors = activity.getSystemService(SensorManager::class.java)
        return when (missionType) {
            "qr" -> activity.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY) &&
                ContextCompat.checkSelfPermission(activity, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
            "movement", "jumping" -> sensors.getDefaultSensor(Sensor.TYPE_ACCELEROMETER) != null
            else -> false
        }
    }

    override fun getAlarmRingtones(): List<RingtoneDto> {
        val bundled = listOf(
            RingtoneDto("android.resource://${activity.packageName}/raw/pulse_a", "Ryser Pulse"),
            RingtoneDto("android.resource://${activity.packageName}/raw/melodic_a", "Ryser Melodic"),
            RingtoneDto("android.resource://${activity.packageName}/raw/urgent_a", "Ryser Urgent"),
        )
        // Resolve every packaged resource before advertising it as playable.
        listOf(R.raw.pulse_a, R.raw.melodic_a, R.raw.urgent_a).forEach {
            activity.resources.openRawResource(it).close()
        }
        val manager = RingtoneManager(activity).apply {
            setType(RingtoneManager.TYPE_ALARM)
        }
        val ringtones = mutableListOf<RingtoneDto>()
        // RingtoneManager owns this Activity-backed cursor. Closing it here
        // causes Activity.performRestart() to requery a stale cursor when a
        // full-screen alarm brings Ryser back to the foreground.
        val cursor = manager.cursor
        var position = 0
        while (cursor.moveToNext()) {
            val uri = manager.getRingtoneUri(position)
            val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            if (uri != null && !title.isNullOrBlank()) {
                ringtones += RingtoneDto(uri.toString(), title)
            }
            position++
        }
        if (ringtones.isEmpty()) {
            val fallback = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                ?: Settings.System.DEFAULT_ALARM_ALERT_URI
            ringtones += RingtoneDto(fallback.toString(), "Default alarm")
        }
        return (bundled + ringtones).distinctBy { it.uri }
    }

    override suspend fun pickAudioFile(): RingtoneDto? {
        val uri = activity.pickAudioFile() ?: return null
        val title = activity.contentResolver.query(
            uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null,
        )?.use { cursor ->
            if (cursor.moveToFirst()) cursor.getString(0) else null
        } ?: uri.lastPathSegment ?: "Selected audio"
        return RingtoneDto(uri.toString(), title)
    }

    override fun scheduleAlarm(schedule: AlarmScheduleDto): AlarmApplyResult {
        if (!isSoundAvailable(schedule.ringtoneUri)) {
            return AlarmApplyResult(false, "sound_unavailable", "Select an available alarm sound.")
        }
        if (!canScheduleExactAlarms()) {
            return AlarmApplyResult(
                scheduled = false,
                errorCode = "exact_alarm_permission",
                message = "Allow Alarms & reminders, then save again.",
            )
        }
        if (!canPostNotifications()) {
            return AlarmApplyResult(
                scheduled = false,
                errorCode = "notification_permission",
                message = "Allow notifications, then save again.",
            )
        }
        return try {
            scheduler.schedule(schedule)
            AlarmApplyResult(scheduled = true)
        } catch (error: Throwable) {
            AlarmApplyResult(
                scheduled = false,
                errorCode = "schedule_failed",
                message = error.message ?: "Android rejected the alarm schedule.",
            )
        }
    }

    override fun cancelAlarm(alarmId: String) {
        scheduler.cancel(alarmId)
    }

    override fun canScheduleExactAlarms(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        val manager = activity.getSystemService(AlarmManager::class.java)
        return manager.canScheduleExactAlarms()
    }

    override fun canPostNotifications(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return true
        return ContextCompat.checkSelfPermission(
            activity,
            Manifest.permission.POST_NOTIFICATIONS,
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun openExactAlarmSettings() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return
        activity.startActivity(
            Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                data = Uri.parse("package:${activity.packageName}")
            },
        )
    }

    override fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                NOTIFICATION_PERMISSION_REQUEST,
            )
        }
    }

    override fun getRuntimeEvents(): List<RuntimeEventDto> =
        RuntimeEventStore(activity.applicationContext).getPending()

    override fun acknowledgeRuntimeEvents(eventIds: List<String>) {
        RuntimeEventStore(activity.applicationContext).acknowledge(eventIds)
    }

    override fun getAlarmHealth(): AlarmHealthDto {
        val notificationManager = activity.getSystemService(NotificationManager::class.java)
        val powerManager = activity.getSystemService(PowerManager::class.java)
        val audioManager = activity.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return AlarmHealthDto(
            exactAlarmsReady = canScheduleExactAlarms(),
            notificationsReady = canPostNotifications() && notificationManager.areNotificationsEnabled(),
            fullScreenReady = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                notificationManager.canUseFullScreenIntent()
            } else {
                true
            },
            batteryUnrestricted = powerManager.isIgnoringBatteryOptimizations(activity.packageName),
            alarmVolume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM).toLong(),
            alarmVolumeMax = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM).toLong(),
        )
    }

    override fun openNotificationSettings() = openAppSettings(Settings.ACTION_APP_NOTIFICATION_SETTINGS)

    override fun openFullScreenSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            activity.startActivity(Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                data = Uri.parse("package:${activity.packageName}")
            })
        } else {
            openNotificationSettings()
        }
    }

    override fun openBatterySettings() {
        activity.startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
    }

    override fun openAlarmVolumeSettings() {
        activity.startActivity(Intent(Settings.ACTION_SOUND_SETTINGS))
    }

    private fun openAppSettings(action: String) {
        activity.startActivity(Intent(action).apply {
            putExtra(Settings.EXTRA_APP_PACKAGE, activity.packageName)
            data = Uri.parse("package:${activity.packageName}")
        })
    }

    private companion object {
        const val NOTIFICATION_PERMISSION_REQUEST = 4701
    }
}
