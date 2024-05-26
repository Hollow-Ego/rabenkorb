import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_sub_category.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/item_sub_category_view_model.dart';

part 'item_sub_categories_dao.g.dart';

@DriftAccessor(tables: [ItemSubCategories])
class ItemSubCategoriesDao extends DatabaseAccessor<AppDatabase> with _$ItemSubCategoriesDaoMixin {
  ItemSubCategoriesDao(super.db);

  Future<int> createItemSubCategory(String name) {
    return into(itemSubCategories).insert(ItemSubCategoriesCompanion(name: Value(name)));
  }

  Future<void> updateItemSubCategory(int id, String name) {
    return update(itemSubCategories).replace(ItemSubCategory(id: id, name: name));
  }

  Stream<ItemSubCategoryViewModel?> watchItemSubCategoryWithId(int id) {
    return (select(itemSubCategories)..where((li) => li.id.equals(id))).watchSingle().map((category) => toItemSubCategoryViewModel(category));
  }

  Future<ItemSubCategoryViewModel?> getItemSubCategoryWithId(int id) async {
    final category = await (select(itemSubCategories)..where((li) => li.id.equals(id))).getSingleOrNull();
    return toItemSubCategoryViewModel(category);
  }

  Future<int> deleteItemSubCategoryWithId(int id) {
    return (delete(itemSubCategories)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ItemSubCategoryViewModel>> watchItemSubCategories() {
    return (select(itemSubCategories)..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch()
        .map((categories) => categories.map((category) => toItemSubCategoryViewModel(category)!).toList());
  }
}
