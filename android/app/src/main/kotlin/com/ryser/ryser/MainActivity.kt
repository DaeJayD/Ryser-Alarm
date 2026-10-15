package com.ryser.ryser

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.Manifest
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.core.content.ContextCompat
import com.ryser.ryser.bridge.AlarmRuntimeApi
import com.ryser.ryser.bridge.AlarmRuntimeApiImpl
import com.ryser.ryser.service.AlarmPlaybackService
import com.ryser.ryser.wakecheck.WakeCheckScheduler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.coroutines.Continuation
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class MainActivity : FlutterActivity() {
    private var audioPickerContinuation: Continuation<Uri?>? = null
    private var pendingWakeMission: Map<String, Any?>? = null

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        captureWakeMission(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        captureWakeMission(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AlarmRuntimeApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            AlarmRuntimeApiImpl(this),
        )
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WAKE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "takePendingMission" -> {
                        result.success(pendingWakeMission)
                        pendingWakeMission = null
                    }
                    "completeDismiss" -> {
                        val arguments = call.arguments as? Map<*, *>
                        startService(
                            AlarmPlaybackService.createDismissIntent(
                                this,
                                arguments?.get("alarmId") as? String ?: "",
                                arguments?.get("sessionId") as? String ?: "",
                                (arguments?.get("scheduledAtMs") as? Number)?.toLong() ?: 0L,
                                arguments?.get("ringtoneUri") as? String ?: "",
                            ),
                        )
                        result.success(null)
                    }
                    "scheduleWakeCheck" -> {
                        val arguments = call.arguments as? Map<*, *>
                        WakeCheckScheduler(applicationContext).schedule(
                            arguments?.get("alarmId") as? String ?: "",
                            arguments?.get("sessionId") as? String ?: "",
                            (arguments?.get("triggerAtMs") as? Number)?.toLong() ?: 0L,
                            (arguments?.get("scheduledAtMs") as? Number)?.toLong() ?: 0L,
                            arguments?.get("ringtoneUri") as? String ?: "",
                            arguments?.get("protocolId") as? String ?: "",
                            (arguments?.get("protocolVersion") as? Number)?.toLong() ?: 0L,
                            arguments?.get("protocolSnapshotJson") as? String ?: "{}",
                        )
                        result.success(null)
                    }
                    "getMissionHealth" -> {
                        val sensors = getSystemService(SensorManager::class.java)
                        result.success(
                            mapOf(
                                "cameraAvailable" to packageManager.hasSystemFeature(
                                    PackageManager.FEATURE_CAMERA_ANY,
                                ),
                                "cameraPermission" to (
                                    ContextCompat.checkSelfPermission(
                                        this,
                                        Manifest.permission.CAMERA,
                                    ) == PackageManager.PERMISSION_GRANTED
                                ),
                                "stepSensorAvailable" to (
                                    sensors.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) != null ||
                                        sensors.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR) != null
                                ),
                                "activityPermission" to (
                                    android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.Q ||
                                        ContextCompat.checkSelfPermission(
                                            this,
                                            Manifest.permission.ACTIVITY_RECOGNITION,
                                        ) == PackageManager.PERMISSION_GRANTED
                                ),
                            ),
                        )
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun captureWakeMission(intent: Intent?) {
        if (intent?.getBooleanExtra(EXTRA_WAKE_MISSION, false) != true) return
        pendingWakeMission = mapOf(
            "alarmId" to intent.getStringExtra("alarm_id").orEmpty(),
            "sessionId" to intent.getStringExtra("session_id").orEmpty(),
            "scheduledAtMs" to intent.getLongExtra("scheduled_at_ms", 0L),
            "ringtoneUri" to intent.getStringExtra("ringtone_uri").orEmpty(),
        )
    }

    suspend fun pickAudioFile(): Uri? = suspendCoroutine { continuation ->
        audioPickerContinuation?.resume(null)
        audioPickerContinuation = continuation
        startActivityForResult(
            Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                addCategory(Intent.CATEGORY_OPENABLE)
                type = "audio/*"
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            },
            AUDIO_PICK_REQUEST,
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != AUDIO_PICK_REQUEST) return
        val uri = if (resultCode == Activity.RESULT_OK) data?.data else null
        if (uri != null) {
            try {
                contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } catch (_: SecurityException) {
                // Some document providers grant access without supporting persistence.
            }
        }
        audioPickerContinuation?.resume(uri)
        audioPickerContinuation = null
    }

    companion object {
        private const val AUDIO_PICK_REQUEST = 4703
        const val WAKE_CHANNEL = "ryser/wake_enforcement"
        const val EXTRA_WAKE_MISSION = "wake_mission"
    }
}
