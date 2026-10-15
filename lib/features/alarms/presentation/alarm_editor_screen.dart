import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ryser/features/adaptive_wake/presentation/wake_protocol_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/app/theme/ryser_spacing.dart';
import 'package:ryser/features/alarms/domain/alarm.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/presentation/adaptive_explanation_screen.dart';
import 'package:ryser/features/sounds/domain/bundled_sound_catalog.dart';
import 'package:ryser/features/alarms/domain/next_occurrence.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/missions/domain/mission.dart';
import 'package:ryser/features/qr_mission/presentation/qr_scanner_screen.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:uuid/uuid.dart';

class AlarmEditorScreen extends ConsumerStatefulWidget {
  const AlarmEditorScreen({super.key, this.alarm});

  final Alarm? alarm;

  @override
  ConsumerState<AlarmEditorScreen> createState() => _AlarmEditorScreenState();
}

class _AlarmEditorScreenState extends ConsumerState<AlarmEditorScreen> {
  late TimeOfDay _time;
  late TextEditingController _labelController;
  late TextEditingController _snoozeDurationController;
  late AlarmRecurrenceType _recurrenceType;
  late int _repeatDaysMask;
  late bool _vibrationEnabled;
  late bool _adaptiveSoundRotation;
  late bool _increasingVolume;
  late bool _snoozeEnabled;
  late int _snoozeDurationMinutes;
  List<RingtoneDto> _ringtones = const [];
  String? _ringtoneUri;
  String? _ringtoneTitle;
  bool _loadingRingtones = true;
  bool _saving = false;
  bool _wakeEnforcementEnabled = false;
  MissionType _missionType = MissionType.qr;
  int _movementSteps = 20;
  int _requiredJumps = 10;
  int _wakeCheckDelayMinutes = 5;
  String? _qrPayloadHash;
  String? _qrLocationLabel;
  String? _error;
  bool _adaptiveWakeEnabled = false;
  bool _adaptSound = true;
  bool _adaptVolume = true;
  bool _adaptVibration = true;
  bool _adaptWakeCheck = true;
  bool _adaptMission = false;
  int _userMaxVolumePercent = 90;
  WakeProtocol? _activeProtocol;
  bool _resetLearningRequested = false;

