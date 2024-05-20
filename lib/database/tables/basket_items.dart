import 'package:drift/drift.dart';
import 'package:rabenkorb/database/constants.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/item_units.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';

@DataClassName('BasketItem')
class BasketItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: maxNameLength)();

  TextColumn get imagePath => text().nullable()();

  RealColumn get amount => real()();

  IntColumn get category => integer().nullable().references(ItemCategories, #id, onDelete: KeyAction.setNull)();

  IntColumn get basket => integer().references(ShoppingBaskets, #id, onDelete: KeyAction.cascade)();

  IntColumn get unit => integer().nullable().references(ItemUnits, #id, onDelete: KeyAction.setNull)();

  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
}
