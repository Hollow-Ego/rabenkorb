import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class BasketItemService {
  final _db = di<AppDatabase>();

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.name);
  final BehaviorSubject<int> _basketIdSubject = BehaviorSubject<int>();

  late Stream<List<GroupedItems<BasketItem>>> basketItemsStream;

  Stream<List<GroupedItems<BasketItem>>> get basketItems => basketItemsStream;

  BasketItemService() {
    basketItemsStream = Rx.combineLatest4(
      _sortModeSubject.stream.distinct(),
      _sortRuleIdSubject.stream.distinct(),
      _searchSubject.stream.distinct(),
      _basketIdSubject.stream.distinct(),
      (SortMode sortMode, int? sortRuleId, String searchTerm, int basketId) => _watchBasketItemsInOrder(
        basketId: basketId,
        sortMode: sortMode,
        sortRuleId: sortRuleId,
        searchTerm: searchTerm,
      ),
    ).debounceTime(const Duration(milliseconds: 300)).switchMap((stream) => stream);
  }

  factory BasketItemService.withValue({
    required int basketId,
    SortMode? sortMode,
    int? sortRuleId,
    String? searchString,
  }) {
    final service = BasketItemService();

    service.setSortMode(sortMode);
    service.setSearchString(searchString);
    service.setSortRuleId(sortRuleId);
    service.setBasketId(basketId);

    return service;
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

  Future<BasketItem?> getBasketItemById(int id) {
    return _db.basketItemsDao.getBasketItemWithId(id);
  }

  Future<int> deleteBasketItemById(int id) {
    return _db.basketItemsDao.deleteBasketItemWithId(id);
  }

  Stream<List<BasketItem>> watchBasketItems() {
    return _db.basketItemsDao.watchBasketItems();
  }

  void setSortMode(SortMode? sortMode) {
    if (sortMode == null) {
      return;
    }
    _sortModeSubject.add(sortMode);
  }

  void setSortRuleId(int? sortRuleId) {
    _sortRuleIdSubject.add(sortRuleId);
  }

  void setBasketId(int basketId) {
    _basketIdSubject.add(basketId);
  }

  void setSearchString(String? searchString) {
    searchString = searchString ?? "";
    _searchSubject.add(searchString);
  }

  Future<int> removeCheckedItemsFromBasket(int basketId) {
    return _db.basketItemsDao.removeCheckedItemsFromBasket(basketId);
  }

  Future<int> removeAllItemsFromBasket(int basketId) {
    return _db.basketItemsDao.removeAllItemsFromBasket(basketId);
  }

  Stream<List<GroupedItems<BasketItem>>> _watchBasketItemsInOrder({
    required int basketId,
    required SortMode sortMode,
    int? sortRuleId,
    String? searchTerm,
  }) {
    return _db.basketItemsDao.watchBasketItemsInOrder(basketId: basketId, sortMode: sortMode, sortRuleId: sortRuleId, searchTerm: searchTerm);
  }
}
