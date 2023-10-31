import 'package:drift/drift.dart';
import 'package:rabenkorb/database/tables/items.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';

@DataClassName('SortOrder')
class SortOrders extends Table {
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get ruleId => integer().references(SortRules, #id)();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {itemId, ruleId};
}