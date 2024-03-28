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
  "Cans": const ItemUnit(id: 4, name: "Cans"),
};

Map<String, TemplateLibrary> testLibraries = {
  "Library Test One": const TemplateLibrary(id: 1, name: "Library Test One"),
};

Map<String, ShoppingBasket> testBaskets = {
  "Lidl": const ShoppingBasket(id: 1, name: "Lidl", useAsGroup: false),
  "Aldi": const ShoppingBasket(id: 2, name: "Aldi", useAsGroup: false),
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
    library: 1,
  ),
  "Rum": ItemTemplate(
    id: 2,
    name: "Rum",
    category: testCategories["Alcohol"]!.id,
    library: 1,
  ),
  "Schnitzel": ItemTemplate(
    id: 3,
    name: "\"Schnitzel\"",
    category: testCategories["Vegan"]!.id,
    library: 1,
  ),
  "Beans": ItemTemplate(
    id: 4,
    name: "Beans",
    category: testCategories["Canned Food"]!.id,
    library: 1,
  ),
  "Flour": ItemTemplate(
    id: 5,
    name: "Flour",
    category: testCategories["Baking Ingredients"]!.id,
    library: 1,
  ),
  "Apple": const ItemTemplate(
    id: 6,
    name: "Apple",
    library: 1,
  ),
  "Socks": const ItemTemplate(
    id: 7,
    name: "Socks",
    library: 1,
  ),
  "Orange Juice": const ItemTemplate(
    id: 8,
    name: "Orange Juice",
    library: 1,
  ),
  "Soup": ItemTemplate(
    id: 9,
    name: "Soup",
    category: testCategories["Canned Food"]!.id,
    library: 1,
  ),
  "Corn": ItemTemplate(
    id: 10,
    name: "Corn",
    category: testCategories["Canned Food"]!.id,
    library: 1,
  ),
  "Kidney Beans": ItemTemplate(
    id: 11,
    name: "Kidney Beans",
    category: testCategories["Canned Food"]!.id,
    library: 1,
  ),
  "Baking Soda": ItemTemplate(
    id: 12,
    name: "Baking Soda",
    category: testCategories["Baking Ingredients"]!.id,
    library: 1,
  ),
  "Earl Grey": ItemTemplate(
    id: 13,
    name: "Earl Grey",
    category: testCategories["Hot Drinks"]!.id,
    library: 1,
  ),
};

Map<String, BasketItem> testBasketItems = {
  "Coffee": BasketItem(
    id: 1,
    name: "Coffee",
    category: testCategories["Hot Drinks"]!.id,
    amount: 0,
    basket: testBaskets["Aldi"]!.id,
  ),
  "Rum": BasketItem(
    id: 2,
    name: "Rum",
    category: testCategories["Alcohol"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
  ),
  "Schnitzel": BasketItem(
    id: 3,
    name: "\"Schnitzel\"",
    category: testCategories["Vegan"]!.id,
    amount: 0,
    basket: testBaskets["Lidl"]!.id,
  ),
  "Beans": BasketItem(
    id: 4,
    name: "Beans",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    unit: testUnits["Cans"]!.id,
    basket: testBaskets["Lidl"]!.id,
  ),
  "Flour": BasketItem(
    id: 5,
    name: "Flour",
    category: testCategories["Baking Ingredients"]!.id,
    amount: 1,
    basket: testBaskets["Lidl"]!.id,
  ),
  "Apple": BasketItem(
    id: 6,
    name: "Apple",
    amount: 0,
    unit: testUnits["Pieces"]!.id,
    basket: testBaskets["Aldi"]!.id,
  ),
  "Socks": BasketItem(
    id: 7,
    name: "Socks",
    amount: 0,
    basket: testBaskets["Lidl"]!.id,
  ),
  "Orange Juice": BasketItem(
    id: 8,
    name: "Orange Juice",
    amount: 1.5,
    unit: testUnits["Liter"]!.id,
    basket: testBaskets["Lidl"]!.id,
  ),
  "Soup": BasketItem(
    id: 9,
    name: "Soup",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
  ),
  "Corn": BasketItem(
    id: 10,
    name: "Corn",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Lidl"]!.id,
  ),
  "Kidney Beans": BasketItem(
    id: 11,
    name: "Kidney Beans",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Lidl"]!.id,
  ),
  "Baking Soda": BasketItem(
    id: 12,
    name: "Baking Soda",
    category: testCategories["Baking Ingredients"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
  ),
  "Earl Grey": BasketItem(
    id: 13,
    name: "Earl Grey",
    category: testCategories["Hot Drinks"]!.id,
    amount: 0,
    basket: testBaskets["Aldi"]!.id,
  ),
};

List<SortOrder> testSortOrdersRuleOne = [
  SortOrder(categoryId: testCategories["Alcohol"]!.id, sortOrder: 1, ruleId: testSortRules["Aldi"]!.id),
  SortOrder(categoryId: testCategories["Baking Ingredients"]!.id, sortOrder: 2, ruleId: testSortRules["Aldi"]!.id),
  SortOrder(categoryId: testCategories["Hot Drinks"]!.id, sortOrder: 3, ruleId: testSortRules["Aldi"]!.id),
];

List<SortOrder> testSortOrdersRuleTwo = [
  SortOrder(categoryId: testCategories["Vegan"]!.id, sortOrder: 1, ruleId: testSortRules["Lidl"]!.id),
  SortOrder(categoryId: testCategories["Alcohol"]!.id, sortOrder: 2, ruleId: testSortRules["Lidl"]!.id),
  SortOrder(categoryId: testCategories["Hot Drinks"]!.id, sortOrder: 3, ruleId: testSortRules["Lidl"]!.id),
  SortOrder(categoryId: testCategories["Canned Food"]!.id, sortOrder: 6, ruleId: testSortRules["Lidl"]!.id),
  SortOrder(categoryId: testCategories["Baking Ingredients"]!.id, sortOrder: 8, ruleId: testSortRules["Lidl"]!.id),
  SortOrder(categoryId: testCategories["Dry Food"]!.id, sortOrder: 10, ruleId: testSortRules["Lidl"]!.id),
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
    batch.insertAll(db.shoppingBaskets, testBaskets.values);
    batch.insertAll(db.itemTemplates, testItemTemplates.values);
    batch.insertAll(db.basketItems, testBasketItems.values);
  });
}
