import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/sub_categories/sub_catgory_list.dart';

class SubCategoryManagementView extends StatelessWidget {
  const SubCategoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SubCategoryList(),
      ],
    );
  }
}
