import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';

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
    return (select(itemCategories)..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch()
        .map((categories) => categories.map((category) => toItemCategoryViewModel(category)!).toList());
  }

  Stream<List<ItemCategoryViewModel>> watchItemCategoriesInOrder(SortMode sortMode, SortDirection sortDirection, {int? sortRuleId}) {
    final sourceQuery = select(itemCategories);

    final query = sourceQuery.join(
      [
        leftOuterJoin(attachedDatabase.sortOrders,
            itemCategories.id.equalsExp(attachedDatabase.sortOrders.categoryId) & attachedDatabase.sortOrders.ruleId.equalsNullable(sortRuleId)),
      ],
    );
    query.orderBy([
      OrderingTerm(expression: itemCategories.id.isNull(), mode: toOrderingMode(sortDirection)),
      OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder.isNull(), mode: toOrderingMode(sortDirection)),
      ..._getOrderingTerms(sortMode),
    ]);

    return query.watch().map((rows) => rows.map((row) => toItemCategoryViewModel(row.readTable(itemCategories))!).toList());
  }

  List<OrderingTerm> _getOrderingTerms<T>(
    SortMode sortMode,
  ) {
    switch (sortMode) {
      case SortMode.databaseOrder:
        return [_byId()];
      case SortMode.name:
        return [_byName()];
      case SortMode.custom:
        return [_bySortOrder(), _byName()];
    }
  }

  OrderingTerm _byId() {
    return OrderingTerm(expression: itemCategories.id);
  }

  OrderingTerm _byName() {
    return OrderingTerm(expression: itemCategories.name);
  }

  OrderingTerm _bySortOrder() {
    return OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder);
  }
}
