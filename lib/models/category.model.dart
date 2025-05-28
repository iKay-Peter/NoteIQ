import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'alarms'),
)
class Category extends OfflineFirstWithSupabaseModel {
  final String name;
  final String? description;

  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  Category({String? id, required this.name, this.description})
    : id = id ?? const Uuid().v4();
}
