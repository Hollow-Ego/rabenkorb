import 'dart:async';

import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class SortRuleService implements Disposable {
  final _db = di<AppDatabase>();

  late StreamSubscription _sortRulesSub;
  final _sortRules = BehaviorSubject<List<SortRuleViewModel>>.seeded([]);

  Stream<List<SortRuleViewModel>> get sortRules => _sortRules.stream;

  SortRuleService() {
    _sortRulesSub = watchSortRules().listen((sortRules) {
      _sortRules.add(sortRules);
    });
  }

  Future<int> createSortRule(String name) {
    return _db.sortRulesDao.createSortRule(name);
  }

  Future<void> updateSortRule(int id, String name) {
    return _db.sortRulesDao.updateSortRule(id, name);
  }

  Future<SortRuleViewModel?> getSortRuleById(int id) {
    return _db.sortRulesDao.getSortRuleWithId(id);
  }

  Future<int> deleteSortRuleById(int id) {
    return _db.sortRulesDao.deleteSortRuleWithId(id);
  }

  Stream<List<SortRuleViewModel>> watchSortRules() {
    return _db.sortRulesDao.watchSortRules();
  }

  Stream<SortRuleViewModel?> watchSortRuleWithId(int id) {
    return _db.sortRulesDao.watchSortRuleWithId(id);
  }

  @override
  FutureOr onDispose() {
    _sortRulesSub.cancel();
  }
}
