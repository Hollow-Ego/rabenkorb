import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_orders.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';

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

  Future<void> updateOrderSingle(int sortRuleId, List<ItemCategoryViewModel> visibleCategories, int oldIndex, int newIndex) async {
    await transaction(() async {
      // Fetch current sort orders for the given sort rule
      final allOrders = await (select(sortOrders)
            ..where((tbl) => tbl.ruleId.equals(sortRuleId))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder)]))
          .get();

      // Create a map of categoryId to its sort order
      final orderMap = {for (var order in allOrders) order.categoryId: order};

      // Filter out the pseudo-category with id -1 from visibleCategories
      visibleCategories = visibleCategories.where((category) => category.id != withoutCategoryId).toList();

      // Validate indices
      if (oldIndex < 0 || oldIndex >= visibleCategories.length || newIndex < 0 || newIndex >= visibleCategories.length) {
        throw ArgumentError("Invalid indices provided.");
      }

      // Reorder the visible categories based on the indices provided
      final targetCategory = visibleCategories.removeAt(oldIndex);
      visibleCategories.insert(newIndex, targetCategory);

      // Ensure all categories within the range have sort orders
      for (int i = 0; i < visibleCategories.length; i++) {
        final category = visibleCategories[i];
        if (orderMap.containsKey(category.id)) {
          // Update existing sort order
          orderMap[category.id] = orderMap[category.id]!.copyWith(sortOrder: i + 1);
        } else {
          // Create a new sort order
          orderMap[category.id] = SortOrder(
            categoryId: category.id,
            ruleId: sortRuleId,
            sortOrder: i + 1,
          );
        }
      }

      // Handle unsorted categories not visible but should be ordered sequentially after visible ones
      final sortedOrderCategories = orderMap.values.toList();
      sortedOrderCategories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      int nextSortOrder = sortedOrderCategories.length + 1;

      final unsortedCategories = await (select(itemCategories)..where((tbl) => (tbl.id.isIn(orderMap.keys.toList()) & tbl.id.isNotValue(-1)).not())).get();

      for (var category in unsortedCategories) {
        orderMap[category.id] = SortOrder(
          categoryId: category.id,
          ruleId: sortRuleId,
          sortOrder: nextSortOrder++,
        );
      }

      // Update the database with new and updated sort orders
      for (var order in orderMap.values) {
        await (into(sortOrders).insertOnConflictUpdate(order));
      }
    });
  }
}
