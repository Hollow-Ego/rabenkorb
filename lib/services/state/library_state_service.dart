import 'dart:convert';

import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import '../../shared/sort_mode.dart';

class LibraryStateService {
  final _prefs = di<PreferenceService>();

  final BehaviorSubject<int?> _libraryIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.name);
  final BehaviorSubject<SortDirection> _sortDirectionSubject = BehaviorSubject<SortDirection>.seeded(SortDirection.asc);
  final BehaviorSubject<bool> _alwaysCollapseCategories = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _multiSelectMode = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<Map<int, bool>> _selectedItems = BehaviorSubject<Map<int, bool>>.seeded({});

  int? get libraryIdSync => _libraryIdSubject.value;

  Stream<String> get search => _searchSubject.stream.debounceTime(const Duration(milliseconds: 300));

  String get currentSearchSync => _searchSubject.value;

  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream;

  int? get sortRuleIdSync => _sortRuleIdSubject.value;

  Stream<SortMode> get sortMode => _sortModeSubject.stream;

  SortMode get sortModeSync => _sortModeSubject.value;

  Stream<SortDirection> get sortDirection => _sortDirectionSubject.stream;

  SortDirection get sortDirectionSync => _sortDirectionSubject.value;

  Stream<bool> get alwaysCollapseCategories => _alwaysCollapseCategories.stream;

  Stream<bool> get isMultiSelectMode => _multiSelectMode.stream;

  Stream<Map<int, bool>> get selectedItemsMap => _selectedItems.stream;

  List<int> get selectedItemsSync => _selectedItems.value.entries.where((e) => e.value).map((e) => e.key).toList();

  Map<String, bool> _collapsedState = <String, bool>{};

  LibraryStateService() {
    init();
  }

  factory LibraryStateService.withValue({
    SortMode? sortMode,
    int? sortRuleId,
    String? searchString,
  }) {
    final service = LibraryStateService();

    service.setSortMode(sortMode);
    service.setSearchString(searchString);
    service.setSortRuleId(sortRuleId);

    return service;
  }

  Future<void> setLibraryId(int? libraryId) async {
    if (libraryId == null) {
      await _prefs.remove(PreferenceKeys.libraryId);
    } else {
      await _prefs.setInt(PreferenceKeys.libraryId, libraryId);
    }
    _libraryIdSubject.add(libraryId);
  }

  Future<void> setSortMode(SortMode? sortMode) async {
    if (sortMode == null) {
      return;
    }
    await _prefs.setString(PreferenceKeys.librarySortMode, sortMode.name);
    _sortModeSubject.add(sortMode);
  }

  Future<void> setSortRuleId(int? sortRuleId) async {
    if (sortRuleId == null) {
      await _prefs.remove(PreferenceKeys.librarySortRuleId);
    } else {
      await _prefs.setInt(PreferenceKeys.librarySortRuleId, sortRuleId);
    }
    _sortRuleIdSubject.add(sortRuleId);
  }

  Future<void> switchSortDirection() async {
    final newDirection = flipSortDirection(sortDirectionSync);
    await _prefs.setString(PreferenceKeys.librarySortDirection, newDirection.name);
    _sortDirectionSubject.add(newDirection);
  }

  Future<void> setAlwaysCollapseCategories(bool alwaysCollapseCategories) async {
    await _prefs.setBool(PreferenceKeys.libraryAlwaysCollapseCategories, alwaysCollapseCategories);
    _alwaysCollapseCategories.add(alwaysCollapseCategories);
  }

  void setSearchString(String? searchString) {
    searchString = searchString ?? "";
    _searchSubject.add(searchString);
  }

  Future<void> setCollapseState(String headerKey, bool value) async {
    _collapsedState[headerKey] = value;
    await _prefs.setString(PreferenceKeys.libraryCollapsedStates, jsonEncode(_collapsedState));
  }

  Future<void> removeCollapsedState(String headerKey) async {
    _collapsedState.remove(headerKey);
    await _prefs.setString(PreferenceKeys.libraryCollapsedStates, jsonEncode(_collapsedState));
  }

  bool isCollapsed(String headerKey) {
    return _collapsedState[headerKey] ?? false;
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
    final alwaysCollapseCategories = _prefs.getBool(PreferenceKeys.libraryAlwaysCollapseCategories) ?? false;

    final libraryId = _prefs.getInt(PreferenceKeys.libraryId);
    final sortModeName = _prefs.getString(PreferenceKeys.librarySortMode);
    final sortMode = sortModeName != null ? SortMode.values.byName(sortModeName) : SortMode.name;

    final sortRuleId = _prefs.getInt(PreferenceKeys.librarySortRuleId);

    final collapsedStateString = _prefs.getString(PreferenceKeys.libraryCollapsedStates) ?? "";

    final sortDirectionName = _prefs.getString(PreferenceKeys.librarySortDirection);
    final sortDirection = sortDirectionName != null ? SortDirection.values.byName(sortDirectionName) : SortDirection.asc;

    _collapsedState = {};
    if (collapsedStateString.isNotEmpty) {
      final decodedMap = jsonDecode(collapsedStateString);
      _collapsedState = decodedMap.cast<String, bool>();
    }

    _libraryIdSubject.add(libraryId);
    _alwaysCollapseCategories.add(alwaysCollapseCategories);
    _sortModeSubject.add(sortMode);
    _sortDirectionSubject.add(sortDirection);
    _sortRuleIdSubject.add(sortRuleId);
  }

  Future<void> reset() async {
    await _prefs.remove(PreferenceKeys.libraryId);
    await _prefs.remove(PreferenceKeys.librarySortMode);
    await _prefs.remove(PreferenceKeys.librarySortDirection);
    await _prefs.remove(PreferenceKeys.librarySortRuleId);
    await _prefs.remove(PreferenceKeys.libraryCollapsedStates);

    init();
  }
}
