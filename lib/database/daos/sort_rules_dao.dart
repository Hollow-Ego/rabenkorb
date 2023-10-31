import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';

part 'sort_rules_dao.g.dart';

@DriftAccessor(tables: [SortRules])
class SortRulesDao extends DatabaseAccessor<AppDatabase> with _$SortRulesDaoMixin {
  SortRulesDao(super.db);
}
