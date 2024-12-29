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
    );
    var pk = '';
    if (primaryKey != null) {
      pk = '${primaryKey.name} ${_type(primaryKey)} primary key';
    }
    if (pk.isNotEmpty) {
      pk += ',';
    }
    final fields = element.fields.where(
      (e) => TypeChecker.fromRuntime(Column).firstAnnotationOf(e) != null,
    );
    String columns = '';
    for (final field in fields) {
      final trailing = field != fields.last ? ',' : '';
      columns += '${field.name} ${_type(field)} $trailing';
    }
    if (columns.isEmpty) {
      pk = pk.replaceAll(',', '');
    }
    final emitter = DartEmitter();
    final method = Method(
      (m) => m
        ..name = 'sql'
        ..type = MethodType.getter
        ..static = true
        ..body = Code(
          'return \'create table ${element.displayName} ('
          '$pk'
          '$columns'
          ');\';',
        )
        ..returns = refer('String'),
    );
    final mixin = Mixin(
      (e) => e
        ..name = '\$${element.name}Entity'
        ..methods.add(method),
    );
    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    );
    return formatter.format(mixin.accept(emitter).toString());
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
