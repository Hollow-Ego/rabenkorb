import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';

class IsGroupedItem extends Matcher {
  final List<GroupedItems> expectedItems;
  int mismatchedItemIndex = -1;
  int mismatchedItemTemplateIndex = -1;

  IsGroupedItem(this.expectedItems);

  @override
  Description describe(Description description) {
    return description.add("GroupedItem matches");
  }

  @override
  bool matches(item, Map matchState) {
    final actualItems = item as List<GroupedItems>;

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
    final actualItems = item as List<GroupedItems>;

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
      mismatchDescription.add(
          'expected to have category "$expectedCategory" but got "$actualCategory"\n');
    }

    if (mismatchedItemTemplateIndex >= 0) {
      final actualItemTemplate =
          actualItem.items.elementAt(mismatchedItemTemplateIndex);
      final expectedItemTemplate =
          expectedItem.items.elementAt(mismatchedItemTemplateIndex);

      mismatchDescription
          .add("actual item templates\n${actualItem.items.toString()}\n");

      mismatchDescription
          .add("expected item templates\n${expectedItem.items.toString()}\n");

      mismatchDescription
          .add("item template at index $mismatchedItemTemplateIndex\n");
      mismatchDescription.add(
          'expected to be\n"${expectedItemTemplate.toJson()}"\nbut got\n"${actualItemTemplate.toJson()}"\n');
    }
    return mismatchDescription;
  }

  bool _isExpectedGroupedItems(
    GroupedItems actualItem,
    GroupedItems expectedItem,
  ) {
    final actualCategory = actualItem.category;
    final expectedCategory = expectedItem.category;
    final isExpectedCategory = _isExpectedCategory(
      actualCategory,
      expectedCategory,
    );

    final actualItems = actualItem.items;
    final expectedItems = expectedItem.items;
    final areExpectedItems = _areExpectedItems(actualItems, expectedItems);

    return isExpectedCategory && areExpectedItems;
  }

  bool _isExpectedCategory(
    ItemCategory actualCategory,
    ItemCategory expectedCategory,
  ) {
    return actualCategory.name == expectedCategory.name;
  }

  bool _areExpectedItems(
    List<ItemTemplate> actualItems,
    List<ItemTemplate> expectedItems,
  ) {
    for (final (index, actualItem) in actualItems.indexed) {
      final expectedItem = expectedItems.elementAt(index);

      final nameMatches = actualItem.name == expectedItem.name;
      final categoryMatches = actualItem.category == expectedItem.category;
      final variantMatches = actualItem.variantKey == expectedItem.variantKey;
      final imagePathMatches = actualItem.imagePath == expectedItem.imagePath;

      if (!(nameMatches &&
          categoryMatches &&
          variantMatches &&
          imagePathMatches)) {
        mismatchedItemTemplateIndex = index;
        break;
      }
    }
    return mismatchedItemTemplateIndex < 0;
  }
}
