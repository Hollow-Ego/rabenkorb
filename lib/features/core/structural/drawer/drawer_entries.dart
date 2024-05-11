import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/features/core/display/about.dart';
import 'package:rabenkorb/features/core/structural/drawer/drawer_entry.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/core/environment_service.dart';
import 'package:watch_it/watch_it.dart';

List<DrawerEntry> drawerEntriesBuilder(BuildContext context) => [
      DrawerEntry(
        title: S.of(context).Home,
        position: 1,
        onTap: (BuildContext context) => context.go(Routes.home),
        leading: const Icon(Icons.home),
      ),
      DrawerEntry(
        title: S.of(context).Settings,
        position: 1,
        onTap: (BuildContext context) => context.go(Routes.settings),
        leading: const Icon(Icons.settings),
      ),
      DrawerEntry(
        titleWidget: const AboutWidget(),
        position: 98,
      ),
      DrawerEntry(
        title: S.of(context).Backup,
        position: 1,
        onTap: (BuildContext context) => context.go(Routes.backup),
        leading: const Icon(Icons.save),
      ),
      if (di<EnvironmentService>().isDebug)
        DrawerEntry(
          title: S.of(context).Debug,
          position: 99,
          onTap: (BuildContext context) => context.go(Routes.debug),
          leading: const Icon(Icons.bug_report),
        ),
    ];
