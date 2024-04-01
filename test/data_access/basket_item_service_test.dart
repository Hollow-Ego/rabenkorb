import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';
import '../matcher/grouped_items_matcher.dart';

void main() {
  late BasketItemService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
    await seedDatabase(database);
    sut = BasketItemService.withValue(
      basketId: 1,
      sortMode: SortMode.custom,
      sortRuleId: 1,
    );
  });

  test('basket items can be created', () async {
    const name = "Milk";

    final id = await sut.createBasketItem(name, basketId: 1);

    final basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, name);
  });

  test('basket items can be created with all properties', () async {
    const name = "Milk";
    const double amount = 2;
    const categoryId = 1;
    const basketId = 1;
    const imagePath = "/img.png";
    const unitId = 1;

    final id = await sut.createBasketItem(
      name,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: imagePath,
      unitId: unitId,
    );

    final basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, name);
    expect(basketItem?.amount, amount);
    expect(basketItem?.category, categoryId);
    expect(basketItem?.basket, basketId);
    expect(basketItem?.imagePath, imagePath);
    expect(basketItem?.unit, unitId);
  });

  test('basket items can be updated', () async {
    const nameOne = "Milk";
    const nameTwo = "Eggs";
    final id = await sut.createBasketItem(nameOne, basketId: 1);

    var basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, nameOne);

    await sut.updateBasketItem(id, name: nameTwo);

    basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, nameTwo);
  });

  test('basket items can be updated partially', () async {
    const nameOne = "Milk";
    const double amount = 2;
    const categoryId = 1;
    const basketId = 1;
    const imagePath = "/img.png";
    const unitId = 1;

    final id = await sut.createBasketItem(nameOne, basketId: 1);

    var basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, nameOne);

    await sut.updateBasketItem(
      id,
      amount: amount,
      categoryId: categoryId,
      basketId: basketId,
      imagePath: imagePath,
      unitId: unitId,
    );

    basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, nameOne);
    expect(basketItem?.amount, amount);
    expect(basketItem?.category, categoryId);
    expect(basketItem?.basket, basketId);
    expect(basketItem?.imagePath, imagePath);
    expect(basketItem?.unit, unitId);

    const modifiedCategory = 2;
    await sut.updateBasketItem(
      id,
      categoryId: modifiedCategory,
    );

    basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, nameOne);
    expect(basketItem?.amount, amount);
    expect(basketItem?.category, modifiedCategory);
    expect(basketItem?.basket, basketId);
    expect(basketItem?.imagePath, imagePath);
    expect(basketItem?.unit, unitId);
  });

  test('basket items can be deleted', () async {
    const name = "Milk";
    final id = await sut.createBasketItem(name, basketId: 1);
    final basketItem = await sut.getBasketItemById(id);

    expect(basketItem?.name, name);
  });

  test('basket items can be watched in custom order with missing category and order and without empty categories', () async {
    final expectedValues = [
      [
        GroupedItems(
          category: testCategories["Alcohol"]!,
          items: [
            testBasketItemsOne["Rum - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Baking Ingredients"]!,
          items: [
            testBasketItemsOne["Baking Soda - Aldi"]!,
            testBasketItemsOne["Flour - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testBasketItemsOne["Coffee - Aldi"]!,
            testBasketItemsOne["Earl Grey - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Vegan"]!,
          items: [
            testBasketItemsOne["Schnitzel - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItemsOne["Beans - Aldi"]!,
            testBasketItemsOne["Corn - Aldi"]!,
            testBasketItemsOne["Kidney Beans - Aldi"]!,
            testBasketItemsOne["Soup - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: const ItemCategory(id: 0, name: "Without Category"),
          items: [
            testBasketItemsOne["Apple - Aldi"]!,
            testBasketItemsOne["Orange Juice - Aldi"]!,
            testBasketItemsOne["Socks - Aldi"]!,
          ],
        ),
      ],
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem<BasketItem>(emission))),
    );
  });

  test('basket items can be filtered case insensitive and debounced', () async {
    const searchStringOne = "e";
    const searchStringTwo = "ea";
    const searchStringThree = "EANS";
    final expectedValues = [
      [
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testBasketItemsOne["Earl Grey - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItemsOne["Beans - Aldi"]!,
            testBasketItemsOne["Kidney Beans - Aldi"]!,
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItemsOne["Beans - Aldi"]!,
            testBasketItemsOne["Kidney Beans - Aldi"]!,
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategories["Alcohol"]!,
          items: [
            testBasketItemsOne["Rum - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Baking Ingredients"]!,
          items: [
            testBasketItemsOne["Baking Soda - Aldi"]!,
            testBasketItemsOne["Flour - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testBasketItemsOne["Coffee - Aldi"]!,
            testBasketItemsOne["Earl Grey - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Vegan"]!,
          items: [
            testBasketItemsOne["Schnitzel - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItemsOne["Beans - Aldi"]!,
            testBasketItemsOne["Corn - Aldi"]!,
            testBasketItemsOne["Kidney Beans - Aldi"]!,
            testBasketItemsOne["Soup - Aldi"]!,
          ],
        ),
        GroupedItems(
          category: const ItemCategory(id: 0, name: "Without Category"),
          items: [
            testBasketItemsOne["Apple - Aldi"]!,
            testBasketItemsOne["Orange Juice - Aldi"]!,
            testBasketItemsOne["Socks - Aldi"]!,
          ],
        ),
      ]
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem(emission))),
    );

    // Delay creation of new items to ensure emissions are happening one by one
    const delay = Duration(milliseconds: 350);
    sut.setSearchString(searchStringOne);
    sut.setSearchString(searchStringTwo);
    await Future.delayed(delay);
    sut.setSearchString(searchStringThree);
    await Future.delayed(delay);
    sut.setSearchString(null);
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
