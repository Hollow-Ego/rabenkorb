import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';

import 'basket_item_matcher.dart';
import 'item_template_matcher.dart';

class IsEqualToGroupedItem<T extends DataClass> extends Matcher {
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

  bool _isExpectedCategory(ItemCategory actualCategory, ItemCategory expectedCategory) {
    return actualCategory.name == expectedCategory.name;
  }

  void _areExpectedItems(List<T> actualItems, List<T> expectedItems) {
    if (actualItems is List<ItemTemplate>) {
      _assertItemTemplates(actualItems as List<ItemTemplate>, expectedItems as List<ItemTemplate>);
    } else if (actualItems is List<BasketItem>) {
      _assertBasketItem(actualItems as List<BasketItem>, expectedItems as List<BasketItem>);
    }
  }

  void _assertItemTemplates(List<ItemTemplate> actualItems, List<ItemTemplate> expectedItems) {
    for (final (index, actualItem) in actualItems.indexed) {
      final expectedItem = expectedItems.elementAt(index);

      expect(actualItem, IsEqualToItemTemplate(expectedItem));
    }
  }

  void _assertBasketItem(List<BasketItem> actualItems, List<BasketItem> expectedItems) {
    for (final (index, actualItem) in actualItems.indexed) {
      final expectedItem = expectedItems.elementAt(index);
      expect(actualItem, IsEqualToBasketItem(expectedItem));
    }
  }
}
