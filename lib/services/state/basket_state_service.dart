import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';

class BasketStateService {
  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.name);
  final BehaviorSubject<int> _basketIdSubject = BehaviorSubject<int>();

  Stream<String> get search => _searchSubject.stream.distinct();

  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream.distinct();

  Stream<SortMode> get sortMode => _sortModeSubject.stream.distinct();

  Stream<int> get basketId => _basketIdSubject.stream.distinct();

  BasketStateService();

  factory BasketStateService.withValue({
    required int basketId,
    SortMode? sortMode,
    int? sortRuleId,
    String? searchString,
  }) {
    final service = BasketStateService();

    service.setSortMode(sortMode);
    service.setSearchString(searchString);
    service.setSortRuleId(sortRuleId);
    service.setBasketId(basketId);

    return service;
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
}
