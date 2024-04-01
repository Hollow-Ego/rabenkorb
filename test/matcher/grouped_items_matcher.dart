import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';

import 'basket_item_matcher.dart';
import 'item_template_matcher.dart';

class IsEqualToGroupedItem<T extends DataItem> extends Matcher {
  final List<GroupedItems<T>> expectedItems;
  int mismatchedItemIndex = -1;

  IsEqualToGroupedItem(this.expectedItems);

  @override
  Description describe(Description description) {
    return description.add("GroupedItem matches");
  }

  @override
  bool matches(item, Map matchState) {
    final actualItems = item as List<GroupedItems<T>>;
    if (expectedItems.isEmpty) {
      return actualItems.isEmpty;
    }

    for (final (index, actualItem) in actualItems.indexed) {
      final expectedItem = expectedItems.elementAt(index);
      final isMatch = _isExpectedGroupedItems(actualItem, expectedItem);

      if (!isMatch) {
        mismatchedItemIndex = index;
        break;
      }
    }
    return mismatchedItemIndex < 0;
  }

  @override
  Description describeMismatch(
    item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    final actualItems = item as List<GroupedItems<T>>;

    if (expectedItems.isEmpty && actualItems.isNotEmpty) {
      mismatchDescription.add("Expected items to be empty, but found ${actualItems.length} items");
      return mismatchDescription;
    }

    mismatchDescription.add("item at index $mismatchedItemIndex\n");

    if (mismatchedItemIndex < 0) {
      mismatchDescription.add("unexpected index for mismatched item\n");
      return mismatchDescription;
    }

    final actualItem = actualItems.elementAt(mismatchedItemIndex);
    final expectedItem = expectedItems.elementAt(mismatchedItemIndex);

    final expectedCategory = expectedItem.category.name;
    final actualCategory = actualItem.category.name;

    if (actualItem.category.name != expectedItem.category.name) {
      mismatchDescription.add('expected to have category "$expectedCategory" but got "$actualCategory"\n');
    }

    return mismatchDescription;
  }

  bool _isExpectedGroupedItems(GroupedItems<T> actualItem, GroupedItems<T> expectedItem) {
    final actualCategory = actualItem.category;
    final expectedCategory = expectedItem.category;
    final isExpectedCategory = _isExpectedCategory(
      actualCategory,
      expectedCategory,
    );

    final actualItems = actualItem.items;
    final expectedItems = expectedItem.items;
    _areExpectedItems(actualItems, expectedItems);

    return isExpectedCategory;
  }

  bool _isExpectedCategory(ItemCategoryViewModel actualCategory, ItemCategoryViewModel expectedCategory) {
    return actualCategory.name == expectedCategory.name;
  }

  void _areExpectedItems(List<T> actualItems, List<T> expectedItems) {
    if (actualItems is List<ItemTemplateViewModel>) {
      _assertItemTemplates(actualItems as List<ItemTemplateViewModel>, expectedItems as List<ItemTemplateViewModel>);
    } else if (actualItems is List<BasketItemViewModel>) {
      _assertBasketItem(actualItems as List<BasketItemViewModel>, expectedItems as List<BasketItemViewModel>);
    }
  }

  void _assertItemTemplates(List<ItemTemplateViewModel> actualItems, List<ItemTemplateViewModel> expectedItems) {
    for (final (index, actualItem) in actualItems.indexed) {
      final expectedItem = expectedItems.elementAt(index);

      expect(actualItem, IsEqualToItemTemplate(expectedItem));
    }
  }

  void _assertBasketItem(List<BasketItemViewModel> actualItems, List<BasketItemViewModel> expectedItems) {
    for (final (index, actualItem) in actualItems.indexed) {
      final expectedItem = expectedItems.elementAt(index);
      expect(actualItem, IsEqualToBasketItem(expectedItem));
    }
  }
}
