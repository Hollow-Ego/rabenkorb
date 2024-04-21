import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';

class IsEqualToBasketItem extends Matcher {
  late final BasketItemViewModel expectedItem;

  IsEqualToBasketItem(this.expectedItem);

  @override
  Description describe(Description description) {
    return description.add('BasketItemViewModel:<${expectedItem.toString()}>');
  }

  @override
  bool matches(item, Map matchState) {
    final actualItem = item as BasketItemViewModel;

    final nameMatches = actualItem.name == expectedItem.name;
    final categoryMatches = actualItem.category?.id == expectedItem.category?.id;
    final imagePathMatches = actualItem.imagePath == expectedItem.imagePath;
    final amountMatches = actualItem.amount == expectedItem.amount;
    final unitMatches = actualItem.unit?.id == expectedItem.unit?.id;
    final basketMatches = actualItem.basket.name == expectedItem.basket.name;
    final checkedStateMatches = actualItem.isChecked == expectedItem.isChecked;

    return nameMatches && categoryMatches && imagePathMatches && amountMatches && unitMatches && basketMatches && checkedStateMatches;
  }
}
