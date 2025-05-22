import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'notes'),
)
class Note extends OfflineFirstWithSupabaseModel {
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? summary; // For AI-generated summaries

  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  Note({
    String? id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.summary,
  }) : id = id ?? const Uuid().v4();
}
