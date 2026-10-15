import 'package:drift/drift.dart';

@TableIndex(
  name: 'wake_events_session_sequence',
  columns: {#wakeSessionId, #sequenceNumber},
  unique: true,
)
class WakeEvents extends Table {
  TextColumn get id => text()();
  TextColumn get wakeSessionId => text()();
  IntColumn get sequenceNumber => integer()();
  TextColumn get eventType => text()();
  IntColumn get occurredAtMs => integer()();
  TextColumn get metadataJson => text()();
  TextColumn get source => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
