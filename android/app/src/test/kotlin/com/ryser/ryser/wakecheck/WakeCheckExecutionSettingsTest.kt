package com.ryser.ryser.wakecheck

import org.junit.Assert.assertEquals
import org.junit.Test

class WakeCheckExecutionSettingsTest {
    @Test fun usesNonDefaultSessionDurationAndRetries() {
        val settings = WakeCheckExecutionSettings.from(3500L, 3)
        assertEquals(3500L, settings.holdMilliseconds)
        assertEquals(3, settings.maximumFailures)
    }
    @Test fun rejectsMalformedBoundsToLegacyDefaults() {
        val settings = WakeCheckExecutionSettings.from(100L, 100)
        assertEquals(2000L, settings.holdMilliseconds)
        assertEquals(2, settings.maximumFailures)
    }
    @Test fun alternateFamilyDoesNotRepeatKnownFamily() {
        assertEquals("melodic_a", WakeCheckExecutionSettings.alternateFamilyResource("PULSE"))
        assertEquals("urgent_a", WakeCheckExecutionSettings.alternateFamilyResource("MELODIC"))
        assertEquals("pulse_a", WakeCheckExecutionSettings.alternateFamilyResource("URGENT"))
    }
}
