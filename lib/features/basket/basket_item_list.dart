import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/basket_item_tile.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/list/core_grouped_list.dart';
import 'package:watch_it/watch_it.dart';

class BasketItemList extends StatelessWidget with WatchItMixin {
  const BasketItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<GroupedItems<BasketItemViewModel>>> items = watchStream((BasketService p0) => p0.basketItems, initialValue: []);
    final alwaysCollapseCategoriesData = watchStream((BasketStateService p0) => p0.alwaysCollapseCategories, initialValue: false);
    final alwaysCollapseCategories = alwaysCollapseCategoriesData.hasData && alwaysCollapseCategoriesData.data!;
    final activeSortRule = di<BasketStateService>().sortRuleIdSync;
    final isShoppingModeStream = watchStream((BasketStateService p0) => p0.isShoppingMode, initialValue: false);
    final isShoppingMode = isShoppingModeStream.data ?? false;
    final multiSelectMode = watchStream((BasketStateService p0) => p0.isMultiSelectMode, initialValue: false);
    final isMultiSelectMode = multiSelectMode.data ?? false;
    AsyncSnapshot<Map<int, bool>> selectedItems = watchStream((BasketStateService p0) => p0.selectedItemsMap, initialValue: {});
    final selectedItemsMap = selectedItems.data ?? {};

    return Expanded(
      child: CoreGroupedList<BasketItemViewModel>(
        listKey: 'basket-item-list',
        source: items.hasData ? items.data! : [],
        onListReorder: (int oldIndex, int newIndex, List<GroupedItems<BasketItemViewModel>> list) async {
          reorderGroupedItems(oldIndex, newIndex, list, activeSortRule);
        },
        canDragList: activeSortRule != null,
        itemContentBuilder: (BuildContext context, BasketItemViewModel item) {
          return BasketItemTile(
            item,
            isMultiSelectMode: isMultiSelectMode,
            isShoppingMode: isShoppingMode,
            isSelected: selectedItemsMap[item.id] ?? false,
          );
        },
        onExpansionChange: (bool isExpanded, ItemCategoryViewModel header, String headerKey) async {
          if (alwaysCollapseCategories) {
            return;
          }
          await di<BasketStateService>().setCollapseState(headerKey, !isExpanded);
        },
        getInitialExpansion: (String headerKey) {
          if (alwaysCollapseCategories) {
            return false;
          }
          return !di<BasketStateService>().isCollapsed(headerKey);
        },
      ),
    );
  }
}
