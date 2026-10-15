# Ryser Privacy Policy — OWNER DRAFT, NOT YET PUBLISHED

Before publishing, replace `[PUBLISHER]`, `[SUPPORT_EMAIL]`, `[PUBLIC_POLICY_URL]`,
and `[EFFECTIVE_DATE]`, confirm the final release behavior, and remove this draft
notice. Do not submit placeholder contact details to Google.

Effective date: [EFFECTIVE_DATE]

Ryser is an Android alarm application provided by [PUBLISHER]. Contact:
[SUPPORT_EMAIL]. Current policy: [PUBLIC_POLICY_URL].

## Information used on your device

Ryser stores alarm settings, sound references, wake-event history, response times,
snoozes, mission results, Wake Check results, and adaptive protocol versions in
local application storage. These records support alarm operation, local reports,
and explainable rule-based changes. Ryser does not require an account.

Camera access is used to register and match a QR target. Matching uses a stored
hash; Ryser does not retain camera images or the raw QR text in wake history.
Motion sensors and activity recognition support walking/jumping missions. If you
allow foreground location, walking can use location differences as a fallback.
Raw coordinates are held in memory for progress and are not saved to wake history.
Chosen audio is accessed through the file or ringtone reference you select.

## Network and third-party components

Ryser's release build uses a bundled ML Kit QR model and removes Internet,
network-state, and advertising-ID permissions from the merged release manifest.
It contains no Ryser server, advertising service, or remote analytics account.
The barcode SDK can generate local diagnostic information. Its developer's
general disclosure describes diagnostics and usage collection when transport
is available; Ryser's release app does not have app-level network permission.

Android, Google Play, device location services, and services you independently
use are governed by their own privacy settings and policies. Their independent
platform diagnostics are distinct from Ryser's local wake records. If future
versions add any remote processing, this policy and the app's disclosures must
be updated before that behavior ships.

## Control, retention, and deletion

You may revoke camera, activity, location, notification, and alarm access in
Android settings. Alarm Health identifies permissions that affect functions.
Revoking access can make a selected mission or alarm presentation unavailable.

Ryser keeps local history until application storage is cleared or the app is
uninstalled. Android cloud backup is disabled for Ryser. Clearing storage or
uninstalling also removes the app's alarm setup; recreate required alarms after
reinstallation. Reset Adaptive Learning preserves history and is not deletion.

Ryser does not sell wake records or provide accounts that require account deletion.
For questions about this policy, contact [SUPPORT_EMAIL].

## Changes and purpose

The current version and effective date are published at [PUBLIC_POLICY_URL].
Ryser describes observed alarm interactions. It is not a medical diagnosis,
sleep-stage measurement, or guarantee that an individual will wake.
