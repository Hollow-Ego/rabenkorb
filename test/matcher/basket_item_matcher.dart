import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';

class IsEqualToBasketItem extends Matcher {
  late final BasketItem expectedItem;

  IsEqualToBasketItem(this.expectedItem);

  @override
  Description describe(Description description) {
    return description.add('BasketItem:<${expectedItem.toString()}>');
  }

  @override
  bool matches(item, Map matchState) {
    final actualItem = item as BasketItem;

    final nameMatches = actualItem.name == expectedItem.name;
    final categoryMatches = actualItem.category == expectedItem.category;
    final imagePathMatches = actualItem.imagePath == expectedItem.imagePath;
    final amountMatches = actualItem.amount == expectedItem.amount;
    final unitMatches = actualItem.unit == expectedItem.unit;
    final basketMatches = actualItem.basket == expectedItem.basket;
    final checkedStateMatches = actualItem.isChecked == expectedItem.isChecked;

    return nameMatches && categoryMatches && imagePathMatches && amountMatches && unitMatches && basketMatches && checkedStateMatches;
  }
}
