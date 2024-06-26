import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/business/sort_service.dart';
import 'package:rabenkorb/services/core/dialog_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/services/state/loading_state.dart';
import 'package:rabenkorb/shared/state_types.dart';
import 'package:rabenkorb/shared/widgets/rename_dialog.dart';
import 'package:watch_it/watch_it.dart';

Future<T> doWithLoadingIndicator<T>(Future<T> Function() operation) async {
  try {
    di<LoadingIndicatorState>().start();
    final result = await operation();
    return result;
  } finally {
    di<LoadingIndicatorState>().stop();
  }
}

Future<void> doWithConfirmation(
  BuildContext context, {
  required Future<void> Function() onConfirm,
  required String text,
  String? title,
  StateType type = StateType.warning,
  Future<void> Function()? onCancel,
}) async {
  return await di<DialogService>().showConfirm(
    context: context,
    text: text,
    title: title,
    type: type,
    onConfirm: onConfirm,
    onCancel: onCancel,
  );
}

Future<void> showRenameDialog(
  BuildContext context, {
  String? initialName,
  required Future<void> Function(String? newName, bool nameChanged) onConfirm,
  Future<void> Function()? onCancel,
}) {
  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return RenameDialog(
        initialName: initialName,
        onConfirm: (String? newName) async {
          bool nameChanged = newName != initialName;
          onConfirm(newName, nameChanged);
        },
        onCancel: onCancel,
      );
    },
  );
}

Future<bool> confirmPermissions(BuildContext context) async {
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

Future<ImageSource?> pickImageSource(BuildContext context) async {
  final dialogResult = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(S.of(context).ChooseSource),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: Text(S.of(context).TakePicture),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: Text(S.of(context).FromGallery),
            ),
          ],
        );
      });
  switch (dialogResult) {
    case ImageSource.gallery:
      return ImageSource.gallery;
    case ImageSource.camera:
      return ImageSource.camera;
    default:
      return null;
  }
}

Future<XFile?> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: source,
    maxWidth: 600,
  );

  return image;
}

Future<void> reorderGroupedItems<T extends DataItem>(int oldIndex, int newIndex, List<GroupedItems<T>> list, int? activeSortRuleId) async {
  if (activeSortRuleId == null || newIndex == oldIndex) {
    return;
  }
  final visibleCategories = list.map((e) => e.category).toList();

  await reorderCategories(oldIndex, newIndex, visibleCategories, activeSortRuleId);
}

Future<void> reorderCategories(int oldIndex, int newIndex, List<ItemCategoryViewModel> list, int? activeSortRuleId) async {
  if (activeSortRuleId == null || newIndex == oldIndex) {
    return;
  }
  await di<SortService>().updateOrderSingle(activeSortRuleId, list, oldIndex, newIndex);
  await di<LibraryStateService>().setSortRuleId(activeSortRuleId);
}
