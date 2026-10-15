package com.ryser.ryser.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.ryser.ryser.scheduling.AlarmScheduler

class AlarmRecoveryReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_LOCKED_BOOT_COMPLETED) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            !context.getSystemService(android.app.AlarmManager::class.java).canScheduleExactAlarms()
        ) return
        AlarmScheduler(context).recoverAll()
    }
}
