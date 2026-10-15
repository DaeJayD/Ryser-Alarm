package com.ryser.ryser.alarm

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.view.Gravity
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import com.ryser.ryser.service.AlarmPlaybackService
import com.ryser.ryser.MainActivity
import com.ryser.ryser.runtime.RuntimeEventStore
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AlarmRingingActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setShowWhenLocked(true)
        setTurnScreenOn(true)
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD,
        )
        setContentView(buildContent())
    }

    private fun buildContent(): LinearLayout {
        val green = Color.rgb(0, 255, 65)
        val pale = Color.rgb(232, 255, 232)
        val muted = Color.rgb(140, 168, 140)
        val label = intent.getStringExtra(EXTRA_LABEL).orEmpty()

        return LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(dp(28), dp(48), dp(28), dp(48))
            setBackgroundColor(Color.BLACK)

            addView(text("RYSER  //  ALARM ACTIVE", 16f, green).apply {
                letterSpacing = 0.12f
            })
            addView(spacer(56))
            addView(text(SimpleDateFormat("hh:mm", Locale.getDefault()).format(Date()), 88f, green).apply {
                typeface = Typeface.MONOSPACE
                setShadowLayer(18f, 0f, 0f, green)
            })
            addView(text(SimpleDateFormat("a", Locale.getDefault()).format(Date()), 22f, green))
            addView(spacer(32))
            addView(text(if (label.isBlank()) "GET UP" else label.uppercase(), 28f, pale).apply {
                letterSpacing = 0.1f
            })
            addView(spacer(12))
            addView(text("ALARM IS RINGING", 14f, muted).apply { letterSpacing = 0.12f })
            addView(spacer(72))
            if (intent.getBooleanExtra(EXTRA_SNOOZE_ENABLED, true)) {
                addView(Button(this@AlarmRingingActivity).apply {
                    text = "SNOOZE  ${intent.getIntExtra(EXTRA_SNOOZE_DURATION, 5)} MIN"
                    textSize = 18f
                    setTextColor(green)
                    setBackgroundColor(Color.rgb(8, 11, 8))
                    minHeight = dp(64)
                    setOnClickListener { snoozeAlarm() }
                }, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(72)))
                addView(spacer(16))
            }
            addView(Button(this@AlarmRingingActivity).apply {
                text = "DISMISS"
                textSize = 20f
                setTextColor(Color.BLACK)
                setBackgroundColor(green)
                minHeight = dp(64)
                setOnClickListener { dismissAlarm() }
            }, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(72)))
        }
    }

    private fun snoozeAlarm() {
        startService(
            AlarmPlaybackService.createSnoozeIntent(
                this,
                intent.getStringExtra(EXTRA_ALARM_ID).orEmpty(),
                intent.getStringExtra(EXTRA_LABEL).orEmpty(),
                intent.getStringExtra(EXTRA_SESSION_ID).orEmpty(),
                intent.getLongExtra(EXTRA_SCHEDULED_AT_MS, 0L),
                intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty(),
                intent.getBooleanExtra(EXTRA_VIBRATION, true),
                intent.getIntExtra(EXTRA_SNOOZE_DURATION, 5),
                intent.getBooleanExtra(EXTRA_ADAPTIVE_ROTATION, true),
                intent.getBooleanExtra(EXTRA_INCREASING_VOLUME, false),
                intent.getIntExtra(EXTRA_SNOOZE_COUNT, 0),
                intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
                intent.getIntExtra(EXTRA_INITIAL_VOLUME, 100),
                intent.getIntExtra(EXTRA_MAX_VOLUME, 100),
                intent.getIntExtra(EXTRA_VOLUME_STEP, 10),
                intent.getIntExtra(EXTRA_VOLUME_INTERVAL, 5),
                intent.getStringExtra(EXTRA_VIBRATION_PATTERN).orEmpty().ifBlank { "standard" },
            ),
        )
        finishAndRemoveTask()
    }

    private fun dismissAlarm() {
        // Product policy: retain audible enforcement, but freeze the volume
        // ramp once the user begins dismissal/mission interaction.
        startService(Intent(this, AlarmPlaybackService::class.java).apply {
            action = AlarmPlaybackService.ACTION_PAUSE_ESCALATION
        })
        try {
            RuntimeEventStore(this).append(
                sessionId = intent.getStringExtra(EXTRA_SESSION_ID).orEmpty(),
                alarmId = intent.getStringExtra(EXTRA_ALARM_ID).orEmpty(),
                eventType = "DISMISS_REQUESTED",
                occurredAtMs = System.currentTimeMillis(),
                scheduledAtMs = intent.getLongExtra(EXTRA_SCHEDULED_AT_MS, 0L),
                ringtoneUri = intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty(),
            )
        } catch (_: Exception) {
            // A failed evidence write cannot trap the user on the alarm screen.
        }
        startActivity(Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(MainActivity.EXTRA_WAKE_MISSION, true)
            putExtra(EXTRA_ALARM_ID, intent.getStringExtra(EXTRA_ALARM_ID).orEmpty())
            putExtra(EXTRA_SESSION_ID, intent.getStringExtra(EXTRA_SESSION_ID).orEmpty())
            putExtra(EXTRA_SCHEDULED_AT_MS, intent.getLongExtra(EXTRA_SCHEDULED_AT_MS, 0L))
            putExtra(EXTRA_RINGTONE_URI, intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty())
        })
        finish()
    }

    private fun text(value: String, size: Float, color: Int) = TextView(this).apply {
        text = value
        textSize = size
        setTextColor(color)
        gravity = Gravity.CENTER
        typeface = Typeface.create(Typeface.MONOSPACE, Typeface.NORMAL)
    }

    private fun spacer(height: Int) = TextView(this).apply {
        layoutParams = LinearLayout.LayoutParams(1, dp(height))
    }

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()

    companion object {
        private const val EXTRA_ALARM_ID = "alarm_id"
        private const val EXTRA_LABEL = "label"
        private const val EXTRA_SESSION_ID = "session_id"
        private const val EXTRA_SCHEDULED_AT_MS = "scheduled_at_ms"
        private const val EXTRA_RINGTONE_URI = "ringtone_uri"
        private const val EXTRA_VIBRATION = "vibration"
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

        fun createIntent(
            context: Context,
            alarmId: String,
            label: String,
            sessionId: String = "",
            scheduledAtMs: Long = 0L,
            ringtoneUri: String = "",
            snoozeEnabled: Boolean = true,
            snoozeDuration: Int = 5,
            adaptiveRotation: Boolean = true,
            snoozeCount: Int = 0,
            increasingVolume: Boolean = false,
            vibrationEnabled: Boolean = true,
            protocolId: String = "",
            protocolVersion: Long = 0,
            protocolSnapshotJson: String = "{}",
            initialVolumePercent: Int = 100,
            maxVolumePercent: Int = 100,
            volumeEscalationStepPercent: Int = 10,
            volumeEscalationIntervalSeconds: Int = 5,
            vibrationPattern: String = "standard",
        ): Intent =
            Intent(context, AlarmRingingActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                putExtra(EXTRA_ALARM_ID, alarmId)
                putExtra(EXTRA_LABEL, label)
                putExtra(EXTRA_SESSION_ID, sessionId)
                putExtra(EXTRA_SCHEDULED_AT_MS, scheduledAtMs)
                putExtra(EXTRA_RINGTONE_URI, ringtoneUri)
                putExtra(EXTRA_SNOOZE_ENABLED, snoozeEnabled)
                putExtra(EXTRA_SNOOZE_DURATION, snoozeDuration)
                putExtra(EXTRA_ADAPTIVE_ROTATION, adaptiveRotation)
                putExtra(EXTRA_INCREASING_VOLUME, increasingVolume)
                putExtra(EXTRA_SNOOZE_COUNT, snoozeCount)
                putExtra(EXTRA_VIBRATION, vibrationEnabled)
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
