import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'reminders'),
)
class Reminder extends OfflineFirstWithSupabaseModel {
  final String message;
  final DateTime remindAt;
  final bool isRecurring;
  final Duration? interval; // e.g., every 6 hours

  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  Reminder({
    String? id,
    required this.message,
    required this.remindAt,
    this.isRecurring = false,
    this.interval,
  }) : id = id ?? const Uuid().v4();
}
