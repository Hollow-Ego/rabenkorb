import 'package:drift/drift.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/variant_keys.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';

@DataClassName('ItemTemplate')
class ItemTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get imagePath => text().nullable()();

  IntColumn get variantKey => integer().nullable().references(VariantKeys, #id)();

  IntColumn get category => integer().nullable().references(ItemCategories, #id)();

  IntColumn get library => integer().nullable().references(TemplateLibraries, #id)();
}
