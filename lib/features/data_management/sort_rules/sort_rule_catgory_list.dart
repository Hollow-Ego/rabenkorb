import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/sort_rules/sort_rule_category_tile.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/business/data_management_service.dart';
import 'package:rabenkorb/services/state/data_management_state_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:watch_it/watch_it.dart';

class SortRuleCategoryList extends StatelessWidget with WatchItMixin {
  const SortRuleCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<ItemCategoryViewModel>> categories = watchStream((DataManagementService p0) => p0.categories, initialValue: []);
    final categoryList = categories.data ?? [];
    final activeSortRule = di<DataManagementStateService>().sortRuleIdSync;

    return Expanded(
      child: DragAndDropLists(
        onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
          reorderCategories(oldItemIndex, newItemIndex, categoryList, activeSortRule);
        },
        onListReorder: (int oldListIndex, int newListIndex) {},
        contentsWhenEmpty: Text(S.of(context).SelectSortRule),
        children: [
          if (categoryList.isNotEmpty)
            DragAndDropList(
              children: _toDragAndDropItem(categoryList, activeSortRule),
            )
        ],
      ),
    );
  }

  List<DragAndDropItem> _toDragAndDropItem(List<ItemCategoryViewModel> categories, int? activeSortRule) {
    return categories.map((c) {
      return DragAndDropItem(
        child: SortRuleCategoryTile(category: c),
        canDrag: activeSortRule != null,
      );
    }).toList();
  }
}
