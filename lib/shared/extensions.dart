extension StringTransformation on String {
  String toLowerSpaceless() {
    return toLowerCase().replaceAll(' ', '-');
  }
}
