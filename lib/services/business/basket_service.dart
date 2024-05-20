import 'dart:async';
import 'dart:io';

import 'package:rabenkorb/abstracts/image_service.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import 'metadata_service.dart';

class BasketService implements Disposable {
  static const defaultBasketName = "Unnamed Basket";
  final _shoppingBasketService = di<ShoppingBasketService>();
  final _basketItemService = di<BasketItemService>();
  final _metadataService = di<MetadataService>();
  final _imageService = di<ImageService>();
  final _basketStateService = di<BasketStateService>();
  final _sortRuleService = di<SortRuleService>();

  Stream<List<GroupedItems<BasketItemViewModel>>> get basketItems => _basketItemService.basketItems;

  List<int> get shownItemIds => _basketItemService.basketItemsSync.expand((group) => group.items.map((item) => item.id)).toList();

  Stream<List<ShoppingBasketViewModel>> get baskets => _shoppingBasketService.baskets;

  late StreamSubscription _activeBasketSub;
  final BehaviorSubject<ShoppingBasketViewModel?> _activeBasket = BehaviorSubject<ShoppingBasketViewModel?>.seeded(null);

  Stream<ShoppingBasketViewModel?> get activeBasket => _activeBasket.stream;

  ShoppingBasketViewModel? get activeBasketSync => _activeBasket.value;

  Stream<List<SortRuleViewModel>> get sortRules => _sortRuleService.sortRules;

  BasketService() {
    _activeBasketSub = _basketStateService.basketId.switchMap((basketId) => watchShoppingBasketById(basketId)).listen((basket) {
      _activeBasket.add(basket);
    });
  }

  Future<int> createShoppingBasket(String? name) {
    if (name == null) {
      return _createDefaultBasket();
    }
    return _shoppingBasketService.createShoppingBasket(name);
  }

  Future<void> updateShoppingBasket(int id, String name) {
    return _shoppingBasketService.updateShoppingBasket(id, name);
  }

  Future<ShoppingBasketViewModel?> getShoppingBasketById(int? id) {
    if (id == null) {
      return Future(() => null);
    }
    return _shoppingBasketService.getShoppingBasketById(id);
  }

  Stream<ShoppingBasketViewModel?> watchShoppingBasketById(int? id) {
    if (id == null || id < 0) {
      return Stream.value(null);
    }
    return _shoppingBasketService.watchShoppingBasketById(id);
  }

  Future<int?> setFirstShoppingBasketActive() async {
    final firstBasketId = await _shoppingBasketService.getFirstShoppingBasketId();
    await _basketStateService.setBasketId(firstBasketId);
    return firstBasketId;
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
    required int? basketId,
    File? image,
    String? note,
    String? imagePath,
    int? unitId,
  }) async {
    basketId = await _ensureExistingBasket(basketId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingUnit(unitId);

    if (image != null) {
      image = await _imageService.saveImage(image);
      imagePath = image?.path;
    }

    return _basketItemService.createBasketItem(
      name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: imagePath,
      note: note,
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
        note: originalBasketItem.note,
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
    String? note,
    int? unitId,
    bool? isChecked,
  }) async {
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
      note: note,
      unitId: unitId,
      isChecked: isChecked,
    );
  }

  Future<void> replaceBasketItem(
    int id, {
    required String name,
    double? amount,
    int? categoryId,
    int? basketId,
    File? image,
    String? note,
    int? unitId,
    bool? isChecked,
    bool imageChanged = false,
  }) async {
    basketId = await _ensureExistingBasket(basketId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingUnit(unitId);

    // Delete old image if new one was provided
    if (imageChanged) {
      await removeBasketItemImage(id);
      // Save new image
    }
    if (image != null && imageChanged) {
      // Save new image
      image = await _imageService.saveImage(image);
    }

    return _basketItemService.replaceBasketItem(
      id,
      name: name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: image?.path,
      note: note,
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

  Future<int> deleteBasketItems(List<int> templateIds) async {
    int deletedItems = 0;
    for (var templateId in templateIds) {
      await removeBasketItemImage(templateId);
      deletedItems += await _basketItemService.deleteBasketItemById(templateId);
    }
    return deletedItems;
  }

  Future<int> countItemsInBasket(int basketId) {
    return _basketItemService.countItemsInBasket(basketId);
  }

  Future<int> _ensureExistingBasket(int? basketId) async {
    if (basketId == null) {
      basketId = await _shoppingBasketService.getFirstShoppingBasketId();
      if (basketId != null) {
        await _basketStateService.setBasketId(basketId);
      }
    }

    if (basketId == null) {
      return _createDefaultBasket();
    }

    final targetLibrary = await _shoppingBasketService.getShoppingBasketById(basketId);
    if (targetLibrary == null) {
      return _createDefaultBasket();
    }
    return basketId;
  }

  Future<int> _createDefaultBasket() async {
    final newBasketId = await _shoppingBasketService.createShoppingBasket(defaultBasketName);
    await _basketStateService.setBasketId(newBasketId);
    return newBasketId;
  }

  @override
  FutureOr onDispose() {
    _activeBasketSub.cancel();
  }
}
