package com.ryser.ryser

import android.database.sqlite.SQLiteDatabase
import androidx.test.platform.app.InstrumentationRegistry
import com.ryser.ryser.bridge.AlarmScheduleDto
import com.ryser.ryser.bridge.ExperimentAssignmentDto
import com.ryser.ryser.receivers.AlarmTriggerReceiver
import com.ryser.ryser.runtime.ExperimentAssignmentCodec
import com.ryser.ryser.runtime.RuntimeEventStore
import com.ryser.ryser.runtime.ScheduleStore
import com.ryser.ryser.scheduling.ExperimentOccurrencePolicy
import org.junit.After
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/** Isolated database names: never deletes or overwrites the user's alarm stores. */
class NativeExperimentStorageTest {
    private val context = InstrumentationRegistry.getInstrumentation().targetContext
    private val schedules = "ryser_test_experiment_schedules.db"
    private val events = "ryser_test_experiment_events.db"
    private val assignment = ExperimentAssignmentDto("experiment", "assignment", "candidate", "context", 5000, 1000)

    @Before fun setup() { context.deleteDatabase(schedules); context.deleteDatabase(events) }
    @After fun cleanup() { context.deleteDatabase(schedules); context.deleteDatabase(events) }

    private fun value() = AlarmScheduleDto(
        "alarm", 5000, "Morning", "content://candidate", true, true, 5,
        true, false, "candidate", 2, "{}", 50, 90, 10, 5,
        "standard", "", 0, 7, 0, "daily", 0, assignment, "{\"id\":\"control\"}",
    )

    @Test fun schedulesAndPendingEventsRetainAssignmentAfterReopen() {
        ScheduleStore(context, schedules).use { it.upsert(value()) }
        ScheduleStore(context, schedules).use {
            assertEquals(assignment, it.get("alarm")!!.experiment)
            assertEquals(value().stableProtocolSnapshotJson, it.get("alarm")!!.stableProtocolSnapshotJson)
        }
        RuntimeEventStore(context, events).use {
            it.append("wake", "alarm", "ALARM_TRIGGERED", 5001, 5000, "content://candidate",
                protocolId = "candidate", protocolVersion = 2, protocolSnapshotJson = "{}", experiment = assignment)
        }
        RuntimeEventStore(context, events).use { assertEquals(assignment, it.getPending().single().experiment) }
        val intent = AlarmTriggerReceiver.createIntent(context, value())
        assertEquals(assignment, ExperimentAssignmentCodec.decode(intent.getStringExtra("experiment_assignment")))
    }

