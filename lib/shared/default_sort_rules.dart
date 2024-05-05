import 'package:rabenkorb/database/tables/sort_rules.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';

const sortByNamePseudoId = -99;
const sortByDatabasePseudoId = -98;

List<SortRuleViewModel> defaultSortRules() => [
      SortRuleViewModel(sortByNamePseudoId, S.current.SortByName, GroupMode.category),
      SortRuleViewModel(sortByDatabasePseudoId, S.current.SortByDatabaseOrder, GroupMode.category)
    ];
