import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_sub_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';

BasketItemViewModel toBasketItemViewModel(BasketItem item, ItemCategory? category, ItemSubCategory? subCategory, ShoppingBasket basket, ItemUnit? unit) {
  return BasketItemViewModel(
    id: item.id,
    name: item.name,
    imagePath: item.imagePath,
    note: item.note,
    amount: item.amount,
    category: toItemCategoryViewModel(category),
    subCategory: toItemSubCategoryViewModel(subCategory),
    basket: toShoppingBasketViewModel(basket)!,
    unit: toItemUnitViewModel(unit),
    isChecked: item.isChecked,
  );
}

ItemTemplateViewModel toItemTemplateViewModel(ItemTemplate item, ItemCategory? category, TemplateLibrary library) {
  return ItemTemplateViewModel(
    id: item.id,
    name: item.name,
    imagePath: item.imagePath,
    category: toItemCategoryViewModel(category),
    library: toTemplateLibraryViewModel(library)!,
  );
}

ItemCategoryViewModel? toItemCategoryViewModel(ItemCategory? category) {
  return category != null ? ItemCategoryViewModel(category.id, category.name) : null;
}

ItemSubCategoryViewModel? toItemSubCategoryViewModel(ItemSubCategory? subCategory) {
  return subCategory != null ? ItemSubCategoryViewModel(subCategory.id, subCategory.name) : null;
}

ItemUnitViewModel? toItemUnitViewModel(ItemUnit? unit) {
  return unit != null ? ItemUnitViewModel(unit.id, unit.name) : null;
}

ShoppingBasketViewModel? toShoppingBasketViewModel(ShoppingBasket? basket) {
  return basket != null ? ShoppingBasketViewModel(basket.id, basket.name) : null;
}

SortRuleViewModel? toSortRuleViewModel(SortRule? rule) {
  return rule != null ? SortRuleViewModel(rule.id, rule.name) : null;
}

TemplateLibraryViewModel? toTemplateLibraryViewModel(TemplateLibrary? library) {
  return library != null ? TemplateLibraryViewModel(library.id, library.name) : null;
}
