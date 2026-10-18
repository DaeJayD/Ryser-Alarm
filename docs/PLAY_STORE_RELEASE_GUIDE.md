# Ryser: step-by-step Google Play release

Prepared 2026-10-15. Policies and Console labels can change; follow the linked
Google pages and the account's actual Dashboard when submitting.

## Readiness boundary

See [Release status](RELEASE_STATUS.md) and [Testing](TESTING.md) for current
checks and outstanding device acceptance. Actual phone screenshots are still
required. Local checks pass, but public-release approval is not established.

Do not upload the existing debug-key APK as a production release. This repository
now requires owner upload credentials for a production build and provides an
explicit test-signing override for local candidates. The upload format is an
Android App Bundle (`.aab`). Google approval, identity verification, closed-test
requirements, and physical-device acceptance cannot be completed by a local build.

The app uses package `com.ryser.ryser`, version 3.0.4 (7), and targets API 36.
Confirm the final package before the first Play upload; its identity persists.
The debug-installed phone copy will not normally upgrade to a different signer.
Keep that copy/history until upgrade/migration testing is done; do not uninstall
it just to bypass an installation error without preserving any needed evidence.

## 1. Create your developer account

1. Open [Google Play Console](https://play.google.com/console/signup) in your own
   browser and sign in with the Google account you will maintain long term.
2. Choose Personal for an individual publisher, or Organization only if you have
   a real organization and the required verification records.
3. Review Google's agreement, pay the one-time US$25 registration fee, and
   complete the identity/contact/device verification requested by the Console.
4. Use your real information. Never send identity documents or passwords here.
5. Check the Dashboard for outstanding account verification before creating a
   production release.

[Google: account setup and fees](https://support.google.com/googleplay/android-developer/answer/6112435).

## 2. Choose the public contact and host the privacy policy

1. Create a support email you are willing to make public.
2. Fill the publisher name/contact/date placeholders in
   `docs/store/PRIVACY_POLICY_DRAFT.md`. Review the actual app and SDK behavior.
3. Host the completed policy on a public, stable HTTPS page you control, such as
   a repository website or existing site. It must open without login, be available
   internationally, and be read-only to visitors. Do not use a PDF as the policy.
4. Supply the final URL/contact to the production build helper below. It embeds
   them in the in-app Privacy screen; the local candidate has no invented details.
5. Read `docs/store/DATA_SAFETY_REVIEW.md` before answering Data safety. Do not
   assume that a local-first description automatically settles SDK disclosures.

[Google: User Data requirements](https://support.google.com/googleplay/android-developer/answer/10144311).

## 3. Create and protect your upload key

Use the Android Studio terminal or PowerShell. Create a private directory outside
the repository, then run the bundled JDK's key tool interactively:

```powershell
$signingDirectory = Join-Path $env:USERPROFILE 'RyserSigning'
New-Item -ItemType Directory -Force -Path $signingDirectory
keytool -genkeypair -v -keystore (Join-Path $signingDirectory 'ryser-upload.jks') -alias ryser-upload -keyalg RSA -keysize 2048 -validity 10000
```

Ensure the JDK's `bin` directory is on PATH so `keytool` is available. Choose
your own strong password, enter your actual certificate identity, and
store the key plus passwords in a secure password manager and separate backup.
Do not commit, upload, or paste the private key/password here. If the key already
exists, use it; do not overwrite it. Enable Play App Signing when Console asks;
Google's app signing key and your upload key serve different purposes.

[Android: app signing](https://developer.android.com/studio/publish/app-signing).

## 4. Build the production bundle

From the Ryser directory, after owner/contact and device acceptance gates pass:

```powershell
.\tool\build_play_release.ps1 -KeystorePath (Join-Path $env:USERPROFILE 'RyserSigning\ryser-upload.jks') -KeyAlias ryser-upload -SupportEmail 'YOUR_PUBLIC_SUPPORT_EMAIL' -PrivacyUrl 'YOUR_PUBLIC_HTTPS_POLICY_URL'
```

The helper asks for passwords privately, passes credentials only to that build,
runs analysis/tests, and builds `build/app/outputs/bundle/release/app-release.aab`.
It clears/restores its process environment afterward. There is no password file.

Verify the bundle signer with JDK `jarsigner -verify -verbose -certs`, confirm the
certificate matches your upload key (not Android Debug), and save the SHA-256.
Check the final APK/bundle for native 16 KB page-size compatibility. The release
has Flutter/SQLite/scanner native libraries, so do not skip this check. In Console,
check App Bundle Explorer and install Play-generated artifacts in an internal test.

For a local sideload candidate only, the explicit override is:

```powershell
$env:RYSER_TEST_SIGNING = '1'
flutter build apk --release --no-pub
Remove-Item Env:RYSER_TEST_SIGNING
```

Never use this override to prepare the production upload.

[Android: App Bundles](https://developer.android.com/guide/app-bundle),
[16 KB compatibility](https://developer.android.com/guide/practices/page-sizes),
[current API requirement](https://developer.android.com/google/play/requirements/target-sdk).

## 5. Create Ryser in Play Console

1. Choose Create app.
2. Enter Ryser, the default language, App rather than Game, and the intended
   free/paid choice. Review pricing implications before choosing.
3. Complete declarations shown by Google, then create the app.
4. Keep the package aligned with the tested app. The first uploaded AAB associates
   its package with this listing.

## 6. Complete the store listing

1. Use the factual draft in `docs/store/LISTING_DRAFT.md`.
2. Provide the final support email and public privacy URL.
3. Supply a 512×512 app icon, 1024×500 feature graphic, and actual phone screenshots
   following the Console's current specifications. Do not substitute widget-test
   images or show controls that are not actually available.
4. Make the alarm-clock purpose clear; avoid medical claims, guaranteed waking,
   or claims that software can bypass Android/OEM restrictions.
5. Review any accessibility, tablet, or other claims against real testing.

## 7. Complete App content and permission declarations

1. App access: no account/login is required. Give reviewers clear steps to create
   a near-future alarm, register a QR target, use a walking/jump mission, and run
   Wake Check. Explain how to grant exact-alarm/full-screen/notification access.
2. Ads: the application includes no ad SDK or advertising UI.
3. Content rating and target audience: answer the actual questionnaires. Do not
   guess an age rating or select children as an audience without assessing the
   additional requirements.
4. Privacy policy and Data safety: use the reviewed final policy and merged
   release artifact; include SDK handling as applicable.
5. Full-screen intent: declare the core alarm-clock use. Prepare a short video
   showing a user scheduling an alarm, the locked-screen alarm firing, and dismissal.
6. Foreground service: declare `mediaPlayback` for user-scheduled audible alarms.
   Explain that it starts for the active alarm and stops on snooze/dismiss. Supply
   the requested demonstration video.
7. Exact alarms: this app requests `SCHEDULE_EXACT_ALARM`, not `USE_EXACT_ALARM`.
   Explain the user-visible clock function if asked; do not claim a different
   permission or invent a policy exemption.
8. Camera and foreground movement/location: describe QR and walking missions.
   No background-location permission is requested.

[Google: foreground service/full-screen declarations](https://support.google.com/googleplay/android-developer/answer/13392821),
[review preparation](https://support.google.com/googleplay/android-developer/answer/9859455).

## 8. Run internal testing

1. Open Testing → Internal testing, add your Google account/tester list, and create
   a release using the production-signed AAB.
2. Review Play's artifact warnings, native-library compatibility, and pre-launch
   report. Resolve failures before increasing exposure.
3. Install using the opt-in link through Google Play.
4. Run the device acceptance matrix in `docs/TESTING.md`, including non-default
   Wake Check, fallback, and adaptive cycle tests. Record device, Android version,
   artifact hash/version, and results.
5. Verify an update from a previous Play-signed build without lost history or
   scheduled-alarm regressions.

## 9. Complete the required closed test

For a new personal account created after November 13, 2023, Google currently
requires at least 12 testers opted in continuously for 14 days before applying
for production access. Recruit real testers and collect actual usage/feedback.
Internal testing alone does not satisfy that production-access requirement.

1. Complete the app setup required by Console.
2. Create a Closed testing track, add testers, and publish the test release.
3. Have testers join through the opt-in link and remain opted in continuously.
4. Keep feedback and fixes. Do not fabricate participation or test results.
5. Once the Console shows eligibility, apply for production access and answer
   its questions based on the completed testing.

[Google: new personal-account testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465).

## 10. Submit production when every gate passes

1. Ensure identity, listing, App content, signing, Data safety, and testing gates
   show complete, with no unresolved critical app defect.
2. Create the Production release with a fresh, higher version code if the build
   changed. Review release notes, countries, pricing, and the exact artifact.
3. Submit for Google's review. Review time and approval are controlled by Google.
4. Use a limited rollout where the Console offers it. Monitor Android vitals,
   alarm failures, and user reports, and pause further rollout if reliability falls.

The first guided action for you is Step 1. Production submission remains a
separate owner decision after the application and account gates are ready.
