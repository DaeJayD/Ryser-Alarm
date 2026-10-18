# V3 UI refresh

The current follow-up candidate is [3.0.4](V3_0_4_FIXES.md), which also refreshes
the native wake screens, adds the supplied in-app logo, and improves scrolling
and wake-plan wording. The artifact recorded below is the earlier 3.0.3 build.

Version 3.0.3 (6) applies the reference design to the existing V3 app. It is not
V4 and does not add new wake missions or an adaptation engine.

## Design

- Black background, subtle grid, green framed panels and rounded controls
- Code-drawn Ryser wordmark and seven-segment clock, without downloaded fonts,
  new runtime dependencies or network access (the in-app logo changes in 3.0.4)
- Alarms, History, Health and Config navigation with a distinct selected state
- Next-alarm card with recurrence/audio/snooze tags and editable feature rows
- Shared typography, fields, surfaces and buttons across the editor, settings,
  history, protocol explanations, health and mission controls
- No Quick Actions section, sleep mode or test-alarm shortcut; the existing
  Initialize New Alarm action remains the primary creation control

## Production-focused behavior

The next card is selected by the actual next enabled occurrence, not list order.
Calendar labels distinguish tomorrow from alarms later in the week.
Alarm controls are disabled while their save is pending; native rejection is
reported and does not flip the persisted enabled state. The health badge is
based on native access checks, with checking/review states instead of a fictional
System Online indicator. It does not promise that a physical alarm will work.

The overview derives first-response average, recorded confirmations and session
count from eligible completed sessions in the last seven days. Missing data
stays empty; total sleep, improvement percentages and sample success rates are
not invented. Recorded confirmation is not a physiological sleep measurement.

QR registration is now an explicit action instead of automatically opening the
camera when wake enforcement is turned on. Existing QR validation remains in
place. Expanded, variable-height dropdowns keep long labels and large text from
overlapping mission fields.

Health loading failures offer retry rather than a permanent spinner. Malformed
QR configuration is reported as not ready. Settings-save failures preserve input
and re-enable saving. Mission emergency stop now has a visible hold label,
remaining-time feedback and a semantic instruction. Its existing hold handlers,
timing, bypass outcome and native stop path were not replaced.

## Verification

- 113 Flutter tests passed, including existing migration, wake flow, adaptation,
  mission, Wake Check and detector fixtures.
- Added dashboard layout coverage for 320 px width, double text and landscape,
  true next-alarm order, missing/denied readiness and real history aggregation.
- Added schedule-rejection, health-error, settings-save-error and double-text
  mission-editor regressions.
- Rendered and inspected the dashboard, editor, settings, history and health
  with test fixtures. These images are widget-test previews, not device screenshots
  or valid proof of native audio, sensors, lock-screen behavior or Play acceptance.
- Static analysis passes. Native Kotlin execution, schema and dependency versions
  were not changed by this UI work.

## Candidate artifact

Built and verified 16 October 2026:

- Local file: `dist/Ryser_V3_3.0.3_UI_candidate.apk`
- Package `com.ryser.ryser`, version 3.0.3 (6), min SDK 24, target SDK 36
- Size: 78,218,025 bytes
- SHA-256: `A3BDD4418675E97EE586F02D4A63F2821BF67192A1345099C45844D78DA1A191`
- Explicit Android Debug signing for sideload tests; APK v2 signature verified
- ZIP 16 KB alignment and all 14 packaged ELF64 LOAD alignment checks passed
- Packaged permissions contain no Internet, network-state, advertising-ID or
  background-location permission
- Final build was rerun after the last application-source correction. No Android
  device was connected for native execution/phone acceptance in this run.

The existing pedometer Kotlin plugin compatibility warning remains a maintenance
item; it did not prevent this release-mode build. APKs and rendered test previews
remain ignored by Git. The source/doc changes are not committed or pushed.

## Phone acceptance before public distribution

Test the new scrollable dashboard, editing, enable/disable, explicit QR setup,
all mission types and the emergency hold on the actual phone. Recheck the failed
Wake Check walking retry, system font scaling, landscape and permission-return
flows. Repeat native locked-screen alarms, reboot/update, audible volume and
history preservation using `docs/TESTING.md`.

Signing and store requirements remain in `PLAY_STORE_RELEASE_GUIDE.md`. A
test-signed sideload APK is not a production Play upload. No source commit,
GitHub push, phone installation or external publication is part of this change.
