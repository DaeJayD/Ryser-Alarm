import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ryser/app/app_version.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/core/widgets/ryser_panel.dart';
import 'package:ryser/core/widgets/segment_display.dart';
import 'package:ryser/core/widgets/ryser_logo.dart';
import 'package:ryser/features/alarms/domain/alarm.dart';
import 'package:ryser/features/alarms/domain/next_occurrence.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/alarms/presentation/dashboard_providers.dart';

DateTime? dashboardOccurrence(Alarm alarm, DateTime now) {
  try {
    return calculateNextOccurrence(
      now: now,
      hour: alarm.localHour,
      minute: alarm.localMinute,
      recurrenceType: alarm.recurrenceType,
      repeatDaysMask: alarm.repeatDaysMask,
    );
  } on ArgumentError {
    return null;
  }
}

List<Alarm> orderDashboardAlarms(List<Alarm> alarms, DateTime now) =>
    [...alarms]..sort((a, b) {
      if (a.enabled != b.enabled) return a.enabled ? -1 : 1;
      final first = dashboardOccurrence(a, now),
          second = dashboardOccurrence(b, now);
      final result = first == null
          ? (second == null ? 0 : 1)
          : second == null
          ? -1
          : first.compareTo(second);
      return result == 0 ? a.id.compareTo(b.id) : result;
    });

int dashboardDayOffset(DateTime occurrence, DateTime now) => DateTime.utc(
  occurrence.year,
  occurrence.month,
  occurrence.day,
).difference(DateTime.utc(now.year, now.month, now.day)).inDays;

class AlarmDashboard extends ConsumerWidget {
  const AlarmDashboard({
    super.key,
    required this.now,
    required this.alarms,
    required this.onAdd,
    required this.onEdit,
    required this.onToggle,
    required this.onHistory,
    required this.onHealth,
    required this.onSettings,
    this.pendingIds = const {},
    this.clock,
  });
  final DateTime now;
  final ValueListenable<DateTime>? clock;
  final List<Alarm> alarms;
  final VoidCallback onAdd, onHistory, onHealth, onSettings;
  final ValueChanged<Alarm> onEdit;
  final void Function(Alarm, bool) onToggle;
  final Set<String> pendingIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordered = orderDashboardAlarms(alarms, now);
    final eligible = ordered.where(
      (a) => a.enabled && dashboardOccurrence(a, now) != null,
    );
    final nextId = eligible.isEmpty ? null : eligible.first.id;
    return ListView(
      key: const PageStorageKey('alarm-dashboard'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _Header(onSettings: onSettings, onHealth: onHealth),
        const SizedBox(height: 24),
        RepaintBoundary(
          child: clock == null
              ? _Clock(now)
              : ValueListenableBuilder<DateTime>(
                  valueListenable: clock!,
                  builder: (_, value, _) => _Clock(value),
                ),
        ),
        const SizedBox(height: 24),
        _Navigation(
          onHistory: onHistory,
          onHealth: onHealth,
          onSettings: onSettings,
        ),
        const SizedBox(height: 22),
        if (ordered.isEmpty)
          const RyserPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.alarm_add_rounded,
                  color: RyserColors.primary,
                  size: 32,
                ),
                SizedBox(height: 14),
                Text(
                  'Your first wake starts here',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'No alarms yet. Add an alarm, then review Alarm Health before relying on it.',
                  style: TextStyle(
                    color: RyserColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          )
        else ...[
          for (final alarm in ordered) ...[
            _AlarmCard(
              alarm: alarm,
              now: now,
              isNext: alarm.id == nextId,
              onEdit: () => onEdit(alarm),
              onToggle: pendingIds.contains(alarm.id)
                  ? null
                  : (value) => onToggle(alarm, value),
            ),
            const SizedBox(height: 14),
          ],
        ],
        const SizedBox(height: 8),
        _Overview(now: now, onHistory: onHistory),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded, size: 25),
          label: const Text(
            'INITIALIZE NEW ALARM',
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Stored on this device. No account required.',
          textAlign: TextAlign.center,
          style: TextStyle(color: RyserColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.onSettings, required this.onHealth});
  final VoidCallback onSettings, onHealth;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(dashboardHealthProvider);
    final data = health.asData?.value;
    final ready =
        data != null &&
        data.exactAlarmsReady &&
        data.notificationsReady &&
        data.fullScreenReady &&
        data.batteryUnrestricted &&
        data.alarmVolume > 0;
    final status = health.isLoading
        ? 'CHECKING ACCESS'
        : ready
        ? 'ACCESS READY'
        : 'CHECK HEALTH';
    final color = ready
        ? RyserColors.primary
        : health.isLoading
        ? RyserColors.textSecondary
        : RyserColors.warning;
    return RyserPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const RyserLogo(),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Settings',
                onPressed: onSettings,
                icon: const Icon(Icons.settings_outlined, size: 27),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'v${RyserBuild.version}  /  ADAPTIVE ALARM SYSTEM',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              letterSpacing: 1.1,
              color: RyserColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: onHealth,
                icon: Icon(
                  ready ? Icons.check_circle_outline : Icons.shield_outlined,
                  size: 15,
                  color: color,
                ),
                label: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                ),
              ),
              const _Tag(Icons.phonelink_lock_outlined, 'LOCAL ONLY'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Clock extends StatelessWidget {
  const _Clock(this.now);
  final DateTime now;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          final height = (constraints.maxWidth / 3.35).clamp(64.0, 138.0);
          final hours = now.hour.toString().padLeft(2, '0'),
              minutes = now.minute.toString().padLeft(2, '0');
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SegmentDisplay(
                    '$hours:$minutes',
                    height: height,
                    semanticLabel: 'Current time $hours:$minutes',
                  ),
                ),
              ),
              const SizedBox(width: 6),
              ExcludeSemantics(
                child: Text(
                  now.second.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: height * .24,
                    color: RyserColors.primary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Semantics(
                selected: i + 1 == now.weekday,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: i + 1 == now.weekday
                        ? Border.all(color: RyserColors.primaryDim)
                        : null,
                  ),
                  child: Text(
                    const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: i + 1 == now.weekday
                          ? RyserColors.primary
                          : RyserColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ],
  );
}

