import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/display/list/core_grouped_list.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

class LibraryView extends StatelessWidget with WatchItMixin {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<GroupedItems<ItemTemplateViewModel>>> templates = watchStream((LibraryService p0) => p0.itemTemplates, initialValue: []);
    final alwaysCollapseCategoriesData = watchStream((LibraryStateService p0) => p0.alwaysCollapseCategories, initialValue: false);
    final alwaysCollapseCategories = alwaysCollapseCategoriesData.hasData && alwaysCollapseCategoriesData.data!;
    return CoreGroupedList<ItemTemplateViewModel>(
      source: templates.hasData ? templates.data! : [],
      itemContentBuilder: (BuildContext context, ItemTemplateViewModel item) {
        return Card(
          key: Key(item.key),
          child: ListTile(
            title: Text(item.name),
          ),
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
    );
  }
}
