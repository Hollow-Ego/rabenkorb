import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/state/data_management_state_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_text_button.dart';
import 'package:rabenkorb/shared/widgets/sort_rule_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class DataManagementSortControl extends StatelessWidget with WatchItMixin {
  final bool customRulesOnly;

  const DataManagementSortControl({
    super.key,
    this.customRulesOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final dataManagementStateService = di<DataManagementStateService>();
    final AsyncSnapshot<List<SortRuleViewModel>> availableSortRules = watchStream((SortRuleService p0) => p0.sortRules, initialValue: []);
    final sortRuleId = watchStream((DataManagementStateService p0) => p0.sortRuleId, initialValue: dataManagementStateService.sortRuleIdSync);
    final sortMode = watchStream((DataManagementStateService p0) => p0.sortMode, initialValue: dataManagementStateService.sortModeSync);
    final sortDirection = watchStream((DataManagementStateService p0) => p0.sortDirection, initialValue: dataManagementStateService.sortDirectionSync);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SortRuleDropdown(
              customRulesOnly: customRulesOnly,
              sortMode: sortMode.data,
              sortRuleId: sortRuleId.data,
              availableSortRules: availableSortRules.data ?? [],
              updateSortRuleDetails: _updateSortDetails,
              onNewSortRule: (int newId) async {
                await di<DataManagementStateService>().setSortRuleId(newId);
              },
            ),
          ),
          CoreIconTextButton(
            icon: const Icon(Icons.sort),
            label: Text(S.of(context).SortDirection(sortDirection.data?.name ?? "")),
            onPressed: () async {
              await dataManagementStateService.switchSortDirection();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateSortDetails(SortRuleViewModel? rule) async {
    final ruleId = rule?.id;
    if (ruleId == null) {
      return;
    }
    final dataManagementStateService = di<DataManagementStateService>();
    if (ruleId == sortByNamePseudoId) {
      await dataManagementStateService.setSortMode(SortMode.name);
      await dataManagementStateService.setSortRuleId(null);
      return;
    }
    if (ruleId == sortByDatabasePseudoId) {
      await dataManagementStateService.setSortMode(SortMode.databaseOrder);
      await dataManagementStateService.setSortRuleId(null);
      return;
    }

    await dataManagementStateService.setSortMode(SortMode.custom);
    await dataManagementStateService.setSortRuleId(ruleId);
  }
}