class _Navigation extends StatelessWidget {
  const _Navigation({
    required this.onHistory,
    required this.onHealth,
    required this.onSettings,
  });
  final VoidCallback onHistory, onHealth, onSettings;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = MediaQuery.textScalerOf(context).scale(11) > 15 ? 2 : 4;
      final items = <(IconData, String, VoidCallback?)>[
        (Icons.alarm_outlined, 'ALARMS', null),
        (Icons.bar_chart_rounded, 'HISTORY', onHistory),
        (Icons.monitor_heart_outlined, 'HEALTH', onHealth),
        (Icons.settings_outlined, 'CONFIG', onSettings),
      ];
      return RyserPanel(
        padding: const EdgeInsets.all(5),
        child: Wrap(
          children: [
            for (var i = 0; i < items.length; i++)
              SizedBox(
                width: (constraints.maxWidth - 10) / columns,
                child: Semantics(
                  selected: i == 0,
                  button: true,
                  child: InkWell(
                    onTap: items[i].$3,
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: i == 0 ? RyserColors.inactive : null,
                        border: i == 0
                            ? Border.all(color: RyserColors.primaryDim)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            items[i].$1,
                            size: 23,
                            color: i == 0
                                ? RyserColors.primary
                                : RyserColors.textSecondary,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            items[i].$2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: i == 0
                                  ? RyserColors.primary
                                  : RyserColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _AlarmCard extends ConsumerWidget {
  const _AlarmCard({
    required this.alarm,
    required this.now,
    required this.isNext,
    required this.onEdit,
    required this.onToggle,
  });
  final Alarm alarm;
  final DateTime now;
  final bool isNext;
  final VoidCallback onEdit;
  final ValueChanged<bool>? onToggle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mission = ref.watch(dashboardMissionProvider(alarm.id));
    final protocol = ref.watch(dashboardProtocolProvider(alarm.id));
    final p = protocol.asData?.value, m = mission.asData?.value;
    final time = TimeOfDay(hour: alarm.localHour, minute: alarm.localMinute);
    final is24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final digits =
        '${is24
            ? time.hour.toString().padLeft(2, '0')
            : time.hourOfPeriod == 0
            ? 12
            : time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')}';
    final occurrence = dashboardOccurrence(alarm, now);
    final dayLabel = occurrence == null
        ? ''
        : switch (dashboardDayOffset(occurrence, now)) {
            0 => 'Today',
            1 => 'Tomorrow',
            _ => MaterialLocalizations.of(context).formatMediumDate(occurrence),
          };
    final type = p != null
        ? (p.missionRequired ? p.missionType : null)
        : m?.enabled == true
        ? m!.missionType
        : null;
    final verification = mission.hasError || protocol.hasError
        ? 'Settings unavailable · open alarm to review'
        : mission.isLoading || protocol.isLoading
        ? 'Loading mission settings'
        : type == null
        ? 'Off · dismiss without a mission'
        : '${switch (type) {
            'movement' => 'Walking mission',
            'jumping' => 'Light-jump mission',
            _ => 'Registered QR code',
          }} · ${p?.wakeCheckRequired == false ? 'No follow-up check' : '${p?.wakeCheckDelayMinutes ?? 5} min Wake Check'}';
    final rising = p?.volumeEscalationEnabled ?? alarm.increasingVolume;
    return RyserPanel(
      key: ValueKey('alarm-card-${alarm.id}'),
      highlighted: isNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Tag(
                      Icons.alarm,
                      isNext
                          ? 'NEXT ALARM'
                          : alarm.enabled
                          ? 'SCHEDULED'
                          : 'DISABLED',
                    ),
                  ],
                ),
              ),
              Semantics(
                label: 'Enable ${alarm.label ?? time.format(context)} alarm',
                child: Switch(value: alarm.enabled, onChanged: onToggle),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Semantics(
            button: true,
            label: 'Edit alarm ${time.format(context)} ${alarm.label ?? ''}',
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: SegmentDisplay(
                                digits,
                                height: (constraints.maxWidth * .24).clamp(
                                  48.0,
                                  82.0,
                                ),
                                semanticLabel: time.format(context),
                              ),
                            ),
                          ),
                          if (!is24)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                bottom: 3,
                              ),
                              child: Text(
                                time.period == DayPeriod.am ? 'AM' : 'PM',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  color: RyserColors.primary,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (alarm.label?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 10),
                      Text(
                        alarm.label!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      !alarm.enabled
                          ? 'Not scheduled'
                          : occurrence == null
                          ? 'Review repeat settings'
                          : '$dayLabel · ${_remaining(occurrence.difference(now))}',
                      style: const TextStyle(
                        color: RyserColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 7,
            runSpacing: 8,
            children: [
              _Tag(
                Icons.calendar_today_outlined,
                formatRecurrence(alarm).toUpperCase(),
              ),
              _Tag(
                Icons.music_note_outlined,
                alarm.ringtoneUri?.startsWith('android.resource:') == true
                    ? 'BUNDLED AUDIO'
                    : 'DEVICE AUDIO',
              ),
              _Tag(
                Icons.snooze_outlined,
                alarm.snoozeEnabled
                    ? '${alarm.snoozeDurationMinutes}M SNOOZE'
                    : 'NO SNOOZE',
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _FeatureRow(
            icon: Icons.music_note_rounded,
            title: alarm.adaptiveSoundRotation
                ? 'Adaptive sound rotation'
                : 'Selected alarm sound',
            subtitle:
                '${p?.initialSoundFamily ?? alarm.ringtoneTitle ?? 'Selected audio'} · ${rising ? 'Progressive volume' : 'Steady volume'}',
            onTap: onEdit,
          ),
          const SizedBox(height: 8),
          _FeatureRow(
            icon: Icons.verified_outlined,
            title: 'Wake-up verification',
            subtitle: verification,
            onTap: onEdit,
          ),
        ],
      ),
    );
  }
}

String _remaining(Duration duration) {
  final minutes = duration.inMinutes;
  if (minutes < 1) return 'in less than a minute';
  if (minutes < 60) return 'in $minutes min';
  return 'in ${minutes ~/ 60}h ${minutes % 60}m';
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: RyserColors.surfaceRaised,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: RyserColors.inactive),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: RyserColors.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: RyserColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              size: 19,
              color: RyserColors.primary,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: RyserColors.muted),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: RyserColors.primaryDim),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              color: RyserColors.textSecondary,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Overview extends ConsumerWidget {
  const _Overview({required this.now, required this.onHistory});
  final DateTime now;
  final VoidCallback onHistory;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(wakeSessionsProvider);
    final sessions = history.asData?.value
        .where(
          (s) =>
              s.triggeredAtMs >=
                  now
                      .subtract(const Duration(days: 7))
                      .millisecondsSinceEpoch &&
              s.triggeredAtMs <= now.millisecondsSinceEpoch &&
              s.completedAtMs != null &&
              !const {
                'active',
                'incomplete',
                'cancelled',
                'bypassed',
                'manualTermination',
              }.contains(s.outcome),
        )
        .toList();
    final latencies =
        sessions
            ?.where(
              (s) => s.responseLatencyMs != null && s.responseLatencyMs! >= 0,
            )
            .map((s) => s.responseLatencyMs!)
            .toList() ??
        [];
    final average = latencies.isEmpty
        ? null
        : latencies.reduce((a, b) => a + b) / latencies.length / 1000;
    final confirmed =
        sessions?.where((s) => s.outcome == 'wakeConfirmed').length ?? 0;
    final count = sessions?.length ?? 0;
    final empty = history.isLoading
        ? 'Loading history'
        : history.hasError
        ? 'History unavailable'
        : 'No completed sessions yet';
    final metrics = <(IconData, String, String)>[
      (
        Icons.timelapse_rounded,
        average == null
            ? '—'
            : average < 60
            ? '${average.toStringAsFixed(0)}s'
            : '${(average / 60).toStringAsFixed(1)}m',
        'Avg response',
      ),
      (
        Icons.verified_outlined,
        count == 0 ? '—' : '${(confirmed / count * 100).round()}%',
        'Confirmed',
      ),
      (Icons.bar_chart_rounded, count == 0 ? '—' : '$count', 'Sessions'),
    ];
    return RyserPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RyserSectionTitle(
            'WAKE OVERVIEW',
            caption: 'Last 7 days · recorded alarm interactions',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 280 ||
                  MediaQuery.textScalerOf(context).scale(12) > 18;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final metric in metrics)
                    SizedBox(
                      width: stacked
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: RyserColors.inactive),
                          color: RyserColors.surfaceRaised,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              metric.$1,
                              size: 23,
                              color: RyserColors.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              metric.$2,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              metric.$3,
                              style: const TextStyle(
                                fontSize: 11,
                                color: RyserColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            count == 0 ? empty : 'Confirmed means a recorded wake confirmation, not measured sleep.',
            style: const TextStyle(
              color: RyserColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
