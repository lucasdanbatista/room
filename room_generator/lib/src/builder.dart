import 'package:build/build.dart';
import 'package:room_annotation/room_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'crud_repository_generator.dart';
import 'database_generator.dart';
import 'entity_generator.dart';

/// Code generator for [CrudRepository] annotation. It provides basic read/write
/// operations to use on a single [Entity].
Builder crudRepositoryBuilder(BuilderOptions options) =>
    SharedPartBuilder([CrudRepositoryGenerator()], 'repository');

/// Code generator for [RoomDatabase] annotation. It provides a Room entrypoint
/// for some database.
Builder databaseBuilder(BuilderOptions options) =>
    SharedPartBuilder([DatabaseGenerator()], 'database');

/// Code generator for [Entity] annotation. It provides a SQL schema based on
/// the given class properties.
Builder entityBuilder(BuilderOptions options) =>
    SharedPartBuilder([EntityGenerator()], 'entity');
