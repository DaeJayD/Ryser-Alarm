# Testing

## Automated checks

```sh
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
```

The suite covers recurrence, wake-flow transitions, detector logic, protocol
validation, adaptive rule priority, time-bounded evidence, recovery, sound
statistics, layout, repositories and database migrations. Local Flutter tests in
`test/integration` exercise workflows with test dependencies; they are not native
Android instrumentation or physical-device proof.

For Kotlin helper tests, run `./gradlew :app:testDebugUnitTest` from `android`
(`.\gradlew.bat :app:testDebugUnitTest` on Windows).

The 3.0.4 baseline passed 117 Flutter tests and 3 Kotlin helper tests. Repeat
checks after changes rather than treating those counts as a guarantee.

Native screen instrumentation is in `android/app/src/androidTest`. With a test
emulator connected, run `./gradlew :app:connectedDebugAndroidTest` from `android`.
This uses the standard unshrunk debug instrumentation variant; it is not proof
of the release artifact. The tests check cold-start layouts, saved hold instructions
and reused ringing-session intents. It does not validate audible alarms or
physical motion detection. Use an isolated emulator because tests record fixture
Wake Check events. See [3.0.4 validation notes](V3_0_4_FIXES.md).

## Device acceptance

Record the model, Android version, app version/artifact hash, permission and
battery settings, expected behavior and actual evidence for every case. Use
another reliable alarm during testing. Keep movement/jump tests safe and optional.

- Audible locked-screen alarm, vibration and notification/full-screen fallback
- Alarm with Dart absent, reboot recovery and update without losing history
- Permission denial/revocation with accurate Alarm Health warnings
- Snooze and recurrence, including clock/time-zone changes
- Normal carried-phone walking and light jumping; false positives and undercounts
- Offline QR registration/scanning on a fresh test profile
- Eight-second emergency stop: early release cancels; completion stops sound and
  vibration and records bypass, not success
- Failed-Wake-Check walking retry at small widths, large text and landscape
- Volume rise, user cap and mission-stage escalation pause
- Non-default snapshot-bound Wake Check hold, retry limit and family selection
- One WakeSession across retries and immutable settings during an active alarm
- Adaptive master switch and fixed dimensions; severe failure must not bypass locks
- Repeated failure, bounded change, execution of the next version, de-escalation
  and recovery after repeated targeted regression
- Removed custom-sound access with an executable fallback
- Preview, Why, Morning Report and Weekly Profile matching stored evidence

Removing an app from recents is not the same as a user force-stop. Test and
document these separately; do not promise automatic recovery from Android's
force-stopped state without the user reopening the app.

Exercise critical cases on a representative OEM and Pixel/AOSP device where
possible, and repeat them on the actual Play-installed artifact before rollout.

## Release artifact checks

- Verify package, version, target SDK, signer and SHA-256.
- Check APK ZIP alignment and 64-bit native-library 16 KB LOAD alignment with
  `tool/verify_native_page_sizes.py`.
- Inspect packaged permissions: release builds must not acquire Internet,
  advertising ID or background-location access unexpectedly.
- Confirm required resources, bundled sounds and offline scanning on-device.
- Verify the upload-key-signed AAB and Play-generated installs separately from
  debug-key sideload candidates.
