import 'package:flutter/material.dart';
import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/models/grouped_items.dart';

class CoreGroupedList<T extends DataItem> extends StatelessWidget {
  final List<GroupedItems<T>>? items;
  final Widget Function(BuildContext, T) itemContentBuilder;

  const CoreGroupedList({super.key, required this.items, required this.itemContentBuilder});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items?.length,
        itemBuilder: (BuildContext context, int index) {
          final itemGroup = items!.elementAt(index);
          final category = itemGroup.category.name;
          final itemsInCategory = itemGroup.items;

          return Column(
            children: [
              ListTile(title: Text(category)),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: itemsInCategory.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = itemsInCategory.elementAt(index);
                  return itemContentBuilder(context, item);
                },
              )
            ],
          );
        });
  }
}
