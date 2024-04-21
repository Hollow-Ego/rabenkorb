class IncompatibleAppVersionException implements Exception {
  final String appVersion;

  IncompatibleAppVersionException(this.appVersion);

  @override
  String toString() => "App version $appVersion is not compatible with the current app version";
}
