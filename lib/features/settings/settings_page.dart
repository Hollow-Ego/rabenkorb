import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/features/settings/basket_settings.dart';
import 'package:rabenkorb/features/settings/general_settings.dart';
import 'package:rabenkorb/features/settings/library_settings.dart';
import 'package:rabenkorb/generated/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              GeneralSettings(),
              BasketSettings(),
              LibrarySettings(),
            ],
          ),
        ),
      ),
      drawer: const CoreDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).Settings),
      ),
    );
  }
}
