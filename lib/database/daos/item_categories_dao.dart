import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';

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

  Stream<ItemCategoryViewModel?> watchItemCategoryWithId(int id) {
    return (select(itemCategories)..where((li) => li.id.equals(id))).watchSingle().map((category) => toItemCategoryViewModel(category));
  }

  Future<ItemCategoryViewModel?> getItemCategoryWithId(int id) async {
    final category = await (select(itemCategories)..where((li) => li.id.equals(id))).getSingleOrNull();
    return toItemCategoryViewModel(category);
  }

  Future<int> deleteItemCategoryWithId(int id) {
    return (delete(itemCategories)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ItemCategoryViewModel>> watchItemCategories() {
    return (select(itemCategories)).watch().map((categories) => categories.map((category) => toItemCategoryViewModel(category)!).toList());
  }
}
