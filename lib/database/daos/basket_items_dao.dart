import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/basket_items.dart';
import 'package:rabenkorb/models/grouped_items.dart';
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
    int? unitId,
  }) {
    final companion = BasketItemsCompanion(
      name: Value(name),
      category: Value(categoryId),
      basket: Value(basketId),
      imagePath: Value(imagePath),
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
    int? unitId,
    bool? isChecked,
  }) {
    final companion = BasketItemsCompanion(
      name: Value.absentIfNull(name),
      category: Value.absentIfNull(categoryId),
      basket: Value.absentIfNull(basketId),
      imagePath: Value.absentIfNull(imagePath),
      unit: Value.absentIfNull(unitId),
      amount: Value.absentIfNull(amount),
      isChecked: Value.absentIfNull(isChecked),
    );
    return (update(basketItems)..where((li) => li.id.equals(id))).write(companion);
  }

  Stream<BasketItem> watchBasketItemWithId(int id) {
    return (select(basketItems)..where((li) => li.id.equals(id))).watchSingle();
  }

  Future<BasketItem?> getBasketItemWithId(int id) {
    return (select(basketItems)..where((li) => li.id.equals(id))).getSingleOrNull();
  }

  Future<int> deleteBasketItemWithId(int id) {
    return (delete(basketItems)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<BasketItem>> watchBasketItems() {
    return (select(basketItems)).watch();
  }

  Stream<List<GroupedItems<BasketItem>>> watchBasketItemsInOrder({
    required int basketId,
    required SortMode sortMode,
    int? sortRuleId,
    String? searchTerm,
  }) {
    final sourceQuery = select(basketItems);
    sourceQuery.where((bi) => bi.basket.equals(basketId));

    if (searchTerm != null && searchTerm.isNotEmpty) {
      sourceQuery.where((bi) => bi.name.like('%$searchTerm%'));
    }

    final query = sourceQuery.join([
      leftOuterJoin(itemCategories, basketItems.category.equalsExp(itemCategories.id)),
      leftOuterJoin(attachedDatabase.sortOrders,
          basketItems.category.equalsExp(attachedDatabase.sortOrders.categoryId) & attachedDatabase.sortOrders.ruleId.equalsNullable(sortRuleId)),
    ]);
    query.orderBy([
      OrderingTerm(expression: itemCategories.id.isNull(), mode: OrderingMode.asc),
      OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder.isNull(), mode: OrderingMode.asc),
      ..._getOrderingTerms(sortMode),
    ]);

    // Mapping the query result to a stream of grouped items
    return query.watch().map((rows) {
      // A map to hold categories and their corresponding items
      final Map<int, GroupedItems<BasketItem>> groupedItems = {};
      for (final row in rows) {
        final item = row.readTable(basketItems);
        final category = row.readTableOrNull(itemCategories) ?? const ItemCategory(id: 0, name: "Without Category");
        groupedItems.putIfAbsent(category.id, () => GroupedItems(category: category, items: []));
        groupedItems[category.id]!.items.add(item);
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
}
