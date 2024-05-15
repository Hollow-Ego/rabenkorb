import 'package:flutter/material.dart';
import 'package:rabenkorb/features/backup/backup_create.dart';
import 'package:rabenkorb/features/backup/backup_restore.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/generated/l10n.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BackupCreate(),
              SizedBox(height: 30),
              BackupRestore(),
            ],
          ),
        ),
      ),
      drawer: const CoreDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).Backup),
      ),
    );
  }
}
