package com.ryser.ryser.alarm

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Typeface
import android.os.Bundle
import android.view.Gravity
import android.view.ViewGroup
import android.widget.LinearLayout
import com.ryser.ryser.service.AlarmPlaybackService
import com.ryser.ryser.MainActivity
import com.ryser.ryser.runtime.RuntimeEventStore
import android.widget.ScrollView
import android.widget.TextClock
import android.util.TypedValue
import androidx.core.widget.TextViewCompat
import com.ryser.ryser.ui.WakeScreenStyle

class AlarmRingingActivity : Activity() {
    private var actionTaken = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WakeScreenStyle(this).prepareWindow()
        setContentView(buildContent())
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // singleTask/SINGLE_TOP reuses this activity for subsequent alarms.
        // Refresh both the visible content and the session used by its buttons.
        setIntent(intent)
        actionTaken = false
        setContentView(buildContent())
    }

    private fun buildContent(): ScrollView {
        val style = WakeScreenStyle(this)
        val label = intent.getStringExtra(EXTRA_LABEL).orEmpty()
        return style.screen("Time to wake up") {
            addView(style.panel().apply {
                addView(TextClock(this@AlarmRingingActivity).apply {
                    format12Hour = "h:mm"
                    format24Hour = "HH:mm"
                    textSize = 72f
                    setTextColor(style.green)
                    typeface = Typeface.MONOSPACE
                    gravity = Gravity.CENTER
                    TextViewCompat.setAutoSizeTextTypeUniformWithConfiguration(this, 32, 72, 2, TypedValue.COMPLEX_UNIT_SP)
                }, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, style.dp(112)))
                addView(TextClock(this@AlarmRingingActivity).apply {
                    format12Hour = "a"
                    format24Hour = "'24-hour time'"
                    textSize = 16f
                    setTextColor(style.muted)
                    gravity = Gravity.CENTER
                })
                addView(style.space(24))
                addView(style.label(if (label == "WAKE CHECK FAILED") "Let's try waking up again" else label.ifBlank { "Your alarm" }, 26f))
                addView(style.space(12))
                addView(style.label(if (label == "WAKE CHECK FAILED")
                    "You missed the follow-up check. Finish your wake-up task to stop the alarm."
                    else "Your alarm is ringing. Start your wake-up routine when you are ready.", 16f, style.muted))
            }, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT))
            addView(style.space(24))
            if (intent.getBooleanExtra(EXTRA_SNOOZE_ENABLED, true)) {
                addView(style.button("Snooze ${intent.getIntExtra(EXTRA_SNOOZE_DURATION, 5)} minutes", false).apply {
                    setOnClickListener { if (!actionTaken) { actionTaken = true; snoozeAlarm() } }
                })
                addView(style.space(12))
            }
            addView(style.button("I'm up · Continue", true).apply {
                setOnClickListener { if (!actionTaken) { actionTaken = true; dismissAlarm() } }
            })
            addView(style.space(12))
            addView(style.label("If a wake-up task is set, it opens next. Otherwise, the alarm stops.", 14f, style.muted))
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
