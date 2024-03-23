import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';

List<ItemCategoriesCompanion> testCategories = [
  const ItemCategoriesCompanion(id: Value(1), name: Value("Category Test One")),
  const ItemCategoriesCompanion(id: Value(2), name: Value("Category Test Two")),
  const ItemCategoriesCompanion(
      id: Value(3), name: Value("Category Test Three")),
];

List<ItemUnitsCompanion> testUnits = [
  const ItemUnitsCompanion(id: Value(1), name: Value("Unit Test One")),
  const ItemUnitsCompanion(id: Value(2), name: Value("Unit Test Two")),
  const ItemUnitsCompanion(id: Value(3), name: Value("Unit Test Three")),
];

List<TemplateLibrariesCompanion> testLibraries = [
  const TemplateLibrariesCompanion(
      id: Value(1), name: Value("Library Test One")),
];

List<VariantKeysCompanion> testVariantKeys = [
  const VariantKeysCompanion(id: Value(1)),
  const VariantKeysCompanion(id: Value(2)),
  const VariantKeysCompanion(id: Value(3)),
];

Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((batch) {
    batch.insertAll(db.itemCategories, testCategories);
    batch.insertAll(db.itemUnits, testUnits);
    batch.insertAll(db.templateLibraries, testLibraries);
    batch.insertAll(db.variantKeys, testVariantKeys);
  });
}
