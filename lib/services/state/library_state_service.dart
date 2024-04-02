import 'package:rabenkorb/abstracts/PreferenceService.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import '../../shared/sort_mode.dart';

class LibraryStateService {
  final _prefs = di<PreferenceService>();

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.name);

  Stream<String> get search => _searchSubject.stream.distinct();
  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream.distinct();
  Stream<SortMode> get sortMode => _sortModeSubject.stream.distinct();

  LibraryStateService() {
    _init();
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

  void setSearchString(String? searchString) {
    searchString = searchString ?? "";
    _searchSubject.add(searchString);
  }

  void _init() {
    final sortModeName = _prefs.getString(PreferenceKeys.libraryGroupMode);
    final sortMode = sortModeName != null ? SortMode.values.byName(sortModeName) : SortMode.name;

    final sortRuleId = _prefs.getInt(PreferenceKeys.librarySortRuleId);

    _sortModeSubject.add(sortMode);
    _sortRuleIdSubject.add(sortRuleId);
  }
}
