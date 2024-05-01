import 'dart:convert';

import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import '../../shared/sort_mode.dart';

class LibraryStateService {
  final _prefs = di<PreferenceService>();

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.name);
  final BehaviorSubject<bool> _alwaysCollapseCategories = BehaviorSubject<bool>.seeded(false);

  Stream<String> get search => _searchSubject.stream.debounceTime(const Duration(milliseconds: 300)).distinct();
  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream.distinct();
  Stream<SortMode> get sortMode => _sortModeSubject.stream.distinct();

  Stream<bool> get alwaysCollapseCategories => _alwaysCollapseCategories.stream.distinct();

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

  Future<void> setSortMode(SortMode? sortMode) async {
    if (sortMode == null) {
      return;
    }
    await _prefs.setString(PreferenceKeys.libraryGroupMode, sortMode.name);
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

  void init() {
    final alwaysCollapseCategories = _prefs.getBool(PreferenceKeys.libraryAlwaysCollapseCategories) ?? false;
    final sortModeName = _prefs.getString(PreferenceKeys.libraryGroupMode);
    final sortMode = sortModeName != null ? SortMode.values.byName(sortModeName) : SortMode.name;

    final sortRuleId = _prefs.getInt(PreferenceKeys.librarySortRuleId);

    final collapsedStateString = _prefs.getString(PreferenceKeys.libraryCollapsedStates) ?? "";

    _collapsedState = collapsedStateString.isNotEmpty ? jsonDecode(collapsedStateString) : {};

    _alwaysCollapseCategories.add(alwaysCollapseCategories);
    _sortModeSubject.add(sortMode);
    _sortRuleIdSubject.add(sortRuleId);
  }
}
