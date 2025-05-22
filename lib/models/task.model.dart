import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'tasks'),
)
class Task extends OfflineFirstWithSupabaseModel {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final String? priority; // "Low", "Medium", "High"
  final String? tag; // e.g., "Work", "Personal"
  final bool isRecurring;
  final Duration? recurrenceInterval; // For periodic tasks

  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  Task({
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
}
