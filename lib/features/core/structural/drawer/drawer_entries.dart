import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/features/core/structural/drawer/drawer_entry.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/routing/routes.dart';

List<DrawerEntry> drawerEntries = [
  DrawerEntry(
    title: S.current.Home,
    index: 99,
    onTap: (BuildContext context) => context.go(Routes.home),
    leading: const Icon(Icons.home),
  ),
  DrawerEntry(
    title: S.current.Debug,
    index: 99,
    onTap: (BuildContext context) => context.go(Routes.debug),
    leading: const Icon(Icons.bug_report),
  ),
];
