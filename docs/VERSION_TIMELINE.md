# Ryser Version Timeline

V1 to V3 and the proposed V4 direction

Project record through 15 October 2026

## 1 Overview

Ryser grew from a native Android alarm into a wake-enforcement system and then
an explainable adaptive alarm. The current version is 3.0.2 (5). It is a locally
validated, test-signed candidate, not a Google Play production release.

The next priority is to prove the existing wake loop on physical phones. V4
should refine adaptive difficulty only after sensor behavior, alarm reliability,
and the evidence behind each change are dependable.

| Milestone | Main change | Evidence and status |
|---|---|---|
| V1 foundation | Native alarms, scheduling, persistence, sound, snooze, health and history | Early build records show 10 tests and a verified APK; not a broad phone reliability study |
| V2 enforcement | QR and walking missions, delayed Wake Checks and same-session reactivation | Candidate APKs and persistent enforcement model; later user reports exposed mission issues |
| V2 bug-fix builds | Jumping, increasing-volume control, sensor fallbacks, history formatting and layout work | Changes exist in current code; walking accuracy still requires measured phone acceptance |
| V3 3.0.0 | Versioned wake protocols and deterministic adaptation | Report dated 6 October: 68 tests and a checked APK; later audit found implementation gaps |
| V3 3.0.1 | Centered walking retry layout | 15 October fix record: four layout scenarios and an updated APK |
| V3 3.0.2 | Adaptive correctness fixes and release preparation | 15 October: 96 Flutter tests, 3 Kotlin helper tests and a checked candidate APK |
| GitHub handoff | Separate Ryser-only source repository | Initial source commit dated 15 October; first push to main succeeded |
| V4 proposal | Validate and refine adaptive difficulty | Not implemented or approved as a final specification |

### How to read the timeline

V1, V2 and V3 here mean product generations. They are not the same as the older
repository roadmap's numbered phases, database schema versions, or the version
number of an individual wake protocol. Exact release dates are not assigned to
early milestones when the record does not establish them.

The older roadmap placed delayed Wake Check in V3, adaptive difficulty in V4 and
sound decline in V5. The later Phase 2 and Phase 3 specifications moved several
of these capabilities earlier. V4 must account for that overlap rather than
reimplementing features already present. [1-3]

<!-- pagebreak -->

## 2 V1 The native alarm foundation

### What changed

V1 established alarm creation, editing, deletion, enabling, one-time and repeated
schedules, local sound selection, vibration, snooze and dismissal. Snooze input
was expanded to any whole-minute duration from 1 to 60 minutes.

Flutter, Riverpod and Drift handled the interface and local product data.
Kotlin handled AlarmManager scheduling, native ringing, notifications and system
recovery. This boundary mattered because an alarm must not depend on Dart being
alive when it fires.

Wake sessions and ordered events recorded trigger and interaction evidence.
Alarm Health exposed conditions such as missing alarm/notification access, and
history provided a local record of what happened. The black and digital-green
interface and an armed-alarm status notification were also established.

### Problems and constraints

- Android controls status-bar icon tint. A green notification asset does not
  guarantee that the system status-bar icon will appear green.
- Permissions, lock-screen presentation and OEM battery management affect the
  alarm surface. They cannot be treated as unconditional app guarantees.
- The native registry/outbox and Drift database have different responsibilities.
  Reboot recovery must not depend on Flutter opening the product database.

### Verification recorded

Early development records report 10 passing Flutter tests, a built/signature-
verified release-mode APK, emulator checks and a recovery-broadcast check. Those
records establish a working foundation, not complete real-device acceptance.
The retained Ryser.apk identifies itself as 1.0.0 (1). [4]

## 3 Early V2 Sound behavior and defaults

Before the full enforcement work, the V2 branch added deterministic sound
rotation using native usage/recency history, application defaults, Settings and
per-sound performance summaries. Rotation could select another available sound
after snoozing. This was a rule-based feature, not machine learning.

The early V2 checkpoint recorded 12 passing tests and a debug build. Its final
release build was not verified at that checkpoint; later V2 candidate artifacts
must not be confused with that earlier partial result. [4]

<!-- pagebreak -->

## 4 V2 Wake enforcement and reported bugs

### What changed

The Phase 2 specification expanded the wake loop: alarm, physical mission,
delayed Wake Check, and reactivation if the check is missed. QR and movement
missions were added first. Jumping and an increasing-alarm-volume toggle were
added during follow-up work.

