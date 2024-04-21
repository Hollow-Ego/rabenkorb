import 'dart:io';

import 'package:rabenkorb/abstracts/image_service.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:watch_it/watch_it.dart';

import 'metadata_service.dart';

class BasketService {
  static const defaultBasketName = "Unnamed Basket";
  final _shoppingBasketService = di<ShoppingBasketService>();
  final _basketItemService = di<BasketItemService>();
  final _metadataService = di<MetadataService>();
  final _imageService = di<ImageService>();

  Stream<List<GroupedItems<BasketItemViewModel>>> get basketItems => _basketItemService.basketItems;

  Future<int> createShoppingBasket(String name) {
    return _shoppingBasketService.createShoppingBasket(name);
  }

  Future<void> updateShoppingBasket(int id, String name) {
    return _shoppingBasketService.updateShoppingBasket(id, name);
  }

  Future<ShoppingBasketViewModel?> getShoppingBasketById(int id) {
    return _shoppingBasketService.getShoppingBasketById(id);
  }

  Future<int> deleteShoppingBasketById(int id) {
    return _shoppingBasketService.deleteShoppingBasketById(id);
  }

  Stream<List<ShoppingBasketViewModel>> watchShoppingBaskets() {
    return _shoppingBasketService.watchShoppingBaskets();
  }

  Future<int> createBasketItem(
    String name, {
    double amount = 0,
    int? categoryId,
    required int basketId,
    File? image,
    int? unitId,
  }) async {
    basketId = await _ensureExistingBasket(basketId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingUnit(unitId);

    if (image != null) {
      image = await _imageService.saveImage(image);
    }

    return _basketItemService.createBasketItem(
      name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: image?.path,
      unitId: unitId,
    );
  }

  Future<void> setBasketItemCheckedState(int id, bool state) {
    return updateBasketItem(id, isChecked: state);
  }

  Future<void> removeBasketItemImage(int id) async {
    final originalBasketItem = await _basketItemService.getBasketItemById(id);
    if (originalBasketItem == null) {
      return;
    }

    final imagePath = originalBasketItem.imagePath;
    if (imagePath == null) {
      return;
    }
    await _basketItemService.replaceBasketItem(id,
        name: originalBasketItem.name,
        categoryId: originalBasketItem.category?.id,
        basketId: originalBasketItem.basket.id,
        imagePath: null,
        isChecked: originalBasketItem.isChecked,
        unitId: originalBasketItem.unit?.id,
        amount: originalBasketItem.amount);

    // Check if the same image is used by other items;
    final usageCount = await _basketItemService.countImagePathUsages(imagePath);
    if (usageCount > 0) {
      return;
    }
    await _imageService.deleteImage(imagePath);
  }

  Future<void> updateBasketItem(
    int id, {
    String? name,
    double? amount,
    int? categoryId,
    int? basketId,
    File? image,
    int? unitId,
    bool? isChecked,
  }) async {
    if (basketId != null) {
      basketId = await _ensureExistingBasket(basketId);
    }
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingUnit(unitId);

    // Delete old image if new one was provided
    if (image != null) {
      await removeBasketItemImage(id);
      // Save new image
      image = await _imageService.saveImage(image);
    }

    return _basketItemService.updateBasketItem(
      id,
      name: name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: image?.path,
      unitId: unitId,
      isChecked: isChecked,
    );
  }

  Future<BasketItemViewModel?> getBasketItemById(int id) {
    return _basketItemService.getBasketItemById(id);
  }

  Future<int> deleteBasketItemById(int id) async {
    await removeBasketItemImage(id);
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
