import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/data_management_sort_control.dart';

import 'sort_rule_catgory_list.dart';

class SortRuleManagementView extends StatelessWidget {
  const SortRuleManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DataManagementSortControl(
          customRulesOnly: true,
        ),
        SortRuleCategoryList(),
      ],
    );
  }
}
