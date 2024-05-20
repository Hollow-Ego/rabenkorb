import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_text_button.dart';
import 'package:rabenkorb/shared/widgets/sort_rule_dropdown.dart';

class CoreSortControl extends StatelessWidget {
  final int? sortRuleId;
  final SortMode? sortMode;
  final SortDirection sortDirection;
  final Function(int newId) onNewSortRule;
  final Function(SortRuleViewModel? rule) updateSortRuleDetails;
  final List<SortRuleViewModel> availableSortRules;
  final bool customRulesOnly;
  final Function() onSwitchSortDirection;

  const CoreSortControl({
    super.key,
    this.sortRuleId,
    this.sortMode,
    required this.sortDirection,
    required this.onNewSortRule,
    required this.updateSortRuleDetails,
    required this.availableSortRules,
    required this.onSwitchSortDirection,
    this.customRulesOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: SortRuleDropdown(
            sortMode: sortMode,
            sortRuleId: sortRuleId,
            availableSortRules: availableSortRules,
            updateSortRuleDetails: updateSortRuleDetails,
            onNewSortRule: onNewSortRule,
          )),
          CoreIconTextButton(
            icon: const Icon(Icons.sort),
            label: Text(S.of(context).SortDirection(sortDirection.name)),
            onPressed: onSwitchSortDirection,
          ),
        ],
      ),
    );
  }
}
