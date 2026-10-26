# V4A experiment execution integration

Development source for phase 4A.
This extends the [V4 plan](V4_IMPLEMENTATION_PLAN.md). It is development source;
the distributed V3.0.4 APK is unchanged.

## Goal and architecture

Reserve control or candidate before an occurrence, execute its saved settings
through Kotlin, and attach the observed wake to that reservation. Native alarms
continue without Flutter. The first execution slice permits sound-family changes
only. Comparison, automatic winner promotion and optional ML remain later work.

`ExperimentExecutionCoordinator` prepares a schedule through an optional gateway
callback. Riverpod supplies one overridable native API and defers preparation to
avoid constructing a provider cycle. Capability checks use the same gateway.
Experimental candidates are registered as archived protocol versions, so session
lookups can resolve them without replacing the active stable plan.

## Data model changes

- Drift schema 6: experiments, pre-run assignments and ordered audit from 4A.1.
- Typed Pigeon DTOs: experiment ID, assignment ID, variant, context, original
  occurrence and assignment time. Dart and Kotlin are regenerated together.
- Native schedule database 4→5: assignment JSON and stable protocol snapshot.
- Native event outbox 2→3: assignment JSON. Both migrations preserve old rows.
- Per-alarm execution flags use existing durable app settings. Experiments
  default OFF; a critical-alarm flag suppresses trial preparation. Corrupt flags
  fail closed. UI controls will be implemented in the later controls phase.

## Experiment logic

The coordinator checks the current executable stable protocol, fixed settings,
volume cap, sound/task/vibration availability and exact scheduled context before
reserving a variant. Context currently means alarm ID, civil hour/minute,
weekday/weekend and time-zone offset. Broader buckets belong to phase 4D.

Native rejection is recorded without changing the assignment; retrying the same
occurrence reuses it. A manual protocol change or lost capability invalidates the
test. A lowered volume cap resolves a current executable fallback even when a
caller still holds an older protocol object.

An assignment authorizes one occurrence. When native recurrence advances, or
recovery moves an overdue occurrence, Kotlin restores the stable snapshot and
clears experiment metadata. A clock/time-zone change forces the stable choice.
A future unchanged occurrence retains its assignment across reboot. Corrupt
metadata/snapshots fall back to locally packaged audio within the saved cap.

When Flutter resumes, `ExperimentSchedulingService` prepares the next occurrence
for running tests. It also restores stable schedules for paused/revoked pending
trials and never enables a disabled alarm. If this optional step fails, the
native stable recurrence is still armed. This deliberately avoids reusing a
candidate indefinitely while Dart is absent.

Snooze and retry retain the original wake-session identity. They do not create
new experimental samples or overwrite the original occurrence. The initial
native trigger carries the assignment into the outbox; reconciliation verifies
its identity and executed protocol snapshot before attachment. Missing or
mismatched provenance stays in history but receives no experimental credit.

## V3 interaction and instrumentation

V3 automatic changes wait while a ready/running/paused experiment owns an alarm.
Experiment occurrences are excluded from V3 training, sound-trend selection and
revert baselines, including failed attachments. Raw history remains available.
The comparison loop will own these outcomes in 4B.

Finalization requires a completed observable wake, no pending follow-up check,
consistent timing and the original executed snapshot. Bypass is adverse evidence,
not a successful wake. Audit distinguishes reservation, native acceptance or
rejection, attachment, invalidation and completion. Native evidence/usage or
next-occurrence bookkeeping failures cannot prevent starting the current alarm.

## Verification and remaining gates

Local results, 26 October 2026:

- All 150 Flutter tests passed; `dart analyze lib test` reports no issues.
- All 8 Kotlin helper tests passed (5 occurrence-policy and 3 wake-check tests).
- Debug application and debug instrumentation APKs build successfully.
- Four native storage/recovery instrumentation tests compile but could not run.
  The isolated API 36.1 emulator repeatedly crashed in SurfaceFlinger with
  `hasReadColorBufferDma`; streamed installation failed, and non-streamed
  installation reported that the package service was unavailable. No app-test
  assertion ran. The owned emulator was stopped after collecting diagnostics.
- `git diff --check` passed. No physical phone was connected or modified.

Tests cover balanced assignment, three simulated valid sessions per variant,
rejection/replay, snooze continuity, wrong snapshots, critical/disabled flags,
changed context/capabilities/caps, manual edits, provider wiring, app-resume
preparation, cancellation/pause, migration, restart and concurrency. Simulation
is contract evidence, not a claim of six real mornings or observed wake success.

Kotlin helper tests cover unchanged recovery, next-occurrence expiry, clock/zone
changes, corrupt/lost metadata and ordinary snooze behavior. Android
instrumentation tests use separate fixture database names for migration and
assignment persistence, valid stable restoration and corrupt-snapshot fallback.

The complete field gate still requires actual control/candidate alarm execution,
reboot during a trial, audible locked-screen playback, retry enforcement and
representative-phone acceptance. Publishing source does not close that gate or
establish that the remaining V4 phases are complete.
