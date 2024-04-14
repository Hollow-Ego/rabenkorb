import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/debug/language_debug.dart';
import 'package:rabenkorb/features/core/debug/logging_debug.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/generated/l10n.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: const [
            LanguageDebug(),
            LoggingDebug(),
          ],
        ),
      ),
      drawer: const CoreDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).Debug),
      ),
    );
  }
}
