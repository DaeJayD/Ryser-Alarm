import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/app/theme/ryser_spacing.dart';
import 'package:ryser/features/alarms/domain/alarm.dart';
import 'package:ryser/features/alarms/domain/next_occurrence.dart';
import 'package:ryser/features/alarms/presentation/alarm_editor_screen.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/wake_sessions/presentation/wake_history_screen.dart';
import 'package:ryser/features/alarm_health/presentation/alarm_health_screen.dart';
import 'package:ryser/features/settings/presentation/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime _now;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(alarmsProvider);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: alarms.when(
              data: (items) => _TerminalHome(
                now: _now,
                alarms: items,
                onAdd: () => _openEditor(context),
                onEdit: (alarm) => _openEditor(context, alarm),
                onToggle: (alarm, enabled) => _setEnabled(alarm, enabled),
                onHistory: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WakeHistoryScreen(),
                  ),
                ),
                onHealth: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AlarmHealthScreen(),
                  ),
                ),
                onSettings: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
              loading: () => const _LoadingState(),
              error: (_, _) =>
                  _LoadError(onRetry: () => ref.invalidate(alarmsProvider)),
            ),
          ),
          const Positioned.fill(child: _ScanlineOverlay()),
        ],
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, [Alarm? alarm]) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => AlarmEditorScreen(alarm: alarm)),
    );
  }

  Future<void> _setEnabled(Alarm alarm, bool enabled) async {
    final runtime = ref.read(alarmRuntimeGatewayProvider);
    if (enabled) {
      final next = calculateNextOccurrence(
        now: DateTime.now(),
        hour: alarm.localHour,
        minute: alarm.localMinute,
        recurrenceType: alarm.recurrenceType,
        repeatDaysMask: alarm.repeatDaysMask,
      );
      final result = await runtime.schedule(
        alarmId: alarm.id,
        triggerAt: next,
        label: alarm.label ?? '',
        ringtoneUri: alarm.ringtoneUri ?? '',
        vibrationEnabled: alarm.vibrationEnabled,
        snoozeEnabled: alarm.snoozeEnabled,
        snoozeDurationMinutes: alarm.snoozeDurationMinutes,
        adaptiveSoundRotation: alarm.adaptiveSoundRotation,
        increasingVolume: alarm.increasingVolume,
        localHour: alarm.localHour,
        localMinute: alarm.localMinute,
        recurrenceType: alarm.recurrenceType.name,
        repeatDaysMask: alarm.repeatDaysMask,
        protocol: await ref
            .read(wakeProtocolRepositoryProvider)
            .ensureDefault(alarm.id),
      );
      if (!result.scheduled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Alarm could not be enabled.'),
            ),
          );
        }
        return;
      }
    } else {
      await runtime.cancel(alarm.id);
    }
    final now = DateTime.now();
    await ref
        .read(alarmRepositoryProvider)
        .save(
          Alarm(
            id: alarm.id,
            localHour: alarm.localHour,
            localMinute: alarm.localMinute,
            label: alarm.label,
            enabled: enabled,
            recurrenceType: alarm.recurrenceType,
            repeatDaysMask: alarm.repeatDaysMask,
            soundId: alarm.soundId,
            ringtoneUri: alarm.ringtoneUri,
            ringtoneTitle: alarm.ringtoneTitle,
            adaptiveSoundRotation: alarm.adaptiveSoundRotation,
            increasingVolume: alarm.increasingVolume,
            vibrationEnabled: alarm.vibrationEnabled,
            snoozeEnabled: alarm.snoozeEnabled,
            snoozeDurationMinutes: alarm.snoozeDurationMinutes,
            definitionRevision: alarm.definitionRevision + 1,
            createdAt: alarm.createdAt,
            updatedAt: now,
          ),
        );
  }
}

class _TerminalHome extends StatelessWidget {
  const _TerminalHome({
    required this.now,
    required this.alarms,
    required this.onAdd,
    required this.onEdit,
    required this.onToggle,
    required this.onHistory,
    required this.onHealth,
    required this.onSettings,
  });

  final DateTime now;
  final List<Alarm> alarms;
  final VoidCallback onAdd;
  final ValueChanged<Alarm> onEdit;
  final void Function(Alarm alarm, bool enabled) onToggle;
  final VoidCallback onHistory;
  final VoidCallback onHealth;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final nextAlarm = _findNextAlarm(now, alarms);

