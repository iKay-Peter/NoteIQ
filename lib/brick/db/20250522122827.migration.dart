// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250522122827_up = [
  InsertColumn('name', Column.varchar, onTable: 'AppUser'),
  InsertColumn('avatar_url', Column.varchar, onTable: 'AppUser')
];

const List<MigrationCommand> _migration_20250522122827_down = [
  DropColumn('name', onTable: 'AppUser'),
  DropColumn('avatar_url', onTable: 'AppUser')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250522122827',
  up: _migration_20250522122827_up,
  down: _migration_20250522122827_down,
)
class Migration20250522122827 extends Migration {
  const Migration20250522122827()
    : super(
        version: 20250522122827,
        up: _migration_20250522122827_up,
        down: _migration_20250522122827_down,
      );
}
