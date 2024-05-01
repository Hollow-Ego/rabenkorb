import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/display/list/core_grouped_list.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:watch_it/watch_it.dart';

class LibraryView extends StatelessWidget with WatchItMixin {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<GroupedItems<ItemTemplateViewModel>>> templates = watchStream((LibraryService p0) => p0.itemTemplates, initialValue: []);

    return CoreGroupedList<ItemTemplateViewModel>(
      source: templates.hasData ? templates.data! : [],
      itemContentBuilder: (BuildContext context, ItemTemplateViewModel item) {
        final itemSubKey = item.name.toLowerSpaceless();
        return Card(
          key: Key("$itemSubKey-${item.id}"),
          child: ListTile(
            title: Text(item.name),
          ),
        );
      },
      onExpansionChange: (bool isExpanded, int headerId) {},
    );
  }
}
