import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_dropdown_button.dart';
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
        ? sortOrder.data!
        : (sortMode.data == SortMode.databaseOrder ? sortByDatabasePseudoId : sortByNamePseudoId);
    sortRules.addAll(availableSortRules.data ?? []);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CoreDropdownButton<int>(
          icon: const Icon(
            Icons.sort_by_alpha,
          ),
          onPressed: _updateSortDetails,
          selectedItem: selectedItem,
          items: _toDropdownMenuItem(sortRules),
        ),
        CoreIconTextButton(
          icon: const Icon(Icons.sort),
          label: Text(S.of(context).SortDirection(sortDirection.data?.name ?? "")),
          onPressed: () async {
            await basketStateService.switchSortDirection();
          },
        ),
      ],
    );
  }

  Future<void> _updateSortDetails(int? id) async {
    if (id == null) {
      return;
    }
    final basketStateService = di<BasketStateService>();
    if (id == sortByNamePseudoId) {
      await basketStateService.setSortMode(SortMode.name);
      await basketStateService.setSortRuleId(null);
      return;
    }
    if (id == sortByDatabasePseudoId) {
      await basketStateService.setSortMode(SortMode.databaseOrder);
      await basketStateService.setSortRuleId(null);
      return;
    }

    await basketStateService.setSortMode(SortMode.custom);
    await basketStateService.setSortRuleId(id);
  }

  List<DropdownMenuItem<int>> _toDropdownMenuItem(List<SortRuleViewModel> sortRules) {
    return sortRules
        .map(
          (sortRule) => DropdownMenuItem<int>(
            value: sortRule.id,
            child: Text(sortRule.name),
          ),
        )
        .toList();
  }
}
