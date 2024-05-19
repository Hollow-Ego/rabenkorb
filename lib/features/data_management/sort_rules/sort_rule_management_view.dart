import 'package:flutter/material.dart';

import 'sort_rule_catgory_list.dart';

class SortRuleManagementView extends StatelessWidget {
  const SortRuleManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SortRuleCategoryList(),
      ],
    );
  }
}
