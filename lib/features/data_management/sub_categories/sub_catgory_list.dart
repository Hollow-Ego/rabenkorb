import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/sub_categories/sub_category_tile.dart';
import 'package:rabenkorb/models/item_sub_category_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:watch_it/watch_it.dart';

class SubCategoryList extends StatelessWidget with WatchItMixin {
  const SubCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<ItemSubCategoryViewModel>> categories = watchStream((MetadataService p0) => p0.subCategories, initialValue: []);
    final subCategoryList = categories.data ?? [];

    return Expanded(
      child: ListView.builder(
        itemCount: subCategoryList.length,
        prototypeItem: SubCategoryTile(
          subCategory: ItemSubCategoryViewModel(-1, "Sub-Category Prototype"),
        ),
        itemBuilder: (BuildContext context, int index) {
          return SubCategoryTile(subCategory: subCategoryList[index]);
        },
      ),
    );
  }
}
