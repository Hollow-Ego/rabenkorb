import 'package:rabenkorb/abstracts/PreferenceService.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class BasketStateService {
  final _prefs = di<PreferenceService>();

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.name);
  final BehaviorSubject<int?> _basketIdSubject = BehaviorSubject<int>();

  Stream<String> get search => _searchSubject.stream.distinct();

  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream.distinct();

  Stream<SortMode> get sortMode => _sortModeSubject.stream.distinct();

  Stream<int?> get basketId => _basketIdSubject.stream.distinct();

  BasketStateService() {
    _init();
  }

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

  Future<void> setSortMode(SortMode? sortMode) async {
    if (sortMode == null) {
      return;
    }
    await _prefs.setString(PreferenceKeys.basketGroupMode, sortMode.name);
    _sortModeSubject.add(sortMode);
  }

  Future<void> setSortRuleId(int? sortRuleId) async {
    if (sortRuleId == null) {
      await _prefs.remove(PreferenceKeys.basketSortRuleId);
    } else {
      await _prefs.setInt(PreferenceKeys.basketSortRuleId, sortRuleId);
    }
    _sortRuleIdSubject.add(sortRuleId);
  }

  Future<void> setBasketId(int? basketId) async {
    if (basketId == null) {
      await _prefs.remove(PreferenceKeys.basketId);
    } else {
      await _prefs.setInt(PreferenceKeys.basketId, basketId);
    }
    _basketIdSubject.add(basketId);
  }

  void setSearchString(String? searchString) {
    searchString = searchString ?? "";
    _searchSubject.add(searchString);
  }

  void _init() {
    final sortModeName = _prefs.getString(PreferenceKeys.basketGroupMode);
    final sortMode = sortModeName != null ? SortMode.values.byName(sortModeName) : SortMode.name;

    final sortRuleId = _prefs.getInt(PreferenceKeys.basketSortRuleId);
    final basketId = _prefs.getInt(PreferenceKeys.basketId) ?? -1;

    _sortModeSubject.add(sortMode);
    _sortRuleIdSubject.add(sortRuleId);
    _basketIdSubject.add(basketId);
  }
}
