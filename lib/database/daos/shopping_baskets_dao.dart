import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';

part 'shopping_baskets_dao.g.dart';

@DriftAccessor(tables: [ShoppingBaskets])
class ShoppingBasketsDao extends DatabaseAccessor<AppDatabase> with _$ShoppingBasketsDaoMixin {
  ShoppingBasketsDao(super.db);
}
