class MissingUnitException implements Exception {
  final int unitId;

  MissingUnitException(this.unitId);

  @override
  String toString() => "Item Unit with the ID of $unitId does not exist";
}
