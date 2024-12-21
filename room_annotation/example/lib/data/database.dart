import 'package:room/room.dart';
import 'package:sqflite/sqflite.dart';

import 'entities/company.dart';
import 'entities/person.dart';

part 'database.g.dart';

@RoomDatabase(
  version: 5,
  entities: [Person, Company],
)
class MyDatabase with _$MyDatabase {
  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion == 3) {
      await db.rawQuery('alter table Company add column name text null');
    }
  }
}
