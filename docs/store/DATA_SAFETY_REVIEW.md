# Data safety and permission review

Prepared 2026-10-15. Complete against the final production artifact, not a debug
build or an earlier APK. The owner must approve the final Console answers.

## Application data flow

| Data | Purpose | Storage / transmission |
|---|---|---|
| Alarm settings and wake events | Alarm execution, local adaptation and history | Device-local Drift and separate native runtime DB |
| QR target | Registered target matching | Hash/label local; no raw QR value in explanations |
| Camera frames | QR detection | Processed by bundled scanner; not stored by Ryser |
| Motion/activity | Walking/jumping mission | Progress processing; outcome/count evidence local |
| Foreground location | Walking fallback | Coordinate differences in memory, not persisted in history |
| Selected audio reference | Alarm playback | Local reference and user-selected content access |
| Protocol decisions | Future alarm settings and explanation | Local versioned records |

## SDK finding and mitigation

`mobile_scanner` uses bundled `com.google.mlkit:barcode-scanning:17.3.0` by default.
ML Kit documents device/app/performance diagnostics. Its transitive libraries
add Internet/network-state permission even when the app does not request it.
This was observed in the pre-mitigation merged manifest.

The release-only manifest now removes Internet, network-state, and advertising-ID
permissions, and the bundled model is explicitly selected. Debug/profile builds
retain development networking. Do not use their behavior as the release policy.

Before final submission:

- Verify the packaged production manifest has none of these network/ad permissions.
- Verify QR registration/scanning works on a fresh phone in airplane mode.
- Confirm no product feature uploads data, and review updated SDK documentation
  whenever dependencies change. Do not assume an absence of a custom backend is
  sufficient proof by itself.
- Review the final policy and Console definitions for off-device collection,
  sharing, optional access, encryption, and deletion. On-device access alone is
  not automatically off-device collection. Do not invent encryption for remote
  transport that the release app does not perform.
- Keep support email and policy URL consistent across the app and store listing.

## Console preparation

App requires no login, contains no ads, and requests no background-location,
contacts, microphone, broad storage, or advertising-ID permission. Verify those
claims against the final merged artifact before answering questionnaires.

Declare the actual alarm-clock use for full-screen intent and the mediaPlayback
foreground service. `SCHEDULE_EXACT_ALARM` remains user-granted special access.
Camera is optional for QR; walking/jumping are alternatives. Do not claim that
denied permissions have no effect; explain unavailable functionality.

## Primary references

- [Google Play Data safety definitions](https://support.google.com/googleplay/android-developer/answer/10787469)
- [ML Kit Android disclosure](https://developers.google.com/ml-kit/android-data-disclosure)
- [Google User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311)
- [Foreground service and full-screen declarations](https://support.google.com/googleplay/android-developer/answer/13392821)
