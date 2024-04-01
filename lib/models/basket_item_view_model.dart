import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';

class BasketItemViewModel {
  final int id;
  final String name;
  final String? imagePath;
  final double amount;
  final ItemCategoryViewModel? category;
  final ShoppingBasketViewModel basket;
  final ItemUnitViewModel? unit;
  final bool isChecked;

  BasketItemViewModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.amount,
    required this.category,
    required this.basket,
    required this.unit,
    required this.isChecked,
  });
}
