class SaveDeleteResult<T> {
  final int deletedRows;
  final T? deletedObject;

  SaveDeleteResult({required this.deletedObject, required this.deletedRows});
}
