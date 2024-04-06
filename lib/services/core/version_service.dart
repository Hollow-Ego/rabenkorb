import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  static const String _styleVersion = "0";
  static const String _debugSuffix = ".db-1";

  late bool _isDebug;
  late String _packageVersion;

  get publicAppVersion {
    return _packageVersion;
  }

  get isDebugOrDev => _isDebug;

  String get internalAppVersion {
    return _isDebug ? "$_packageVersion$_styleVersion$_debugSuffix" : "$_packageVersion$_styleVersion";
  }

  VersionService();

  VersionService.forTest() {
    _isDebug = false;
    _packageVersion = "1.0.0";
  }

  Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _isDebug = _isDebugOrDevPackage(packageInfo.packageName) || kDebugMode;
    _packageVersion = packageInfo.version;
  }

  bool _isDebugOrDevPackage(String packageName) {
    return packageName.endsWith(".debug") || packageName.endsWith(".dev");
  }
}
