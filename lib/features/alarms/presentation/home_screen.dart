import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/core/widgets/ryser_panel.dart';
import 'package:ryser/features/alarms/presentation/alarm_dashboard.dart';
import 'package:ryser/features/alarms/presentation/dashboard_providers.dart';
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

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  final Set<String> _pendingIds = {};
  late DateTime _now;
  late final ValueNotifier<DateTime> _clock;
  bool _routeVisible = true;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _now = DateTime.now();
    _clock = ValueNotifier(_now);
    _startClock();
  }

  void _startClock() {
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_routeVisible) return;
      final now = DateTime.now();
      _clock.value = now;
      // Only time-dependent card labels need a minute-level refresh.
      if (now.millisecondsSinceEpoch ~/ 60000 !=
          _now.millisecondsSinceEpoch ~/ 60000) {
        setState(() => _now = now);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeVisible = TickerMode.valuesOf(context).enabled;
    if (_routeVisible) {
      _now = DateTime.now();
      _clock.value = _now;
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _clock.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(dashboardHealthProvider);
      setState(() => _now = DateTime.now());
      _clock.value = _now;
      _startClock();
    } else {
      _clockTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(alarmsProvider);
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: alarms.when(
              data: (items) => AlarmDashboard(
                now: _now,
                clock: _clock,
                alarms: items,
                pendingIds: _pendingIds,
                onAdd: () => _openEditor(context),
                onEdit: (alarm) => _openEditor(context, alarm),
                onToggle: _setEnabled,
                onHistory: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WakeHistoryScreen(),
                  ),
                ),
                onHealth: () => Navigator.of(context)
                    .push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AlarmHealthScreen(),
                      ),
                    )
                    .then((_) => ref.invalidate(dashboardHealthProvider)),
                onSettings: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: RyserPanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Alarms could not be loaded.'),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => ref.invalidate(alarmsProvider),
                          child: const Text('TRY AGAIN'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, [Alarm? alarm]) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => AlarmEditorScreen(alarm: alarm)),
    );
  }

  Future<void> _setEnabled(Alarm alarm, bool enabled) async {
    if (_pendingIds.contains(alarm.id)) return;
    setState(() => _pendingIds.add(alarm.id));
    try {
      await _applyEnabled(alarm, enabled);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Alarm change could not be saved. Review Alarm Health and try again.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _pendingIds.remove(alarm.id));
        ref.invalidate(dashboardHealthProvider);
      }
    }
  }

  Future<void> _applyEnabled(Alarm alarm, bool enabled) async {
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
