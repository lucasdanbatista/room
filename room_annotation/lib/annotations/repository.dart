class CrudRepository<D extends Type, E extends Type> {
  final D database;
  final E entity;

  const CrudRepository({
    required this.database,
    required this.entity,
  });
}
