import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:watch_it/watch_it.dart';

class ShoppingBasketService {
  final _db = di<AppDatabase>();

  Future<int> createShoppingBasket(String name) {
    return _db.shoppingBasketsDao.createShoppingBasket(name);
  }

  Future<void> updateShoppingBasket(int id, String name) {
    return _db.shoppingBasketsDao.updateShoppingBasket(id, name);
  }

  Future<ShoppingBasketViewModel?> getShoppingBasketById(int id) {
    return _db.shoppingBasketsDao.getShoppingBasketWithId(id);
  }

  Future<int> deleteShoppingBasketById(int id) {
    return _db.shoppingBasketsDao.deleteShoppingBasketWithId(id);
  }

  Stream<List<ShoppingBasketViewModel>> watchShoppingBaskets() {
    return _db.shoppingBasketsDao.watchShoppingBaskets();
  }
}