  @override
  void initState() {
    super.initState();
    final alarm = widget.alarm;
    _time = alarm == null
        ? TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 5)))
        : TimeOfDay(hour: alarm.localHour, minute: alarm.localMinute);
    _labelController = TextEditingController(text: alarm?.label ?? '');
    _recurrenceType = alarm?.recurrenceType ?? AlarmRecurrenceType.oneTime;
    _repeatDaysMask = alarm?.repeatDaysMask ?? 0;
    _vibrationEnabled = alarm?.vibrationEnabled ?? true;
    _adaptiveSoundRotation = alarm?.adaptiveSoundRotation ?? true;
    _increasingVolume = alarm?.increasingVolume ?? false;
    _snoozeEnabled = alarm?.snoozeEnabled ?? true;
    _snoozeDurationMinutes = alarm?.snoozeDurationMinutes ?? 5;
    _snoozeDurationController = TextEditingController(
      text: _snoozeDurationMinutes.toString(),
    );
    _ringtoneUri = alarm?.ringtoneUri;
    _ringtoneTitle = alarm?.ringtoneTitle;
    _loadRingtones();
    _loadMission();
    _loadAdaptiveWake();
    if (alarm == null) _loadDefaults();
  }

  Future<void> _loadAdaptiveWake() async {
    final alarm = widget.alarm;
    if (alarm == null) return;
    final repository = ref.read(wakeProtocolRepositoryProvider);
    final policy = await repository.policyForAlarm(alarm.id);
    final protocol = await repository.activeForAlarm(alarm.id);
    if (!mounted) return;
    setState(() {
      _adaptiveWakeEnabled = policy.enabled;
      _adaptSound = policy.sound == AdaptiveMode.adaptive;
      _adaptVolume = policy.volume == AdaptiveMode.adaptive;
      _adaptVibration = policy.vibration == AdaptiveMode.adaptive;
      _adaptWakeCheck = policy.wakeCheck == AdaptiveMode.adaptive;
      _adaptMission = policy.mission == AdaptiveMode.adaptive;
      _userMaxVolumePercent = policy.userMaxVolumePercent;
      _activeProtocol = protocol;
    });
  }

  Future<void> _loadMission() async {
    final alarm = widget.alarm;
    if (alarm == null) return;
    final mission = await ref
        .read(missionRepositoryProvider)
        .findByAlarmId(alarm.id);
    if (!mounted || mission == null) return;
    final configuration =
        jsonDecode(mission.configurationJson) as Map<String, dynamic>;
    setState(() {
      _wakeEnforcementEnabled = mission.enabled;
      _missionType = mission.type;
      _qrPayloadHash = configuration['payloadHash'] as String?;
      _qrLocationLabel = configuration['locationLabel'] as String?;
      _movementSteps = configuration['requiredSteps'] as int? ?? 20;
      _requiredJumps = configuration['requiredJumps'] as int? ?? 10;
      _wakeCheckDelayMinutes =
          configuration['wakeCheckDelayMinutes'] as int? ?? 5;
    });
  }

  Future<void> _registerQr() async {
    final registration = await Navigator.of(context).push<QrRegistration>(
      MaterialPageRoute(builder: (_) => const QrScannerScreen.registration()),
    );
    if (!mounted || registration == null) return;
    setState(() {
      _qrPayloadHash = registration.payloadHash;
      _qrLocationLabel = registration.locationLabel;
      _wakeEnforcementEnabled = true;
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _snoozeDurationController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(context: context, initialTime: _time);
    if (selected != null) setState(() => _time = selected);
  }

  Future<void> _loadRingtones() async {
    try {
      final ringtones = await ref
          .read(alarmRuntimeGatewayProvider)
          .getAlarmRingtones();
      if (!mounted) return;
      setState(() {
        _ringtones = ringtones;
        final selectedStillExists = ringtones.any(
          (ringtone) => ringtone.uri == _ringtoneUri,
        );
        if (!selectedStillExists && ringtones.isNotEmpty) {
          _ringtoneUri = ringtones.first.uri;
          _ringtoneTitle = ringtones.first.title;
        }
        _loadingRingtones = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingRingtones = false;
          _error = 'Device ringtones could not be loaded.';
        });
      }
    }
  }

  Future<void> _loadDefaults() async {
    try {
      final defaults = await ref.read(appDefaultsRepositoryProvider).load();
      if (!mounted) return;
      setState(() {
        _snoozeDurationMinutes = defaults.snoozeDurationMinutes;
        _snoozeDurationController.text = defaults.snoozeDurationMinutes
            .toString();
        _vibrationEnabled = defaults.vibrationEnabled;
        _adaptiveSoundRotation = defaults.adaptiveSoundRotation;
      });
    } catch (_) {
      // Built-in defaults remain valid if settings cannot be read.
    }
  }

  Future<void> _browseAudioFile() async {
    try {
      final selected = await ref
          .read(alarmRuntimeGatewayProvider)
          .pickAudioFile();
      if (!mounted || selected == null) return;
      setState(() {
        _ringtoneUri = selected.uri;
        _ringtoneTitle = selected.title;
        _ringtones = [
          selected,
          ..._ringtones.where((item) => item.uri != selected.uri),
        ];
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'The selected audio file could not be opened.');
      }
    }
  }

  Future<void> _save() async {
    if (_recurrenceType == AlarmRecurrenceType.selectedWeekdays &&
        _repeatDaysMask == 0) {
      setState(() => _error = 'Choose at least one repeat day.');
      return;
    }
    if (_wakeEnforcementEnabled &&
        _missionType == MissionType.qr &&
        (_qrPayloadHash == null || _qrLocationLabel == null)) {
      setState(
        () => _error = 'Register a QR code before enabling Wake Enforcement.',
      );
      return;
    }
    if (_snoozeEnabled) {
      final duration = int.tryParse(_snoozeDurationController.text.trim());
      if (duration == null || duration < 1 || duration > 60) {
        setState(
          () => _error = 'Snooze duration must be from 1 to 60 minutes.',
        );
        return;
      }
      _snoozeDurationMinutes = duration;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final now = DateTime.now();
    final existing = widget.alarm;
    if (_ringtoneUri == null || _ringtoneTitle == null) {
      setState(() {
        _saving = false;
        _error = 'Choose a valid device ringtone.';
      });
      return;
    }
    final alarmId = existing?.id ?? const Uuid().v4();
    final nextOccurrence = calculateNextOccurrence(
      now: now,
      hour: _time.hour,
      minute: _time.minute,
      recurrenceType: _recurrenceType,
      repeatDaysMask: _repeatDaysMask,
    );
    final runtime = ref.read(alarmRuntimeGatewayProvider);
    final canNotify = await runtime.canPostNotifications();
    if (!canNotify) {
      await runtime.requestNotificationPermission();
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Allow notifications, then tap SAVE ALARM again.';
        });
      }
      return;
    }
    final canSchedule = await runtime.canScheduleExactAlarms();
    if (!canSchedule) {
      await runtime.openExactAlarmSettings();
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Allow Alarms & reminders, then tap SAVE ALARM again.';
        });
      }
      return;
    }
    final applyResult = await runtime.schedule(
      alarmId: alarmId,
      triggerAt: nextOccurrence,
      label: _labelController.text.trim(),
      ringtoneUri: _ringtoneUri!,
      vibrationEnabled: _vibrationEnabled,
      snoozeEnabled: _snoozeEnabled,
      snoozeDurationMinutes: _snoozeDurationMinutes,
      adaptiveSoundRotation: _adaptiveSoundRotation,
      increasingVolume: _increasingVolume,
      localHour: _time.hour,
      localMinute: _time.minute,
      recurrenceType: _recurrenceType.name,
      repeatDaysMask: _recurrenceType == AlarmRecurrenceType.selectedWeekdays
          ? _repeatDaysMask
          : 0,
    );
    if (!applyResult.scheduled) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = applyResult.message ?? 'Android rejected this alarm.';
        });
      }
      return;
    }
    final alarm = Alarm(
      id: alarmId,
      localHour: _time.hour,
      localMinute: _time.minute,
      label: _labelController.text.trim().isEmpty
          ? null
          : _labelController.text.trim(),
      enabled: true,
      recurrenceType: _recurrenceType,
      repeatDaysMask: _recurrenceType == AlarmRecurrenceType.selectedWeekdays
          ? _repeatDaysMask
          : 0,
      soundId: BundledSoundCatalog.byUri(_ringtoneUri)?.id ?? 'device-custom',
      ringtoneUri: _ringtoneUri,
      ringtoneTitle: _ringtoneTitle,
      adaptiveSoundRotation: _adaptiveSoundRotation,
      increasingVolume: _increasingVolume,
      vibrationEnabled: _vibrationEnabled,
      snoozeEnabled: _snoozeEnabled,
      snoozeDurationMinutes: _snoozeDurationMinutes,
      definitionRevision: (existing?.definitionRevision ?? 0) + 1,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await ref.read(alarmRepositoryProvider).save(alarm);
      final missions = ref.read(missionRepositoryProvider);
      if (_wakeEnforcementEnabled) {
        await missions.save(
          Mission(
            id: widget.alarm == null ? const Uuid().v4() : 'mission-$alarmId',
            alarmId: alarmId,
            type: _missionType,
            enabled: true,
            difficulty: MissionDifficulty.normal,
            configurationJson: jsonEncode(
              _missionType == MissionType.qr
                  ? {
                      'payloadHash': _qrPayloadHash,
                      'locationLabel': _qrLocationLabel,
                      'timeoutSeconds': 120,
                      'wakeCheckDelayMinutes': _wakeCheckDelayMinutes,
                    }
                  : _missionType == MissionType.jumping
                  ? {
                      'requiredJumps': _requiredJumps,
                      'timeoutSeconds': 120,
                      'wakeCheckDelayMinutes': _wakeCheckDelayMinutes,
                    }
                  : {
                      'requiredSteps': _movementSteps,
                      'timeoutSeconds': 120,
                      'wakeCheckDelayMinutes': _wakeCheckDelayMinutes,
                    },
            ),
            createdAt: now,
            updatedAt: now,
          ),
        );
      } else {
        await missions.deleteForAlarm(alarmId);
      }
      final protocolRepository = ref.read(wakeProtocolRepositoryProvider);
      await protocolRepository.savePolicy(
        alarmId,
        AlarmAdaptationPolicy(
          enabled: _adaptiveWakeEnabled,
          sound: _adaptSound ? AdaptiveMode.adaptive : AdaptiveMode.fixed,
          volume: _adaptVolume ? AdaptiveMode.adaptive : AdaptiveMode.fixed,
          vibration: _adaptVibration
              ? AdaptiveMode.adaptive
              : AdaptiveMode.fixed,
          wakeCheck: _adaptWakeCheck
              ? AdaptiveMode.adaptive
              : AdaptiveMode.fixed,
          mission: _adaptMission ? AdaptiveMode.adaptive : AdaptiveMode.fixed,
          userMaxVolumePercent: _userMaxVolumePercent,
        ),
      );
      final protocol = widget.alarm == null
          ? await protocolRepository.ensureDefault(alarmId)
          : await protocolRepository.createUserDefinedVersion(
              alarmId,
              resetLearning: _resetLearningRequested,
            );
      final protocolApply = await runtime.schedule(
        alarmId: alarmId,
        triggerAt: nextOccurrence,
        label: _labelController.text.trim(),
        ringtoneUri: _ringtoneUri!,
        vibrationEnabled: _vibrationEnabled,
        snoozeEnabled: _snoozeEnabled,
        snoozeDurationMinutes: _snoozeDurationMinutes,
        adaptiveSoundRotation: _adaptiveSoundRotation,
        increasingVolume: _increasingVolume,
        localHour: _time.hour,
        localMinute: _time.minute,
        recurrenceType: _recurrenceType.name,
        repeatDaysMask: _recurrenceType == AlarmRecurrenceType.selectedWeekdays
            ? _repeatDaysMask
            : 0,
        protocol: protocol,
      );
      if (!protocolApply.scheduled) {
        throw StateError('Protocol schedule was rejected.');
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Alarm could not be saved. Try again.';
        });
      }
    }
  }

  Future<void> _delete() async {
    final alarm = widget.alarm;
    if (alarm == null) return;
    await ref.read(alarmRuntimeGatewayProvider).cancel(alarm.id);
    await ref.read(alarmRepositoryProvider).delete(alarm.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final next =
        _recurrenceType == AlarmRecurrenceType.selectedWeekdays &&
            _repeatDaysMask == 0
        ? null
        : calculateNextOccurrence(
            now: DateTime.now(),
            hour: _time.hour,
            minute: _time.minute,
            recurrenceType: _recurrenceType,
            repeatDaysMask: _repeatDaysMask,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm == null ? 'ADD ALARM' : 'EDIT ALARM'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RyserSpacing.lg),
          children: [
            Text('TIME', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: RyserSpacing.xs),
            Semantics(
              button: true,
              label: 'Alarm time ${_time.format(context)}',
              child: InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RyserSpacing.md,
                    vertical: RyserSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: RyserColors.surface,
                    border: Border.all(color: RyserColors.muted),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _time.format(context),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: RyserColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: RyserSpacing.lg),
            TextField(
              controller: _labelController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'LABEL (OPTIONAL)'),
            ),
            const SizedBox(height: RyserSpacing.lg),
            DropdownButtonFormField<AlarmRecurrenceType>(
              initialValue: _recurrenceType,
              decoration: const InputDecoration(labelText: 'REPEAT'),
              items: const [
                DropdownMenuItem(
                  value: AlarmRecurrenceType.oneTime,
                  child: Text('One time'),
                ),
                DropdownMenuItem(
                  value: AlarmRecurrenceType.daily,
                  child: Text('Every day'),
                ),
                DropdownMenuItem(
                  value: AlarmRecurrenceType.selectedWeekdays,
                  child: Text('Selected weekdays'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _recurrenceType = value);
              },
            ),
            if (_recurrenceType == AlarmRecurrenceType.selectedWeekdays) ...[
              const SizedBox(height: RyserSpacing.sm),
              Wrap(
                spacing: RyserSpacing.xs,
                children: [
                  for (var index = 0; index < 7; index++)
                    FilterChip(
                      label: Text(
                        const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                      ),
                      selected: _repeatDaysMask & (1 << index) != 0,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _repeatDaysMask |= 1 << index;
                          } else {
                            _repeatDaysMask &= ~(1 << index);
                          }
                        });
                      },
                    ),
                ],
              ),
            ],
            const SizedBox(height: RyserSpacing.sm),
            if (next != null)
              Text(
                'Next: ${MaterialLocalizations.of(context).formatFullDate(next)} '
                'at ${TimeOfDay.fromDateTime(next).format(context)}',
                style: const TextStyle(color: RyserColors.textSecondary),
              ),
            const SizedBox(height: RyserSpacing.lg),
            if (_loadingRingtones)
              const LinearProgressIndicator(color: RyserColors.primary)
            else if (_ringtones.isEmpty)
              OutlinedButton(
                onPressed: () {
                  setState(() => _loadingRingtones = true);
                  _loadRingtones();
                },
                child: const Text('RETRY RINGTONE SCAN'),
              )
            else
              DropdownButtonFormField<String>(
                initialValue: _ringtoneUri,
                decoration: const InputDecoration(labelText: 'RINGTONE'),
                items: [
                  for (final ringtone in _ringtones)
                    DropdownMenuItem(
                      value: ringtone.uri,
                      child: Text(
                        ringtone.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (uri) {
                  if (uri == null) return;
                  final ringtone = _ringtones.firstWhere(
                    (candidate) => candidate.uri == uri,
                  );
                  setState(() {
                    _ringtoneUri = ringtone.uri;
                    _ringtoneTitle = ringtone.title;
                  });
                },
              ),
            const SizedBox(height: RyserSpacing.sm),
            OutlinedButton.icon(
              onPressed: _browseAudioFile,
              icon: const Icon(Icons.folder_open, size: 18),
              label: const Text('BROWSE AUDIO FILES'),
            ),
            const SizedBox(height: RyserSpacing.md),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('AUTOMATIC SOUND ROTATION'),
              subtitle: const Text('Use another alarm sound after snoozing'),
              value: _adaptiveSoundRotation,
              onChanged: (value) =>
                  setState(() => _adaptiveSoundRotation = value),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('INCREASING ALARM VOLUME'),
              subtitle: const Text('Start quieter and rise to full volume'),
              value: _increasingVolume,
              onChanged: (value) => setState(() => _increasingVolume = value),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('VIBRATION'),
              value: _vibrationEnabled,
              onChanged: (value) => setState(() => _vibrationEnabled = value),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('SNOOZE'),
              value: _snoozeEnabled,
              onChanged: (value) => setState(() => _snoozeEnabled = value),
            ),
            if (_snoozeEnabled)
              TextField(
                controller: _snoozeDurationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'SNOOZE DURATION',
                  suffixText: 'MIN',
                  helperText: 'Choose any duration from 1 to 60 minutes',
                  counterText: '',
                ),
                onChanged: (value) {
                  final duration = int.tryParse(value);
                  if (duration != null && duration >= 1 && duration <= 60) {
                    _snoozeDurationMinutes = duration;
                  }
                },
              ),
            const SizedBox(height: RyserSpacing.lg),
            const Divider(color: RyserColors.muted),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('ADAPTIVE WAKE'),
              subtitle: const Text(
                'Use your valid wake history to adjust future alarms',
              ),
              value: _adaptiveWakeEnabled,
              onChanged: (value) =>
                  setState(() => _adaptiveWakeEnabled = value),
            ),
            if (_adaptiveWakeEnabled) ...[
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('ADAPT SOUND'),
                value: _adaptSound,
                onChanged: (value) =>
                    setState(() => _adaptSound = value ?? false),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('ADAPT VOLUME'),
                value: _adaptVolume,
                onChanged: (value) =>
                    setState(() => _adaptVolume = value ?? false),
              ),
              if (_adaptVolume)
                DropdownButtonFormField<int>(
                  initialValue: _userMaxVolumePercent,
                  decoration: const InputDecoration(
                    labelText: 'MAXIMUM PLAYBACK LEVEL',
                  ),
                  items: const [
                    DropdownMenuItem(value: 70, child: Text('70%')),
                    DropdownMenuItem(value: 80, child: Text('80%')),
                    DropdownMenuItem(value: 90, child: Text('90%')),
                    DropdownMenuItem(value: 100, child: Text('100%')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _userMaxVolumePercent = value);
                    }
                  },
                ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('ADAPT VIBRATION'),
                value: _adaptVibration,
                onChanged: (value) =>
                    setState(() => _adaptVibration = value ?? false),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('ADAPT WAKE CHECK'),
                value: _adaptWakeCheck,
                onChanged: (value) =>
                    setState(() => _adaptWakeCheck = value ?? false),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('ADAPT MISSION'),
                subtitle: const Text('Off by default'),
                value: _adaptMission,
                onChanged: (value) =>
                    setState(() => _adaptMission = value ?? false),
              ),
              if (_activeProtocol != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('WAKE PROTOCOL V${_activeProtocol!.version}'),
                  subtitle: WakeProtocolPreview(
                    protocol: _activeProtocol!,
                    policy: AlarmAdaptationPolicy(
                      enabled: _adaptiveWakeEnabled,
                      sound: _adaptSound
                          ? AdaptiveMode.adaptive
                          : AdaptiveMode.fixed,
                      volume: _adaptVolume
                          ? AdaptiveMode.adaptive
                          : AdaptiveMode.fixed,
                      vibration: _adaptVibration
                          ? AdaptiveMode.adaptive
                          : AdaptiveMode.fixed,
                      wakeCheck: _adaptWakeCheck
                          ? AdaptiveMode.adaptive
                          : AdaptiveMode.fixed,
                      mission: _adaptMission
                          ? AdaptiveMode.adaptive
                          : AdaptiveMode.fixed,
                      userMaxVolumePercent: _userMaxVolumePercent,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AdaptiveExplanationScreen(
                          alarmId: widget.alarm!.id,
                        ),
                      ),
                    ),
                    child: const Text('WHY?'),
                  ),
                ),
              if (_activeProtocol != null)
                TextButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Reset Adaptive Learning?'),
                              content: const Text(
                                'This pauses Adaptive Wake and restores the current alarm settings as a new protocol. Wake history and earlier protocols are kept. Any unsaved edits on this screen will be saved too.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: const Text('RESET AND SAVE'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true || !mounted) return;
                          setState(() {
                            _resetLearningRequested = true;
                            _adaptiveWakeEnabled = false;
                          });
                          await _save();
                        },
                  child: const Text('RESET ADAPTIVE LEARNING'),
                ),
            ],
            const Divider(color: RyserColors.muted),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('WAKE ENFORCEMENT'),
              subtitle: const Text('Require a wake mission to dismiss'),
              value: _wakeEnforcementEnabled,
              onChanged: (value) {
                setState(() => _wakeEnforcementEnabled = value);
                if (value && _qrPayloadHash == null) _registerQr();
              },
            ),
            if (_wakeEnforcementEnabled) ...[
              DropdownButtonFormField<MissionType>(
                initialValue: _missionType,
                decoration: const InputDecoration(labelText: 'MISSION'),
                items: const [
                  DropdownMenuItem(
                    value: MissionType.qr,
                    child: Text('QR LOCATION'),
                  ),
                  DropdownMenuItem(
                    value: MissionType.movement,
                    child: Text('MOVEMENT'),
                  ),
                  DropdownMenuItem(
                    value: MissionType.jumping,
                    child: Text('JUMPING'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _missionType = value);
                },
              ),
              if (_missionType == MissionType.qr) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('WAKE LOCATION'),
                  subtitle: Text(_qrLocationLabel ?? 'No code registered'),
                  trailing: const Icon(Icons.qr_code_scanner),
                  onTap: _registerQr,
                ),
                Text(
                  _qrPayloadHash == null ? 'NEEDS CAMERA ACCESS' : 'QR READY',
                  style: TextStyle(
                    color: _qrPayloadHash == null
                        ? RyserColors.critical
                        : RyserColors.primary,
                  ),
                ),
              ] else if (_missionType == MissionType.movement) ...[
                const SizedBox(height: RyserSpacing.md),
                DropdownButtonFormField<int>(
                  initialValue: _movementSteps,
                  decoration: const InputDecoration(
                    labelText: 'REQUIRED STEPS',
                  ),
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10 — EASY')),
                    DropdownMenuItem(value: 20, child: Text('20 — NORMAL')),
                    DropdownMenuItem(value: 40, child: Text('40 — HARD')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _movementSteps = value);
                  },
                ),
              ] else ...[
                const SizedBox(height: RyserSpacing.md),
                DropdownButtonFormField<int>(
                  initialValue: _requiredJumps,
                  decoration: const InputDecoration(
                    labelText: 'REQUIRED JUMPS',
                  ),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5 — EASY')),
                    DropdownMenuItem(value: 10, child: Text('10 — NORMAL')),
                    DropdownMenuItem(value: 20, child: Text('20 — HARD')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _requiredJumps = value);
                  },
                ),
              ],
              const SizedBox(height: RyserSpacing.md),
              DropdownButtonFormField<int>(
                initialValue: _wakeCheckDelayMinutes,
                decoration: const InputDecoration(
                  labelText: 'WAKE CHECK DELAY',
                ),
                items: const [
                  DropdownMenuItem(value: 5, child: Text('5 MINUTES')),
                  DropdownMenuItem(value: 7, child: Text('7 MINUTES')),
                  DropdownMenuItem(value: 10, child: Text('10 MINUTES')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _wakeCheckDelayMinutes = value);
                  }
                },
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: RyserSpacing.md),
              Text(
                _error!,
                style: const TextStyle(color: RyserColors.critical),
              ),
            ],
            const SizedBox(height: RyserSpacing.xl),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'SAVING…' : 'SAVE ALARM'),
            ),
            if (widget.alarm != null) ...[
              const SizedBox(height: RyserSpacing.md),
              TextButton(
                onPressed: _saving ? null : _delete,
                style: TextButton.styleFrom(
                  foregroundColor: RyserColors.critical,
                  minimumSize: const Size(48, 48),
                ),
                child: const Text('DELETE ALARM'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
