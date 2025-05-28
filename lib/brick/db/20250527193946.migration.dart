// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250527193946_up = [
  InsertTable('Category'),
  InsertColumn('name', Column.varchar, onTable: 'Category'),
  InsertColumn('description', Column.varchar, onTable: 'Category'),
  InsertColumn('id', Column.varchar, onTable: 'Category', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Category', unique: true)
];

const List<MigrationCommand> _migration_20250527193946_down = [
  DropTable('Category'),
  DropColumn('name', onTable: 'Category'),
  DropColumn('description', onTable: 'Category'),
  DropColumn('id', onTable: 'Category'),
  DropIndex('index_Category_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250527193946',
  up: _migration_20250527193946_up,
  down: _migration_20250527193946_down,
)
class Migration20250527193946 extends Migration {
  const Migration20250527193946()
    : super(
        version: 20250527193946,
        up: _migration_20250527193946_up,
        down: _migration_20250527193946_down,
      );
}
