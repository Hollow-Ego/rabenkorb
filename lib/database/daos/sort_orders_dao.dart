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
}
