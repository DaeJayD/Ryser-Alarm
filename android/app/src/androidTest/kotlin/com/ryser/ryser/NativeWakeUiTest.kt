package com.ryser.ryser

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.test.platform.app.InstrumentationRegistry
import com.ryser.ryser.alarm.AlarmRingingActivity
import com.ryser.ryser.wakecheck.WakeCheckActivity
import org.junit.After
import org.junit.Assert.*
import org.junit.Test
import java.io.File

/** UI-only cold starts. Does not claim audio, sensor, or physical-device proof. */
class NativeWakeUiTest {
    private val instrumentation = InstrumentationRegistry.getInstrumentation()
    private val context get() = instrumentation.targetContext
    private var activity: Activity? = null

    @After fun close() {
        instrumentation.runOnMainSync { activity?.finish() }
        instrumentation.waitForIdleSync()
    }

    private fun texts(view: View): List<TextView> = when (view) {
        is TextView -> listOf(view)
        is ViewGroup -> (0 until view.childCount).flatMap { texts(view.getChildAt(it)) }
        else -> emptyList()
    }

    private fun start(intent: Intent): Activity {
        val started = instrumentation.startActivitySync(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        activity = started
        instrumentation.waitForIdleSync()
        return started
    }

    private fun capture(name: String) {
        val output = File(context.getExternalFilesDir(null), "ui-smoke").apply { mkdirs() }
        val bitmap = requireNotNull(instrumentation.uiAutomation.takeScreenshot())
        File(output, "$name.png").outputStream().use {
            assertTrue(bitmap.compress(Bitmap.CompressFormat.PNG, 100, it))
        }
        bitmap.recycle()
    }

    @Test fun ringingColdStartHasCurrentVersionAndUsableControls() {
        val screen = start(AlarmRingingActivity.createIntent(context, "ui-smoke", "Morning alarm"))
        instrumentation.runOnMainSync {
            val labels = texts(screen.window.decorView)
            val version = context.packageManager.getPackageInfo(context.packageName, 0).versionName
            assertTrue(labels.any { it.text.toString() == "RYSER · $version" })
            assertTrue(labels.any { it.text.toString() == "Morning alarm" })
            val button = labels.filterIsInstance<Button>().first { it.text.toString() == "I'm up · Continue" }
            assertTrue(button.width > 0)
            assertTrue(button.height >= (48 * context.resources.displayMetrics.density).toInt())
            button.requestRectangleOnScreen(android.graphics.Rect(0, 0, button.width, button.height), true)
        }
        instrumentation.waitForIdleSync()
        capture("ringing")
    }

    @Test fun reusedRingingActivityReceivesTheNewAlarmSession() {
        val screen = start(AlarmRingingActivity.createIntent(context, "first", "First alarm", "session-first"))
        instrumentation.runOnMainSync {
            screen.startActivity(AlarmRingingActivity.createIntent(context, "second", "Second alarm", "session-second"))
        }
        val deadline = System.currentTimeMillis() + 5000
        while (System.currentTimeMillis() < deadline) {
            var updated = false
            instrumentation.runOnMainSync { updated = screen.intent.getStringExtra("session_id") == "session-second" }
            if (updated) break
            Thread.sleep(50)
        }
        instrumentation.waitForIdleSync()
        instrumentation.runOnMainSync {
            assertEquals("session-second", screen.intent.getStringExtra("session_id"))
            assertTrue(texts(screen.window.decorView).any { it.text.toString() == "Second alarm" })
            assertFalse(texts(screen.window.decorView).any { it.text.toString() == "First alarm" })
        }
    }

    @Test fun wakeCheckColdStartShowsTheSavedHoldTime() {
        val screen = start(WakeCheckActivity.createIntent(
            context, "ui-smoke", "ui-smoke-check", System.currentTimeMillis(),
            System.currentTimeMillis(), "", "ui-smoke", 1,
            "{\"wakeCheckHoldMilliseconds\":3500,\"maxWakeCheckFailures\":2}",
        ))
        instrumentation.runOnMainSync {
            val labels = texts(screen.window.decorView)
            assertTrue(labels.any { it.text.toString().contains("3.5 seconds") })
            assertTrue(labels.any { it.text.toString() == "Hold · I'm awake" })
        }
        capture("wake-check")
    }
}