Mission attempts, missed checks and retries were attached to one WakeSession.
Persistent mission/check records and additive database changes preserved earlier
alarms and history. Emergency bypass was kept distinct from success. [2,5]

### Reported problems and response

| Reported problem | Change or response | Closure status |
|---|---|---|
| Eight-second emergency hold finished but alarm kept ringing | Bypass/stop handling was revised to stop native outputs and record bypass separately | Implemented; audible stop and stale-restart checks remain phone gates |
| Walking did not progress despite permissions | Added motion fallback and permitted foreground-location distance input alongside the step counter | Implemented; permission alone does not prove usable sensor readings |
| More than 20 real steps could show only 2; fast phone movement counted quickly | Step/jump handling was revised; current walking detector uses acceleration peaks and source-progress merging | User-reported reliability concern remains open until measured on phones |
| Jump detection demanded too much effort | Changed to light-jump detection using a low-gravity phase followed by landing | Local detector tests exist; comfort, undercounts and false positives need phone evidence |
| History showed raw JSON and long audio URIs | Added readable event details and sound summaries | Formatting exists in current code; inspect report screens on phone |
| Mission controls or labels overlapped | Adjusted editor/mission layout; walking retry required a later V3.0.1 fix | Related local layout tests pass; device visual acceptance remains required |

The current movement-progress implementation takes the strongest source count
rather than summing all sensor sources, avoiding duplicate credit. Location
distance is an estimate, not proof of individual steps; indoor drift and phone
position still need testing.

### Important version and storage distinctions

The retained completion and step/jump-fix APKs both identify themselves as
2.0.0 (2), even where a filename says v2.1. A filename is not authoritative app
version metadata. Likewise, JSON displayed in history was a presentation problem,
not proof that all history used JSON storage: relational Drift tables already
existed, and typed JSON snapshots can legitimately remain inside those tables.
[5,10,11]

<!-- pagebreak -->

## 5 V3 The Adaptive Wake Engine

V3 introduced a versioned wake protocol containing sound, volume/ramp,
vibration, mission, Wake Check settings and an intensity label. A session retains
the snapshot it actually ran; an adaptation is intended for a future wake.

The design follows a repeatable loop: measure the session, classify the failure,
choose the minimum supported change, validate it, execute it on a later wake,
then keep or recover from that change. There is no machine-learning model.

| Stage | Added responsibility |
|---|---|
| 3A | Protocol/evidence contract, schema v5 and migration preservation |
| 3B | Native snapshots and protocol-bound execution compatibility |
| 3C | Deterministic session analysis and failure classification |
| 3D | Bundled sound families, performance and decline detection |
| 3E | Parameterized volume and vibration with user bounds |
| 3F | Protocol-driven Wake Check and mission adaptation |
| 3G | Prioritized rules, conflicts, traces and idempotent evaluation |
| 3H | Success de-escalation, targeted comparison and recovery |
| 3I | Controls, preview, Why, Morning Report and Weekly Profile |
| 3J | Automated regression, artifact checks and physical-device gate |

### V3 3.0.0 checkpoint

The report dated 6 October recorded 68 passing tests, clean analysis, a checked
APK and emulator installation/launch. The emulator's System UI/Launcher was
unstable. That environment problem was not evidence of a Ryser-owned crash, nor
was a successful emulator launch proof of audible wake reliability.

An October 15 requirements audit later found missing or incomplete behaviors.
The earlier statement that implementation was complete was therefore too strong.
Passing the tests that existed did not establish that every specified behavior
was present. The audit and V3.0.2 remediation supersede that completion claim.
[3,6,7]

### V3 3.0.1 layout patch

The failed-Wake-Check walking retry was visibly misaligned in the user's phone
screenshot. The fix used the available viewport width and scrollable minimum
height rather than a rigid layout. Four local scenarios checked normal phone,
small phone, double-size text and landscape. This produced 3.0.1 (4); phone
inspection of the changed retry screen remains a separate acceptance step.

<!-- pagebreak -->

## 6 V3 3.0.2 Audit fixes and release preparation

### Evidence attribution and decision rules

The coordinator could classify an older pending session using the newest
session's analysis and later evidence. Evaluation now uses the current session's
own analysis and a time-bounded comparison window. Mixed-backlog/idempotency
tests cover the original mismatch.

