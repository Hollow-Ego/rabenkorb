import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/business/data_management_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/state/data_management_state_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:rabenkorb/shared/widgets/sort_rule_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class SortRuleManagementTitle extends StatelessWidget with WatchItMixin {
  const SortRuleManagementTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final activeSortRule = watchStream((DataManagementService p0) => p0.activeSortRule, initialValue: null);
    final activeSortRuleData = activeSortRule.data;

    final dataManagementStateService = di<DataManagementStateService>();
    final AsyncSnapshot<List<SortRuleViewModel>> availableSortRules = watchStream((SortRuleService p0) => p0.sortRules, initialValue: []);
    final sortRuleId = watchStream((DataManagementStateService p0) => p0.sortRuleId, initialValue: dataManagementStateService.sortRuleIdSync);
    final sortMode = watchStream((DataManagementStateService p0) => p0.sortMode, initialValue: dataManagementStateService.sortModeSync);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SortRuleDropdown(
            customRulesOnly: true,
            sortMode: sortMode.data,
            sortRuleId: sortRuleId.data,
            availableSortRules: availableSortRules.data ?? [],
            updateSortRuleDetails: _updateSortDetails,
            onNewSortRule: (int newId) async {
              await di<DataManagementStateService>().setSortRuleId(newId);
            },
          ),
        ),
        if (activeSortRuleData != null)
          CoreIconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await showRenameDialog(
                context,
                initialName: activeSortRuleData.name,
                onConfirm: (String? newName, bool nameChanged) async {
                  if (!nameChanged || newName == null) {
                    return;
                  }
                  await di<SortRuleService>().updateSortRule(activeSortRuleData.id, newName);
                },
              );
            },
          ),
        if (activeSortRuleData != null)
          CoreIconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () async {
              await doWithConfirmation(
                context,
                text: S.of(context).ConfirmDeleteSortRule,
                title: S.of(context).Confirm,
                onConfirm: () async {
                  await di<SortRuleService>().deleteSortRuleById(activeSortRuleData.id);
                  await di<DataManagementStateService>().setSortRuleId(null);
                },
              );
            },
          ),
      ],
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
