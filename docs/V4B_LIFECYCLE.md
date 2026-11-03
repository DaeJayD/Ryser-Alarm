# V4B.2: saved decisions and stable-alarm recovery

Development implementation, not a release or device acceptance. Experiments
remain off by default. Automatic candidate promotion and visible controls are
still pending.

`ExperimentLifecycleService` recomputes a comparison inside the same Drift
transaction that saves its result and status. It appends `comparisonApplied`
and `stableRestoreRequested` together. An audit failure rolls back the entire
decision, including revoked future reservations. Finished evidence and linked,
in-flight wake sessions are not rewritten. Ordinary winner/tie conclusions end
the test; a candidate safety stop ends it without a winner; serious control
failure or exhausted incomplete evidence pauses it for review. Replaying a
finished/paused decision makes no duplicate writes.

The stored winner ID is comparison provenance only. It does not activate a
protocol or make that choice the next alarm sound.

The append-only audit is also a durable restoration outbox. Recovery resolves
the current executable stable plan and current volume cap, schedules a future
occurrence without experiment preparation, then appends native acceptance.
Rejected calls, exceptions and failed acceptance audits leave a retryable
request across restarts. Disabled/deleted alarms receive an explicit skipped
record, never a successful scheduling claim. Active wake flows defer recovery;
their current sound, snooze, task and snapshot are not replaced by this service.

Pending recovery blocks new reservations, experimental preparation, ordinary
experiment rearming and V3 automatic changes for that alarm. App resumption
imports native evidence, finalizes sessions, applies decisions, retries recovery,
then performs optional adaptation/scheduling before opening the pending mission.
If native import, session reconciliation or lifecycle processing fails, recovery
and optional new preparation are skipped for that pass; mission handling remains
available. Recovery also defers if the executable protocol changes during
validation, so an older snapshot cannot overwrite a new manual choice.

No database schema, Pigeon contract or native trigger/playback code changed.
This is app-resume orchestration, not an always-running background safety
controller. Immediate enforcement while Dart is absent, all cross-process
edit/scheduling races and representative-device behavior remain acceptance work.
Do not enable experiments broadly based only on unit tests.

Tests cover atomic rollback, duplicate/concurrent processing, ties, sample caps,
safety stops, future reservation revocation, unchanged active wakes, native
false/throw, acknowledgement failure, deleted/disabled alarms, lowered caps,
malformed acknowledgements, restart recovery and provider construction. Native
instrumentation remains blocked by the previously recorded emulator graphics
failure. See [comparison policy](V4B_COMPARISON.md) and [testing](TESTING.md).

The development build identity is **3.0.5-dev.1 (8)**. The current source passed
208 Flutter tests, including 22 lifecycle/recovery tests. Regression coverage
includes a settings edit during validation and failed native import while
mission handling remains reachable. The full 208-test run completed after the
earlier interrupted delivery attempt; native/device acceptance remains separate.
