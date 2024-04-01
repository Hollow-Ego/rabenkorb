import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';

part 'sort_rules_dao.g.dart';

@DriftAccessor(tables: [SortRules])
class SortRulesDao extends DatabaseAccessor<AppDatabase> with _$SortRulesDaoMixin {
  SortRulesDao(super.db);

  Future<int> createSortRule(String name, {GroupMode groupMode = GroupMode.category}) {
    return into(sortRules).insert(SortRulesCompanion(name: Value(name), groupMode: Value(groupMode)));
  }

  Future<void> updateSortRule(int id, String name, {GroupMode groupMode = GroupMode.category}) {
    return update(sortRules).replace(SortRule(id: id, name: name, groupMode: groupMode));
  }

  Stream<SortRule> watchSortRuleWithId(int id) {
    return (select(sortRules)..where((li) => li.id.equals(id))).watchSingle();
  }

  Future<SortRule?> getSortRuleWithId(int id) {
    return (select(sortRules)..where((li) => li.id.equals(id))).getSingleOrNull();
  }

  Future<int> deleteSortRuleWithId(int id) {
    return (delete(sortRules)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<SortRule>> watchSortRules() {
    return (select(sortRules)).watch();
  }
}
