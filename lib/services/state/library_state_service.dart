import 'package:rabenkorb/abstracts/PreferenceService.dart';
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

  LibraryStateService();

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
}
