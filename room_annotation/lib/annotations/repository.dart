import 'package:room_annotation/room_annotation.dart';

///Create basic read/write operations to be used on a given [Entity]
class CrudRepository<D extends Type, E extends Type> {
  final D database;
  final E entity;

  const CrudRepository({
    required this.database,
    required this.entity,
  });
}
