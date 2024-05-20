import 'package:flutter/material.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/core_sort_control.dart';
import 'package:watch_it/watch_it.dart';

class BasketSortControl extends StatelessWidget with WatchItMixin {
  const BasketSortControl({super.key});

  @override
  Widget build(BuildContext context) {
    final basketStateService = di<BasketStateService>();
    final AsyncSnapshot<List<SortRuleViewModel>> availableSortRules = watchStream((BasketService p0) => p0.sortRules, initialValue: []);
    final sortRuleId = watchStream((BasketStateService p0) => p0.sortRuleId, initialValue: basketStateService.sortRuleIdSync);
    final sortMode = watchStream((BasketStateService p0) => p0.sortMode, initialValue: basketStateService.sortModeSync);
    final sortDirection = watchStream((BasketStateService p0) => p0.sortDirection, initialValue: basketStateService.sortDirectionSync);

    return CoreSortControl(
      sortRuleId: sortRuleId.data,
      sortMode: sortMode.data,
      sortDirection: sortDirection.data ?? SortDirection.asc,
      onNewSortRule: (int newId) async {
        await di<BasketStateService>().setSortRuleId(newId);
      },
      updateSortRuleDetails: _updateSortDetails,
      availableSortRules: availableSortRules.data ?? [],
      onSwitchSortDirection: () async {
        await basketStateService.switchSortDirection();
      },
    );
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
