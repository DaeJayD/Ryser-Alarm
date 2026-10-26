import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';

/// Also excludes rejected/mismatched executions by original occurrence, even
/// when their native session could not be attached to the reserved variant.
Expression<bool> outsideExperimentOccurrences(
  AppDatabase database,
  $WakeSessionsTable sessions,
) => notExistsQuery(
  database.selectOnly(database.experimentSessions)
    ..addColumns([database.experimentSessions.id])
    ..where(
      database.experimentSessions.alarmId.equalsExp(sessions.alarmId) &
          database.experimentSessions.scheduledTimeMs.equalsExp(
            sessions.scheduledTimeMs,
          ),
    ),
);
