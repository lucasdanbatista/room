import 'package:room/room.dart';
import 'package:sqflite/sqflite.dart';

import '../database.dart';
import '../entities/company.dart';

part 'company_repository.g.dart';

@CrudRepository(
  database: MyDatabase,
  entity: Company,
)
class CompanyRepository with _$CompanyRepository {}
