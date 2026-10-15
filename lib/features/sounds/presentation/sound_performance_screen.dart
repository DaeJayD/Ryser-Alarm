import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/app/theme/ryser_spacing.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/sounds/data/sound_performance_repository.dart';

class SoundPerformanceScreen extends ConsumerWidget {
  const SoundPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performance = ref.watch(soundPerformanceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('SOUND PERFORMANCE')),
      body: SafeArea(
        child: performance.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('SOUND DATA UNAVAILABLE')),
          data: (items) => items.isEmpty
              ? const _EmptyPerformance()
              : RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(soundPerformanceProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(RyserSpacing.md),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: RyserSpacing.sm),
                    itemBuilder: (_, index) =>
                        _PerformanceCard(item: items[index]),
                  ),
                ),
        ),
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.item});

  final SoundPerformance item;

  @override
  Widget build(BuildContext context) {
    final latency = item.averageResponseLatencyMs == null
        ? 'NO RESPONSE DATA'
        : '${(item.averageResponseLatencyMs! / 1000).toStringAsFixed(1)} SEC AVG';
    return Container(
      padding: const EdgeInsets.all(RyserSpacing.md),
      decoration: BoxDecoration(
        color: RyserColors.surface,
        border: Border.all(color: RyserColors.muted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _displayName(item.soundUri),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: RyserColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          if (item.effectivenessDeclining) ...[
            const SizedBox(height: RyserSpacing.xs),
            const Text(
              'SOUND EFFECTIVENESS MAY BE DECLINING',
              style: TextStyle(color: RyserColors.critical, fontSize: 10),
            ),
          ],
          const SizedBox(height: RyserSpacing.sm),
          Text(
            '${item.timesUsed} USES  //  ${item.snoozeCount} SNOOZES  //  $latency',
            style: const TextStyle(
              color: RyserColors.textSecondary,
              fontSize: 10,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    );
  }

  String _displayName(String uri) {
    final segments = Uri.tryParse(uri)?.pathSegments ?? const <String>[];
    final decoded = segments.isEmpty ? null : segments.last;
    return (decoded == null || decoded.isEmpty ? uri : decoded).toUpperCase();
  }
}

class _EmptyPerformance extends StatelessWidget {
  const _EmptyPerformance();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(RyserSpacing.xl),
        child: Text(
          '> NO COMPLETED WAKE SESSIONS\n\nSOUND PERFORMANCE WILL APPEAR AFTER ALARMS FIRE.',
          textAlign: TextAlign.center,
          style: TextStyle(color: RyserColors.textSecondary, height: 1.6),
        ),
      ),
    );
  }
}
