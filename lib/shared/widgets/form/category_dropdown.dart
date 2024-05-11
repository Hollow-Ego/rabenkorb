import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/widgets/form/core_searchable_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class CategoryDropdown extends StatelessWidget with WatchItMixin {
  final ItemCategoryViewModel? selectedCategory;
  final Function(ItemCategoryViewModel? category) onChanged;
  final Function(String)? onNoSearchResultAction;
  final String? dropdownKey;

  const CategoryDropdown({super.key, this.selectedCategory, required this.onChanged, this.onNoSearchResultAction, this.dropdownKey});

  @override
  Widget build(BuildContext context) {
    final categories = watchStream((MetadataService p0) => p0.categories, initialValue: List<ItemCategoryViewModel>.empty());
    final categoryList = categories.data ?? List<ItemCategoryViewModel>.empty();

    return CoreSearchableDropdown<ItemCategoryViewModel>(
      key: dropdownKey != null ? Key(dropdownKey!) : null,
      items: categoryList,
      selectedItem: selectedCategory,
      itemAsString: (category) => category.name,
      displayString: (category) => category?.name ?? "",
      compareFn: (a, b) => a.id == b.id,
      onChanged: onChanged,
      onNoSearchResultAction: onNoSearchResultAction,
      inputDecoration: InputDecoration(
        labelText: S.of(context).Category,
      ),
    );
  }
}
