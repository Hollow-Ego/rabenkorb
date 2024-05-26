import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_sub_category_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/widgets/form/core_searchable_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class SubCategoryDropdown extends StatelessWidget with WatchItMixin {
  final ItemSubCategoryViewModel? selectedSubCategory;
  final Function(ItemSubCategoryViewModel? subCategory) onChanged;
  final Function(String)? onNoSearchResultAction;
  final String? dropdownKey;

  const SubCategoryDropdown({super.key, this.selectedSubCategory, required this.onChanged, this.onNoSearchResultAction, this.dropdownKey});

  @override
  Widget build(BuildContext context) {
    final subCategories = watchStream((MetadataService p0) => p0.subCategories, initialValue: List<ItemSubCategoryViewModel>.empty());
    final subCategoryList = subCategories.data ?? List<ItemSubCategoryViewModel>.empty();

    return CoreSearchableDropdown<ItemSubCategoryViewModel>(
      key: dropdownKey != null ? Key(dropdownKey!) : null,
      items: subCategoryList,
      selectedItem: selectedSubCategory,
      itemAsString: (subCategory) => subCategory.name,
      displayString: (subCategory) => subCategory?.name ?? "",
      compareFn: (a, b) => a.id == b.id,
      onChanged: onChanged,
      onNoSearchResultAction: onNoSearchResultAction,
      inputDecoration: InputDecoration(
        labelText: S.of(context).SubCategory,
      ),
    );
  }
}
