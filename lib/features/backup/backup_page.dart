import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/core/dialog_service.dart';
import 'package:rabenkorb/services/utility/backup_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/state_types.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CorePrimaryButton(
              onPressed: () => _createBackup(context),
              child: Text(S.of(context).BackupCreate),
            )
          ],
        ),
      ),
      drawer: const CoreDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).Backup),
      ),
    );
  }

  Future<void> _createBackup(BuildContext context) async {
    final canAccessExternalStorage = await _confirmPermissions(context);
    if (!canAccessExternalStorage) {
      return;
    }
    final exportPath = await FilePicker.platform.getDirectoryPath();
    if (exportPath == null || exportPath.trim().isEmpty) {
      return;
    }
    doWithLoadingIndicator(() async {
      await di<BackupService>().backup(exportPath);
    });
  }

  Future<bool> _confirmPermissions(BuildContext context) async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }
    var askForPermission = false;
    await di<DialogService>().showConfirm(
      context: context,
      confirmBtnText: S.of(context).SetPermission,
      title: S.of(context).PermissionsRequired,
      text: S.of(context).MessagePermissionRequired,
      type: StateType.warning,
      onConfirm: () async {
        askForPermission = true;
      },
    );

    if (!askForPermission) {
      return false;
    }

    return await Permission.manageExternalStorage.request().isGranted;
  }
}
