///Entry point for the given database.
class RoomDatabase {
  ///The current database version
  final int version;

  ///Entities of the database
  final List<Type> entities;

  const RoomDatabase({
    required this.version,
    required this.entities,
  });
}
