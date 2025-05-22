// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250522122827.migration.dart';
part '20250522115749.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20250522122827(),const Migration20250522115749()};

/// A consumable database structure including the latest generated migration.
final schema = Schema(
  20250522115749,
  generatorVersion: 1,
  tables: <SchemaTable>{
    SchemaTable(
      'Alarm',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('time', Column.datetime),
        SchemaColumn('label', Column.varchar),
        SchemaColumn('is_enabled', Column.boolean),
        SchemaColumn('repeat_days', Column.varchar),
        SchemaColumn('id', Column.varchar, unique: true),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'AppUser',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('email', Column.varchar),
        SchemaColumn('name', Column.varchar),
        SchemaColumn('avatar_url', Column.varchar),
        SchemaColumn('id', Column.varchar, unique: true),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'Note',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('title', Column.varchar),
        SchemaColumn('content', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('summary', Column.varchar),
        SchemaColumn('id', Column.varchar, unique: true),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'Reminder',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('message', Column.varchar),
        SchemaColumn('remind_at', Column.datetime),
        SchemaColumn('is_recurring', Column.boolean),
        SchemaColumn('id', Column.varchar, unique: true),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
    SchemaTable(
      'Task',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('title', Column.varchar),
        SchemaColumn('description', Column.varchar),
        SchemaColumn('due_date', Column.datetime),
        SchemaColumn('is_completed', Column.boolean),
        SchemaColumn('priority', Column.varchar),
        SchemaColumn('tag', Column.varchar),
        SchemaColumn('is_recurring', Column.boolean),
        SchemaColumn('id', Column.varchar, unique: true),
      },
      indices: <SchemaIndex>{
        SchemaIndex(columns: ['id'], unique: true),
      },
    ),
  },
);
