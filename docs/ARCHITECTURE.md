# Architecture

Ryser separates editable alarm settings from the native runtime that must ring
when Flutter is not running.

## Ownership

Flutter owns alarm editing, mission flows, reports, adaptation rules and the
product database. Riverpod provides application dependencies and observable state;
Drift stores alarms, wake sessions, ordered events, mission/check records,
versioned protocols and evaluations.

Kotlin owns AlarmManager scheduling, alarm receivers, foreground audio playback,
vibration, notification/full-screen presentation, and recovery after reboot,
package replacement or clock changes. It persists schedule snapshots and an event
outbox in a separate native SQLite store. The native and Drift stores never share
the same database file.

Pigeon generates the typed Dart/Kotlin bridge from
`pigeons/alarm_runtime_api.dart`. Flutter reconciles native events into its local
history when available; the alarm trigger path does not depend on Dart starting.

## Wake sessions

A wake session retains the protocol snapshot used when it starts. Snoozes,
mission attempts, delayed Wake Checks and reactivation remain attached to that
session. Editing an alarm changes future settings, not the in-flight snapshot.
Emergency bypass is recorded separately from confirmed success.

The movement and jumping missions process sensor readings in the foreground.
Walking can use permitted foreground location as a fallback. QR matching uses a
registered payload hash and the bundled scanner.

## Adaptation

The coordinator evaluates completed sessions against evidence available at that
session's time. Configurable thresholds and prioritized rules select a bounded
change, subject to the master switch, fixed dimensions, volume cap and resource
validation. Evaluations retain the evidence window, rule trace and explanation.

New protocols have increasing versions and explicit predecessors. A repeated
regression in the targeted metric can produce a recovery version while retaining
the failed version as reverted history. Intensity labels describe configured
burden; they are not measurements of a user's sleep or health.

## Reliability and privacy boundaries

- A native scheduling acknowledgement is required before considering a schedule
  applied. A failed optional adaptation must not suppress the existing alarm.
- One-shot native alarms are rescheduled explicitly; reboot receivers restore
  schedules rather than starting media playback.
- Wake history stays in app-local storage. The release manifest removes network
  permissions and disables cloud backup.
- Android permissions and OEM power management can restrict alarm presentation or
  mission capabilities. Alarm Health reports these limitations.
- Unit/emulator checks cannot establish audible or locked-screen reliability on
  physical devices. Release acceptance includes named-device tests.
