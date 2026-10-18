import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/app/theme/ryser_spacing.dart';
import 'package:ryser/core/widgets/ryser_panel.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/wake_enforcement/data/wake_mission_bridge.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmHealthScreen extends ConsumerStatefulWidget {
  const AlarmHealthScreen({super.key});

  @override
  ConsumerState<AlarmHealthScreen> createState() => _AlarmHealthScreenState();
}

class _AlarmHealthScreenState extends ConsumerState<AlarmHealthScreen>
    with WidgetsBindingObserver {
  late Future<_HealthSnapshot> _health;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) setState(_refresh);
  }

  void _refresh() {
    _health = _loadHealth();
  }

  Future<_HealthSnapshot> _loadHealth() async {
    final native = await ref.read(alarmRuntimeGatewayProvider).getAlarmHealth();
    final mission = await WakeMissionBridge().getMissionHealth();
    final database = ref.read(appDatabaseProvider);
    final configured = await database.select(database.missions).get();
    final alarms = await database.select(database.alarms).get();
    final protocols = await database.select(database.wakeProtocols).get();
    final policy = await database
        .select(database.alarmAdaptationSettings)
        .get();
    final repository = ref.read(wakeProtocolRepositoryProvider);
    final readyAlarmIds = <String>{};
    for (final row in protocols.where((p) => p.status == 'active')) {
      try {
        final protocol = await repository.findById(row.id);
        if (protocol != null && await repository.isValid(protocol)) {
          readyAlarmIds.add(row.alarmId);
        }
      } catch (_) {
        /* Show an actionable warning for unreadable protocols. */
      }
    }
    final missing = alarms
        .where((item) => item.enabled && !readyAlarmIds.contains(item.id))
        .length;
    final adaptive = policy.where((item) => item.enabled).length;
    final qrReady = configured
        .where((item) => item.enabled && item.missionType == 'qr')
        .every((item) {
          try {
            final json =
                jsonDecode(item.configurationJson) as Map<String, dynamic>;
            return (json['payloadHash'] as String?)?.isNotEmpty == true &&
                (json['locationLabel'] as String?)?.isNotEmpty == true;
          } catch (_) {
            return false;
          }
        });
    return _HealthSnapshot(native, mission, qrReady, missing, adaptive);
  }

  @override
  Widget build(BuildContext context) {
    final runtime = ref.read(alarmRuntimeGatewayProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALARM HEALTH'),
        actions: [
          IconButton(
            tooltip: 'Refresh alarm health',
            onPressed: () => setState(_refresh),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<_HealthSnapshot>(
        future: _health,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: RyserPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: RyserColors.warning,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Alarm readiness could not be checked.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => setState(_refresh),
                        child: const Text('TRY AGAIN'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final snapshotHealth = snapshot.data;
          if (snapshotHealth == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final health = snapshotHealth.native;
          final mission = snapshotHealth.mission;
          return ListView(
            padding: const EdgeInsets.all(RyserSpacing.md),
            children: [
              const RyserSectionTitle(
                'SYSTEM READINESS',
                caption: 'Android access and sound settings. Readiness does not guarantee an audible alarm on every device.',
              ),
              const SizedBox(height: RyserSpacing.md),
              _HealthRow(
                'EXACT ALARMS',
                health.exactAlarmsReady,
                runtime.openExactAlarmSettings,
              ),
              _HealthRow(
                'NOTIFICATIONS',
                health.notificationsReady,
                runtime.openNotificationSettings,
              ),
              _HealthRow(
                'FULL-SCREEN ALARM',
                health.fullScreenReady,
                runtime.openFullScreenSettings,
              ),
              _HealthRow(
                'BATTERY ACCESS',
                health.batteryUnrestricted,
                runtime.openBatterySettings,
              ),
              _HealthRow(
                'ALARM VOLUME  ${health.alarmVolume}/${health.alarmVolumeMax}',
                health.alarmVolume > 0,
                runtime.openAlarmVolumeSettings,
              ),
              const SizedBox(height: RyserSpacing.md),
              const Text(
                '> MISSION READINESS',
                style: TextStyle(
                  color: RyserColors.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: RyserSpacing.sm),
              _HealthRow(
                'CAMERA HARDWARE',
                mission.cameraAvailable,
                openAppSettings,
              ),
              _HealthRow(
                'CAMERA ACCESS',
                mission.cameraPermission,
                openAppSettings,
              ),
              _HealthRow(
                'QR REGISTRATION',
                snapshotHealth.qrConfigured,
                openAppSettings,
              ),
              _HealthRow(
                'DEDICATED STEP SENSOR',
                mission.stepSensorAvailable,
                openAppSettings,
              ),
              _HealthRow(
                'ACTIVITY ACCESS',
                mission.activityPermission,
                openAppSettings,
              ),
              const SizedBox(height: RyserSpacing.md),
              const Text(
                '> ADAPTIVE WAKE',
                style: TextStyle(
                  color: RyserColors.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: RyserSpacing.sm),
              _HealthRow(
                'ENABLED ALARMS WITHOUT A SOUND PROTOCOL: ${snapshotHealth.missingProtocols}',
                snapshotHealth.missingProtocols == 0,
                null,
              ),
              Text(
                'Adaptive Wake enabled on ${snapshotHealth.adaptiveAlarms} alarms. '
                'A protocol warning does not mean the native alarm is disabled; '
                'check its sound and resave the alarm.',
                style: const TextStyle(color: RyserColors.textSecondary),
              ),
              if (!health.batteryUnrestricted) ...[
                const SizedBox(height: RyserSpacing.lg),
                const Text(
                  'Battery restrictions may prevent Ryser from waking you reliably.',
                  style: TextStyle(color: RyserColors.critical, height: 1.5),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _HealthSnapshot {
  const _HealthSnapshot(
    this.native,
    this.mission,
    this.qrConfigured,
    this.missingProtocols,
    this.adaptiveAlarms,
  );

  final AlarmHealthDto native;
  final MissionHealth mission;
  final bool qrConfigured;
  final int missingProtocols;
  final int adaptiveAlarms;
}

class _HealthRow extends StatelessWidget {
  const _HealthRow(this.label, this.ready, this.onTap);
  final String label;
  final bool ready;
  final Future<void> Function()? onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: RyserPanel(
      accent: ready
          ? RyserColors.muted
          : RyserColors.warning.withValues(alpha: .55),
      onTap: onTap == null
          ? null
          : () async {
              try {
                await onTap!();
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Settings could not be opened. Open Android settings manually.',
                      ),
                    ),
                  );
                }
              }
            },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ready ? Icons.check_circle_outline : Icons.info_outline,
            color: ready ? RyserColors.primary : RyserColors.warning,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  ready ? 'Ready' : 'Needs review',
                  style: TextStyle(
                    color: ready ? RyserColors.primaryDim : RyserColors.warning,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(
              Icons.chevron_right,
              color: RyserColors.textSecondary,
              size: 18,
            ),
        ],
      ),
    ),
  );
}
