import 'package:drift/drift.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/item_units.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';

@DataClassName('BasketItem')
class BasketItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get imagePath => text().nullable()();

  RealColumn get amount => real()();

  IntColumn get category => integer().nullable().references(ItemCategories, #id)();

  IntColumn get basket => integer().references(ShoppingBaskets, #id)();

  IntColumn get unit => integer().nullable().references(ItemUnits, #id)();

  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
}
