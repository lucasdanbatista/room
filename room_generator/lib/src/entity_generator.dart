import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:room_annotation/room_annotation.dart';
import 'package:source_gen/source_gen.dart';

class EntityGenerator extends GeneratorForAnnotation<Entity> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    covariant ClassElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final primaryKey = element.fields.firstWhereOrNull(
      (e) => TypeChecker.fromRuntime(PrimaryKey).firstAnnotationOf(e) != null,
    )!;
    final initialSchema =
        "'create table ${element.name} (${primaryKey.name} ${_type(primaryKey)} primary key);'";
    final fields = element.fields.where(
      (e) => TypeChecker.fromRuntime(Column).firstAnnotationOf(e) != null,
    );
    final migrations = <int, List<String>>{
      1: [initialSchema],
    };
    for (final field in fields) {
      final since = TypeChecker.fromRuntime(Column)
          .firstAnnotationOf(field)!
          .getField('since')!
          .toIntValue()!;
      if (!migrations.containsKey(since)) {
        migrations[since] = [];
      }
      migrations[since]!.add(
        "'alter table ${element.name} add column ${field.name} ${_type(field)};'",
      );
    }
    final migrationsCode = migrations
        .map(
          (since, migrations) => MapEntry(
            since,
            "$since: [${migrations.join(',')}],",
          ),
        )
        .values
        .join();
    final emitter = DartEmitter();
    final method = Method(
      (m) => m
        ..name = 'migrations'
        ..type = MethodType.getter
        ..static = true
        ..body = Code('return {$migrationsCode};')
        ..returns = refer('Map<int, List<String>>'),
    );
    final class$ = Class(
      (e) => e
        ..name = '\$${element.name}Entity'
        ..modifier = ClassModifier.interface
        ..methods.add(method),
    );
    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    );
    return formatter.format(class$.accept(emitter).toString());
  }

  String _type(FieldElement field) {
    final type = field.type.toString();
    return switch (type) {
      'String' => 'text not null',
      'String?' => 'text null',
      'double' => 'real not null',
      'double?' => 'real null',
      'int' => 'integer not null',
      'int?' => 'integer null',
      _ => throw UnsupportedError('type is not supported: $type'),
    };
  }
}
