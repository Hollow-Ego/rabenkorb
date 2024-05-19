import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/sort_mode.dart';

class DataManagementStateService {
  final BehaviorSubject<int?> _sortRuleIdSubject = BehaviorSubject<int?>.seeded(null);
  final BehaviorSubject<SortMode> _sortModeSubject = BehaviorSubject<SortMode>.seeded(SortMode.custom);
  final BehaviorSubject<SortDirection> _sortDirectionSubject = BehaviorSubject<SortDirection>.seeded(SortDirection.asc);

  Stream<int?> get sortRuleId => _sortRuleIdSubject.stream;

  int? get sortRuleIdSync => _sortRuleIdSubject.value;

  Stream<SortMode> get sortMode => _sortModeSubject.stream;

  SortMode get sortModeSync => _sortModeSubject.value;

  Stream<SortDirection> get sortDirection => _sortDirectionSubject.stream;

  SortDirection get sortDirectionSync => _sortDirectionSubject.value;

  Future<void> setSortMode(SortMode? sortMode) async {
    if (sortMode == null) {
      return;
    }
    _sortModeSubject.add(sortMode);
  }

  Future<void> setSortRuleId(int? sortRuleId) async {
    _sortRuleIdSubject.add(sortRuleId);
  }

  Future<void> switchSortDirection() async {
    final newDirection = flipSortDirection(sortDirectionSync);
    _sortDirectionSubject.add(newDirection);
  }
}
