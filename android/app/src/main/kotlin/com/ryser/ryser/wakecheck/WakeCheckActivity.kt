package com.ryser.ryser.wakecheck

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.os.CountDownTimer
import android.view.Gravity
import android.view.MotionEvent
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.ryser.ryser.alarm.AlarmRingingActivity
import com.ryser.ryser.runtime.RuntimeEventStore
import com.ryser.ryser.service.AlarmPlaybackService
import com.ryser.ryser.runtime.SoundRotationSelector
import org.json.JSONObject

class WakeCheckActivity : Activity() {
    private var holdTimer: CountDownTimer? = null
    private var responseTimer: CountDownTimer? = null
    private var responseDeadlineAtMs: Long = 0L
    private var resolved = false
    private val sessionProtocol: JSONObject
        get() = try { JSONObject(intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT) ?: "{}") }
            catch (_: Exception) { JSONObject() }
    private val holdMilliseconds: Long
        get() = WakeCheckExecutionSettings.from(
            sessionProtocol.optLong("wakeCheckHoldMilliseconds", 2000L),
            sessionProtocol.optInt("maxWakeCheckFailures", 2),
        ).holdMilliseconds

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setShowWhenLocked(true)
        setTurnScreenOn(true)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        responseDeadlineAtMs = savedInstanceState?.getLong(STATE_RESPONSE_DEADLINE)
            ?.takeIf { it > 0L }
            ?: (System.currentTimeMillis() + RESPONSE_TIMEOUT_MS)
        if (savedInstanceState == null) record("WAKE_CHECK_TRIGGERED")
        setContentView(content())
        val remaining = (responseDeadlineAtMs - System.currentTimeMillis()).coerceAtLeast(1L)
        responseTimer = object : CountDownTimer(remaining, 1_000L) {
            override fun onTick(remaining: Long) = Unit
            override fun onFinish() = failAndReactivate("WAKE_CHECK_MISSED")
        }.start()
    }

    override fun onDestroy() {
        holdTimer?.cancel()
        responseTimer?.cancel()
        super.onDestroy()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        outState.putLong(STATE_RESPONSE_DEADLINE, responseDeadlineAtMs)
        super.onSaveInstanceState(outState)
    }

    @Deprecated("Back is treated as a failed Wake Check")
    override fun onBackPressed() {
        failAndReactivate("WAKE_CHECK_FAILED")
    }

    private fun content() = LinearLayout(this).apply {
        orientation = LinearLayout.VERTICAL
        gravity = Gravity.CENTER
        setPadding(dp(28), dp(48), dp(28), dp(48))
        setBackgroundColor(Color.BLACK)
        addView(TextView(this@WakeCheckActivity).apply {
            text = "STILL AWAKE?"
            textSize = 34f
            gravity = Gravity.CENTER
            setTextColor(Color.rgb(0, 255, 65))
        })
        addView(TextView(this@WakeCheckActivity).apply {
            text = "Hold for ${holdMilliseconds / 1000.0} seconds to confirm"
            textSize = 17f
            gravity = Gravity.CENTER
            setTextColor(Color.rgb(232, 255, 232))
        })
        addView(Button(this@WakeCheckActivity).apply {
            text = "I'M UP"
            textSize = 24f
            setTextColor(Color.BLACK)
            setBackgroundColor(Color.rgb(0, 255, 65))
            setOnTouchListener { _, event ->
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> beginHold()
                    MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> holdTimer?.cancel()
                }
                true
            }
        }, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(88)).apply {
            topMargin = dp(64)
        })
    }

    private fun beginHold() {
        record("WAKE_CHECK_INTERACTION")
        holdTimer?.cancel()
        holdTimer = object : CountDownTimer(holdMilliseconds, 50L) {
            override fun onTick(remaining: Long) = Unit
            override fun onFinish() {
                if (resolved) return
                resolved = true
                responseTimer?.cancel()
                record("WAKE_CHECK_PASSED")
                finishAndRemoveTask()
            }
        }.start()
    }

    private fun failAndReactivate(eventType: String) {
        if (resolved) return
        resolved = true
        holdTimer?.cancel()
        responseTimer?.cancel()
        record(eventType)
        record("ALARM_REACTIVATED")
        val alarmId = intent.getStringExtra(EXTRA_ALARM_ID).orEmpty()
        val sessionId = intent.getStringExtra(EXTRA_SESSION_ID).orEmpty()
        val ringtoneUri = intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty()
        val snapshotJson = intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" }
        val snapshot = try { JSONObject(snapshotJson) } catch (_: Exception) { JSONObject() }
        val rotateSound = snapshot.optString("reactivationSoundPolicy", "alternateSound") != "keep"
        val nextRingtoneUri = if (snapshot.optString("reactivationSoundPolicy") == "alternateFamily") {
            val currentFamily = snapshot.optString("soundFamily")
            val resource = WakeCheckExecutionSettings.alternateFamilyResource(currentFamily)
            "android.resource://$packageName/raw/$resource"
        } else if (rotateSound) {
            SoundRotationSelector(this).select(alarmId, ringtoneUri)
        } else ringtoneUri
        if (nextRingtoneUri != ringtoneUri) record("SOUND_CHANGED", nextRingtoneUri)
        val scheduledAtMs = intent.getLongExtra(EXTRA_ORIGINAL_SCHEDULED_AT, 0L)
        ContextCompat.startForegroundService(
            this,
            AlarmPlaybackService.createStartIntent(
                this, alarmId, "WAKE CHECK FAILED", nextRingtoneUri,
                snapshot.optBoolean("vibrationEnabled", true), sessionId,
                scheduledAtMs, false, 5, rotateSound,
                snapshot.optBoolean("volumeEscalationEnabled", false), 0,
                protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                protocolSnapshotJson = snapshotJson,
                initialVolumePercent = snapshot.optInt("initialVolumePercent", 100),
                maxVolumePercent = snapshot.optInt("maxVolumePercent", 100),
                volumeEscalationStepPercent = snapshot.optInt("volumeEscalationStepPercent", 10),
                volumeEscalationIntervalSeconds = snapshot.optInt("volumeEscalationIntervalSeconds", 5),
                vibrationPattern = snapshot.optString("vibrationPattern", "standard"),
            ),
        )
        startActivity(
            AlarmRingingActivity.createIntent(
                this, alarmId, "WAKE CHECK FAILED", sessionId, scheduledAtMs,
                nextRingtoneUri, false, 5, rotateSound, 0,
                increasingVolume = snapshot.optBoolean("volumeEscalationEnabled", false),
                vibrationEnabled = snapshot.optBoolean("vibrationEnabled", true),
                protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
                protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
                protocolSnapshotJson = snapshotJson,
                initialVolumePercent = snapshot.optInt("initialVolumePercent", 100),
                maxVolumePercent = snapshot.optInt("maxVolumePercent", 100),
                volumeEscalationStepPercent = snapshot.optInt("volumeEscalationStepPercent", 10),
                volumeEscalationIntervalSeconds = snapshot.optInt("volumeEscalationIntervalSeconds", 5),
                vibrationPattern = snapshot.optString("vibrationPattern", "standard"),
            ),
        )
        finishAndRemoveTask()
    }

    private fun record(type: String, ringtoneUri: String? = null) {
        RuntimeEventStore(this).append(
            intent.getStringExtra(EXTRA_SESSION_ID).orEmpty(),
            intent.getStringExtra(EXTRA_ALARM_ID).orEmpty(),
            type,
            System.currentTimeMillis(),
            intent.getLongExtra(EXTRA_WAKE_CHECK_AT, 0L),
            ringtoneUri ?: intent.getStringExtra(EXTRA_RINGTONE_URI).orEmpty(),
            protocolId = intent.getStringExtra(EXTRA_PROTOCOL_ID).orEmpty(),
            protocolVersion = intent.getLongExtra(EXTRA_PROTOCOL_VERSION, 0L),
            protocolSnapshotJson = intent.getStringExtra(EXTRA_PROTOCOL_SNAPSHOT).orEmpty().ifBlank { "{}" },
        )
    }

    private fun dp(value: Int) = (value * resources.displayMetrics.density).toInt()

    companion object {
        private const val RESPONSE_TIMEOUT_MS = 60_000L
        private const val STATE_RESPONSE_DEADLINE = "response_deadline_at_ms"
        private const val EXTRA_ALARM_ID = "alarm_id"
        private const val EXTRA_SESSION_ID = "session_id"
        private const val EXTRA_WAKE_CHECK_AT = "wake_check_at"
        private const val EXTRA_ORIGINAL_SCHEDULED_AT = "scheduled_at_ms"
        private const val EXTRA_RINGTONE_URI = "ringtone_uri"
        private const val EXTRA_PROTOCOL_ID = "protocol_id"
        private const val EXTRA_PROTOCOL_VERSION = "protocol_version"
        private const val EXTRA_PROTOCOL_SNAPSHOT = "protocol_snapshot"

        fun createIntent(
            context: Context,
            alarmId: String,
            sessionId: String,
            wakeCheckAtMs: Long,
            scheduledAtMs: Long,
            ringtoneUri: String,
            protocolId: String,
            protocolVersion: Long,
            protocolSnapshotJson: String,
        ) = Intent(context, WakeCheckActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(EXTRA_ALARM_ID, alarmId)
            putExtra(EXTRA_SESSION_ID, sessionId)
            putExtra(EXTRA_WAKE_CHECK_AT, wakeCheckAtMs)
            putExtra(EXTRA_ORIGINAL_SCHEDULED_AT, scheduledAtMs)
            putExtra(EXTRA_RINGTONE_URI, ringtoneUri)
            putExtra(EXTRA_PROTOCOL_ID, protocolId)
            putExtra(EXTRA_PROTOCOL_VERSION, protocolVersion)
            putExtra(EXTRA_PROTOCOL_SNAPSHOT, protocolSnapshotJson)
        }
    }
}
