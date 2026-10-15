package com.ryser.ryser.wakecheck

/** Pure, bounded session settings, also exercised without an Android process. */
data class WakeCheckExecutionSettings(val holdMilliseconds: Long, val maximumFailures: Int) {
    companion object {
        fun from(hold: Long, failures: Int) = WakeCheckExecutionSettings(
            if (hold in 1500L..4000L) hold else 2000L,
            if (failures in 1..3) failures else 2,
        )

        fun alternateFamilyResource(family: String) = when (family) {
            "PULSE" -> "melodic_a"
            "MELODIC" -> "urgent_a"
            else -> "pulse_a"
        }
    }
}
