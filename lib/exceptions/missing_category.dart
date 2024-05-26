class MissingCategoryException implements Exception {
  final int categoryId;

  MissingCategoryException(this.categoryId);

  @override
  String toString() => "Category with the ID of $categoryId does not exist";
}

class MissingSubCategoryException implements Exception {
  final int subCategoryId;

  MissingSubCategoryException(this.subCategoryId);

  @override
  String toString() => "Sub-Category with the ID of $subCategoryId does not exist";
}
