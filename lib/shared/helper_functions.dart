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
import 'package:rabenkorb/shared/default_sort_rules.dart';
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

void reorderGroupedItems<T extends DataItem>(int oldIndex, int newIndex, List<GroupedItems<T>> list, int? activeSortRuleId) async {
  if (activeSortRuleId == null || newIndex == oldIndex) {
    return;
  }
  // New index would be relative to the list without the item being reordered
  newIndex--;
  final filteredList = list.where((e) => e.category.id != withoutCategoryId).toList();
  final reorderedItem = filteredList[oldIndex];
  final placeAfterItem = newIndex < filteredList.length && newIndex >= 0
      ? filteredList[newIndex]
      : newIndex >= filteredList.length
          ? filteredList.last
          : null;
  final placeBeforeItem = newIndex < 0 ? filteredList.first : null;

  final targetId = reorderedItem.category.id;
  final placeAfterId = placeAfterItem?.category.id;
  final placeBeforeId = placeBeforeItem?.category.id;

  await di<SortService>().updateOrderSingle(activeSortRuleId, targetId, placeBeforeId: placeBeforeId, placeAfterId: placeAfterId);
  await di<LibraryStateService>().setSortRuleId(activeSortRuleId);
}

void reorderCategories(int oldIndex, int newIndex, List<ItemCategoryViewModel> list, int? activeSortRuleId) async {
  if (activeSortRuleId == null || newIndex == oldIndex) {
    return;
  }
  // New index would be relative to the list without the item being reordered
  newIndex--;

  final reorderedItem = list[oldIndex];
  final placeAfterItem = newIndex < list.length && newIndex >= 0
      ? list[newIndex]
      : newIndex >= list.length
          ? list.last
          : null;
  final placeBeforeItem = newIndex < 0 ? list.first : null;

  final targetId = reorderedItem.id;
  final placeAfterId = placeAfterItem?.id;
  final placeBeforeId = placeBeforeItem?.id;

  await di<SortService>().updateOrderSingle(activeSortRuleId, targetId, placeBeforeId: placeBeforeId, placeAfterId: placeAfterId);
  await di<LibraryStateService>().setSortRuleId(activeSortRuleId);
}
