// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Alarm> _$AlarmFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Alarm(
    time: DateTime.parse(data['time'] as String),
    label: data['label'] as String,
    isEnabled: data['is_enabled'] as bool,
    repeatDays: data['repeat_days'].toList().cast<int>(),
    id: data['id'] as String?,
  );
}

Future<Map<String, dynamic>> _$AlarmToSupabase(
  Alarm instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'time': instance.time.toIso8601String(),
    'label': instance.label,
    'is_enabled': instance.isEnabled,
    'repeat_days': instance.repeatDays,
    'id': instance.id,
  };
}

Future<Alarm> _$AlarmFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Alarm(
    time: DateTime.parse(data['time'] as String),
    label: data['label'] as String,
    isEnabled: data['is_enabled'] == 1,
    repeatDays: jsonDecode(data['repeat_days']).toList().cast<int>(),
    id: data['id'] as String,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$AlarmToSqlite(
  Alarm instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'time': instance.time.toIso8601String(),
    'label': instance.label,
    'is_enabled': instance.isEnabled ? 1 : 0,
    'repeat_days': jsonEncode(instance.repeatDays),
    'id': instance.id,
  };
}

/// Construct a [Alarm]
class AlarmAdapter extends OfflineFirstWithSupabaseAdapter<Alarm> {
  AlarmAdapter();

  @override
  final supabaseTableName = 'alarms';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'time': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'time',
    ),
    'label': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'label',
    ),
    'isEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_enabled',
    ),
    'repeatDays': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'repeat_days',
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
    'time': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'time',
      iterable: false,
      type: DateTime,
    ),
    'label': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'label',
      iterable: false,
      type: String,
    ),
    'isEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_enabled',
      iterable: false,
      type: bool,
    ),
    'repeatDays': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'repeat_days',
      iterable: true,
      type: int,
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
    Alarm instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Alarm` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Alarm';

  @override
  Future<Alarm> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AlarmFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Alarm input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AlarmToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Alarm> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AlarmFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Alarm input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$AlarmToSqlite(input, provider: provider, repository: repository);
}
