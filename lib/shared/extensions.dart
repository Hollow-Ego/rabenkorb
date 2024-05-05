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
