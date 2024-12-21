class RoomDatabase {
  final int version;
  final List<Type> entities;

  const RoomDatabase({
    required this.version,
    required this.entities,
  });
}
