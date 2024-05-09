import 'dart:convert';

import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class BasketStateService {
  final _prefs = di<PreferenceService>();

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.name);
  final BehaviorSubject<SortDirection> _sortDirectionSubject = BehaviorSubject<SortDirection>.seeded(SortDirection.asc);
  final BehaviorSubject<int?> _basketIdSubject = BehaviorSubject<int>();
  final BehaviorSubject<bool> _alwaysCollapseCategories = BehaviorSubject<bool>.seeded(false);

  Stream<String> get search => _searchSubject.stream.debounceTime(const Duration(milliseconds: 300));

  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream;

  Stream<SortMode> get sortMode => _sortModeSubject.stream;

  Stream<SortDirection> get sortDirection => _sortDirectionSubject.stream;

  Stream<int?> get basketId => _basketIdSubject.stream;

  Stream<bool> get alwaysCollapseCategories => _alwaysCollapseCategories.stream;

  Map<String, bool> _collapsedState = <String, bool>{};

  BasketStateService() {
    init();
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

  Future<void> setSortDirection(SortDirection sortDirection) async {
    await _prefs.setString(PreferenceKeys.basketSortDirection, sortDirection.name);
    _sortDirectionSubject.add(sortDirection);
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

  Future<void> setAlwaysCollapseCategories(bool alwaysCollapseCategories) async {
    await _prefs.setBool(PreferenceKeys.basketAlwaysCollapseCategories, alwaysCollapseCategories);
    _alwaysCollapseCategories.add(alwaysCollapseCategories);
  }

  Future<void> setCollapseState(String headerKey, bool value) async {
    _collapsedState[headerKey] = value;
    await _prefs.setString(PreferenceKeys.basketCollapsedStates, jsonEncode(_collapsedState));
  }

  Future<void> removeCollapsedState(String headerKey) async {
    _collapsedState.remove(headerKey);
    await _prefs.setString(PreferenceKeys.basketCollapsedStates, jsonEncode(_collapsedState));
  }

  bool isExpanded(String headerKey) {
    return _collapsedState[headerKey] ?? false;
  }

  void init() {
    final alwaysCollapseCategories = _prefs.getBool(PreferenceKeys.basketAlwaysCollapseCategories) ?? false;
    final sortModeName = _prefs.getString(PreferenceKeys.basketGroupMode);
    final sortMode = sortModeName != null ? SortMode.values.byName(sortModeName) : SortMode.name;

    final sortRuleId = _prefs.getInt(PreferenceKeys.basketSortRuleId);
    final basketId = _prefs.getInt(PreferenceKeys.basketId) ?? -1;

    final sortDirectionName = _prefs.getString(PreferenceKeys.librarySortDirection);
    final sortDirection = sortDirectionName != null ? SortDirection.values.byName(sortDirectionName) : SortDirection.asc;

    final collapsedStateString = _prefs.getString(PreferenceKeys.basketCollapsedStates) ?? "";
    _collapsedState = collapsedStateString.isNotEmpty ? jsonDecode(collapsedStateString) : {};

    _alwaysCollapseCategories.add(alwaysCollapseCategories);
    _sortModeSubject.add(sortMode);
    _sortDirectionSubject.add(sortDirection);
    _sortRuleIdSubject.add(sortRuleId);
    _basketIdSubject.add(basketId);
  }
}
