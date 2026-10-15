import 'package:flutter/material.dart';
import 'package:ryser/features/settings/presentation/privacy_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/app/theme/ryser_spacing.dart';
import 'package:ryser/features/alarm_health/presentation/alarm_health_screen.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/settings/data/app_defaults_repository.dart';
import 'package:ryser/features/sounds/presentation/sound_performance_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _snoozeController = TextEditingController();
  bool _vibration = true;
  bool _rotation = true;
  bool _loaded = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _snoozeController.dispose();
    super.dispose();
  }

  void _applyDefaults(AppDefaults defaults) {
    if (_loaded) return;
    _loaded = true;
    _snoozeController.text = defaults.snoozeDurationMinutes.toString();
    _vibration = defaults.vibrationEnabled;
    _rotation = defaults.adaptiveSoundRotation;
  }

  Future<void> _save() async {
    final snooze = int.tryParse(_snoozeController.text.trim());
    if (snooze == null || snooze < 1 || snooze > 60) {
      setState(() => _error = 'Default snooze must be from 1 to 60 minutes.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    await ref
        .read(appDefaultsRepositoryProvider)
        .save(
          AppDefaults(
            snoozeDurationMinutes: snooze,
            vibrationEnabled: _vibration,
            adaptiveSoundRotation: _rotation,
          ),
        );
    ref.invalidate(appDefaultsProvider);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Ryser defaults saved.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaults = ref.watch(appDefaultsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('CONFIG')),
      body: SafeArea(
        child: defaults.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('SETTINGS UNAVAILABLE')),
          data: (value) {
            _applyDefaults(value);
            return ListView(
              padding: const EdgeInsets.all(RyserSpacing.md),
              children: [
                const Text(
                  '> NEW ALARM DEFAULTS',
                  style: TextStyle(
                    color: RyserColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: RyserSpacing.md),
                TextField(
                  controller: _snoozeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 2,
                  decoration: const InputDecoration(
                    labelText: 'DEFAULT SNOOZE',
                    suffixText: 'MIN',
                    counterText: '',
                  ),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('DEFAULT VIBRATION'),
                  value: _vibration,
                  onChanged: (value) => setState(() => _vibration = value),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('AUTOMATIC SOUND ROTATION'),
                  subtitle: const Text('Avoid recent and overused sounds'),
                  value: _rotation,
                  onChanged: (value) => setState(() => _rotation = value),
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: RyserColors.critical),
                  ),
                const SizedBox(height: RyserSpacing.md),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'SAVING…' : 'SAVE DEFAULTS'),
                ),
                const SizedBox(height: RyserSpacing.xl),
                _SettingsLink(
                  label: 'SOUND PERFORMANCE',
                  subtitle: 'Uses, response time, and snoozes by sound',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SoundPerformanceScreen(),
                    ),
                  ),
                ),
                _SettingsLink(
                  label: 'ALARM HEALTH',
                  subtitle: 'Review Android reliability settings',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AlarmHealthScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: RyserSpacing.xl),
                _SettingsLink(
                  label: 'PRIVACY',
                  subtitle: 'Local data and permissions',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PrivacyScreen(),
                    ),
                  ),
                ),
                const Text(
                  'RYSER V3 // DETERMINISTIC ADAPTATION\nLOCAL-FIRST. NO ACCOUNT.',
                  style: TextStyle(
                    color: RyserColors.muted,
                    fontSize: 10,
                    height: 1.6,
                    letterSpacing: 1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SettingsLink extends StatelessWidget {
  const _SettingsLink({
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: RyserColors.primary)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: RyserColors.primaryDim),
      onTap: onTap,
    );
  }
}
