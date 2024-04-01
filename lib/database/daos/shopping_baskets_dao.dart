import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';

part 'shopping_baskets_dao.g.dart';

@DriftAccessor(tables: [ShoppingBaskets])
class ShoppingBasketsDao extends DatabaseAccessor<AppDatabase> with _$ShoppingBasketsDaoMixin {
  ShoppingBasketsDao(super.db);

  Future<int> createShoppingBasket(String name) {
    return into(shoppingBaskets).insert(ShoppingBasketsCompanion(name: Value(name)));
  }

  Future<void> updateShoppingBasket(int id, String name) {
    return update(shoppingBaskets).replace(ShoppingBasket(id: id, name: name));
  }

  Stream<ShoppingBasket> watchShoppingBasketWithId(int id) {
    return (select(shoppingBaskets)..where((li) => li.id.equals(id))).watchSingle();
  }

  Future<ShoppingBasket?> getShoppingBasketWithId(int id) {
    return (select(shoppingBaskets)..where((li) => li.id.equals(id))).getSingleOrNull();
  }

  Future<int> deleteShoppingBasketWithId(int id) {
    return (delete(shoppingBaskets)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ShoppingBasket>> watchShoppingBaskets() {
    return (select(shoppingBaskets)).watch();
  }
}
