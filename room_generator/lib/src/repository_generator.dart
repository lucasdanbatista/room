import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:room_annotation/room_annotation.dart';
import 'package:source_gen/source_gen.dart';

class RepositoryGenerator extends GeneratorForAnnotation<CrudRepository> {
  @override
  generateForAnnotatedElement(
    covariant ClassElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final emitter = DartEmitter();
    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    );
    final tableName = annotation.read('entity').typeValue;
    final databaseName =
        annotation.read('database').typeValue.getDisplayString();
    final pk = (tableName.element as ClassElement).fields.firstWhereOrNull(
        (e) =>
            TypeChecker.fromRuntime(PrimaryKey).firstAnnotationOf(e) != null);
    final findAllMethod = Method(
      (m) => m
        ..name = 'findAll'
        ..returns = refer('Future<List<$tableName>>')
        ..modifier = MethodModifier.async
        ..body = Code(
          '''
          final db = await openDatabase('$databaseName.db');
          final results = await db.query('$tableName');
          return results.map($tableName.fromJson).toList();
          ''',
        ),
    );
    final findByIdMethod = Method(
      (m) => m
        ..name = 'findById'
        ..returns = refer('Future<$tableName?>')
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer(pk!.type.getDisplayString())
              ..name = pk.displayName,
          ),
        )
        ..modifier = MethodModifier.async
        ..body = Code(
          '''
          final db = await openDatabase('$databaseName.db');
          final results = await db.query('$tableName', where: '${pk!.displayName} = ?', whereArgs: [${pk.displayName}]);
          if(results.isEmpty) return null;
          return $tableName.fromJson(results.first);
          ''',
        ),
    );
    final saveMethod = Method(
      (m) => m
        ..name = 'save'
        ..returns = refer('Future<void>')
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer(tableName.getDisplayString())
              ..name = 'it',
          ),
        )
        ..modifier = MethodModifier.async
        ..body = Code(
          '''
          final db = await openDatabase('$databaseName.db');
          await db.insert('$tableName', it.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          ''',
        ),
    );
    final deleteByIdMethod = Method(
      (m) => m
        ..name = 'deleteById'
        ..returns = refer('Future<void>')
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer(pk!.type.getDisplayString())
              ..name = pk.displayName,
          ),
        )
        ..modifier = MethodModifier.async
        ..body = Code(
          '''
          final db = await openDatabase('$databaseName.db');
          await db.delete('$tableName', where: '${pk!.displayName} = ?', whereArgs: [${pk.displayName}]);
          ''',
        ),
    );
    final mixin = Mixin(
      (e) => e
        ..name = '_\$${element.displayName}'
        ..methods.addAll([
          findAllMethod,
          findByIdMethod,
          saveMethod,
          deleteByIdMethod,
        ]),
    );
    return formatter.format(mixin.accept(emitter).toString());
  }
}
