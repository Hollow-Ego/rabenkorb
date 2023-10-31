import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_orders.dart';

part 'sort_orders_dao.g.dart';

@DriftAccessor(tables: [SortOrders])
class SortOrdersDao extends DatabaseAccessor<AppDatabase> with _$SortOrdersDaoMixin {
  SortOrdersDao(super.db);
}
