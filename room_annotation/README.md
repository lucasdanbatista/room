A code generator to use with `sqflite` package.

### Getting started

#### Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  room_annotation: 0.1.0
  sqflite: ^2.4.1
  json_annotation: ^4.9.0

dev_dependencies:
  room_generator: 0.1.0
  build_runner: ^2.4.14
  json_serializable: ^6.9.2
```

#### Create your entities

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:room/room.dart';

part 'company.g.dart';

@Entity()
@JsonSerializable()
class Company with $CompanyEntity {
  @PrimaryKey()
  final String document;

  @Column()
  String? name;

  Company({
    required this.document,
    this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
```

#### Create your database:

```dart
import 'package:room/room.dart';
import 'package:sqflite/sqflite.dart';

import 'company.dart';

part 'database.g.dart';

@RoomDatabase(
  version: 1,
  entities: [Company],
)
class MyDatabase with _$MyDatabase {
  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    //TODO: run your db migrations here. See the docs from `sqflite` package.
  }
}
```

#### Create your crud repository:

```dart
import 'package:room/room.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'company.dart';

part 'company_repository.g.dart';

@CrudRepository(
  database: MyDatabase,
  entity: Company,
)
class CompanyRepository with _$CompanyRepository {}
```

#### Run and test:

```dart
import 'company.dart';
import 'company_repository.dart';
import 'database.dart';


void main() async {
  final db = MyDatabase();
  await db.initialize();
  final repository = CompanyRepository();
  await repository.save(
    Company(
      document: '123456',
      name: 'The Company',
    ),
  );
  final companies = await repository.findAll();
  for (final company in companies) {
    print(company.name);
  }
}
```

