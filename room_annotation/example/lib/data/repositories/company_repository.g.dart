// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_repository.dart';

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
