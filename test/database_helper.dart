import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';

List<ItemCategoriesCompanion> testCategories = [
  const ItemCategoriesCompanion(id: Value(1), name: Value("Category Test One")),
  const ItemCategoriesCompanion(id: Value(2), name: Value("Category Test Two")),
  const ItemCategoriesCompanion(
      id: Value(3), name: Value("Category Test Three")),
  const ItemCategoriesCompanion(
      id: Value(4), name: Value("Category Test Four")),
  const ItemCategoriesCompanion(
      id: Value(5), name: Value("Category Test Five")),
  const ItemCategoriesCompanion(id: Value(6), name: Value("Category Test Six")),
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

List<SortRulesCompanion> testSortRules = [
  const SortRulesCompanion(
    id: Value(1),
    name: Value("Aldi"),
    groupMode: Value(GroupMode.category),
  ),
  const SortRulesCompanion(
    id: Value(2),
    name: Value("Lidl"),
    groupMode: Value(GroupMode.category),
  ),
];

List<SortOrdersCompanion> testSortOrdersRuleOne = [
  const SortOrdersCompanion(
    categoryId: Value(1), // Category Test One
    sortOrder: Value(1),
    ruleId: Value(1),
  ),
  const SortOrdersCompanion(
    categoryId: Value(6), // Category Test Six
    sortOrder: Value(2),
    ruleId: Value(1),
  ),
  const SortOrdersCompanion(
    categoryId: Value(3), // Category Test Three
    sortOrder: Value(3),
    ruleId: Value(1),
  ),
];

List<SortOrdersCompanion> testSortOrdersRuleTwo = [
  const SortOrdersCompanion(
    categoryId: Value(2), // Category Test Two
    sortOrder: Value(1),
    ruleId: Value(2),
  ),
  const SortOrdersCompanion(
    categoryId: Value(1), // Category Test One
    sortOrder: Value(2),
    ruleId: Value(2),
  ),
  const SortOrdersCompanion(
    categoryId: Value(3), // Category Test Three
    sortOrder: Value(3),
    ruleId: Value(2),
  ),
  const SortOrdersCompanion(
    categoryId: Value(4), // Category Test Four
    sortOrder: Value(6),
    ruleId: Value(2),
  ),
  const SortOrdersCompanion(
    categoryId: Value(6), // Category Test Six
    sortOrder: Value(8),
    ruleId: Value(2),
  ),
  const SortOrdersCompanion(
    categoryId: Value(5), // Category Test Five
    sortOrder: Value(10),
    ruleId: Value(2),
  ),
];

Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((batch) {
    batch.insertAll(db.itemCategories, testCategories);
    batch.insertAll(db.itemUnits, testUnits);
    batch.insertAll(db.templateLibraries, testLibraries);
    batch.insertAll(db.variantKeys, testVariantKeys);
    batch.insertAll(db.sortRules, testSortRules);
    batch.insertAll(db.sortOrders, testSortOrdersRuleOne);
    batch.insertAll(db.sortOrders, testSortOrdersRuleTwo);
  });
}
