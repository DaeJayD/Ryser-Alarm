package com.ryser.ryser.runtime

import android.content.Context
import android.media.RingtoneManager

class SoundRotationSelector(private val context: Context) {
    fun select(alarmId: String, currentUri: String): String {
        val manager = RingtoneManager(context).apply { setType(RingtoneManager.TYPE_ALARM) }
        val available = buildList {
            val cursor = manager.cursor
            var position = 0
            while (cursor.moveToNext()) {
                manager.getRingtoneUri(position)?.toString()?.let(::add)
                position++
            }
        }.distinct().sorted()
        if (available.isEmpty()) return currentUri
        if (available.size == 1) return available.first()

        val recent = ScheduleStore(context).recentSoundUris(alarmId)
        val counts = recent.groupingBy { it }.eachCount()
        val recentRank = recent.withIndex().associate { it.value to it.index }
        return available
            .asSequence()
            .filter { it != currentUri }
            .sortedWith(
                compareBy<String> { counts[it] ?: 0 }
                    .thenByDescending { recentRank[it] ?: Int.MAX_VALUE }
                    .thenBy { it },
            )
            .firstOrNull() ?: currentUri
    }
}
