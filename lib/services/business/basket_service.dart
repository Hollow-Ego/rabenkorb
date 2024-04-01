import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:watch_it/watch_it.dart';

import 'metadata_service.dart';

class BasketService {
  static const defaultBasketName = "Unnamed Basket";
  final _shoppingBasketService = di<ShoppingBasketService>();
  final _basketItemService = di<BasketItemService>();
  final _metadataService = di<MetadataService>();

  Stream<List<GroupedItems<BasketItem>>> get basketItems => _basketItemService.basketItems;

  Future<int> createShoppingBasket(String name) {
    return _shoppingBasketService.createShoppingBasket(name);
  }

  Future<void> updateShoppingBasket(int id, String name) {
    return _shoppingBasketService.updateShoppingBasket(id, name);
  }

  Future<ShoppingBasket?> getShoppingBasketById(int id) {
    return _shoppingBasketService.getShoppingBasketById(id);
  }

  Future<int> deleteShoppingBasketById(int id) {
    return _shoppingBasketService.deleteShoppingBasketById(id);
  }

  Stream<List<ShoppingBasket>> watchShoppingBaskets() {
    return _shoppingBasketService.watchShoppingBaskets();
  }

  Future<int> createBasketItem(
    String name, {
    double amount = 0,
    int? categoryId,
    required int basketId,
    String? imagePath,
    int? unitId,
  }) async {
    basketId = await _ensureExistingBasket(basketId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingUnit(unitId);

    return _basketItemService.createBasketItem(
      name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: imagePath,
      unitId: unitId,
    );
  }

  Future<void> setBasketItemCheckedState(int id, bool state) {
    return updateBasketItem(id, isChecked: state);
  }

  Future<void> updateBasketItem(
    int id, {
    String? name,
    double? amount,
    int? categoryId,
    int? basketId,
    String? imagePath,
    int? unitId,
    bool? isChecked,
  }) async {
    if (basketId != null) {
      basketId = await _ensureExistingBasket(basketId);
    }
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingUnit(unitId);

    return _basketItemService.updateBasketItem(
      id,
      name: name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: imagePath,
      unitId: unitId,
      isChecked: isChecked,
    );
  }

  Future<BasketItem?> getBasketItemById(int id) {
    return _basketItemService.getBasketItemById(id);
  }

  Future<int> deleteBasketItemById(int id) {
    return _basketItemService.deleteBasketItemById(id);
  }

  Future<int> removeCheckedItemsFromBasket(int basketId) {
    return _basketItemService.removeCheckedItemsFromBasket(basketId);
  }

  Future<int> removeAllItemsFromBasket(int basketId) {
    return _basketItemService.removeAllItemsFromBasket(basketId);
  }

  Future<int> _ensureExistingBasket(int basketId) async {
    final targetLibrary = await _shoppingBasketService.getShoppingBasketById(basketId);
    if (targetLibrary == null) {
      return await _shoppingBasketService.createShoppingBasket(defaultBasketName);
    }
    return basketId;
  }
}
