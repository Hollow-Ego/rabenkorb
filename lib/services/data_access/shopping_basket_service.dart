import 'dart:async';

import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class ShoppingBasketService implements Disposable {
  final _db = di<AppDatabase>();

  late StreamSubscription _basketsSub;
  final _baskets = BehaviorSubject<List<ShoppingBasketViewModel>>.seeded([]);

  Stream<List<ShoppingBasketViewModel>> get baskets => _baskets.stream;

  ShoppingBasketService() {
    _basketsSub = watchShoppingBaskets().listen((baskets) {
      _baskets.add(baskets);
    });
  }

  Future<int> createShoppingBasket(String name) {
    return _db.shoppingBasketsDao.createShoppingBasket(name);
  }

  Future<void> updateShoppingBasket(int id, String name) {
    return _db.shoppingBasketsDao.updateShoppingBasket(id, name);
  }

  Future<ShoppingBasketViewModel?> getShoppingBasketById(int id) {
    return _db.shoppingBasketsDao.getShoppingBasketWithId(id);
  }

  Future<int?> getFirstShoppingBasketId() {
    return _db.shoppingBasketsDao.getFirstShoppingBasketId();
  }

  Future<int> deleteShoppingBasketById(int id) {
    return _db.shoppingBasketsDao.deleteShoppingBasketWithId(id);
  }

  Stream<List<ShoppingBasketViewModel>> watchShoppingBaskets() {
    return _db.shoppingBasketsDao.watchShoppingBaskets();
  }

  @override
  FutureOr onDispose() {
    _basketsSub.cancel();
  }
}
