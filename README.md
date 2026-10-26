# Ryser

Ryser is an Android alarm app with walking, jumping, and QR-code dismissal
missions, follow-up Wake Checks, and rule-based adjustments based on local wake
history. The interface uses a black and digital-green theme.

## Features

- Native scheduling, alarm audio, vibration, snooze, and reboot recovery
- Walking, light-jump, and registered QR-code missions
- Delayed Wake Checks and an eight-second emergency-stop hold
- Increasing volume with a user-defined cap
- Versioned wake protocols, fixed/adaptive controls, and change explanations
- Local wake history, morning reports, and weekly summaries

No account or server is required. The release build uses a bundled QR scanner
and has no Internet permission.

## Status

Version **3.0.4 (7)** is the current V3 candidate, not a published
Google Play release. Physical-device acceptance remains required, especially for
locked-screen alarms, OEM battery restrictions, motion detection, and repeated
adaptive cycles. Do not rely on a test build as your only alarm.

The latest local checks passed 117 Flutter tests and 3 Kotlin helper tests.
These do not replace device testing.
See [Testing](docs/TESTING.md), the [3.0.4 changes](docs/V3_0_4_FIXES.md), and
[Release status](docs/RELEASE_STATUS.md).

See the [version timeline](docs/VERSION_TIMELINE.md) for V1–V3 changes, reported
bugs, fixes, and the proposed V4 direction.

V4 development starts with the [implementation plan](docs/V4_IMPLEMENTATION_PLAN.md).
The experiment foundation uses additive schema 6. [Native preparation and
reconciliation](docs/V4A_NATIVE_INTEGRATION.md) support one sound-family test;
comparison, visible learning controls and optional personalization are pending.
The distributed V3.0.4 APK remains the existing candidate.

## Toolchain

- Flutter 3.47.4
- Dart 3.13.3
- Android SDK 36
- AGP 9.1.0 / Gradle 9.3.1 / Kotlin 2.4.0
- Android Studio's bundled JDK (JDK 21 used for the current local build);
  Java/Kotlin bytecode target 17

## Run locally

Install the pinned Flutter SDK and Android SDK, accept Android SDK licenses, and
check `flutter doctor`. Then connect an Android device or start an emulator:

```powershell
flutter pub get
flutter run
```

Android SDK paths in `android/local.properties` are generated locally and must
not be committed. Exact-alarm, notification, and full-screen access affect alarm
behavior; review the in-app Alarm Health screen after installation.

## Verify and build

```sh
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug
```

For native helper tests, run `./gradlew :app:testDebugUnitTest` inside `android`
(`.\gradlew.bat :app:testDebugUnitTest` in PowerShell).

Generated Drift and Pigeon sources are included. Regenerate them after changing
their input definitions, and review both sides of the platform bridge together:

```sh
dart run build_runner build --delete-conflicting-outputs
dart run pigeon --input pigeons/alarm_runtime_api.dart
```

Keep historical schema snapshots and migration fixtures in version control.

## Project layout

- `lib/`: Flutter UI, repositories, local database, and adaptation rules
- `android/app/src/`: native scheduling, playback, recovery, and bridge
- `pigeons/`: typed platform API definition
- `drift_schemas/`: database schema history
- `test/`: unit, widget, repository, and migration tests
- `tool/`: sound/artwork generation and release helpers

See [Architecture](docs/ARCHITECTURE.md) for runtime ownership and data flow.

## Distribution

Production builds require an owner-controlled upload key. A missing key fails
the release build instead of silently selecting the debug key. Follow the
[release guide](docs/PLAY_STORE_RELEASE_GUIDE.md) for signing and Play preparation.

Dependencies retain their own licenses. No open-source license has been selected
for Ryser yet; public source visibility alone does not grant a reuse license.
