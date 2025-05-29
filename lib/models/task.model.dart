import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:notiq/app/utils/priority.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'tasks'),
)
class Task extends OfflineFirstWithSupabaseModel {
  final String user_id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final String? _priority; // Internal storage for Priority enum
  final String? tag;
  final bool isRecurring;
  final Duration? recurrenceInterval;

  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  Task({
    required this.user_id,
    String? id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    String? priority,
    this.tag,
    this.isRecurring = false,
    this.recurrenceInterval,
  }) : _priority = priority,
       id = id ?? const Uuid().v4();

  String? get priority => _priority;

  Priority? get priorityValue => _priority != null
      ? Priority.values.firstWhere(
          (p) => p.name.toLowerCase() == _priority!.toLowerCase(),
          orElse: () => Priority.medium,
        )
      : null;

  Task copyWith({
    String? id,
    String? user_id,
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
    String? description,
    Priority? priority,
    String? tag,
    bool? isRecurring,
    Duration? recurrenceInterval,
  }) {
    return Task(
      user_id: user_id ?? this.user_id,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority?.name.toLowerCase() ?? _priority,
      tag: tag ?? this.tag,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    );
  }
}
