import 'package:flutter/material.dart';

import 'unit_list.dart';

class UnitManagementView extends StatelessWidget {
  const UnitManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        UnitList(),
      ],
    );
  }
}