    return Column(
      children: [
        const _SystemHeader(),
        _ClockPanel(now: now, nextAlarm: nextAlarm),
        _ModeStrip(
          onHistory: onHistory,
          onHealth: onHealth,
          onSettings: onSettings,
        ),
        Expanded(
          child: alarms.isEmpty
              ? const _EmptyState()
              : _AlarmList(alarms: alarms, onEdit: onEdit, onToggle: onToggle),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            RyserSpacing.md,
            RyserSpacing.xs,
            RyserSpacing.md,
            RyserSpacing.md,
          ),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('INITIALIZE NEW ALARM'),
            ),
          ),
        ),
      ],
    );
  }

  static _NextAlarm? _findNextAlarm(DateTime now, List<Alarm> alarms) {
    _NextAlarm? next;
    for (final alarm in alarms) {
      if (!alarm.enabled) continue;
      final occurrence = calculateNextOccurrence(
        now: now,
        hour: alarm.localHour,
        minute: alarm.localMinute,
        recurrenceType: alarm.recurrenceType,
        repeatDaysMask: alarm.repeatDaysMask,
      );
      if (next == null || occurrence.isBefore(next.occurrence)) {
        next = _NextAlarm(alarm, occurrence);
      }
    }
    return next;
  }
}

class _SystemHeader extends StatelessWidget {
  const _SystemHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        RyserSpacing.md,
        RyserSpacing.sm,
        RyserSpacing.md,
        RyserSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: RyserColors.inactive)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RYSER // ADAPTIVE ALARM',
                  style: TextStyle(
                    color: RyserColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'v3.0.2 — ADAPTIVE SYSTEM ONLINE',
                  style: TextStyle(
                    color: RyserColors.primaryDim,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              children: [
                _StatusDot(),
                SizedBox(width: 7),
                Text(
                  'LOCAL',
                  style: TextStyle(
                    color: RyserColors.primaryDim,
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: RyserColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: RyserColors.primary, blurRadius: 8, spreadRadius: 1),
        ],
      ),
    );
  }
}

class _ClockPanel extends StatelessWidget {
  const _ClockPanel({required this.now, required this.nextAlarm});

  final DateTime now;
  final _NextAlarm? nextAlarm;

