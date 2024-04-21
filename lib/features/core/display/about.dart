import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/core/version_service.dart';
import 'package:watch_it/watch_it.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  static const String legalese = "\u{a9} 2024 Alexander Pahn";

  @override
  Widget build(BuildContext context) {
    final versionService = di<VersionService>();
    return AboutListTile(
      icon: const Icon(Icons.info),
      applicationName: S.of(context).AppTitle,
      applicationVersion: versionService.internalAppVersion,
      applicationLegalese: legalese,
    );
  }
}
