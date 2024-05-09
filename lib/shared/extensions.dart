extension StringTransformation on String {
  String toLowerSpaceless() {
    return toLowerCase().replaceAll(' ', '-');
  }
}

extension NullableStrings on String? {
  bool isValid() {
    return this != null && this!.isNotEmpty;
  }
}

extension FirstWhereExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
