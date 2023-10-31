import 'package:drift/drift.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/item_units.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';
import 'package:rabenkorb/database/tables/variant_keys.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';

@DataClassName('Item')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get imagePath => text().nullable()();

  RealColumn get amount => real()();
  IntColumn get variantKey => integer().nullable().references(VariantKeys, #id)();

  IntColumn get category => integer().nullable().references(ItemCategories, #id)();

  IntColumn get basket => integer().nullable().references(ShoppingBaskets, #id)();

  IntColumn get unit => integer().nullable().references(ItemUnits, #id)();
}
