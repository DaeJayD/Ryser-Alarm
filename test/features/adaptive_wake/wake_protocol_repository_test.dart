import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart'
    as domain;

import 'adaptive_test_fixtures.dart';

void main() {
  test(
    'default obeys volume cap and manual reset preserves protocol history',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      try {
        await database
            .into(database.alarms)
            .insert(
              AlarmsCompanion.insert(
                id: 'alarm-1',
                localHour: 7,
                localMinute: 0,
                recurrenceType: 'daily',
                soundId: 'pulse-a',
                ringtoneUri: const Value('content://sound/1'),
                snoozeDurationMinutes: 5,
                createdAtMs: 1000,
                updatedAtMs: 1000,
              ),
            );
        final repository = WakeProtocolRepository(database);
        await repository.savePolicy('alarm-1', adaptivePolicy);
        final original = await repository.ensureDefault('alarm-1');
        expect(original.maxVolumePercent, 90);
        expect(original.initialVolumePercent, 90);
        final reset = await repository.createUserDefinedVersion(
          'alarm-1',
          resetLearning: true,
        );
        expect(reset.reasonCode, domain.AdaptiveReasonCode.manualReset);
        expect(reset.supersedesProtocolId, original.id);
        expect((await repository.historyForAlarm('alarm-1')), hasLength(2));
      } finally {
        await database.close();
      }
    },
  );
}
