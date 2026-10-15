package com.ryser.ryser.service

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import org.json.JSONObject
import androidx.core.app.NotificationCompat
import com.ryser.ryser.R
import com.ryser.ryser.alarm.AlarmRingingActivity
import com.ryser.ryser.runtime.RuntimeEventStore
import com.ryser.ryser.bridge.AlarmScheduleDto
import com.ryser.ryser.scheduling.AlarmScheduler
import com.ryser.ryser.runtime.SoundRotationSelector

class AlarmPlaybackService : Service() {
    private var player: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    private val volumeHandler = Handler(Looper.getMainLooper())
    private var volumeStep = 0
    private var previousVibrationPattern: String? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_PAUSE_ESCALATION) {
            volumeHandler.removeCallbacksAndMessages(null)
            return START_NOT_STICKY
        }
        if (intent?.action == ACTION_DISMISS) {
            recordDismissal(intent)
            stopSelf()
            return START_NOT_STICKY
        }
        if (intent?.action == ACTION_SNOOZE) {
            snooze(intent)
            stopSelf()
            return START_NOT_STICKY
        }

        val alarmId = intent?.getStringExtra(EXTRA_ALARM_ID) ?: return START_NOT_STICKY
        val label = intent.getStringExtra(EXTRA_LABEL).orEmpty()
        val ringtoneUri = intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty()
        val shouldVibrate = intent.getBooleanExtra(EXTRA_VIBRATION, true)
        val sessionId = intent.getStringExtra(EXTRA_SESSION_ID).orEmpty()
        val scheduledAtMs = intent.getLongExtra(EXTRA_SCHEDULED_AT_MS, 0L)
        val snoozeEnabled = intent.getBooleanExtra(EXTRA_SNOOZE_ENABLED, true)
        val snoozeDuration = intent.getIntExtra(EXTRA_SNOOZE_DURATION, 5)
        val adaptiveRotation = intent.getBooleanExtra(EXTRA_ADAPTIVE_ROTATION, true)
        val snoozeCount = intent.getIntExtra(EXTRA_SNOOZE_COUNT, 0)
        val increasingVolume = intent.getBooleanExtra(EXTRA_INCREASING_VOLUME, false)
        val initialVolumePercent = intent.getIntExtra(EXTRA_INITIAL_VOLUME, if (increasingVolume) 30 else 100)
        val maxVolumePercent = intent.getIntExtra(EXTRA_MAX_VOLUME, 100)
        val volumeStepPercent = intent.getIntExtra(EXTRA_VOLUME_STEP, 10)
        val volumeIntervalSeconds = intent.getIntExtra(EXTRA_VOLUME_INTERVAL, 5)
        val vibrationPattern = intent.getStringExtra(EXTRA_VIBRATION_PATTERN).orEmpty().ifBlank { "standard" }

        startForeground(
            NOTIFICATION_ID,
            buildNotification(
                alarmId, label, sessionId, scheduledAtMs, ringtoneUri,
                shouldVibrate, snoozeEnabled, snoozeDuration, adaptiveRotation,
                increasingVolume, snoozeCount,
                intent,
            ),
        )
        startAudio(
            ringtoneUri,
            increasingVolume,
            initialVolumePercent,
            maxVolumePercent,
            volumeStepPercent,
            volumeIntervalSeconds,
            intent,
        )
        if (shouldVibrate) {
            val selectedPattern = when (vibrationPattern) {
                "standard", "doublePulse", "longShortShort", "ramping", "strongPulse" -> vibrationPattern
                else -> "standard"
            }
            startVibration(selectedPattern)
            try {
                if (previousVibrationPattern != selectedPattern) {
                    RuntimeEventStore(this).append(
                        sessionId, alarmId, "VIBRATION_CHANGED", System.currentTimeMillis(),
                        scheduledAtMs, ringtoneUri,
                        metadataJson = JSONObject().put("oldPattern", previousVibrationPattern ?: "off")
                            .put("newPattern", selectedPattern).toString(),
                        protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                        protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                    )
                }
                previousVibrationPattern = selectedPattern
                RuntimeEventStore(this).append(
                    sessionId = sessionId,
                    alarmId = alarmId,
                    eventType = "VIBRATION_STARTED",
                    occurredAtMs = System.currentTimeMillis(),
                    scheduledAtMs = scheduledAtMs,
                    ringtoneUri = ringtoneUri,
                    metadataJson = "{\"pattern\":\"$selectedPattern\"}",
                    protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                    protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                    protocolSnapshotJson = intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
                )
            } catch (_: Exception) {
                // Playback and vibration must not depend on evidence storage.
            }
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        player?.run {
            if (isPlaying) stop()
            release()
        }
        player = null
        volumeHandler.removeCallbacksAndMessages(null)
        vibrator?.cancel()
        vibrator = null
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startAudio(
        ringtoneUri: String,
        increasingVolume: Boolean,
        initialVolumePercent: Int,
        maxVolumePercent: Int,
        stepPercent: Int,
        intervalSeconds: Int,
        sourceIntent: Intent,
    ) {
        player?.release()
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val initial = initialVolumePercent.coerceIn(0, 100)
        player = createPlayer(Uri.parse(ringtoneUri), attributes, initial)
        if (player == null) {
            player = createPlayer(
                Uri.parse("android.resource://$packageName/raw/pulse_a"),
                attributes,
                initial,
            ) ?: createPlayer(
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM),
                attributes,
                initial,
            )
            try {
                RuntimeEventStore(this).append(
                    sessionId = sourceIntent.getStringExtra(EXTRA_SESSION_ID).orEmpty(),
                    alarmId = sourceIntent.getStringExtra(EXTRA_ALARM_ID).orEmpty(),
                    eventType = "SOUND_FALLBACK",
                    occurredAtMs = System.currentTimeMillis(),
                    scheduledAtMs = sourceIntent.getLongExtra(EXTRA_SCHEDULED_AT_MS, 0L),
                    ringtoneUri = ringtoneUri,
                    metadataJson = "{\"bundledFallback\":true}",
                    protocolId = sourceIntent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                    protocolVersion = sourceIntent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                    protocolSnapshotJson = sourceIntent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
                )
            } catch (_: Exception) {
                // Playback is never coupled to telemetry.
            }
        }
        val maximum = maxVolumePercent.coerceIn(initial, 100)
        player?.start()
        if (increasingVolume && initial < maximum) {
            startVolumeRamp(initial, maximum, stepPercent, intervalSeconds, sourceIntent)
        }
    }

    private fun startVolumeRamp(
        initialPercent: Int,
        maxPercent: Int,
        stepPercent: Int,
        intervalSeconds: Int,
        sourceIntent: Intent,
    ) {
        volumeStep = initialPercent
        val startedAt = SystemClock.elapsedRealtime()
        val ramp = object : Runnable {
            override fun run() {
                val oldPercent = volumeStep
                volumeStep = (volumeStep + stepPercent.coerceIn(5, 25)).coerceAtMost(maxPercent)
                val level = volumeStep / 100f
                player?.setVolume(level, level)
                try { RuntimeEventStore(this@AlarmPlaybackService).append(
                    sessionId = sourceIntent.getStringExtra(EXTRA_SESSION_ID).orEmpty(),
                    alarmId = sourceIntent.getStringExtra(EXTRA_ALARM_ID).orEmpty(),
                    eventType = "VOLUME_INCREASED",
                    occurredAtMs = System.currentTimeMillis(),
                    scheduledAtMs = sourceIntent.getLongExtra(EXTRA_SCHEDULED_AT_MS, 0L),
                    ringtoneUri = sourceIntent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty(),
                    metadataJson = JSONObject().put("oldPercent", oldPercent)
                        .put("newPercent", volumeStep)
                        .put("elapsedMs", SystemClock.elapsedRealtime() - startedAt).toString(),
                ) } catch (_: Exception) {
                    // Evidence storage must never interrupt audible playback.
                }
                if (volumeStep < maxPercent) {
                    volumeHandler.postDelayed(this, intervalSeconds.coerceIn(5, 60) * 1000L)
                }
            }
        }
        volumeHandler.postDelayed(ramp, intervalSeconds.coerceIn(5, 60) * 1000L)
    }

    private fun createPlayer(uri: Uri?, attributes: AudioAttributes, initialPercent: Int): MediaPlayer? {
        if (uri == null) return null
        val candidate = MediaPlayer()
        return try {
            candidate.apply {
                setAudioAttributes(attributes)
                setDataSource(this@AlarmPlaybackService, uri)
                isLooping = true
                prepare()
                val initial = initialPercent.coerceIn(0, 100) / 100f
                setVolume(initial, initial)
            }
        } catch (_: Exception) {
            candidate.release()
            null
        }
    }

    private fun startVibration(patternId: String) {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(VIBRATOR_SERVICE) as Vibrator
        }
        val pattern = when (patternId) {
            "doublePulse" -> longArrayOf(0, 350, 180, 350, 650)
            "longShortShort" -> longArrayOf(0, 800, 200, 250, 150, 250, 600)
            "ramping" -> longArrayOf(0, 250, 500, 450, 350, 700, 250)
            "strongPulse" -> longArrayOf(0, 1000, 250, 1000, 350)
            else -> longArrayOf(0, 700, 300, 700, 500)
        }
        vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
    }

    private fun buildNotification(
        alarmId: String,
        label: String,
        sessionId: String,
        scheduledAtMs: Long,
        ringtoneUri: String,
        vibrationEnabled: Boolean,
        snoozeEnabled: Boolean,
        snoozeDuration: Int,
        adaptiveRotation: Boolean,
        increasingVolume: Boolean,
        snoozeCount: Int,
        sourceIntent: Intent,
    ) =
        NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(if (label.isBlank()) "Ryser alarm" else label)
            .setContentText("Alarm is ringing")
            .setColor(Color.GREEN)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setOngoing(true)
            .setAutoCancel(false)
            .setContentIntent(openAlarmIntent(alarmId, label, sessionId, scheduledAtMs, ringtoneUri, snoozeEnabled, snoozeDuration, adaptiveRotation, increasingVolume, snoozeCount, sourceIntent))
            .setFullScreenIntent(openAlarmIntent(alarmId, label, sessionId, scheduledAtMs, ringtoneUri, snoozeEnabled, snoozeDuration, adaptiveRotation, increasingVolume, snoozeCount, sourceIntent), true)
            .apply {
                if (snoozeEnabled) {
                    addAction(0, "SNOOZE", snoozeIntent(alarmId, label, sessionId, scheduledAtMs, ringtoneUri, vibrationEnabled, snoozeDuration, adaptiveRotation, increasingVolume, snoozeCount, sourceIntent))
                }
            }
            .addAction(
                0,
                "DISMISS",
                openAlarmIntent(
                    alarmId,
                    label,
                    sessionId,
                    scheduledAtMs,
                    ringtoneUri,
                    snoozeEnabled,
                    snoozeDuration,
                    adaptiveRotation,
                    increasingVolume, snoozeCount, sourceIntent,
                ),
            )
            .build()

    private fun openAlarmIntent(
        alarmId: String,
        label: String,
        sessionId: String,
        scheduledAtMs: Long,
        ringtoneUri: String,
        snoozeEnabled: Boolean,
        snoozeDuration: Int,
        adaptiveRotation: Boolean,
        increasingVolume: Boolean,
        snoozeCount: Int,
        sourceIntent: Intent,
    ): PendingIntent = PendingIntent.getActivity(
        this,
        alarmId.hashCode() and Int.MAX_VALUE,
        AlarmRingingActivity.createIntent(
            this,
            alarmId,
            label,
            sessionId,
            scheduledAtMs,
            ringtoneUri,
            snoozeEnabled,
            snoozeDuration,
            adaptiveRotation,
            snoozeCount, increasingVolume,
            vibrationEnabled = sourceIntent.getBooleanExtra(EXTRA_VIBRATION, true),
            protocolId = sourceIntent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
            protocolVersion = sourceIntent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
            protocolSnapshotJson = sourceIntent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
            initialVolumePercent = sourceIntent.getIntExtra(EXTRA_INITIAL_VOLUME, 100),
            maxVolumePercent = sourceIntent.getIntExtra(EXTRA_MAX_VOLUME, 100),
            volumeEscalationStepPercent = sourceIntent.getIntExtra(EXTRA_VOLUME_STEP, 10),
            volumeEscalationIntervalSeconds = sourceIntent.getIntExtra(EXTRA_VOLUME_INTERVAL, 5),
            vibrationPattern = sourceIntent.getStringExtra(EXTRA_VIBRATION_PATTERN).orEmpty().ifBlank { "standard" },
        ),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    private fun snoozeIntent(
        alarmId: String,
        label: String,
        sessionId: String,
        scheduledAtMs: Long,
        ringtoneUri: String,
        vibrationEnabled: Boolean,
        snoozeDuration: Int,
        adaptiveRotation: Boolean,
        increasingVolume: Boolean,
        snoozeCount: Int,
        sourceIntent: Intent,
    ): PendingIntent = PendingIntent.getService(
        this,
        (alarmId.hashCode() and Int.MAX_VALUE) xor SNOOZE_MASK,
        createSnoozeIntent(
            this, alarmId, label, sessionId, scheduledAtMs, ringtoneUri,
            vibrationEnabled, snoozeDuration, adaptiveRotation, increasingVolume,
            snoozeCount,
            sourceIntent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
            sourceIntent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
            sourceIntent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
            sourceIntent.getIntExtra(EXTRA_INITIAL_VOLUME, 100),
            sourceIntent.getIntExtra(EXTRA_MAX_VOLUME, 100),
            sourceIntent.getIntExtra(EXTRA_VOLUME_STEP, 10),
            sourceIntent.getIntExtra(EXTRA_VOLUME_INTERVAL, 5),
            sourceIntent.getStringExtra(EXTRA_VIBRATION_PATTERN).orEmpty().ifBlank { "standard" },
        ),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    private fun dismissIntent(
        alarmId: String,
        sessionId: String,
        scheduledAtMs: Long,
        ringtoneUri: String,
    ): PendingIntent = PendingIntent.getService(
        this,
        (alarmId.hashCode() and Int.MAX_VALUE) xor DISMISS_MASK,
        createDismissIntent(this, alarmId, sessionId, scheduledAtMs, ringtoneUri),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    private fun recordDismissal(intent: Intent) {
        val sessionId = intent.getStringExtra(EXTRA_SESSION_ID) ?: return
        val alarmId = intent.getStringExtra(EXTRA_ALARM_ID) ?: return
        RuntimeEventStore(this).append(
            sessionId = sessionId,
            alarmId = alarmId,
            eventType = RuntimeEventStore.EVENT_DISMISSED,
            occurredAtMs = System.currentTimeMillis(),
            scheduledAtMs = intent.getLongExtra(EXTRA_SCHEDULED_AT_MS, 0L),
            ringtoneUri = intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty(),
        )
    }

    private fun snooze(intent: Intent) {
        val sessionId = intent.getStringExtra(EXTRA_SESSION_ID) ?: return
        val alarmId = intent.getStringExtra(EXTRA_ALARM_ID) ?: return
        val now = System.currentTimeMillis()
        val duration = intent.getIntExtra(EXTRA_SNOOZE_DURATION, 5)
        val currentUri = intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty()
        val rotate = intent.getBooleanExtra(EXTRA_ADAPTIVE_ROTATION, true)
        val nextUri = if (rotate) SoundRotationSelector(this).select(alarmId, currentUri) else currentUri
        RuntimeEventStore(this).append(
            sessionId, alarmId, RuntimeEventStore.EVENT_SNOOZED, now,
            intent.getLongExtra(EXTRA_SCHEDULED_AT_MS, now), currentUri,
        )
        AlarmScheduler(this).schedule(
            AlarmScheduleDto(
                alarmId = alarmId,
                triggerAtMs = now + duration * 60_000L,
                label = intent.getStringExtra(EXTRA_LABEL).orEmpty(),
                ringtoneUri = nextUri,
                vibrationEnabled = intent.getBooleanExtra(EXTRA_VIBRATION, true),
                snoozeEnabled = true,
                snoozeDurationMinutes = duration.toLong(),
                adaptiveSoundRotation = rotate,
                increasingVolume = intent.getBooleanExtra(EXTRA_INCREASING_VOLUME, false),
                protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                protocolSnapshotJson = intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
                initialVolumePercent = intent.getIntExtra(EXTRA_INITIAL_VOLUME, 100).toLong(),
                maxVolumePercent = intent.getIntExtra(EXTRA_MAX_VOLUME, 100).toLong(),
                volumeEscalationStepPercent = intent.getIntExtra(EXTRA_VOLUME_STEP, 10).toLong(),
                volumeEscalationIntervalSeconds = intent.getIntExtra(EXTRA_VOLUME_INTERVAL, 5).toLong(),
                vibrationPattern = intent.getStringExtra(EXTRA_VIBRATION_PATTERN).orEmpty().ifBlank { "standard" },
                sessionId = sessionId,
                snoozeCount = (intent.getIntExtra(EXTRA_SNOOZE_COUNT, 0) + 1).toLong(),
                localHour = 0,
                localMinute = 0,
                recurrenceType = "oneTime",
                repeatDaysMask = 0,
            ),
            persist = false,
        )
    }

    private fun createNotificationChannel() {
        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Ringing alarms",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Active Ryser alarms"
            setSound(null, null)
            enableVibration(false)
            lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
        }
        manager.createNotificationChannel(channel)
    }

    companion object {
        const val ACTION_PAUSE_ESCALATION = "com.ryser.ryser.PAUSE_ESCALATION"
        private const val CHANNEL_ID = "ryser_ringing_alarm"
        private const val NOTIFICATION_ID = 4702
        private const val ACTION_DISMISS = "com.ryser.ryser.DISMISS_ALARM"
        private const val ACTION_SNOOZE = "com.ryser.ryser.SNOOZE_ALARM"
        private const val EXTRA_ALARM_ID = "alarm_id"
        private const val EXTRA_LABEL = "label"
        private const val EXTRA_RINGTONE_URI = "ringtone_uri"
        private const val EXTRA_VIBRATION = "vibration"
        private const val EXTRA_SESSION_ID = "session_id"
        private const val EXTRA_SCHEDULED_AT_MS = "scheduled_at_ms"
        private const val EXTRA_SNOOZE_ENABLED = "snooze_enabled"
        private const val EXTRA_SNOOZE_DURATION = "snooze_duration"
        private const val EXTRA_ADAPTIVE_ROTATION = "adaptive_rotation"
        private const val EXTRA_INCREASING_VOLUME = "increasing_volume"
        private const val EXTRA_SNOOZE_COUNT = "snooze_count"
        private const val EXTRA_PROTOCOL_ID = "protocol_id"
        private const val EXTRA_PROTOCOL_VERSION = "protocol_version"
        private const val EXTRA_PROTOCOL_SNAPSHOT = "protocol_snapshot"
        private const val EXTRA_INITIAL_VOLUME = "initial_volume_percent"
        private const val EXTRA_MAX_VOLUME = "max_volume_percent"
        private const val EXTRA_VOLUME_STEP = "volume_step_percent"
        private const val EXTRA_VOLUME_INTERVAL = "volume_interval_seconds"
        private const val EXTRA_VIBRATION_PATTERN = "vibration_pattern"
        private const val DISMISS_MASK = 0x5D15
        private const val SNOOZE_MASK = 0x5A00

        fun createStartIntent(
            context: Context,
            alarmId: String,
            label: String,
            ringtoneUri: String,
            vibrationEnabled: Boolean,
            sessionId: String,
            scheduledAtMs: Long,
            snoozeEnabled: Boolean,
            snoozeDurationMinutes: Int,
            adaptiveSoundRotation: Boolean,
            increasingVolume: Boolean,
            snoozeCount: Int,
            protocolId: String = "",
            protocolVersion: Long = 0,
            protocolSnapshotJson: String = "{}",
            initialVolumePercent: Int = 100,
            maxVolumePercent: Int = 100,
            volumeEscalationStepPercent: Int = 10,
            volumeEscalationIntervalSeconds: Int = 5,
            vibrationPattern: String = "standard",
        ): Intent = Intent(context, AlarmPlaybackService::class.java).apply {
            putExtra(EXTRA_ALARM_ID, alarmId)
            putExtra(EXTRA_LABEL, label)
            putExtra(EXTRA_RINGTONE_URI, ringtoneUri)
            putExtra(EXTRA_VIBRATION, vibrationEnabled)
            putExtra(EXTRA_SESSION_ID, sessionId)
            putExtra(EXTRA_SCHEDULED_AT_MS, scheduledAtMs)
            putExtra(EXTRA_SNOOZE_ENABLED, snoozeEnabled)
            putExtra(EXTRA_SNOOZE_DURATION, snoozeDurationMinutes)
            putExtra(EXTRA_ADAPTIVE_ROTATION, adaptiveSoundRotation)
            putExtra(EXTRA_INCREASING_VOLUME, increasingVolume)
            putExtra(EXTRA_SNOOZE_COUNT, snoozeCount)
            putExtra(EXTRA_PROTOCOL_ID, protocolId)
            putExtra(EXTRA_PROTOCOL_VERSION, protocolVersion)
            putExtra(EXTRA_PROTOCOL_SNAPSHOT, protocolSnapshotJson)
            putExtra(EXTRA_INITIAL_VOLUME, initialVolumePercent)
            putExtra(EXTRA_MAX_VOLUME, maxVolumePercent)
            putExtra(EXTRA_VOLUME_STEP, volumeEscalationStepPercent)
            putExtra(EXTRA_VOLUME_INTERVAL, volumeEscalationIntervalSeconds)
            putExtra(EXTRA_VIBRATION_PATTERN, vibrationPattern)
        }

        fun createDismissIntent(
            context: Context,
            alarmId: String,
            sessionId: String,
            scheduledAtMs: Long,
            ringtoneUri: String,
        ): Intent = Intent(context, AlarmPlaybackService::class.java).apply {
            action = ACTION_DISMISS
            putExtra(EXTRA_ALARM_ID, alarmId)
            putExtra(EXTRA_SESSION_ID, sessionId)
            putExtra(EXTRA_SCHEDULED_AT_MS, scheduledAtMs)
            putExtra(EXTRA_RINGTONE_URI, ringtoneUri)
        }

        fun createSnoozeIntent(
            context: Context,
            alarmId: String,
            label: String,
            sessionId: String,
            scheduledAtMs: Long,
            ringtoneUri: String,
            vibrationEnabled: Boolean,
            snoozeDuration: Int,
            adaptiveRotation: Boolean,
            increasingVolume: Boolean,
            snoozeCount: Int,
            protocolId: String = "",
            protocolVersion: Long = 0,
            protocolSnapshotJson: String = "{}",
            initialVolumePercent: Int = 100,
            maxVolumePercent: Int = 100,
            volumeEscalationStepPercent: Int = 10,
            volumeEscalationIntervalSeconds: Int = 5,
            vibrationPattern: String = "standard",
        ): Intent = Intent(context, AlarmPlaybackService::class.java).apply {
            action = ACTION_SNOOZE
            putExtra(EXTRA_ALARM_ID, alarmId)
            putExtra(EXTRA_LABEL, label)
            putExtra(EXTRA_SESSION_ID, sessionId)
            putExtra(EXTRA_SCHEDULED_AT_MS, scheduledAtMs)
            putExtra(EXTRA_RINGTONE_URI, ringtoneUri)
            putExtra(EXTRA_VIBRATION, vibrationEnabled)
            putExtra(EXTRA_SNOOZE_DURATION, snoozeDuration)
            putExtra(EXTRA_ADAPTIVE_ROTATION, adaptiveRotation)
            putExtra(EXTRA_INCREASING_VOLUME, increasingVolume)
            putExtra(EXTRA_SNOOZE_COUNT, snoozeCount)
            putExtra(EXTRA_PROTOCOL_ID, protocolId)
            putExtra(EXTRA_PROTOCOL_VERSION, protocolVersion)
            putExtra(EXTRA_PROTOCOL_SNAPSHOT, protocolSnapshotJson)
            putExtra(EXTRA_INITIAL_VOLUME, initialVolumePercent)
            putExtra(EXTRA_MAX_VOLUME, maxVolumePercent)
            putExtra(EXTRA_VOLUME_STEP, volumeEscalationStepPercent)
            putExtra(EXTRA_VOLUME_INTERVAL, volumeEscalationIntervalSeconds)
            putExtra(EXTRA_VIBRATION_PATTERN, vibrationPattern)
        }
    }
}