The rule engine was expanded into actual prioritized rules with match/rejection
traces. It now includes repeated high snoozes, bypass-practicality review and a
bounded severe no-response path. A severe exception does not override user locks
or volume limits. Recent evidence receives explicit normalized weights.

### Executable protocols and Wake Checks

Earlier validation could accept nonempty but unreadable sound references or
mission JSON that parsed without being executable. Validation now checks typed
mission limits, native resource/capability availability and fixed-dimension
fields before activation, with resolution of an older executable protocol.

Stored Wake Check hold, retry and reactivation-family settings had not fully
controlled execution. Native/Flutter paths now consume session-bound values;
non-default parser/helper tests were added. Actual device timing still needs
measurement.

### Recovery and truthful explanations

Recovery had relied on response latency alone and could describe a change that
did not match the restored settings. Targeted comparisons, actual field
differences, recovery versions and reverted history were added. Intensity is
recalculated from configuration rather than left as a stale label.

Sound metrics gained use/recency fields and more complete denominators. Decline
comparisons now constrain recorded protocol identity so other configuration
changes are not casually blamed on sound. Legacy rows with unknown protocol
identity remain weaker evidence. Preview, Why, Morning Report and Weekly Profile
were expanded to show configuration and recorded evidence. [7,8]

### Distribution preparation

Version metadata was synchronized to 3.0.2 (5), targeting API 36. Production
builds now reject missing upload credentials; test signing requires an explicit
override. Release network/ad permissions were removed, bundled scanning was
selected, cloud backup was disabled, and privacy/listing/release materials and
Ryser artwork were prepared.

The local build also encountered memory pressure and a mistaken native test-task
name. Those were build-environment/workflow issues, not demonstrated runtime app
defects. Lower worker/heap limits and the available debug-unit-test task allowed
verification to complete. [8]

<!-- pagebreak -->

## 7 Current evidence and remaining limits

| V3.0.2 check | Recorded result | What it does not prove |
|---|---|---|
| Flutter analysis | No issues | Absence of runtime or device-specific defects |
| Flutter suite | 96 passed | Every requirement or real alarm scenario |
| Kotlin helper tests | 3 passed | Android instrumentation or actual native timing |
| Candidate APK | Built; signature and ZIP checks passed | Play upload signing or store acceptance |
| Native page alignment | 14 ELF64 libraries passed 16 KB checks | All device/runtime compatibility |
| Packaged permissions | No Internet, network-state or ad-ID permission | Offline QR success without a phone test |
| Production signing guard | Missing owner credentials rejected | A production-signed AAB was built |
| UI checks | Walking layout and narrow/large-text preview tests | All physical layouts and accessibility |

The current candidate is signed with the Android debug key for sideload testing.
No production AAB or Google Play publication is established. Play registration
and production setup remain deferred; local development and GitHub source
hosting can continue independently.

### Open acceptance work

- Verify audible locked-screen alarms, Dart-absent execution, reboot/update
  recovery, snooze and permission-denied fallbacks on named physical devices.
- Measure normal walking/light-jump undercounts and shaking/location false
  positives rather than declaring them fixed from detector tests alone.
- Confirm emergency stop ends audio/vibration and leaves no stale reactivation.
- Execute non-default Wake Check duration, retry and family policies on-device.
- Run a complete multi-wake adapt, execute, evaluate and recover cycle while
  checking user caps, fixed settings, evidence order and preserved history.
- Recheck offline QR, report readability, large text and the retry layout.
- Review the pedometer dependency before upgrading Flutter/Kotlin: the current
  build warns about a future incompatibility in its legacy plugin path.

### GitHub milestone

A separate Ryser-only repository was prepared without the unrelated LTO project,
local planning records, build outputs or signing material. App/test/schema files
were compared with the working source, analysis was clean and all 96 Flutter
tests passed in that copy. Commit 515364e, dated 15 October, introduced the source.
The owner's push output confirms main was uploaded and linked to origin/main.
This is source publication, not a production app release. [8-10]

<!-- pagebreak -->

## 8 Proposed V4 Plan

The original roadmap's V4 question was whether adaptive protocol difficulty
could reduce unnecessary intensity while preserving successful wakes. V3 already
implements much of the mechanism. V4 should validate and refine it, not add a
second adaptation engine. This is a proposal, not an approved implementation
schedule or a claim that V4 work has started. [1,3]

