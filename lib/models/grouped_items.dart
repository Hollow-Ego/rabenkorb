import 'package:rabenkorb/database/database.dart';

class GroupedItems<T> {
  final ItemCategory category;
  final List<T> items;

  GroupedItems({required this.category, required this.items});
}
