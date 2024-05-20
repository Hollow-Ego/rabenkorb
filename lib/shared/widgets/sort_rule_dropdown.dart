import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/form/core_searchable_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class SortRuleDropdown extends StatelessWidget {
  final int? sortRuleId;
  final SortMode? sortMode;
  final Function(int newId) onNewSortRule;
  final Function(SortRuleViewModel? rule) updateSortRuleDetails;
  final List<SortRuleViewModel> availableSortRules;
  final bool customRulesOnly;

  const SortRuleDropdown({
    super.key,
    this.sortRuleId,
    this.sortMode,
    required this.onNewSortRule,
    required this.updateSortRuleDetails,
    required this.availableSortRules,
    this.customRulesOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<SortRuleViewModel> sortRules = customRulesOnly ? [] : defaultSortRules();
    sortRules.addAll(availableSortRules);
    final selectedItem = _getSelectedItem(sortMode, sortRules, sortRuleId, customRulesOnly);

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
    return rule?.name ?? S.of(context).NoSelection;
  }

  SortRuleViewModel? _getSelectedItem(SortMode? sortMode, List<SortRuleViewModel> sortRules, int? sortRuleId, bool customRulesOnly) {
    if (sortRules.isEmpty) {
      return null;
    }

    if (customRulesOnly && sortRuleId == null) {
      return null;
    }

    if (sortMode == SortMode.custom) {
      return sortRules.firstWhereOrNull((e) => e.id == sortRuleId);
    }

    if (sortMode == SortMode.databaseOrder) {
      return sortRules.firstWhere((e) => e.id == sortByDatabasePseudoId);
    }
    return sortRules.firstWhere((e) => e.id == sortByNamePseudoId);
  }
}
