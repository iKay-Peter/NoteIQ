import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

enum Priority { low, medium, high }

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'tasks'),
)
class Task extends OfflineFirstWithSupabaseModel {
  final String user_id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final String? priority; // Stores Priority enum value as string
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
    this.priority,
    this.tag,
    this.isRecurring = false,
    this.recurrenceInterval,
  }) : id = id ?? const Uuid().v4();

  // Convert string priority to enum
  Priority? get priorityEnum => priority != null
      ? Priority.values.firstWhere(
          (p) => p.name.toLowerCase() == priority!.toLowerCase(),
          orElse: () => Priority.medium,
        )
      : null;

  // Create a new Task with the Priority enum value converted to string
  Task copyWith({
    String? id,
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
      user_id: this.user_id,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority?.name.toLowerCase() ?? this.priority,
      tag: tag ?? this.tag,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    );
  }
}
