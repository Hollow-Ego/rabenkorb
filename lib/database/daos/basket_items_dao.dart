import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/basket_items.dart';

part 'basket_items_dao.g.dart';

@DriftAccessor(tables: [BasketItems])
class BasketItemsDao extends DatabaseAccessor<AppDatabase> with _$BasketItemsDaoMixin {
  BasketItemsDao(super.db);
}
