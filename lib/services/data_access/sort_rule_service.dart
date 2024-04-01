import 'package:rabenkorb/database/database.dart';
import 'package:watch_it/watch_it.dart';

class SortRuleService {
  final _db = di<AppDatabase>();

  Future<int> createSortRule(String name) {
    return _db.sortRulesDao.createSortRule(name);
  }

  Future<void> updateSortRule(int id, String name) {
    return _db.sortRulesDao.updateSortRule(id, name);
  }

  Future<SortRule?> getSortRuleById(int id) {
    return _db.sortRulesDao.getSortRuleWithId(id);
  }

  Future<int> deleteSortRuleById(int id) {
    return _db.sortRulesDao.deleteSortRuleWithId(id);
  }

  Stream<List<SortRule>> watchSortRules() {
    return _db.sortRulesDao.watchSortRules();
  }

  Stream<SortRule> watchSortRuleWithId(int id) {
    return _db.sortRulesDao.watchSortRuleWithId(id);
  }
}
