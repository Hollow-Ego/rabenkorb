import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/form/core_searchable_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class SortRuleDropdown extends StatelessWidget {
  final int? sortRuleId;
  final SortMode? sortMode;
  final Function(int newId) onNewSortRule;
  final Function(SortRuleViewModel? rule) updateSortRuleDetails;
  final List<SortRuleViewModel> availableSortRules;

  const SortRuleDropdown({
    super.key,
    this.sortRuleId,
    this.sortMode,
    required this.onNewSortRule,
    required this.updateSortRuleDetails,
    required this.availableSortRules,
  });

  @override
  Widget build(BuildContext context) {
    final sortRules = defaultSortRules();
    final selectedItem = sortRuleId != null && (availableSortRules.length ?? 0) > 0
        ? availableSortRules.firstWhere((e) => e.id == sortRuleId, orElse: () => _getDefaultSelectedItem(sortMode, sortRules))
        : _getDefaultSelectedItem(sortMode, sortRules);
    sortRules.addAll(availableSortRules);

    return CoreSearchableDropdown<SortRuleViewModel>(
      selectedItem: selectedItem,
      items: sortRules,
      itemAsString: (SortRuleViewModel? rule) => _getSortRuleName(context, rule),
      displayString: (SortRuleViewModel? rule) => _getSortRuleName(context, rule),
      onChanged: updateSortRuleDetails,
      compareFn: (a, b) => a.id == b.id,
      inputDecoration: const InputDecoration(
        border: InputBorder.none,
      ),
      allowEmptyValue: false,
      onNoSearchResultAction: (String searchValue) async {
        final newId = await di<SortRuleService>().createSortRule(searchValue);
        await onNewSortRule(newId);
      },
    );
  }

  String _getSortRuleName(BuildContext context, SortRuleViewModel? rule) {
    return rule?.name ?? S.of(context).Unnamed;
  }

  SortRuleViewModel _getDefaultSelectedItem(SortMode? sortMode, List<SortRuleViewModel> sortRules) {
    if (sortMode == SortMode.databaseOrder) {
      return sortRules.firstWhere((e) => e.id == sortByDatabasePseudoId);
    }
    return sortRules.firstWhere((e) => e.id == sortByNamePseudoId);
  }
}
