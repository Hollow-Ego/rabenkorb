import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';

const sortByNamePseudoId = -99;
const sortByDatabasePseudoId = -98;
const withoutCategoryId = 0;

List<SortRuleViewModel> defaultSortRules() =>
    [SortRuleViewModel(sortByNamePseudoId, S.current.SortByName), SortRuleViewModel(sortByDatabasePseudoId, S.current.SortByDatabaseOrder)];
