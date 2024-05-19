import 'package:flutter/material.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';

class SortRuleCategoryTile extends StatelessWidget {
  final ItemCategoryViewModel category;

  const SortRuleCategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(category.name),
      ),
    );
  }
}
