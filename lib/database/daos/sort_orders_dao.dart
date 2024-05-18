import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_orders.dart';

part 'sort_orders_dao.g.dart';

@DriftAccessor(tables: [SortOrders])
class SortOrdersDao extends DatabaseAccessor<AppDatabase> with _$SortOrdersDaoMixin {
  SortOrdersDao(super.db);

  Future<int> removeOrders(int ruleId) async {
    return await (delete(sortOrders)..where((tbl) => tbl.ruleId.equals(ruleId))).go();
  }

  Future<void> setOrder(int ruleId, List<int> categoryIds) async {
    // Start a transaction to ensure atomicity
    await transaction(() async {
      // Optional: Remove existing orders for this rule to avoid conflicts
      await removeOrders(ruleId);

      // Insert the new order
      final rows = categoryIds.map((i) => SortOrdersCompanion(
            categoryId: Value(i),
            ruleId: Value(ruleId),
            sortOrder: Value(categoryIds.indexOf(i)),
          ));
      await batch((batch) => batch.insertAll(sortOrders, rows));
    });
  }

  Future<void> updateOrderSingle(int sortRuleId, int targetId, {int? placeBeforeId, int? placeAfterId}) async {
    await transaction(() async {
      final allOrders = await (select(sortOrders)
            ..where((tbl) => tbl.ruleId.equals(sortRuleId))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder)]))
          .get();

      // Find target, placeBefore, and placeAfter indices
      final targetIndex = allOrders.indexWhere((order) => order.categoryId == targetId);
      final placeBeforeIndex = placeBeforeId != null ? allOrders.indexWhere((order) => order.categoryId == placeBeforeId) : -1;
      final placeAfterIndex = placeAfterId != null ? allOrders.indexWhere((order) => order.categoryId == placeAfterId) : -1;

      if (targetIndex == -1) {
        throw ArgumentError("Target ID $targetId not found.");
      }

      if (placeBeforeId == null && placeAfterId == null) {
        // No reordering needed
        return;
      }

      final targetOrder = allOrders.removeAt(targetIndex);

      // Determine the new position for targetOrder
      int newIndex;
      if (placeBeforeIndex != -1) {
        newIndex = placeBeforeIndex > targetIndex ? placeBeforeIndex - 1 : placeBeforeIndex;
      } else if (placeAfterIndex != -1) {
        newIndex = placeAfterIndex > targetIndex ? placeAfterIndex : placeAfterIndex + 1;
      } else {
        // If both are null, it means we shouldn't be here due to the previous check
        return;
      }

      // Insert the target order at the new position
      allOrders.insert(newIndex, targetOrder);

      // Update sortOrder to ensure no gaps
      for (int i = 0; i < allOrders.length; i++) {
        allOrders[i] = allOrders[i].copyWith(sortOrder: i + 1);
      }

      // Update the database
      for (var order in allOrders) {
        await (update(sortOrders)..where((tbl) => tbl.categoryId.equals(order.categoryId) & tbl.ruleId.equals(sortRuleId))).write(order);
      }
    });
  }
}
