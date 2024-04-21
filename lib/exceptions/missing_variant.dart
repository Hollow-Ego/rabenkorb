class MissingVariantException implements Exception {
  final int variantId;

  MissingVariantException(this.variantId);

  @override
  String toString() => "Variant Key with the ID of $variantId does not exist";
}
