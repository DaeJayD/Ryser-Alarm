package com.ryser.ryser.runtime

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.ryser.ryser.bridge.AlarmScheduleDto

class ScheduleStore(context: Context, databaseName: String = DATABASE_NAME) :
    SQLiteOpenHelper(context, databaseName, null, DATABASE_VERSION) {

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("""CREATE TABLE schedules (
            alarm_id TEXT PRIMARY KEY,
            trigger_at_ms INTEGER NOT NULL,
            label TEXT NOT NULL,
            ringtone_uri TEXT NOT NULL,
            vibration_enabled INTEGER NOT NULL,
            snooze_enabled INTEGER NOT NULL,
            snooze_duration_minutes INTEGER NOT NULL,
            adaptive_sound_rotation INTEGER NOT NULL,
            increasing_volume INTEGER NOT NULL DEFAULT 0,
            protocol_id TEXT NOT NULL DEFAULT '',
            protocol_version INTEGER NOT NULL DEFAULT 0,
            protocol_snapshot_json TEXT NOT NULL DEFAULT '{}',
            initial_volume_percent INTEGER NOT NULL DEFAULT 100,
            max_volume_percent INTEGER NOT NULL DEFAULT 100,
            volume_escalation_step_percent INTEGER NOT NULL DEFAULT 10,
            volume_escalation_interval_seconds INTEGER NOT NULL DEFAULT 5,
            vibration_pattern TEXT NOT NULL DEFAULT 'standard',
            local_hour INTEGER NOT NULL,
            local_minute INTEGER NOT NULL,
            recurrence_type TEXT NOT NULL,
            repeat_days_mask INTEGER NOT NULL
            ,experiment_json TEXT NOT NULL DEFAULT ''
            ,stable_protocol_snapshot_json TEXT
        )""".trimIndent())
        createSoundUsageTable(db)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) createSoundUsageTable(db)
        if (oldVersion < 3) db.execSQL("ALTER TABLE schedules ADD COLUMN increasing_volume INTEGER NOT NULL DEFAULT 0")
        if (oldVersion < 4) {
            db.execSQL("ALTER TABLE schedules ADD COLUMN protocol_id TEXT NOT NULL DEFAULT ''")
            db.execSQL("ALTER TABLE schedules ADD COLUMN protocol_version INTEGER NOT NULL DEFAULT 0")
            db.execSQL("ALTER TABLE schedules ADD COLUMN protocol_snapshot_json TEXT NOT NULL DEFAULT '{}'")
            db.execSQL("ALTER TABLE schedules ADD COLUMN initial_volume_percent INTEGER NOT NULL DEFAULT 100")
            db.execSQL("ALTER TABLE schedules ADD COLUMN max_volume_percent INTEGER NOT NULL DEFAULT 100")
            db.execSQL("ALTER TABLE schedules ADD COLUMN volume_escalation_step_percent INTEGER NOT NULL DEFAULT 10")
            db.execSQL("ALTER TABLE schedules ADD COLUMN volume_escalation_interval_seconds INTEGER NOT NULL DEFAULT 5")
            db.execSQL("ALTER TABLE schedules ADD COLUMN vibration_pattern TEXT NOT NULL DEFAULT 'standard'")
        }
        if (oldVersion < 5) {
            db.execSQL("ALTER TABLE schedules ADD COLUMN experiment_json TEXT NOT NULL DEFAULT ''")
            db.execSQL("ALTER TABLE schedules ADD COLUMN stable_protocol_snapshot_json TEXT")
        }
    }

    private fun createSoundUsageTable(db: SQLiteDatabase) {
        db.execSQL("""CREATE TABLE IF NOT EXISTS sound_usage (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            alarm_id TEXT NOT NULL,
            ringtone_uri TEXT NOT NULL,
            used_at_ms INTEGER NOT NULL
        )""".trimIndent())
        db.execSQL(
            "CREATE INDEX IF NOT EXISTS sound_usage_alarm_time " +
                "ON sound_usage(alarm_id, used_at_ms DESC)",
        )
    }

    fun recordSoundUse(alarmId: String, ringtoneUri: String, usedAtMs: Long) {
        writableDatabase.insert("sound_usage", null, ContentValues().apply {
            put("alarm_id", alarmId)
            put("ringtone_uri", ringtoneUri)
            put("used_at_ms", usedAtMs)
        })
        writableDatabase.delete(
            "sound_usage",
            "id NOT IN (SELECT id FROM sound_usage WHERE alarm_id = ? ORDER BY used_at_ms DESC LIMIT 30) AND alarm_id = ?",
            arrayOf(alarmId, alarmId),
        )
    }

    fun recentSoundUris(alarmId: String, limit: Int = 10): List<String> =
        readableDatabase.query(
            "sound_usage", arrayOf("ringtone_uri"), "alarm_id = ?",
            arrayOf(alarmId), null, null, "used_at_ms DESC", limit.toString(),
        ).use { cursor ->
            buildList { while (cursor.moveToNext()) add(cursor.getString(0)) }
        }

    fun upsert(schedule: AlarmScheduleDto) {
        writableDatabase.insertWithOnConflict(
            "schedules", null, values(schedule), SQLiteDatabase.CONFLICT_REPLACE,
        )
    }

    fun delete(alarmId: String) {
        writableDatabase.delete("schedules", "alarm_id = ?", arrayOf(alarmId))
    }

    fun get(alarmId: String): AlarmScheduleDto? = readableDatabase.query(
        "schedules", null, "alarm_id = ?", arrayOf(alarmId), null, null, null,
    ).use { cursor -> if (cursor.moveToFirst()) fromCursor(cursor) else null }

    fun all(): List<AlarmScheduleDto> = readableDatabase.query(
        "schedules", null, null, null, null, null, "alarm_id ASC",
    ).use { cursor ->
        buildList { while (cursor.moveToNext()) add(fromCursor(cursor)) }
    }

    private fun values(schedule: AlarmScheduleDto) = ContentValues().apply {
        put("alarm_id", schedule.alarmId)
        put("trigger_at_ms", schedule.triggerAtMs)
        put("label", schedule.label)
        put("ringtone_uri", schedule.ringtoneUri)
        put("vibration_enabled", schedule.vibrationEnabled)
        put("snooze_enabled", schedule.snoozeEnabled)
        put("snooze_duration_minutes", schedule.snoozeDurationMinutes)
        put("adaptive_sound_rotation", schedule.adaptiveSoundRotation)
        put("increasing_volume", schedule.increasingVolume)
        put("protocol_id", schedule.protocolId)
        put("protocol_version", schedule.protocolVersion)
        put("protocol_snapshot_json", schedule.protocolSnapshotJson)
        put("initial_volume_percent", schedule.initialVolumePercent)
        put("max_volume_percent", schedule.maxVolumePercent)
        put("volume_escalation_step_percent", schedule.volumeEscalationStepPercent)
        put("volume_escalation_interval_seconds", schedule.volumeEscalationIntervalSeconds)
        put("vibration_pattern", schedule.vibrationPattern)
        put("local_hour", schedule.localHour)
        put("local_minute", schedule.localMinute)
        put("recurrence_type", schedule.recurrenceType)
        put("repeat_days_mask", schedule.repeatDaysMask)
        put("experiment_json", ExperimentAssignmentCodec.encode(schedule.experiment))
        put("stable_protocol_snapshot_json", schedule.stableProtocolSnapshotJson)
    }

    private fun fromCursor(cursor: android.database.Cursor) = AlarmScheduleDto(
        alarmId = cursor.getString(cursor.getColumnIndexOrThrow("alarm_id")),
        triggerAtMs = cursor.getLong(cursor.getColumnIndexOrThrow("trigger_at_ms")),
        label = cursor.getString(cursor.getColumnIndexOrThrow("label")),
        ringtoneUri = cursor.getString(cursor.getColumnIndexOrThrow("ringtone_uri")),
        vibrationEnabled = cursor.getInt(cursor.getColumnIndexOrThrow("vibration_enabled")) != 0,
        snoozeEnabled = cursor.getInt(cursor.getColumnIndexOrThrow("snooze_enabled")) != 0,
        snoozeDurationMinutes = cursor.getLong(cursor.getColumnIndexOrThrow("snooze_duration_minutes")),
        adaptiveSoundRotation = cursor.getInt(cursor.getColumnIndexOrThrow("adaptive_sound_rotation")) != 0,
        increasingVolume = cursor.getInt(cursor.getColumnIndexOrThrow("increasing_volume")) != 0,
        protocolId = cursor.getString(cursor.getColumnIndexOrThrow("protocol_id")),
        protocolVersion = cursor.getLong(cursor.getColumnIndexOrThrow("protocol_version")),
        protocolSnapshotJson = cursor.getString(cursor.getColumnIndexOrThrow("protocol_snapshot_json")),
        initialVolumePercent = cursor.getLong(cursor.getColumnIndexOrThrow("initial_volume_percent")),
        maxVolumePercent = cursor.getLong(cursor.getColumnIndexOrThrow("max_volume_percent")),
        volumeEscalationStepPercent = cursor.getLong(cursor.getColumnIndexOrThrow("volume_escalation_step_percent")),
        volumeEscalationIntervalSeconds = cursor.getLong(cursor.getColumnIndexOrThrow("volume_escalation_interval_seconds")),
        vibrationPattern = cursor.getString(cursor.getColumnIndexOrThrow("vibration_pattern")),
        sessionId = "",
        snoozeCount = 0,
        localHour = cursor.getLong(cursor.getColumnIndexOrThrow("local_hour")),
        localMinute = cursor.getLong(cursor.getColumnIndexOrThrow("local_minute")),
        recurrenceType = cursor.getString(cursor.getColumnIndexOrThrow("recurrence_type")),
        repeatDaysMask = cursor.getLong(cursor.getColumnIndexOrThrow("repeat_days_mask")),
        experiment = ExperimentAssignmentCodec.decode(cursor.getString(cursor.getColumnIndexOrThrow("experiment_json"))),
        stableProtocolSnapshotJson = cursor.getString(cursor.getColumnIndexOrThrow("stable_protocol_snapshot_json")),
    )

    companion object {
        private const val DATABASE_NAME = "alarm_schedules.db"
        private const val DATABASE_VERSION = 5
    }
}
