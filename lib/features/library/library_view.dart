import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/display/core_grouped_list.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:watch_it/watch_it.dart';

class LibraryView extends StatelessWidget with WatchItMixin {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<GroupedItems<ItemTemplateViewModel>>> templates = watchStream((LibraryService p0) => p0.itemTemplates, initialValue: []);

    return CoreGroupedList(
        items: templates.data,
        itemContentBuilder: (BuildContext context, ItemTemplateViewModel item) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.name),
            ),
          );
        });
  }
}
