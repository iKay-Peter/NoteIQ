// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:uuid/uuid.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../models/alarm.model.dart';
import '../models/appuser.model.dart';
import '../models/note.model.dart';
import '../models/reminder.model.dart';
import '../models/task.model.dart';

part 'adapters/alarm_adapter.g.dart';
part 'adapters/app_user_adapter.g.dart';
part 'adapters/note_adapter.g.dart';
part 'adapters/reminder_adapter.g.dart';
part 'adapters/task_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  Alarm: AlarmAdapter(),
  AppUser: AppUserAdapter(),
  Note: NoteAdapter(),
  Reminder: ReminderAdapter(),
  Task: TaskAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  Alarm: AlarmAdapter(),
  AppUser: AppUserAdapter(),
  Note: NoteAdapter(),
  Reminder: ReminderAdapter(),
  Task: TaskAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
