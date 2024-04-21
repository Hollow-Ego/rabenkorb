import 'package:flutter/material.dart';
import 'package:rabenkorb/services/core/version_service.dart';
import 'package:watch_it/watch_it.dart';

class AppVersion extends StatelessWidget {
  final bool showPublicAppVersion;

  const AppVersion({super.key, this.showPublicAppVersion = false});

  @override
  Widget build(BuildContext context) {
    final versionService = di<VersionService>();
    final version = showPublicAppVersion ? versionService.publicAppVersion : versionService.internalAppVersion;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Text(
        version,
        textAlign: TextAlign.end,
      ),
    );
  }
}
