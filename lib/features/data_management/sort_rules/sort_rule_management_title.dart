import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/business/data_management_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:watch_it/watch_it.dart';

class SortRuleManagementTitle extends StatelessWidget with WatchItMixin {
  const SortRuleManagementTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final activeSortRule = watchStream((DataManagementService p0) => p0.activeSortRule, initialValue: null);
    final activeSortRuleData = activeSortRule.data;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(activeSortRuleData?.name ?? S.current.SortRules),
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
                },
              );
            },
          ),
      ],
    );
  }
}
