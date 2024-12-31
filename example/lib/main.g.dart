// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

mixin _$MyDatabase {
  final List entities = [_$CompanyEntity()];

  Future<void> initialize() async {
    await openDatabase(
      'MyDatabase.db',
      version: 5,
      onCreate: (db, version) => _migrate(db, version),
      onUpgrade: (db, oldVersion, newVersion) => _migrate(db, newVersion),
    );
  }

  Future<void> _migrate(Database db, int newVersion) async {
    for (final entity in entities) {
      if (entity.migrations.containsKey(newVersion)) {
        for (final migration in entity.migrations[newVersion]!) {
          await db.execute(migration);
        }
      }
    }
  }
}

// **************************************************************************
// EntityGenerator
// **************************************************************************

interface class _$CompanyEntity {
  Map<int, List<String>> get migrations {
    return {
      1: [
        'create table Company (document text not null primary key);',
        'alter table Company add column name text null;',
      ],
      2: ['alter table Company add column phone text null;'],
      3: ['alter table Company add column address text null;'],
      4: ['alter table Company add column metadata text null;'],
      5: [
        'alter table Company add column metadata2 text null;',
        'alter table Company add column metadata3 text null;',
      ],
    };
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      document: json['document'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      metadata: json['metadata'] as String?,
      metadata2: json['metadata2'] as String?,
      metadata3: json['metadata3'] as String?,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'document': instance.document,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'metadata': instance.metadata,
      'metadata2': instance.metadata2,
      'metadata3': instance.metadata3,
    };

// **************************************************************************
// CrudRepositoryGenerator
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
