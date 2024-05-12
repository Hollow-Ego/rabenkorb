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
  final BehaviorSubject<bool> _isShoppingMode = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _multiSelectMode = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<Map<int, bool>> _selectedItems = BehaviorSubject<Map<int, bool>>.seeded({});

  Stream<String> get search => _searchSubject.stream.debounceTime(const Duration(milliseconds: 300));

  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream;

  int? get sortRuleIdSync => _sortRuleIdSubject.value;

  Stream<SortMode> get sortMode => _sortModeSubject.stream;

  SortMode get sortModeSync => _sortModeSubject.value;

  Stream<SortDirection> get sortDirection => _sortDirectionSubject.stream;

  SortDirection get sortDirectionSync => _sortDirectionSubject.value;

  Stream<int?> get basketId => _basketIdSubject.stream;

  int? get basketIdSync => _basketIdSubject.value;

  Stream<bool> get alwaysCollapseCategories => _alwaysCollapseCategories.stream;

  Map<String, bool> _collapsedState = <String, bool>{};

  Stream<bool> get isShoppingMode => _isShoppingMode.stream;

  Stream<bool> get isMultiSelectMode => _multiSelectMode.stream;

  Stream<Map<int, bool>> get selectedItemsMap => _selectedItems.stream;

  List<int> get selectedItemsSync => _selectedItems.value.entries.where((e) => e.value).map((e) => e.key).toList();

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
    await _prefs.setString(PreferenceKeys.basketSortMode, sortMode.name);
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

  bool isCollapsed(String headerKey) {
    return _collapsedState[headerKey] ?? false;
  }

  Future<void> switchSortDirection() async {
    final newDirection = flipSortDirection(sortDirectionSync);
    await _prefs.setString(PreferenceKeys.basketSortDirection, newDirection.name);
    _sortDirectionSubject.add(newDirection);
  }

  Future<void> toggleShoppingMode() async {
    final current = _isShoppingMode.value;
    final newValue = !current;
    _prefs.setBool(PreferenceKeys.basketShoppingMode, newValue);
    _isShoppingMode.add(newValue);
  }

  void enterMultiSelectMode() {
    _multiSelectMode.add(true);
  }

  void leaveMultiSelectMode() {
    _multiSelectMode.add(false);
    _selectedItems.add({});
  }

  void setSelectionState(int id, bool state) {
    final selectedItems = _selectedItems.value;
    selectedItems[id] = state;
    _selectedItems.add(selectedItems);
  }

  void selectAll(List<int> ids) {
    Map<int, bool> selectedItems = {};

    for (var id in ids) {
      selectedItems[id] = true;
    }
    _selectedItems.add(selectedItems);
  }

  void deselectAll() {
    _selectedItems.add({});
  }

  void init() {
    final alwaysCollapseCategories = _prefs.getBool(PreferenceKeys.basketAlwaysCollapseCategories) ?? false;
    final sortModeName = _prefs.getString(PreferenceKeys.basketSortMode);
    final sortMode = sortModeName != null ? SortMode.values.byName(sortModeName) : SortMode.name;

    final sortRuleId = _prefs.getInt(PreferenceKeys.basketSortRuleId);
    final basketId = _prefs.getInt(PreferenceKeys.basketId) ?? -1;

    final sortDirectionName = _prefs.getString(PreferenceKeys.basketSortDirection);
    final sortDirection = sortDirectionName != null ? SortDirection.values.byName(sortDirectionName) : SortDirection.asc;

    final collapsedStateString = _prefs.getString(PreferenceKeys.basketCollapsedStates) ?? "";
    _collapsedState = collapsedStateString.isNotEmpty ? jsonDecode(collapsedStateString) : {};

    final isShoppingMode = _prefs.getBool(PreferenceKeys.basketShoppingMode) ?? false;

    _alwaysCollapseCategories.add(alwaysCollapseCategories);
    _sortModeSubject.add(sortMode);
    _sortDirectionSubject.add(sortDirection);
    _sortRuleIdSubject.add(sortRuleId);
    _basketIdSubject.add(basketId);
    _isShoppingMode.add(isShoppingMode);
  }
}
