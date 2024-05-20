import 'package:flutter/material.dart';

import 'catgory_list.dart';

class CategoryManagementView extends StatelessWidget {
  const CategoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CategoryList(),
      ],
    );
  }
}
