import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/core/snackbar_service.dart';
import 'package:rabenkorb/services/utility/backup_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/constant_widgets.dart';
import 'package:rabenkorb/shared/widgets/display/core_card.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_text_button.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  String? _backupFile;
  String? _displayPath;
  bool _overwriteCurrentData = true;

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CoreCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CoreIconTextButton(
                        icon: const Icon(Icons.folder),
                        label: Text(S.of(context).SelectBackup),
                        onPressed: _pickAndSetBackupDirectory,
                      ),
                    ],
                  ),
                  if (_displayPath != null) Text(_displayPath!),
                  gap,
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(S.of(context).BackupOverwriteExisting),
                  //     CoreCheckbox(
                  //       value: _overwriteCurrentData,
                  //       onChanged: (bool? isChecked) async {
                  //         setState(() {
                  //           _overwriteCurrentData = isChecked ?? false;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  if (_overwriteCurrentData)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).BackupOverwriteWarning,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_displayPath != null) gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CorePrimaryButton(
                        child: Text(S.of(context).BackupImport),
                        onPressed: () async {
                          await _startImport(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _pickAndSetBackupDirectory() async {
    final canAccessExternalStorage = await confirmPermissions(context);
    if (!canAccessExternalStorage) {
      return;
    }
    final backupFile = await FilePicker.platform.getDirectoryPath();
    if (backupFile == null) {
      return;
    }
    setState(() {
      _backupFile = backupFile;
      _displayPath = p.basename(backupFile);
    });
  }

  Future<void> _startImport(BuildContext context) async {
    if (_backupFile == null) {
      return;
    }
    bool importSuccess = false;
    await doWithLoadingIndicator(() async {
      importSuccess = await di<BackupService>().restore(_backupFile!);
    });
    if (!context.mounted) {
      return;
    }
    if (importSuccess) {
      di<SnackBarService>().show(context: context, text: S.of(context).BackupImported);
      context.pop();
      return;
    }
    di<SnackBarService>().show(context: context, text: S.of(context).BackupImportFailed);
  }
}
