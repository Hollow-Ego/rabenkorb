import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_sub_category_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/shared/extensions.dart';

class BasketItemViewModel extends DataItem {
  final int id;
  final String name;
  final String? imagePath;
  final String? note;
  final double amount;
  final ItemCategoryViewModel? category;
  final ItemSubCategoryViewModel? subCategory;
  final ShoppingBasketViewModel basket;
  final ItemUnitViewModel? unit;
  final bool isChecked;

  @override
  String get key => "${name.toLowerSpaceless()}-$id";

  BasketItemViewModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.note,
    required this.amount,
    required this.category,
    required this.subCategory,
    required this.basket,
    required this.unit,
    required this.isChecked,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imagePath": imagePath,
      "note": note,
      "amount": amount,
      "category": category,
      "subCategory": subCategory,
      "basket": basket,
      "unit": unit,
      "isChecked": isChecked,
    };
  }
}
