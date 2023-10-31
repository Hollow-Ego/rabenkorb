import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';

part 'item_categories_dao.g.dart';

@DriftAccessor(tables: [ItemCategories])
class ItemCategoriesDao extends DatabaseAccessor<AppDatabase> with _$ItemCategoriesDaoMixin {
  ItemCategoriesDao(super.db);
}
