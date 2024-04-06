class MissingCategoryException implements Exception {
  final int categoryId;

  MissingCategoryException(this.categoryId);

  @override
  String toString() => "Category with the ID of $categoryId does not exist";
}
