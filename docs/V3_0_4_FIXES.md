# V3.0.4: consistent wake screens and clearer wake-up plans

## Reported old interface

The supplied home screenshot says v3.0.2. Its exact header text still exists in
an older development checkout. Current development and this candidate build use
the GitHub checkout. The app has one Flutter home route and no code that installs
an older APK after dismissal. Without inspecting the installed phone package,
the apparent version change cannot be attributed to a confirmed cause.

The ringing and follow-up check screens were separate native Android activities
that still had the old design. They now use the mint-green palette, rounded
panels, readable text, scrolling, and system-bar/cutout insets. They remain native
so an alarm can start while Flutter is absent. Both display the installed package
version. Reused ringing activities now refresh their intent, visible label and
session identity instead of retaining the previous alarm's extras.

## Scrolling and branding

- Second ticks update only the clock. Card ordering, labels and the history
  summary refresh on minute changes or actual data changes.
- Clock ticks pause in the background and do not rebuild covered home routes.
- Seven-segment digits no longer use per-segment blur. Clock painting and the
  static background grid have separate repaint boundaries.
- The in-app logo is decoded at its display size instead of full source size.
- The original green R stays the launcher/store app icon. The supplied clock
  artwork is used inside the app and on the store feature graphic.

These changes reduce unnecessary work. Phone frame-time improvements still need
measurement on the affected device; no percentage speed-up is claimed.

## Plain-language wake-up plans

The app calls a protocol a wake-up plan. Its revision is labelled "Update 4",
not "V4", to distinguish it from the app version. Explanations show what changed
and why in ordinary language, without internal field names or reason codes.
Settings show what the alarm will do, which choices Ryser may adjust, and what
happens when a follow-up check is missed. Existing stored plans use these labels
too; no history rewrite or database migration is needed.

## Phone acceptance

Install the candidate as an update, keeping app data. Check v3.0.4 on the home,
ringing and follow-up screens. Create a short test alarm, close and reopen the
app, complete its task and follow-up check, and verify that home still shows
v3.0.4. Repeat with the screen locked and with a missed check. Test scrolling,
large text and the original launcher icon on the physical phone. Keep another
reliable alarm during validation.

The APK is a locally test-signed candidate, not a Play release. Do not uninstall
to resolve an update/signature error without first protecting local wake history.

## Local verification and artifact

- 117 Flutter tests passed, including the per-second rebuild regression, plain
  text for existing plans, large-text layouts, migrations and wake-flow tests.
- `dart analyze lib test`: no issues.
- 3 Kotlin helper tests passed; native screen sources compile.
- The debug native UI test APK builds successfully. This is compilation evidence
  only; its on-device assertions have not passed yet.
- Release APK: `dist/Ryser_V3_3.0.4_candidate.apk`.
- Package `com.ryser.ryser`, version 3.0.4 (7), min SDK 24, target SDK 36.
- Size: 79,862,419 bytes.
- SHA-256: `559191BA0D7FB079EBDEBDA8A8B7E28624392BE89866BAF60B10801EB88D9A1C`.
- APK v2 signature verified with the existing Android Debug test certificate.
- ZIP 16 KB alignment and all 14 packaged ELF64 LOAD checks passed.
- No Internet, network-state, advertising-ID or background-location permission.
- Original Android launcher assets and store app icon match the repository's
  original versions exactly. The supplied in-app artwork matches its source hash.

Native UI instrumentation did not complete. The isolated API 36.1 emulator's
display service repeatedly crashed with `hasReadColorBufferDma` assertions,
including after a graphics-backend change. The attempted release-test runner
also failed at startup with a missing `androidx.tracing.Trace` class. The harness
now uses the standard debug instrumentation variant instead of release shrinking;
its UI assertions still need a successful run on a working emulator or test phone.
These failures are not passing tests or proof of an app UI failure.

No physical-phone installation, visual acceptance, audible-alarm verification,
or measured scrolling benchmark is claimed. The isolated emulator was stopped
after collecting crash evidence; no personal device data was changed.
