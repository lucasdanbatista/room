// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

mixin _$MyDatabase {
  Future<void> initialize() async {
    await openDatabase(
      'MyDatabase.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute($CompanyEntity.sql);
      },
      onUpgrade: onUpgrade,
    );
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion);
}

// **************************************************************************
// EntityGenerator
// **************************************************************************

mixin $CompanyEntity {
  static String get sql {
    return 'create table Company (document text not null primary key,name text null );';
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      document: json['document'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'document': instance.document,
      'name': instance.name,
    };

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

mixin _$CompanyRepository {
  Future<List<Company>> findAll() async {
    final db = await openDatabase('MyDatabase.db');
    final results = await db.query('Company');
    return results.map(Company.fromJson).toList();
  }

  Future<Company?> findById(String document) async {
    final db = await openDatabase('MyDatabase.db');
    final results = await db.query(
      'Company',
      where: 'document = ?',
      whereArgs: [document],
    );
    if (results.isEmpty) return null;
    return Company.fromJson(results.first);
  }

  Future<void> save(Company it) async {
    final db = await openDatabase('MyDatabase.db');
    await db.insert(
      'Company',
      it.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteById(String document) async {
    final db = await openDatabase('MyDatabase.db');
    await db.delete('Company', where: 'document = ?', whereArgs: [document]);
  }
}
