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
    final cleanedDecimalString = this?.replaceAll(',', '.');
    if (cleanedDecimalString == null) {
      return 0;
    }
    return double.tryParse(cleanedDecimalString) ?? 0;
  }
}

extension DoubleTransformation on double {
  String toFormattedString() {
    if (this == 0) {
      return "";
    }
    var text = toString().replaceAll(',', '.');
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
