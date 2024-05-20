import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';

Map<String, ItemCategory> testCategories = {
  "Alcohol": const ItemCategory(id: 1, name: "Alcohol"),
  "Vegan": const ItemCategory(id: 2, name: "Vegan"),
  "Hot Drinks": const ItemCategory(id: 3, name: "Hot Drinks"),
  "Canned Food": const ItemCategory(id: 4, name: "Canned Food"),
  "Dry Food": const ItemCategory(id: 5, name: "Dry Food"),
  "Baking Ingredients": const ItemCategory(id: 6, name: "Baking Ingredients"),
  "Unused Category": const ItemCategory(id: 7, name: "Unused Category"),
  "Frozen Food": const ItemCategory(id: 8, name: "Frozen Food"),
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
  "Aldi": const ShoppingBasket(id: 1, name: "Aldi"),
  "Lidl": const ShoppingBasket(id: 2, name: "Lidl"),
};

Map<String, SortRule> testSortRules = {
  "Aldi": const SortRule(id: 1, name: "Aldi"),
  "Lidl": const SortRule(id: 2, name: "Lidl"),
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
  "Peas - Canned": ItemTemplate(
    id: 14,
    name: "Peas",
    category: testCategories["Canned Food"]!.id,
    library: 1,
  ),
  "Peas - Frozen": ItemTemplate(
    id: 15,
    name: "Peas",
    category: testCategories["Frozen Food"]!.id,
    library: 1,
  ),
};

Map<String, BasketItem> testBasketItemsOne = {
  "Coffee - Aldi": BasketItem(
    id: 1,
    name: "Coffee",
    category: testCategories["Hot Drinks"]!.id,
    note: "Beans",
    amount: 0,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Rum - Aldi": BasketItem(
    id: 2,
    name: "Rum",
    category: testCategories["Alcohol"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Apple - Aldi": BasketItem(
    id: 6,
    name: "Apple",
    note: "Braeburn",
    amount: 0,
    unit: testUnits["Pieces"]!.id,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Soup - Aldi": BasketItem(
    id: 9,
    name: "Soup",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Baking Soda - Aldi": BasketItem(
    id: 12,
    name: "Baking Soda",
    category: testCategories["Baking Ingredients"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Earl Grey - Aldi": BasketItem(
    id: 13,
    name: "Earl Grey",
    category: testCategories["Hot Drinks"]!.id,
    amount: 0,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Beans - Aldi": BasketItem(
    id: 14,
    name: "Beans",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    unit: testUnits["Cans"]!.id,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Flour - Aldi": BasketItem(
    id: 15,
    name: "Flour",
    category: testCategories["Baking Ingredients"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Schnitzel - Aldi": BasketItem(
    id: 16,
    name: "\"Schnitzel\"",
    category: testCategories["Vegan"]!.id,
    amount: 0,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Socks - Aldi": BasketItem(
    id: 17,
    name: "Socks",
    amount: 0,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Orange Juice - Aldi": BasketItem(
    id: 18,
    name: "Orange Juice",
    amount: 1.5,
    unit: testUnits["Liter"]!.id,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Corn - Aldi": BasketItem(
    id: 19,
    name: "Corn",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
  "Kidney Beans - Aldi": BasketItem(
    id: 20,
    name: "Kidney Beans",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Aldi"]!.id,
    isChecked: false,
  ),
};

Map<String, BasketItem> testBasketItemsTwo = {
  "Schnitzel - Lidl": BasketItem(
    id: 3,
    name: "\"Schnitzel\"",
    category: testCategories["Vegan"]!.id,
    amount: 0,
    basket: testBaskets["Lidl"]!.id,
    isChecked: false,
  ),
  "Beans - Lidl": BasketItem(
    id: 4,
    name: "Beans",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    unit: testUnits["Cans"]!.id,
    basket: testBaskets["Lidl"]!.id,
    isChecked: false,
  ),
  "Flour - Lidl": BasketItem(
    id: 5,
    name: "Flour",
    category: testCategories["Baking Ingredients"]!.id,
    amount: 1,
    basket: testBaskets["Lidl"]!.id,
    isChecked: false,
  ),
  "Socks - Lidl": BasketItem(
    id: 7,
    name: "Socks",
    amount: 0,
    basket: testBaskets["Lidl"]!.id,
    isChecked: false,
  ),
  "Orange Juice - Lidl": BasketItem(
    id: 8,
    name: "Orange Juice",
    amount: 1.5,
    unit: testUnits["Liter"]!.id,
    basket: testBaskets["Lidl"]!.id,
    isChecked: false,
  ),
  "Corn - Lidl": BasketItem(
    id: 10,
    name: "Corn",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Lidl"]!.id,
    isChecked: false,
  ),
  "Kidney Beans - Lidl": BasketItem(
    id: 11,
    name: "Kidney Beans",
    category: testCategories["Canned Food"]!.id,
    amount: 1,
    basket: testBaskets["Lidl"]!.id,
    isChecked: false,
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
    batch.insertAll(db.sortRules, testSortRules.values);
    batch.insertAll(db.sortOrders, testSortOrdersRuleOne);
    batch.insertAll(db.sortOrders, testSortOrdersRuleTwo);
    batch.insertAll(db.shoppingBaskets, testBaskets.values);
    batch.insertAll(db.itemTemplates, testItemTemplates.values);
    batch.insertAll(db.basketItems, testBasketItemsOne.values);
    batch.insertAll(db.basketItems, testBasketItemsTwo.values);
  });
}

Future<void> clearDatabase(AppDatabase db) async {
  await db.batch((batch) {
    batch.deleteAll(db.itemCategories);
    batch.deleteAll(db.itemUnits);
    batch.deleteAll(db.templateLibraries);
    batch.deleteAll(db.sortRules);
    batch.deleteAll(db.sortOrders);
    batch.deleteAll(db.sortOrders);
    batch.deleteAll(db.shoppingBaskets);
    batch.deleteAll(db.itemTemplates);
    batch.deleteAll(db.basketItems);
    batch.deleteAll(db.basketItems);
  });
}

ItemCategoryViewModel testCategory(String key) {
  return toItemCategoryViewModel(testCategories[key])!;
}

ItemUnitViewModel testUnit(String key) {
  return toItemUnitViewModel(testUnits[key])!;
}

TemplateLibraryViewModel testLibrary(String key) {
  return toTemplateLibraryViewModel(testLibraries[key])!;
}

ShoppingBasketViewModel testBasket(String key) {
  return toShoppingBasketViewModel(testBaskets[key])!;
}

SortRuleViewModel testSortRule(String key) {
  return toSortRuleViewModel(testSortRules[key])!;
}

ItemTemplateViewModel testItemTemplate(String key) {
  final item = testItemTemplates[key]!;
  final category = item.category != null ? testCategories.values.firstWhere((c) => c.id == item.category) : null;
  final library = testLibraries.values.firstWhere((c) => c.id == item.library);
  return toItemTemplateViewModel(item, category, library);
}

BasketItemViewModel testBasketItem(String key, String basketName) {
  var item = basketName == "Aldi" ? testBasketItemsOne[key]! : testBasketItemsTwo[key]!;
  var category = item.category != null ? testCategories.values.firstWhere((c) => c.id == item.category) : null;
  var basket = testBaskets.values.firstWhere((c) => c.id == item.basket);
  var unit = item.unit != null ? testUnits.values.firstWhere((c) => c.id == item.unit) : null;

  return toBasketItemViewModel(item, category, basket, unit);
}
