// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250522115749_up = [
  InsertTable('Alarm'),
  InsertTable('AppUser'),
  InsertTable('Note'),
  InsertTable('Reminder'),
  InsertTable('Task'),
  InsertColumn('time', Column.datetime, onTable: 'Alarm'),
  InsertColumn('label', Column.varchar, onTable: 'Alarm'),
  InsertColumn('is_enabled', Column.boolean, onTable: 'Alarm'),
  InsertColumn('repeat_days', Column.varchar, onTable: 'Alarm'),
  InsertColumn('id', Column.varchar, onTable: 'Alarm', unique: true),
  InsertColumn('email', Column.varchar, onTable: 'AppUser'),
  InsertColumn('id', Column.varchar, onTable: 'AppUser', unique: true),
  InsertColumn('title', Column.varchar, onTable: 'Note'),
  InsertColumn('content', Column.varchar, onTable: 'Note'),
  InsertColumn('created_at', Column.datetime, onTable: 'Note'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Note'),
  InsertColumn('summary', Column.varchar, onTable: 'Note'),
  InsertColumn('id', Column.varchar, onTable: 'Note', unique: true),
  InsertColumn('message', Column.varchar, onTable: 'Reminder'),
  InsertColumn('remind_at', Column.datetime, onTable: 'Reminder'),
  InsertColumn('is_recurring', Column.boolean, onTable: 'Reminder'),
  InsertColumn('id', Column.varchar, onTable: 'Reminder', unique: true),
  InsertColumn('title', Column.varchar, onTable: 'Task'),
  InsertColumn('description', Column.varchar, onTable: 'Task'),
  InsertColumn('due_date', Column.datetime, onTable: 'Task'),
  InsertColumn('is_completed', Column.boolean, onTable: 'Task'),
  InsertColumn('priority', Column.varchar, onTable: 'Task'),
  InsertColumn('tag', Column.varchar, onTable: 'Task'),
  InsertColumn('is_recurring', Column.boolean, onTable: 'Task'),
  InsertColumn('id', Column.varchar, onTable: 'Task', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Alarm', unique: true),
  CreateIndex(columns: ['id'], onTable: 'AppUser', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Note', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Reminder', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Task', unique: true)
];

const List<MigrationCommand> _migration_20250522115749_down = [
  DropTable('Alarm'),
  DropTable('AppUser'),
  DropTable('Note'),
  DropTable('Reminder'),
  DropTable('Task'),
  DropColumn('time', onTable: 'Alarm'),
  DropColumn('label', onTable: 'Alarm'),
  DropColumn('is_enabled', onTable: 'Alarm'),
  DropColumn('repeat_days', onTable: 'Alarm'),
  DropColumn('id', onTable: 'Alarm'),
  DropColumn('email', onTable: 'AppUser'),
  DropColumn('id', onTable: 'AppUser'),
  DropColumn('title', onTable: 'Note'),
  DropColumn('content', onTable: 'Note'),
  DropColumn('created_at', onTable: 'Note'),
  DropColumn('updated_at', onTable: 'Note'),
  DropColumn('summary', onTable: 'Note'),
  DropColumn('id', onTable: 'Note'),
  DropColumn('message', onTable: 'Reminder'),
  DropColumn('remind_at', onTable: 'Reminder'),
  DropColumn('is_recurring', onTable: 'Reminder'),
  DropColumn('id', onTable: 'Reminder'),
  DropColumn('title', onTable: 'Task'),
  DropColumn('description', onTable: 'Task'),
  DropColumn('due_date', onTable: 'Task'),
  DropColumn('is_completed', onTable: 'Task'),
  DropColumn('priority', onTable: 'Task'),
  DropColumn('tag', onTable: 'Task'),
  DropColumn('is_recurring', onTable: 'Task'),
  DropColumn('id', onTable: 'Task'),
  DropIndex('index_Alarm_on_id'),
  DropIndex('index_AppUser_on_id'),
  DropIndex('index_Note_on_id'),
  DropIndex('index_Reminder_on_id'),
  DropIndex('index_Task_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250522115749',
  up: _migration_20250522115749_up,
  down: _migration_20250522115749_down,
)
class Migration20250522115749 extends Migration {
  const Migration20250522115749()
    : super(
        version: 20250522115749,
        up: _migration_20250522115749_up,
        down: _migration_20250522115749_down,
      );
}
