import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/generated/l10n.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: Container(),
      drawer: const CoreDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).Backup),
      ),
    );
  }
}
