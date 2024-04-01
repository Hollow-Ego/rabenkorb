import 'package:drift/drift.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';
import 'package:rabenkorb/database/tables/variant_keys.dart';

@DataClassName('ItemTemplate')
class ItemTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  TextColumn get imagePath => text().nullable()();

  IntColumn get variantKey => integer().nullable().references(VariantKeys, #id, onDelete: KeyAction.setNull)();

  IntColumn get category => integer().nullable().references(ItemCategories, #id, onDelete: KeyAction.setNull)();

  IntColumn get library => integer().references(TemplateLibraries, #id, onDelete: KeyAction.cascade)();
}
