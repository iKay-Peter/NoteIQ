// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Task> _$TaskFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Task(
    title: data['title'] as String,
    description: data['description'] == null
        ? null
        : data['description'] as String?,
    dueDate: data['due_date'] == null
        ? null
        : data['due_date'] == null
        ? null
        : DateTime.tryParse(data['due_date'] as String),
    isCompleted: data['is_completed'] as bool,
    priority: data['priority'] == null ? null : data['priority'] as String?,
    tag: data['tag'] == null ? null : data['tag'] as String?,
    isRecurring: data['is_recurring'] as bool,
    id: data['id'] as String?,
  );
}

Future<Map<String, dynamic>> _$TaskToSupabase(
  Task instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'title': instance.title,
    'description': instance.description,
    'due_date': instance.dueDate?.toIso8601String(),
    'is_completed': instance.isCompleted,
    'priority': instance.priority,
    'tag': instance.tag,
    'is_recurring': instance.isRecurring,
    'id': instance.id,
  };
}

Future<Task> _$TaskFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Task(
    title: data['title'] as String,
    description: data['description'] == null
        ? null
        : data['description'] as String?,
    dueDate: data['due_date'] == null
        ? null
        : data['due_date'] == null
        ? null
        : DateTime.tryParse(data['due_date'] as String),
    isCompleted: data['is_completed'] == 1,
    priority: data['priority'] == null ? null : data['priority'] as String?,
    tag: data['tag'] == null ? null : data['tag'] as String?,
    isRecurring: data['is_recurring'] == 1,
    id: data['id'] as String,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TaskToSqlite(
  Task instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'title': instance.title,
    'description': instance.description,
    'due_date': instance.dueDate?.toIso8601String(),
    'is_completed': instance.isCompleted ? 1 : 0,
    'priority': instance.priority,
    'tag': instance.tag,
    'is_recurring': instance.isRecurring ? 1 : 0,
    'id': instance.id,
  };
}

/// Construct a [Task]
class TaskAdapter extends OfflineFirstWithSupabaseAdapter<Task> {
  TaskAdapter();

  @override
  final supabaseTableName = 'tasks';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'title': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'title',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'dueDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'due_date',
    ),
    'isCompleted': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_completed',
    ),
    'priority': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'priority',
    ),
    'tag': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tag',
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
    'title': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'title',
      iterable: false,
      type: String,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'dueDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'due_date',
      iterable: false,
      type: DateTime,
    ),
    'isCompleted': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_completed',
      iterable: false,
      type: bool,
    ),
    'priority': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'priority',
      iterable: false,
      type: String,
    ),
    'tag': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tag',
      iterable: false,
      type: String,
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
    Task instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Task` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Task';

  @override
  Future<Task> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TaskFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Task input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TaskToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Task> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TaskFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    Task input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TaskToSqlite(input, provider: provider, repository: repository);
}
