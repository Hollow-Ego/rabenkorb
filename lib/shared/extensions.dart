extension StringTransformation on String {
  String toLowerSpaceless() {
    return toLowerCase().replaceAll(' ', '-');
  }
}

extension NullableStrings on String? {
  bool isValid() {
    return this != null && this!.isNotEmpty;
  }

  double toDoubleOrZero() {
    return double.tryParse(this!) ?? 0;
  }
}

extension DoubleTransformation on double {
  String toFormattedString() {
    var text = toString();
    if (text.contains('.') && double.parse(text) == truncateToDouble()) {
      return text.substring(0, text.indexOf('.'));
    }
    return text;
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
