import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/core/snackbar_service.dart';
import 'package:rabenkorb/services/utility/backup_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class BackupCreate extends StatelessWidget {
  const BackupCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return CorePrimaryButton(
      onPressed: () => _createBackup(context),
      child: Text(S.of(context).BackupCreate),
    );
  }

  Future<void> _createBackup(BuildContext context) async {
    final canAccessExternalStorage = await confirmPermissions(context);
    if (!canAccessExternalStorage) {
      return;
    }
    final exportPath = await FilePicker.platform.getDirectoryPath();
    if (exportPath == null || exportPath.trim().isEmpty) {
      return;
    }
    bool exportSuccess = false;
    await doWithLoadingIndicator(() async {
      exportSuccess = await di<BackupService>().backup(exportPath);
    });

    if (!context.mounted) {
      return;
    }
    if (exportSuccess) {
      di<SnackBarService>().show(context: context, text: S.of(context).BackupCreated);
      return;
    }
    di<SnackBarService>().show(context: context, text: S.of(context).BackupCreationFailed);
  }
}
