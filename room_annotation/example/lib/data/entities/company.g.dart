// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

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