  @override
  Widget build(BuildContext context) {
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    final seconds = now.second.toString().padLeft(2, '0');
    const weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        RyserSpacing.md,
        RyserSpacing.xl,
        RyserSpacing.md,
        RyserSpacing.lg,
      ),
      child: Column(
        children: [
          Semantics(
            label: 'Current time $hours $minutes and $seconds seconds',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$hours:$minutes',
                  style: const TextStyle(
                    color: RyserColors.primary,
                    fontSize: 64,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(color: RyserColors.primary, blurRadius: 18),
                      Shadow(color: RyserColors.primaryDim, blurRadius: 5),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 6),
                  child: Text(
                    seconds,
                    style: const TextStyle(
                      color: RyserColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(color: RyserColors.primary, blurRadius: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: RyserSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 0; index < weekdays.length; index++) ...[
                Text(
                  weekdays[index],
                  style: TextStyle(
                    color: index + 1 == now.weekday
                        ? RyserColors.primary
                        : RyserColors.muted,
                    fontSize: 9,
                    fontWeight: index + 1 == now.weekday
                        ? FontWeight.w800
                        : FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
                if (index != weekdays.length - 1)
                  const SizedBox(width: RyserSpacing.xs),
              ],
            ],
          ),
          const SizedBox(height: RyserSpacing.md),
          if (nextAlarm == null)
            const Text(
              'NEXT ALARM  --:--  [STANDBY]',
              style: TextStyle(
                color: RyserColors.primaryDim,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            )
          else
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'NEXT ALARM  '),
                  TextSpan(
                    text: _formatTime(nextAlarm!.occurrence),
                    style: const TextStyle(
                      color: RyserColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(text: '  [${nextAlarm!.alarm.label ?? 'READY'}]'),
                ],
              ),
              style: const TextStyle(
                color: RyserColors.primaryDim,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}

class _ModeStrip extends StatelessWidget {
  const _ModeStrip({
    required this.onHistory,
    required this.onHealth,
    required this.onSettings,
  });

  final VoidCallback onHistory;
  final VoidCallback onHealth;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: const BoxDecoration(
        color: RyserColors.surface,
        border: Border(
          top: BorderSide(color: RyserColors.muted),
          bottom: BorderSide(color: RyserColors.muted),
        ),
      ),
      child: Row(
        children: [
          const _ModeItem(label: 'ALARMS', active: true),
          _ModeItem(label: 'HISTORY', onTap: onHistory),
          _ModeItem(label: 'HEALTH', onTap: onHealth),
          _ModeItem(label: 'CONFIG', onTap: onSettings),
        ],
      ),
    );
  }
}

class _ModeItem extends StatelessWidget {
  const _ModeItem({required this.label, this.active = false, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? RyserColors.inactive.withValues(alpha: 0.45) : null,
            border: active
                ? const Border(
                    bottom: BorderSide(color: RyserColors.primary, width: 2),
                  )
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? RyserColors.primary : RyserColors.muted,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(RyserSpacing.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(RyserSpacing.lg),
        decoration: BoxDecoration(
          color: RyserColors.surface.withValues(alpha: 0.55),
          border: Border.all(color: RyserColors.muted),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '> ALARM REGISTRY EMPTY',
              style: TextStyle(
                color: RyserColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: RyserSpacing.sm),
            Text(
              'NO WAKE SEQUENCE CONFIGURED.\nINITIALIZE AN ALARM TO BEGIN.',
              style: TextStyle(
                color: RyserColors.textSecondary,
                fontSize: 11,
                height: 1.6,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlarmList extends StatelessWidget {
  const _AlarmList({
    required this.alarms,
    required this.onEdit,
    required this.onToggle,
  });

  final List<Alarm> alarms;
  final ValueChanged<Alarm> onEdit;
  final void Function(Alarm alarm, bool enabled) onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(RyserSpacing.sm),
      itemCount: alarms.length,
      separatorBuilder: (_, _) => const SizedBox(height: RyserSpacing.sm),
      itemBuilder: (context, index) => _AlarmModule(
        alarm: alarms[index],
        isNext: index == 0,
        onTap: () => onEdit(alarms[index]),
        onToggle: (enabled) => onToggle(alarms[index], enabled),
      ),
    );
  }
}

class _AlarmModule extends StatelessWidget {
  const _AlarmModule({
    required this.alarm,
    required this.isNext,
    required this.onTap,
    required this.onToggle,
  });

  final Alarm alarm;
  final bool isNext;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay(
      hour: alarm.localHour,
      minute: alarm.localMinute,
    ).format(context);

    return Semantics(
      button: true,
      label: 'Edit alarm $time ${alarm.label ?? ''}',
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(RyserSpacing.md),
          decoration: BoxDecoration(
            color: RyserColors.surface.withValues(alpha: 0.72),
            border: Border.all(
              color: isNext ? RyserColors.primary : RyserColors.muted,
            ),
            boxShadow: isNext
                ? const [
                    BoxShadow(
                      color: Color(0x3300FF41),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: RyserSpacing.xs,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: RyserColors.primary),
                    ),
                    child: Text(
                      isNext ? '> NEXT ALARM' : '> SCHEDULED',
                      style: const TextStyle(
                        color: RyserColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Switch.adaptive(value: alarm.enabled, onChanged: onToggle),
                ],
              ),
              const SizedBox(height: RyserSpacing.sm),
              if (alarm.label != null)
                Text(
                  alarm.label!.toUpperCase(),
                  style: const TextStyle(
                    color: RyserColors.primaryDim,
                    fontSize: 10,
                    letterSpacing: 1.6,
                  ),
                ),
              const SizedBox(height: RyserSpacing.xs),
              Text(
                time,
                style: const TextStyle(
                  color: RyserColors.primary,
                  fontSize: 38,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: RyserColors.primary, blurRadius: 12)],
                ),
              ),
              const SizedBox(height: RyserSpacing.sm),
              Text(
                '${formatRecurrence(alarm).toUpperCase()}  //  '
                '${alarm.soundId.toUpperCase()}  //  '
                '${alarm.snoozeEnabled ? '${alarm.snoozeDurationMinutes}M SNOOZE' : 'NO SNOOZE'}',
                style: const TextStyle(
                  color: RyserColors.textSecondary,
                  fontSize: 9,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '> LOADING LOCAL REGISTRY…',
        style: TextStyle(color: RyserColors.primary, letterSpacing: 1.2),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '> REGISTRY READ FAILURE',
            style: TextStyle(
              color: RyserColors.critical,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: RyserSpacing.md),
          OutlinedButton(onPressed: onRetry, child: const Text('RETRY READ')),
        ],
      ),
    );
  }
}

class _ScanlineOverlay extends StatelessWidget {
  const _ScanlineOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _ScanlinePainter()));
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0800FF41)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NextAlarm {
  const _NextAlarm(this.alarm, this.occurrence);

  final Alarm alarm;
  final DateTime occurrence;
}

String _formatTime(DateTime value) {
  return '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}
