import 'package:flutter/material.dart';
import 'package:rabenkorb/features/library/item_template_tile.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/list/core_grouped_list.dart';
import 'package:watch_it/watch_it.dart';

class LibraryItemTemplateList extends StatelessWidget with WatchItMixin {
  const LibraryItemTemplateList({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<GroupedItems<ItemTemplateViewModel>>> templates = watchStream((LibraryService p0) => p0.itemTemplates, initialValue: []);
    final alwaysCollapseCategoriesData = watchStream((LibraryStateService p0) => p0.alwaysCollapseCategories, initialValue: false);
    final alwaysCollapseCategories = alwaysCollapseCategoriesData.hasData && alwaysCollapseCategoriesData.data!;
    final activeSortRule = di<LibraryStateService>().sortRuleIdSync;

    final multiSelectMode = watchStream((LibraryStateService p0) => p0.isMultiSelectMode, initialValue: false);
    final isMultiSelectMode = multiSelectMode.data ?? false;

    AsyncSnapshot<Map<int, bool>> selectedItems = watchStream((LibraryStateService p0) => p0.selectedItemsMap, initialValue: {});
    final selectedItemsMap = selectedItems.data ?? {};

    return Expanded(
      child: CoreGroupedList<ItemTemplateViewModel>(
        listKey: 'library-item-template-list',
        source: templates.hasData ? templates.data! : [],
        onListReorder: (int oldIndex, int newIndex, List<GroupedItems<ItemTemplateViewModel>> list) async {
          reorderGroupedItems(oldIndex, newIndex, list, activeSortRule);
        },
        canDragList: activeSortRule != null,
        itemContentBuilder: (BuildContext context, ItemTemplateViewModel item) {
          return ItemTemplateTile(
            item,
            isMultiSelectMode: isMultiSelectMode,
            isSelected: selectedItemsMap[item.id] ?? false,
          );
        },
        onExpansionChange: (bool isExpanded, ItemCategoryViewModel header, String headerKey) async {
          if (alwaysCollapseCategories) {
            return;
          }
          await di<LibraryStateService>().setCollapseState(headerKey, !isExpanded);
        },
        getInitialExpansion: (String headerKey) {
          if (alwaysCollapseCategories) {
            return false;
          }
          return !di<LibraryStateService>().isCollapsed(headerKey);
        },
      ),
    );
  }
}
