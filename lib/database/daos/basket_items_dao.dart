import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/basket_items.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';

part 'basket_items_dao.g.dart';

@DriftAccessor(tables: [BasketItems])
class BasketItemsDao extends DatabaseAccessor<AppDatabase> with _$BasketItemsDaoMixin {
  BasketItemsDao(super.db);

  Future<int> createBasketItem(
    String name, {
    double amount = 0,
    int? categoryId,
    required int basketId,
    String? imagePath,
    String? note,
    int? unitId,
  }) async {
    final existingItems = await findBasketItemsByNameCategoryUnit(name, basketId, categoryId, unitId);
    // Exactly one item matching the name, category and unit: assume to add the amount instead of duplicating item
    if (existingItems.length == 1) {
      final existingItem = existingItems.first;
      final id = existingItem.id;
      final previousAmount = existingItem.amount;
      final newAmount = previousAmount + amount;
      updateBasketItem(id, amount: newAmount);
      return id;
    }
    final companion = BasketItemsCompanion(
      name: Value(name),
      category: Value(categoryId),
      basket: Value(basketId),
      imagePath: Value(imagePath),
      note: Value(note),
      unit: Value(unitId),
      amount: Value(amount),
    );
    return into(basketItems).insert(companion);
  }

  Future<void> updateBasketItem(
    int id, {
    String? name,
    double? amount,
    int? categoryId,
    int? basketId,
    String? imagePath,
    String? note,
    int? unitId,
    bool? isChecked,
  }) {
    final companion = BasketItemsCompanion(
      name: Value.absentIfNull(name),
      category: Value.absentIfNull(categoryId),
      basket: Value.absentIfNull(basketId),
      imagePath: Value.absentIfNull(imagePath),
      note: Value.absentIfNull(note),
      unit: Value.absentIfNull(unitId),
      amount: Value.absentIfNull(amount),
      isChecked: Value.absentIfNull(isChecked),
    );
    return (update(basketItems)..where((li) => li.id.equals(id))).write(companion);
  }

