import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/widgets/list/core_list_ghost.dart';
import 'package:rabenkorb/shared/widgets/list/core_list_header.dart';
import 'package:rabenkorb/shared/widgets/list/core_placeholder.dart';

class CoreGroupedList<T extends DataItem> extends StatelessWidget {
  final void Function(int, int, int, int)? onItemReorder;
  final void Function(int, int, List<GroupedItems<T>>)? onListReorder;
  final void Function(bool, ItemCategoryViewModel, String)? onExpansionChange;
  final bool Function(String) getInitialExpansion;
  final bool canDragList;
  final bool canDragItem;

  final List<GroupedItems<T>> source;
  final Widget Function(BuildContext, T) itemContentBuilder;
  final String? listKey;

  const CoreGroupedList({
    super.key,
    required this.source,
    required this.itemContentBuilder,
    required this.getInitialExpansion,
    this.onItemReorder,
    this.onListReorder,
    this.canDragList = false,
    this.canDragItem = false,
    this.onExpansionChange,
    this.listKey,
  });

  Widget _buildHeader(String header, String subKey) {
    return CoreListHeader(
      header: header,
      subKey: subKey,
    );
  }

  List<DragAndDropListInterface> _createChildren(BuildContext context) {
    return _mapItemsAndAdd(context);
  }

  List<DragAndDropListInterface> _mapItemsAndAdd(BuildContext context) {
    return source.map((itemGroup) {
      final header = itemGroup.category.name;
      final headerKey = itemGroup.category.key;

      final mappedItems = itemGroup.items.map((T v) {
        return DragAndDropItem(
          child: itemContentBuilder(context, v),
          canDrag: canDragItem,
        );
      }).toList();

      final newList = DragAndDropListExpansion(
        listKey: Key(headerKey),
        title: _buildHeader(header, headerKey),
        children: mappedItems,
        canDrag: canDragList,
        disableTopAndBottomBorders: true,
        initiallyExpanded: getInitialExpansion(headerKey),
        onExpansionChanged: (bool expanded) {
          if (onExpansionChange != null) {
            onExpansionChange!(expanded, itemGroup.category, headerKey);
          }
        },
      );

      return newList;
    }).toList();
  }

  void _onListReorder(int oldIndex, int newIndex) {
    if (onListReorder == null) {
      return;
    }
    onListReorder!(oldIndex, newIndex, source);
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropLists(
      key: listKey.isValid() ? Key(listKey!) : null,
      children: _createChildren(context),
      onItemReorder: onItemReorder ?? (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {},
      onListReorder: _onListReorder,
      contentsWhenEmpty: const CorePlaceholder(),
      listGhost: const CoreListGhost(),
    );
  }
}
