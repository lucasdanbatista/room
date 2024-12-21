// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

mixin _$MyDatabase {
  Future<void> initialize() async {
    await openDatabase(
      'MyDatabase.db',
      version: 5,
      onCreate: (db, version) async {
        await db.execute($PersonEntity.sql);
        await db.execute($CompanyEntity.sql);
      },
      onUpgrade: onUpgrade,
    );
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion);
}
