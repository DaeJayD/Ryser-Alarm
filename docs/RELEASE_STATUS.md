# Release status

Current candidate: **3.0.4 (7)**, package `com.ryser.ryser`, target SDK 36.

This follows the [V3 UI refresh](UI_REFRESH_V3.md), without Quick Actions.
[3.0.4](V3_0_4_FIXES.md) updates the native wake screens, refreshes reused alarm
intents, reduces dashboard drawing/rebuild work and explains plans in plain
language. Native alarm ownership and the adaptation rules remain intact; it is not V4.

Local validation completed:

- Static analysis without issues
- 117 Flutter tests and 3 Kotlin helper tests
- Release-mode APK build using an explicit local test-signing override
- APK signature/ZIP alignment and 14 ELF64 libraries checked for 16 KB alignment
- Packaged manifest without Internet, network-state or advertising-ID permission
- Production build guard rejects missing upload credentials

Native UI instrumentation remains unverified after emulator display-service and
release-test-runner failures; see the [validation notes](V3_0_4_FIXES.md).

Public distribution is not approved. Remaining gates are physical-device
acceptance, publisher identity/contact and hosted privacy policy, an upload key,
owner-signed AAB verification, Play declarations, internal/closed testing where
required, and Google review. No production AAB or publication is claimed.

Follow [Testing](TESTING.md) and the [release guide](PLAY_STORE_RELEASE_GUIDE.md).

## Known maintenance item

The pedometer dependency currently uses the legacy Kotlin Gradle plugin path.
It builds with the pinned toolchain, but Flutter warns future versions will stop
supporting that integration. Review this dependency before upgrading Flutter or
the Android build toolchain.
