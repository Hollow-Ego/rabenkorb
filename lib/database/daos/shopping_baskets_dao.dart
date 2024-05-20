import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';

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

  Stream<ShoppingBasketViewModel?> watchShoppingBasketWithId(int id) {
    return (select(shoppingBaskets)..where((li) => li.id.equals(id))).watchSingleOrNull().map((basket) => toShoppingBasketViewModel(basket));
  }

  Future<ShoppingBasketViewModel?> getShoppingBasketWithId(int id) async {
    final basket = await (select(shoppingBaskets)..where((li) => li.id.equals(id))).getSingleOrNull();
    return toShoppingBasketViewModel(basket);
  }

  Future<int?> getFirstShoppingBasketId() {
    final query = (selectOnly(shoppingBaskets)
      ..addColumns([shoppingBaskets.id])
      ..limit(1));
    return query.map((row) => row.read(shoppingBaskets.id)).getSingleOrNull();
  }

  Future<int> deleteShoppingBasketWithId(int id) {
    return (delete(shoppingBaskets)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ShoppingBasketViewModel>> watchShoppingBaskets() {
    return (select(shoppingBaskets)).watch().map((baskets) => baskets.map((basket) => toShoppingBasketViewModel(basket)!).toList());
  }
}
