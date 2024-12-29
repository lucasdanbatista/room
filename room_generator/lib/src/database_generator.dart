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
          (e) =>
              'await db.execute(\$${e.toTypeValue()!.getDisplayString()}Entity.sql);',
        )
        .join('\n');
    final version = annotation.read('version').intValue;
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
            onCreate: (db, version) async {
              $entities
            },
            onUpgrade: onUpgrade,
          );
          ''',
        ),
    );
    final onUpgradeMethod = Method(
      (m) => m
        ..name = 'onUpgrade'
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
              ..name = 'oldVersion',
          ),
        )
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer('int')
              ..name = 'newVersion',
          ),
        ),
    );
    final mixin = Mixin(
      (e) => e
        ..name = '_\$${element.displayName}'
        ..methods.addAll([
          initializeMethod,
          onUpgradeMethod,
        ]),
    );
    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    );
    return formatter.format(mixin.accept(emitter).toString());
  }
}
