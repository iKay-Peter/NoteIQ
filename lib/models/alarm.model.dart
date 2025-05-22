import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'alarms'),
)
class Alarm extends OfflineFirstWithSupabaseModel {
  final DateTime time;
  final String label;
  final bool isEnabled;
  final List<int> repeatDays; // 0 (Sun) to 6 (Sat)

  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  Alarm({
    String? id,
    required this.time,
    required this.label,
    this.isEnabled = true,
    this.repeatDays = const [],
  }) : id = id ?? const Uuid().v4();
}
