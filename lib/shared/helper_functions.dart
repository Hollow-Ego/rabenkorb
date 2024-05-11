import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/services/data_access/sort_order_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/services/state/loading_state.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
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
  if (activeSortRuleId == null) {
    return;
  }

  final reorderedItem = list.removeAt(oldIndex);
  list.insert(newIndex, reorderedItem);

  final newOrder = list.where((e) => e.category.id != withoutCategoryId).map((e) => e.category.id).toList();
  await di<SortOrderService>().setOrder(activeSortRuleId, newOrder);
  await di<LibraryStateService>().setSortRuleId(activeSortRuleId);
}
