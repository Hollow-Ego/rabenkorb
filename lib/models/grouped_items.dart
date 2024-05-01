import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';

class GroupedItems<T extends DataItem> {
  final ItemCategoryViewModel category;
  final List<T> items;

  GroupedItems({required this.category, required this.items});

  Map<String, dynamic> toJson() {
    return {
      "category": category.toJson(),
      "items": items.map((e) => e.toJson()),
    };
  }
}
