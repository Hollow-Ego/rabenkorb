import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/form/core_searchable_dropdown.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_text_button.dart';
import 'package:watch_it/watch_it.dart';

class BasketSortControl extends StatelessWidget with WatchItMixin {
  const BasketSortControl({super.key});

  @override
  Widget build(BuildContext context) {
    final basketStateService = di<BasketStateService>();

    final sortRules = defaultSortRules();
    final AsyncSnapshot<List<SortRuleViewModel>> availableSortRules = watchStream((BasketService p0) => p0.sortRules, initialValue: []);
    final sortOrder = watchStream((BasketStateService p0) => p0.sortRuleId, initialValue: basketStateService.sortRuleIdSync);
    final sortMode = watchStream((BasketStateService p0) => p0.sortMode, initialValue: basketStateService.sortModeSync);
    final sortDirection = watchStream((BasketStateService p0) => p0.sortDirection, initialValue: basketStateService.sortDirectionSync);
    final selectedItem = sortOrder.hasData && (availableSortRules.data?.length ?? 0) > 0
        ? availableSortRules.data!.firstWhere((e) => e.id == sortOrder.data!, orElse: () => _getDefaultSelectedItem(sortMode, sortRules))
        : _getDefaultSelectedItem(sortMode, sortRules);
    sortRules.addAll(availableSortRules.data ?? []);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: CoreSearchableDropdown<SortRuleViewModel>(
              selectedItem: selectedItem,
              items: sortRules,
              itemAsString: (SortRuleViewModel? rule) => _getSortRuleName(context, rule),
              displayString: (SortRuleViewModel? rule) => _getSortRuleName(context, rule),
              onChanged: _updateSortDetails,
              compareFn: (a, b) => a.id == b.id,
              inputDecoration: const InputDecoration(
                border: InputBorder.none,
              ),
              allowEmptyValue: false,
              onNoSearchResultAction: (String searchValue) async {
                final newId = await di<SortRuleService>().createSortRule(searchValue);
                await di<BasketStateService>().setSortRuleId(newId);
              },
            ),
          ),
          CoreIconTextButton(
            icon: const Icon(Icons.sort),
            label: Text(S.of(context).SortDirection(sortDirection.data?.name ?? "")),
            onPressed: () async {
              await basketStateService.switchSortDirection();
            },
          ),
        ],
      ),
    );
  }

  String _getSortRuleName(BuildContext context, SortRuleViewModel? rule) {
    return rule?.name ?? S.of(context).Unnamed;
  }

  SortRuleViewModel _getDefaultSelectedItem(AsyncSnapshot<SortMode> sortMode, List<SortRuleViewModel> sortRules) {
    if (sortMode.data == SortMode.databaseOrder) {
      return sortRules.firstWhere((e) => e.id == sortByDatabasePseudoId);
    }
    return sortRules.firstWhere((e) => e.id == sortByNamePseudoId);
  }

  Future<void> _updateSortDetails(SortRuleViewModel? rule) async {
    final ruleId = rule?.id;
    if (ruleId == null) {
      return;
    }
    final basketStateService = di<BasketStateService>();
    if (ruleId == sortByNamePseudoId) {
      await basketStateService.setSortMode(SortMode.name);
      await basketStateService.setSortRuleId(null);
      return;
    }
    if (ruleId == sortByDatabasePseudoId) {
      await basketStateService.setSortMode(SortMode.databaseOrder);
      await basketStateService.setSortRuleId(null);
      return;
    }

    await basketStateService.setSortMode(SortMode.custom);
    await basketStateService.setSortRuleId(ruleId);
  }
}
