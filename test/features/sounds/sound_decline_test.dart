import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/sounds/data/sound_performance_repository.dart';
import 'package:ryser/features/sounds/domain/bundled_sound_catalog.dart';

void main() {
  test('decline needs four earlier and three recent comparable uses', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    try {
      final uri = BundledSoundCatalog.sounds.first.uri;
      for (var index = 0; index < 7; index++) {
        await database
            .into(database.wakeSessions)
            .insert(
              WakeSessionsCompanion.insert(
                id: 'session-$index',
                alarmId: 'alarm-1',
                scheduledTimeMs: index * 100000,
                triggeredAtMs: index * 100000,
                initialSoundId: uri,
                responseLatencyMs: Value(index < 4 ? 10000 : 40000),
                outcome: 'wakeConfirmed',
                createdAtMs: index * 100000,
                completedAtMs: Value(index * 100000 + 41000),
              ),
            );
      }
      final stats = await SoundPerformanceRepository(database)
          .load(alarmId: 'alarm-1');
      expect(stats, hasLength(1));
      expect(stats.single.timesUsed, 7);
      expect(stats.single.effectivenessDeclining, isTrue);
      expect(stats.single.recentMedianResponseLatencyMs, 40000);
      expect(
        await SoundPerformanceRepository(database).load(alarmId: 'other'),
        isEmpty,
      );
      await database
          .into(database.wakeSessions)
          .insert(
            WakeSessionsCompanion.insert(
              id: 'no-response',
              alarmId: 'alarm-1',
              scheduledTimeMs: 800000,
              triggeredAtMs: 800000,
              initialSoundId: uri,
              outcome: 'noResponse',
              createdAtMs: 800000,
              completedAtMs: const Value(900000),
            ),
          );
      final allUses = (await SoundPerformanceRepository(
        database,
      ).load(alarmId: 'alarm-1')).single;
      expect(allUses.timesUsed, 8);
      expect(allUses.sessionSuccessRate, 7 / 8);
      expect(allUses.lastUsedAtMs, 800000);
      expect(allUses.consecutiveUses, 8);
      // Slower uses after a protocol change cannot establish sound decline
      // against the old configuration's faster baseline.
      await (database.update(database.wakeSessions)..where(
            (s) =>
                s.id.isIn(['session-0', 'session-1', 'session-2', 'session-3']),
          ))
          .write(
            const WakeSessionsCompanion(
              protocolId: Value('older-configuration'),
            ),
          );
      final comparable = (await SoundPerformanceRepository(
        database,
      ).load(alarmId: 'alarm-1')).single;
      expect(comparable.effectivenessDeclining, isFalse);
      expect(comparable.timesUsed, 8);
    } finally {
      await database.close();
    }
  });
}