    @Test fun v4SchedulesAndV2EventsUpgradeWithoutLosingRows() {
        context.getDatabasePath(schedules).parentFile!!.mkdirs()
        SQLiteDatabase.openOrCreateDatabase(context.getDatabasePath(schedules), null).use { db ->
            db.execSQL("""CREATE TABLE schedules (alarm_id TEXT PRIMARY KEY, trigger_at_ms INTEGER NOT NULL,
                label TEXT NOT NULL, ringtone_uri TEXT NOT NULL, vibration_enabled INTEGER NOT NULL,
                snooze_enabled INTEGER NOT NULL, snooze_duration_minutes INTEGER NOT NULL,
                adaptive_sound_rotation INTEGER NOT NULL, increasing_volume INTEGER NOT NULL DEFAULT 0,
                protocol_id TEXT NOT NULL DEFAULT '', protocol_version INTEGER NOT NULL DEFAULT 0,
                protocol_snapshot_json TEXT NOT NULL DEFAULT '{}', initial_volume_percent INTEGER NOT NULL DEFAULT 100,
                max_volume_percent INTEGER NOT NULL DEFAULT 100, volume_escalation_step_percent INTEGER NOT NULL DEFAULT 10,
                volume_escalation_interval_seconds INTEGER NOT NULL DEFAULT 5, vibration_pattern TEXT NOT NULL DEFAULT 'standard',
                local_hour INTEGER NOT NULL, local_minute INTEGER NOT NULL, recurrence_type TEXT NOT NULL, repeat_days_mask INTEGER NOT NULL)""")
            db.execSQL("CREATE TABLE sound_usage (id INTEGER PRIMARY KEY AUTOINCREMENT, alarm_id TEXT NOT NULL, ringtone_uri TEXT NOT NULL, used_at_ms INTEGER NOT NULL)")
            db.execSQL("INSERT INTO schedules (alarm_id,trigger_at_ms,label,ringtone_uri,vibration_enabled,snooze_enabled,snooze_duration_minutes,adaptive_sound_rotation,local_hour,local_minute,recurrence_type,repeat_days_mask) VALUES ('old',5000,'Keep','content://keep',1,1,5,1,7,0,'daily',0)")
            db.version = 4
        }
        ScheduleStore(context, schedules).use {
            val old = it.get("old")!!
            assertEquals("Keep", old.label)
            assertEquals("content://keep", old.ringtoneUri)
            assertNull(old.experiment)
            assertNull(old.stableProtocolSnapshotJson)
        }
        SQLiteDatabase.openOrCreateDatabase(context.getDatabasePath(events), null).use { db ->
            db.execSQL("""CREATE TABLE runtime_events (id TEXT PRIMARY KEY,session_id TEXT NOT NULL,
                alarm_id TEXT NOT NULL,event_type TEXT NOT NULL,occurred_at_ms INTEGER NOT NULL,
                scheduled_at_ms INTEGER NOT NULL,ringtone_uri TEXT NOT NULL,metadata_json TEXT NOT NULL DEFAULT '{}',
                protocol_id TEXT NOT NULL DEFAULT '',protocol_version INTEGER NOT NULL DEFAULT 0,
                protocol_snapshot_json TEXT NOT NULL DEFAULT '{}')""")
            db.execSQL("INSERT INTO runtime_events VALUES ('old','wake','old','ALARM_TRIGGERED',5001,5000,'content://keep','{}','control',1,'{}')")
            db.version = 2
        }
        RuntimeEventStore(context, events).use {
            assertEquals("old", it.getPending().single().id)
            assertNull(it.getPending().single().experiment)
        }
    }

    @Test fun corruptStableSnapshotFallsBackToBundledAudioWithinVolumeCap() {
        val restored = ExperimentAssignmentCodec.restoreStable(value().copy(stableProtocolSnapshotJson = "{broken"))
        assertTrue(restored.ringtoneUri.endsWith("/raw/pulse_a"))
        assertEquals(90L, restored.maxVolumePercent)
        assertEquals(50L, restored.initialVolumePercent)
        assertEquals("", restored.protocolId)
    }

    @Test fun laterOccurrenceRestoresAllStablePlaybackFieldsFromJson() {
        val snapshot = """{"id":"control","version":1,"ringtoneUri":"content://control",
            "initialVolumePercent":40,"maxVolumePercent":70,"volumeEscalationEnabled":true,
            "volumeEscalationStepPercent":5,"volumeEscalationIntervalSeconds":10,
            "vibrationEnabled":false,"vibrationPattern":"doublePulse"}"""
        val restored = ExperimentOccurrencePolicy.forOccurrence(value().copy(stableProtocolSnapshotJson = snapshot),
            9000, ExperimentAssignmentCodec::restoreStable)
        assertEquals("control", restored.protocolId)
        assertEquals(1L, restored.protocolVersion)
        assertEquals("content://control", restored.ringtoneUri)
        assertEquals(40L, restored.initialVolumePercent)
        assertEquals(70L, restored.maxVolumePercent)
        assertEquals(5L, restored.volumeEscalationStepPercent)
        assertEquals(10L, restored.volumeEscalationIntervalSeconds)
        assertTrue(restored.increasingVolume)
        assertFalse(restored.vibrationEnabled)
        assertEquals("doublePulse", restored.vibrationPattern)
        assertNull(restored.experiment)
    }
}
