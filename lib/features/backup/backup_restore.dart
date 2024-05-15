import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';

class BackupRestore extends StatelessWidget {
  const BackupRestore({super.key});

  @override
  Widget build(BuildContext context) {
    return CorePrimaryButton(
      onPressed: () => context.push(Routes.backupRestore),
      child: Text(S.of(context).BackupImport),
    );
  }
}
