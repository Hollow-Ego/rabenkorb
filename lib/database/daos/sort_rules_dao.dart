import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';

part 'sort_rules_dao.g.dart';

@DriftAccessor(tables: [SortRules])
class SortRulesDao extends DatabaseAccessor<AppDatabase> with _$SortRulesDaoMixin {
  SortRulesDao(super.db);

  Future<int> createSortRule(String name) {
    return into(sortRules).insert(SortRulesCompanion(name: Value(name)));
  }

  Future<void> updateSortRule(int id, String name) {
    return update(sortRules).replace(SortRule(id: id, name: name));
  }

  Stream<SortRuleViewModel?> watchSortRuleWithId(int id) {
    return (select(sortRules)..where((li) => li.id.equals(id))).watchSingle().map((rule) => toSortRuleViewModel(rule));
  }

  Future<SortRuleViewModel?> getSortRuleWithId(int id) async {
    final rule = await (select(sortRules)..where((li) => li.id.equals(id))).getSingleOrNull();
    return toSortRuleViewModel(rule);
  }

  Future<int> deleteSortRuleWithId(int id) {
    return (delete(sortRules)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<SortRuleViewModel>> watchSortRules() {
    return (select(sortRules)).watch().map((rules) => rules.map((rule) => toSortRuleViewModel(rule)!).toList());
  }
}
