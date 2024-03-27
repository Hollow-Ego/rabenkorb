import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';

Map<String, ItemCategory> testCategories = {
  "Alcohol": const ItemCategory(id: 1, name: "Alcohol"),
  "Vegan": const ItemCategory(id: 2, name: "Vegan"),
  "Hot Drinks": const ItemCategory(id: 3, name: "Hot Drinks"),
  "Canned Food": const ItemCategory(id: 4, name: "Canned Food"),
  "Dry Food": const ItemCategory(id: 5, name: "Dry Food"),
  "Baking Ingredients": const ItemCategory(id: 6, name: "Baking Ingredients"),
  "Unused Category": const ItemCategory(id: 7, name: "Unused Category"),
};

Map<String, ItemUnit> testUnits = {
  "Kg": const ItemUnit(id: 1, name: "Kg"),
  "Liter": const ItemUnit(id: 2, name: "Liter"),
  "Pieces": const ItemUnit(id: 3, name: "Pieces"),
};

Map<String, TemplateLibrary> testLibraries = {
  "Library Test One": const TemplateLibrary(id: 1, name: "Library Test One"),
};

Map<String, VariantKey> testVariantKeys = {
  "Key 1": const VariantKey(id: 1),
  "Key 2": const VariantKey(id: 2),
  "Key 3": const VariantKey(id: 3),
};

Map<String, SortRule> testSortRules = {
  "Aldi": const SortRule(id: 1, name: "Aldi", groupMode: GroupMode.category),
  "Lidl": const SortRule(id: 2, name: "Lidl", groupMode: GroupMode.category),
};

Map<String, ItemTemplate> testItemTemplates = {
  "Coffee": ItemTemplate(
    id: 1,
    name: "Coffee",
    category: testCategories["Hot Drinks"]!.id,
  ),
  "Rum": ItemTemplate(
    id: 2,
    name: "Rum",
    category: testCategories["Alcohol"]!.id,
  ),
  "Schnitzel": ItemTemplate(
    id: 3,
    name: "\"Schnitzel\"",
    category: testCategories["Vegan"]!.id,
  ),
  "Beans": ItemTemplate(
    id: 4,
    name: "Beans",
    category: testCategories["Canned Food"]!.id,
  ),
  "Flour": ItemTemplate(
    id: 5,
    name: "Flour",
    category: testCategories["Baking Ingredients"]!.id,
  ),
  "Apple": const ItemTemplate(id: 6, name: "Apple"),
  "Socks": const ItemTemplate(id: 7, name: "Socks"),
  "Orange Juice": const ItemTemplate(id: 8, name: "Orange Juice"),
  "Soup": ItemTemplate(
    id: 9,
    name: "Soup",
    category: testCategories["Canned Food"]!.id,
  ),
  "Corn": ItemTemplate(
    id: 10,
    name: "Corn",
    category: testCategories["Canned Food"]!.id,
  ),
  "Kidney Beans": ItemTemplate(
    id: 11,
    name: "Kidney Beans",
    category: testCategories["Canned Food"]!.id,
  ),
  "Baking Soda": ItemTemplate(
    id: 12,
    name: "Baking Soda",
    category: testCategories["Baking Ingredients"]!.id,
  ),
  "Earl Grey": ItemTemplate(
    id: 13,
    name: "Earl Grey",
    category: testCategories["Hot Drinks"]!.id,
  ),
};

List<SortOrder> testSortOrdersRuleOne = [
  SortOrder(
      categoryId: testCategories["Alcohol"]!.id,
      sortOrder: 1,
      ruleId: testSortRules["Aldi"]!.id),
  SortOrder(
      categoryId: testCategories["Baking Ingredients"]!.id,
      sortOrder: 2,
      ruleId: testSortRules["Aldi"]!.id),
  SortOrder(
      categoryId: testCategories["Hot Drinks"]!.id,
      sortOrder: 3,
      ruleId: testSortRules["Aldi"]!.id),
];

List<SortOrder> testSortOrdersRuleTwo = [
  SortOrder(
      categoryId: testCategories["Vegan"]!.id,
      sortOrder: 1,
      ruleId: testSortRules["Lidl"]!.id),
  SortOrder(
      categoryId: testCategories["Alcohol"]!.id,
      sortOrder: 2,
      ruleId: testSortRules["Lidl"]!.id),
  SortOrder(
      categoryId: testCategories["Hot Drinks"]!.id,
      sortOrder: 3,
      ruleId: testSortRules["Lidl"]!.id),
  SortOrder(
      categoryId: testCategories["Canned Food"]!.id,
      sortOrder: 6,
      ruleId: testSortRules["Lidl"]!.id),
  SortOrder(
      categoryId: testCategories["Baking Ingredients"]!.id,
      sortOrder: 8,
      ruleId: testSortRules["Lidl"]!.id),
  SortOrder(
      categoryId: testCategories["Dry Food"]!.id,
      sortOrder: 10,
      ruleId: testSortRules["Lidl"]!.id),
];

Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((batch) {
    batch.insertAll(db.itemCategories, testCategories.values);
    batch.insertAll(db.itemUnits, testUnits.values);
    batch.insertAll(db.templateLibraries, testLibraries.values);
    batch.insertAll(db.variantKeys, testVariantKeys.values);
    batch.insertAll(db.sortRules, testSortRules.values);
    batch.insertAll(db.sortOrders, testSortOrdersRuleOne);
    batch.insertAll(db.sortOrders, testSortOrdersRuleTwo);
    batch.insertAll(db.itemTemplates, testItemTemplates.values);
  });
}
