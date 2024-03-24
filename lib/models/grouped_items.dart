import 'package:rabenkorb/database/database.dart';

class GroupedItems {
  final ItemCategory category;
  final List<ItemTemplate> items;

  GroupedItems({required this.category, required this.items});
}
