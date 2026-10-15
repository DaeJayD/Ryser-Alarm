package com.ryser.ryser.runtime

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.ryser.ryser.bridge.RuntimeEventDto
import java.util.UUID

class RuntimeEventStore(context: Context) :
    SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(
            """CREATE TABLE runtime_events (
                id TEXT PRIMARY KEY,
                session_id TEXT NOT NULL,
                alarm_id TEXT NOT NULL,
                event_type TEXT NOT NULL,
                occurred_at_ms INTEGER NOT NULL,
                scheduled_at_ms INTEGER NOT NULL,
                ringtone_uri TEXT NOT NULL
                ,metadata_json TEXT NOT NULL DEFAULT '{}'
                ,protocol_id TEXT NOT NULL DEFAULT ''
                ,protocol_version INTEGER NOT NULL DEFAULT 0
                ,protocol_snapshot_json TEXT NOT NULL DEFAULT '{}'
            )""".trimIndent(),
        )
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE runtime_events ADD COLUMN metadata_json TEXT NOT NULL DEFAULT '{}'")
            db.execSQL("ALTER TABLE runtime_events ADD COLUMN protocol_id TEXT NOT NULL DEFAULT ''")
            db.execSQL("ALTER TABLE runtime_events ADD COLUMN protocol_version INTEGER NOT NULL DEFAULT 0")
            db.execSQL("ALTER TABLE runtime_events ADD COLUMN protocol_snapshot_json TEXT NOT NULL DEFAULT '{}'")
        }
    }

    fun append(
        sessionId: String,
        alarmId: String,
        eventType: String,
        occurredAtMs: Long,
        scheduledAtMs: Long,
        ringtoneUri: String,
        metadataJson: String = "{}",
        protocolId: String = "",
        protocolVersion: Long = 0,
        protocolSnapshotJson: String = "{}",
    ) {
        writableDatabase.insertOrThrow(
            "runtime_events",
            null,
            ContentValues().apply {
                put("id", UUID.randomUUID().toString())
                put("session_id", sessionId)
                put("alarm_id", alarmId)
                put("event_type", eventType)
                put("occurred_at_ms", occurredAtMs)
                put("scheduled_at_ms", scheduledAtMs)
                put("ringtone_uri", ringtoneUri)
                put("metadata_json", metadataJson)
                put("protocol_id", protocolId)
                put("protocol_version", protocolVersion)
                put("protocol_snapshot_json", protocolSnapshotJson)
            },
        )
    }

    fun getPending(): List<RuntimeEventDto> = readableDatabase.run {
            val events = mutableListOf<RuntimeEventDto>()
            query(
                "runtime_events",
                null,
                null,
                null,
                null,
                null,
                "occurred_at_ms ASC, rowid ASC",
            ).use { cursor ->
                while (cursor.moveToNext()) {
                    events += RuntimeEventDto(
                        id = cursor.getString(cursor.getColumnIndexOrThrow("id")),
                        sessionId = cursor.getString(cursor.getColumnIndexOrThrow("session_id")),
                        alarmId = cursor.getString(cursor.getColumnIndexOrThrow("alarm_id")),
                        eventType = cursor.getString(cursor.getColumnIndexOrThrow("event_type")),
                        occurredAtMs = cursor.getLong(cursor.getColumnIndexOrThrow("occurred_at_ms")),
                        scheduledAtMs = cursor.getLong(cursor.getColumnIndexOrThrow("scheduled_at_ms")),
                        ringtoneUri = cursor.getString(cursor.getColumnIndexOrThrow("ringtone_uri")),
                        metadataJson = cursor.getString(cursor.getColumnIndexOrThrow("metadata_json")),
                        protocolId = cursor.getString(cursor.getColumnIndexOrThrow("protocol_id")),
                        protocolVersion = cursor.getLong(cursor.getColumnIndexOrThrow("protocol_version")),
                        protocolSnapshotJson = cursor.getString(cursor.getColumnIndexOrThrow("protocol_snapshot_json")),
                    )
                }
            }
            events
    }

    fun acknowledge(eventIds: List<String>) {
        if (eventIds.isEmpty()) return
        writableDatabase.beginTransaction()
        try {
            eventIds.forEach { id ->
                writableDatabase.delete("runtime_events", "id = ?", arrayOf(id))
            }
            writableDatabase.setTransactionSuccessful()
        } finally {
            writableDatabase.endTransaction()
        }
    }

    companion object {
        private const val DATABASE_NAME = "alarm_runtime.db"
        private const val DATABASE_VERSION = 2
        const val EVENT_TRIGGERED = "ALARM_TRIGGERED"
        const val EVENT_DISMISSED = "ALARM_DISMISSED"
        const val EVENT_SNOOZED = "SNOOZED"
        const val EVENT_SOUND_CHANGED = "SOUND_CHANGED"
    }
}
