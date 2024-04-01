import 'package:drift/drift.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';

@DataClassName('SortOrder')
class SortOrders extends Table {
  IntColumn get categoryId => integer().references(ItemCategories, #id, onDelete: KeyAction.cascade)();

  IntColumn get ruleId => integer().references(SortRules, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {categoryId, ruleId};
}
