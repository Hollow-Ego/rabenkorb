import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/display/app_version.dart';
import 'package:rabenkorb/features/core/structural/drawer/drawer_entries.dart';
import 'package:rabenkorb/features/core/structural/drawer/drawer_entry.dart';
import 'package:rabenkorb/generated/l10n.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    drawerEntries.sort((a, b) => a.index.compareTo(b.index));

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: ListView(
            children: [
              DrawerHeader(
                child: Text(S.of(context).Menu),
              ),
              ...drawerEntries.map((entry) => _toListTile(context, entry)),
            ],
          )),
          const AppVersion(),
        ],
      ),
    );
  }

  Widget _toListTile(BuildContext context, DrawerEntry entry) {
    return ListTile(
      leading: entry.leading,
      title: Text(entry.title),
      onTap: () => entry.onTap(context),
    );
  }
}
