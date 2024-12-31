import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:room_annotation/room_annotation.dart';
import 'package:source_gen/source_gen.dart';

class DatabaseGenerator extends GeneratorForAnnotation<RoomDatabase> {
  @override
  generateForAnnotatedElement(
    covariant ClassElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final emitter = DartEmitter();
    final entities = annotation
        .read('entities')
        .listValue
        .map(
          (e) => '\$${e.toTypeValue()!.getDisplayString()}Entity(),',
        )
        .join('\n');
    final version = annotation.read('version').intValue;
    final entitiesField = Field(
      (f) => f
        ..name = 'entities'
        ..modifier = FieldModifier.final$
        ..type = Reference('List')
        ..assignment = Code('[$entities]'),
    );
    final initializeMethod = Method(
      (m) => m
        ..name = 'initialize'
        ..returns = refer('Future<void>')
        ..modifier = MethodModifier.async
        ..body = Code(
          '''
          await openDatabase(
            '${element.displayName}.db',
            version: $version,
            onCreate: (db, version) => _migrate(db, version),
            onUpgrade: (db, oldVersion, newVersion) => _migrate(db, newVersion),
          );
          ''',
        ),
    );
    final migrateMethod = Method(
      (m) => m
        ..name = '_migrate'
        ..returns = refer('Future<void>')
        ..modifier = MethodModifier.async
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer('Database')
              ..name = 'db',
          ),
        )
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer('int')
              ..name = 'newVersion',
          ),
        )
        ..body = Code(
          '''
          for (final entity in entities) {
            if (entity.migrations.containsKey(newVersion)) {
              for (final migration in entity.migrations[newVersion]!) {
                await db.execute(migration);
              }
            }
          }
          ''',
        ),
    );
    final mixin = Mixin(
      (e) => e
        ..name = '_\$${element.displayName}'
        ..fields.add(entitiesField)
        ..methods.addAll([
          initializeMethod,
          migrateMethod,
        ]),
    );
    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    );
    return formatter.format(mixin.accept(emitter).toString());
  }
}
