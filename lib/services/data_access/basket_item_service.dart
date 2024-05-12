import 'dart:async';

import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/filter_details.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class BasketItemService implements Disposable {
  final _db = di<AppDatabase>();
  final _basketStateService = di<BasketStateService>();

  late Stream<List<GroupedItems<BasketItemViewModel>>> basketItemsStream;

  late StreamSubscription _basketItemsSub;
  final _basketItems = BehaviorSubject<List<GroupedItems<BasketItemViewModel>>>.seeded([]);

  Stream<List<GroupedItems<BasketItemViewModel>>> get basketItems => _basketItems.stream;

  List<GroupedItems<BasketItemViewModel>> get basketItemsSync => _basketItems.value;

  BasketItemService() {
    _basketItemsSub = Rx.combineLatest5(
      _basketStateService.sortMode,
      _basketStateService.sortDirection,
      _basketStateService.sortRuleId,
      _basketStateService.search,
      _basketStateService.basketId,
      (SortMode sortMode, SortDirection sortDirection, int? sortRuleId, String searchTerm, int? basketId) =>
          BasketItemFilterDetails(sortMode: sortMode, sortDirection: sortDirection, searchTerm: searchTerm, sortRuleId: sortRuleId, basketId: basketId),
    ).switchMap((BasketItemFilterDetails details) {
      return _watchBasketItemsInOrder(
        basketId: details.basketId,
        sortMode: details.sortMode,
        sortDirection: details.sortDirection,
        sortRuleId: details.sortRuleId,
        searchTerm: details.searchTerm,
      );
    }).listen((items) {
      _basketItems.add(items);
    });
  }

  Future<int> createBasketItem(
    String name, {
    double amount = 0,
    int? categoryId,
    required int basketId,
    String? imagePath,
    int? unitId,
  }) {
    return _db.basketItemsDao.createBasketItem(
      name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: imagePath,
      unitId: unitId,
    );
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
  }) {
    return _db.basketItemsDao.updateBasketItem(
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

  Future<void> replaceBasketItem(
    int id, {
    required String name,
    double? amount,
    int? categoryId,
    required int basketId,
    String? imagePath,
    int? unitId,
    bool? isChecked,
  }) {
    return _db.basketItemsDao.replaceBasketItem(
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

  Future<BasketItemViewModel?> getBasketItemById(int id) {
    return _db.basketItemsDao.getBasketItemWithId(id);
  }

  Future<int> deleteBasketItemById(int id) {
    return _db.basketItemsDao.deleteBasketItemWithId(id);
  }

  Stream<List<BasketItemViewModel>> watchBasketItems() {
    return _db.basketItemsDao.watchBasketItems();
  }

  Future<int> removeCheckedItemsFromBasket(int basketId) {
    return _db.basketItemsDao.removeCheckedItemsFromBasket(basketId);
  }

  Future<int> removeAllItemsFromBasket(int basketId) {
    return _db.basketItemsDao.removeAllItemsFromBasket(basketId);
  }

  Future<int> countImagePathUsages(String imagePath) async {
    return (await _db.basketItemsDao.countImagePathUsages(imagePath)) ?? 0;
  }

  Stream<List<GroupedItems<BasketItemViewModel>>> _watchBasketItemsInOrder({
    required int? basketId,
    required SortMode sortMode,
    required SortDirection sortDirection,
    int? sortRuleId,
    String? searchTerm,
  }) {
    return _db.basketItemsDao
        .watchBasketItemsInOrder(basketId: basketId, sortMode: sortMode, sortDirection: sortDirection, sortRuleId: sortRuleId, searchTerm: searchTerm);
  }

  @override
  FutureOr onDispose() {
    _basketItemsSub.cancel();
  }
}
