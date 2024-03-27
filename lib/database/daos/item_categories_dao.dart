import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';

part 'item_categories_dao.g.dart';

@DriftAccessor(tables: [ItemCategories])
class ItemCategoriesDao extends DatabaseAccessor<AppDatabase> with _$ItemCategoriesDaoMixin {
  ItemCategoriesDao(super.db);

  Future<int> createItemCategory(String name) {
    return into(itemCategories).insert(ItemCategoriesCompanion(name: Value(name)));
  }

  Future<void> updateItemCategory(int id, String name) {
    return update(itemCategories).replace(ItemCategory(id: id, name: name));
  }

  Stream<ItemCategory> watchItemCategoryWithId(int id) {
    return (select(itemCategories)..where((li) => li.id.equals(id))).watchSingle();
  }

  Future<ItemCategory?> getItemCategoryWithId(int id) {
    return (select(itemCategories)..where((li) => li.id.equals(id))).getSingleOrNull();
  }

  Future<int> deleteItemCategoryWithId(int id) {
    return (delete(itemCategories)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ItemCategory>> watchItemCategories() {
    return (select(itemCategories)).watch();
  }
}