| Order | Proposed work | Exit evidence |
|---|---|---|
| 4A Close the V3 gate | Freeze a candidate, run the physical-device matrix and reproduce unresolved incidents | Named device/Android/build records; no unexplained critical alarm or bypass failure |
| 4B Mission practicality | Validate carried-phone walking, light jumps, location drift, source attribution and permission fallbacks | Predefined accuracy/false-positive criteria, observed counts, repeatable traces and safe alternatives |
| 4C Adaptive difficulty | Calibrate burden changes using complete versioned sessions; keep one major change, caps, fixed settings and recovery | End-to-end phone evidence that proposed changes execute correctly and reverse when targeted outcomes worsen |
| 4D Evidence and controls | Audit event ordering, incomplete/legacy evidence and report wording; assess history export/deletion separately | Reports match recorded actions; any new data controls preserve alarm definitions and require clear confirmation |
| 4E Platform maintenance | Resolve pedometer/toolchain migration, add native reliability coverage and retest upgrades | Pinned compatible toolchain, preserved history, stable native build and relevant device regressions |
| 4F Pilot and release | Run a documented multi-morning pilot; finish signing/privacy/store gates when the owner can proceed | Actual device feedback and incident ledger; owner-signed/verified artifacts before public distribution |

### What stays out of this V4 proposal

No machine learning, opaque Wake Score, cloud dependency, account requirement,
wearable integration, new platform or medical claim is needed to complete these
gates. Revisit such scope only after trustworthy longitudinal data exists and the
owner approves a separate specification.

The first practical task is 4A, with special attention to the walking/shaking
report. Set test criteria before collecting results; do not invent a success
rate from a small number of informal mornings. A trustworthy adaptive alarm
needs both correct code and evidence that its physical wake actions work.

<!-- pagebreak -->

## 9 Version identities and next actions

| Artifact or label | Verified identity or meaning |
|---|---|
| Ryser.apk | 1.0.0, version code 1 |
| V2 completion candidate | 2.0.0, version code 2 |
| v2.1 step/jump filename | Still 2.0.0, version code 2; filename labels the patch |
| V3 original candidate | 3.0.0, version code 3 |
| Walking layout patch | 3.0.1, version code 4 |
| Current local candidate | 3.0.2, version code 5; debug-key sideload candidate |

### Next actions

1. Keep development in the clean Ryser GitHub repository and commit meaningful,
   reviewed changes without build outputs or signing credentials.
2. Test the current candidate using docs/TESTING.md. Record failed or skipped
   cases honestly; do not treat old phone feedback as proof of changed code.
3. Convert the V4 proposal into explicit requirements and acceptance criteria
   after the V3 device results identify the highest-priority problems.
4. When ready, resume Play account setup, finalize contact/privacy details,
   create/protect an upload key and verify a production AAB. Follow the existing
   release guide and current Console requirements at submission time.

### Source register

- [1] Ryser Product Roadmap Loop Engineering, page 17: original V3/V4/V5 scope.
- [2] Ryser Phase 2 Master Development Prompt: wake enforcement specification.
- [3] Ryser Phase 3 Master Development Prompt and Adaptive Wake Plan: V3 scope
  and stages 3A to 3J.
- [4] Archived early development records: V1 checks and initial V2 checkpoint.
  These are historical records, not fresh hardware measurements.
- [5] V2_COMPLETION_GATE.md and retained V2 APK metadata.
- [6] RYSER_V3_VALIDATION_REPORT.md, dated 6 October 2026: original V3 checks.
- [7] PHASE_3_REQUIREMENTS_AUDIT_2026-10-15.md: gaps that superseded the earlier
  code-complete claim.
- [8] PUBLIC_RELEASE_VALIDATION_2026-10-15.md and current docs/RELEASE_STATUS.md
  and docs/TESTING.md: remediation and local/public-release boundaries.
- [9] Clean repository verification and commit 515364e; owner-provided push log.
- [10] Current movement/jump detectors, movement-progress merger, mission flow
  and history formatter; retained artifact metadata checks.
- [11] Owner's bug descriptions and screenshots: original behavioral reports,
  distinct from instrumented acceptance measurements.

Public-repository documentation lives under docs. Some historical specifications
and validation records remain in the local archive and are not part of the
clean source repository. No unrecorded release date, hardware pass, production
approval or V4 implementation is implied by this timeline.
