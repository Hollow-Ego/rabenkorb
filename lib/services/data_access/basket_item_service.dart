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

  late Stream<List<GroupedItems<BasketItem>>> basketItemsStream;

  Stream<List<GroupedItems<BasketItem>>> get basketItems => basketItemsStream;

  BasketItemService() {
    basketItemsStream = Rx.combineLatest3(
      _sortModeSubject.stream.distinct(),
      _sortRuleIdSubject.stream.distinct(),
      _searchSubject.stream.distinct(),
      (SortMode sortMode, int? sortRuleId, String searchTerm) => _watchBasketItemsInOrder(
        sortMode,
        sortRuleId: sortRuleId,
        searchTerm: searchTerm,
      ),
    ).debounceTime(const Duration(milliseconds: 300)).switchMap((stream) => stream);
  }

  factory BasketItemService.withValue({
    SortMode? sortMode,
    int? sortRuleId,
    String? searchString,
  }) {
    final service = BasketItemService();

    service.setSortMode(sortMode);
    service.setSearchString(searchString);
    service.setSortRuleId(sortRuleId);

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
  }) {
    return _db.basketItemsDao.updateBasketItem(
      id,
      name: name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: imagePath,
      unitId: unitId,
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

  void setSearchString(String? searchString) {
    searchString = searchString ?? "";
    _searchSubject.add(searchString);
  }

  Stream<List<GroupedItems<BasketItem>>> _watchBasketItemsInOrder(SortMode sortMode, {int? sortRuleId, String? searchTerm}) {
    return _db.basketItemsDao.watchBasketItemsInOrder(sortMode, sortRuleId: sortRuleId, searchTerm: searchTerm);
  }
}
