import 'package:rabenkorb/services/core/version_service.dart';
import 'package:watch_it/watch_it.dart';

void enrichWithAppVersion(Map<String, dynamic> data) {
  final versionService = di<VersionService>();
  final internalVersion = versionService.internalAppVersion;
  final publicVersion = versionService.publicAppVersion;
  data["internal_app_version"] = internalVersion;
  data["public_app_version"] = publicVersion;
}
