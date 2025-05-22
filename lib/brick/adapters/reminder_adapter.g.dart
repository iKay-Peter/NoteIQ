// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Reminder> _$ReminderFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Reminder(
    message: data['message'] as String,
    remindAt: DateTime.parse(data['remind_at'] as String),
    isRecurring: data['is_recurring'] as bool,
    id: data['id'] as String?,
  );
}

Future<Map<String, dynamic>> _$ReminderToSupabase(
  Reminder instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'message': instance.message,
    'remind_at': instance.remindAt.toIso8601String(),
    'is_recurring': instance.isRecurring,
    'id': instance.id,
  };
}

Future<Reminder> _$ReminderFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Reminder(
    message: data['message'] as String,
    remindAt: DateTime.parse(data['remind_at'] as String),
    isRecurring: data['is_recurring'] == 1,
    id: data['id'] as String,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ReminderToSqlite(
  Reminder instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'message': instance.message,
    'remind_at': instance.remindAt.toIso8601String(),
    'is_recurring': instance.isRecurring ? 1 : 0,
    'id': instance.id,
  };
}

/// Construct a [Reminder]
class ReminderAdapter extends OfflineFirstWithSupabaseAdapter<Reminder> {
  ReminderAdapter();

  @override
  final supabaseTableName = 'reminders';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'message': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'message',
    ),
    'remindAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remind_at',
    ),
    'isRecurring': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_recurring',
    ),
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'message': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'message',
      iterable: false,
      type: String,
    ),
    'remindAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remind_at',
      iterable: false,
      type: DateTime,
    ),
    'isRecurring': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_recurring',
      iterable: false,
      type: bool,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Reminder instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Reminder` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Reminder';

  @override
  Future<Reminder> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ReminderFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Reminder input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ReminderToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Reminder> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ReminderFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Reminder input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ReminderToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