  Future<void> replaceBasketItem(
    int id, {
    required String name,
    double? amount,
    int? categoryId,
    required int basketId,
    String? imagePath,
    String? note,
    int? unitId,
    bool? isChecked,
  }) {
    final companion = BasketItemsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(categoryId),
      basket: Value(basketId),
      imagePath: Value(imagePath),
      note: Value(note),
      unit: Value(unitId),
      amount: Value(amount ?? 0),
      isChecked: Value(isChecked ?? false),
    );
    return update(basketItems).replace(companion);
  }

  Stream<BasketItemViewModel?> watchBasketItemWithId(int id) {
    return _joinValues((select(basketItems)..where((li) => li.id.equals(id)))).watchSingle().map((row) => _rowToViewModel(row));
  }

  Future<BasketItemViewModel?> getBasketItemWithId(int id) async {
    final row = await _joinValues((select(basketItems)..where((li) => li.id.equals(id)))).getSingleOrNull();
    return _rowToViewModel(row);
  }

  Future<int> deleteBasketItemWithId(int id) {
    return (delete(basketItems)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<BasketItemViewModel>> watchBasketItems() {
    return _joinValues(select(basketItems)).watch().map((rows) => _rowsToViewModels(rows));
  }

  Stream<List<GroupedItems<BasketItemViewModel>>> watchBasketItemsInOrder({
    required int? basketId,
    required SortMode sortMode,
    required SortDirection sortDirection,
    int? sortRuleId,
    String? searchTerm,
  }) {
    if (basketId == null) {
      return const Stream.empty();
    }
    final sourceQuery = select(basketItems);
    sourceQuery.where((bi) => bi.basket.equals(basketId));

    if (searchTerm != null && searchTerm.isNotEmpty) {
      sourceQuery.where((bi) => bi.name.like('%$searchTerm%'));
    }

    final query = _joinValues(
      sourceQuery,
      includeJoins: [
        leftOuterJoin(attachedDatabase.sortOrders,
            basketItems.category.equalsExp(attachedDatabase.sortOrders.categoryId) & attachedDatabase.sortOrders.ruleId.equalsNullable(sortRuleId))
      ],
    );

    query.orderBy([
      OrderingTerm(expression: itemCategories.id.isNull(), mode: toOrderingMode(sortDirection)),
      OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder.isNull(), mode: toOrderingMode(sortDirection)),
      ..._getOrderingTerms(sortMode),
    ]);

    // Mapping the query result to a stream of grouped items
    return query.watch().map((rows) {
      // A map to hold categories and their corresponding items
      final Map<int, GroupedItems<BasketItemViewModel>> groupedItems = {};
      for (final row in rows) {
        final viewModel = _rowToViewModel(row)!;
        final category = viewModel.category ?? ItemCategoryViewModel(withoutCategoryId, "Without Category");

        groupedItems.putIfAbsent(category.id, () => GroupedItems(category: category, items: []));
        groupedItems[category.id]!.items.add(viewModel);
      }

      // Convert the map to a list of GroupedItems
      return groupedItems.values.toList();
    });
  }

  Future<int> removeCheckedItemsFromBasket(int basketId) {
    return (delete(basketItems)..where((li) => li.basket.equals(basketId) & li.isChecked)).go();
  }

  Future<int> removeAllItemsFromBasket(int basketId) {
    return (delete(basketItems)..where((li) => li.basket.equals(basketId))).go();
  }

  Future<List<String>> getImagePaths() {
    final query = select(basketItems)..where((t) => t.imagePath.isNotNull());
    return query.map((row) => row.imagePath!).get();
  }

  Future<List<BasketItemViewModel>> findBasketItemsByNameCategoryUnit(String name, int basketId, int? categoryId, int? unitId) async {
    final query = select(basketItems)
      ..where((i) => i.name.equals(name) & i.basket.equals(basketId) & i.category.equalsNullable(categoryId) & i.unit.equalsNullable(unitId));
    final rows = await _joinValues(query).get();
    return _rowsToViewModels(rows);
  }

  Future<int> countItemsInBasket(int basketId) async {
    final itemsInBasket = basketItems.basket.count(filter: basketItems.basket.equals(basketId));
    final itemsInBasketQuery = selectOnly(basketItems)..addColumns([itemsInBasket]);
    return await itemsInBasketQuery.map((row) => row.read(itemsInBasket)).getSingle() ?? 0;
  }

  Future<int> moveItemsToBasket(int targetBasketId, List<int> templateIds) async {
    return (update(basketItems)..where((tbl) => tbl.id.isIn(templateIds))).write(BasketItemsCompanion(basket: Value(targetBasketId)));
  }

  List<OrderingTerm> _getOrderingTerms<T>(
    SortMode sortMode,
  ) {
    switch (sortMode) {
      case SortMode.databaseOrder:
        return [_byId()];
      case SortMode.name:
        return [_byCategoryName(), _byBasketItemName()];
      case SortMode.custom:
        return [_bySortOrder(), _byBasketItemName()];
    }
  }

  OrderingTerm _byCategoryName() {
    return OrderingTerm(expression: itemCategories.name);
  }

  OrderingTerm _byBasketItemName() {
    return OrderingTerm(expression: basketItems.name);
  }

  OrderingTerm _byId() {
    return OrderingTerm(expression: basketItems.id);
  }

  OrderingTerm _bySortOrder() {
    return OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder);
  }

  JoinedSelectStatement<HasResultSet, dynamic> _joinValues(
    SimpleSelectStatement<$BasketItemsTable, BasketItem> sourceQuery, {
    List<Join<HasResultSet, dynamic>> includeJoins = const [],
  }) {
    return sourceQuery.join([
      leftOuterJoin(itemCategories, basketItems.category.equalsExp(itemCategories.id)),
      leftOuterJoin(itemUnits, basketItems.unit.equalsExp(itemUnits.id)),
      leftOuterJoin(shoppingBaskets, basketItems.basket.equalsExp(shoppingBaskets.id)),
      ...includeJoins
    ]);
  }

  List<BasketItemViewModel> _rowsToViewModels(List<TypedResult> rows) {
    return rows.map((row) => _rowToViewModel(row)!).toList();
  }

  BasketItemViewModel? _rowToViewModel(TypedResult? row) {
    if (row == null) {
      return null;
    }
    final item = row.readTable(basketItems);
    final category = row.readTableOrNull(itemCategories);
    final subCategory = row.readTableOrNull(itemSubCategories);
    final basket = row.readTable(shoppingBaskets);
    final unit = row.readTableOrNull(itemUnits);
    return toBasketItemViewModel(item, category, subCategory, basket, unit);
  }
}
