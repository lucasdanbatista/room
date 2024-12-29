import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'database_generator.dart';
import 'entity_generator.dart';
import 'repository_generator.dart';

Builder repositoryBuilder(BuilderOptions options) =>
    SharedPartBuilder([RepositoryGenerator()], 'repository');

Builder databaseBuilder(BuilderOptions options) =>
    SharedPartBuilder([DatabaseGenerator()], 'database');

Builder entityBuilder(BuilderOptions options) =>
    SharedPartBuilder([EntityGenerator()], 'entity');
