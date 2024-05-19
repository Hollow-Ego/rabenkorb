import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/categories/category_tile.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:watch_it/watch_it.dart';

class CategoryList extends StatelessWidget with WatchItMixin {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<ItemCategoryViewModel>> categories = watchStream((MetadataService p0) => p0.categories, initialValue: []);
    final categoryList = categories.data ?? [];

    return Expanded(
      child: ListView.builder(
        itemCount: categoryList.length,
        prototypeItem: CategoryTile(
          category: ItemCategoryViewModel(-1, "Category Prototype"),
        ),
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(category: categoryList[index]);
        },
      ),
    );
  }
}
