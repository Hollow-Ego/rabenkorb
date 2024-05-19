import 'package:package_info_plus/package_info_plus.dart';
import 'package:rabenkorb/services/core/environment_service.dart';
import 'package:watch_it/watch_it.dart';

class VersionService {
  static const String _styleVersion = "0";
  static const String _debugSuffix = ".db-0";

  late String _packageVersion;

  get publicAppVersion {
    return _packageVersion;
  }

  String get internalAppVersion {
    return di<EnvironmentService>().isDebug ? "$_packageVersion.$_styleVersion$_debugSuffix" : "$_packageVersion.$_styleVersion";
  }

  VersionService();

  VersionService.forTest() {
    _packageVersion = "1.0.0";
  }

  Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _packageVersion = packageInfo.version;
  }
}
