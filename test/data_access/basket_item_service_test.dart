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
            testBasketItems["Rum"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Baking Ingredients"]!,
          items: [
            testBasketItems["Baking Soda"]!,
            testBasketItems["Flour"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testBasketItems["Coffee"]!,
            testBasketItems["Earl Grey"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Vegan"]!,
          items: [
            testBasketItems["Schnitzel"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItems["Beans"]!,
            testBasketItems["Corn"]!,
            testBasketItems["Kidney Beans"]!,
            testBasketItems["Soup"]!,
          ],
        ),
        GroupedItems(
          category: const ItemCategory(id: 0, name: "Without Category"),
          items: [
            testBasketItems["Apple"]!,
            testBasketItems["Orange Juice"]!,
            testBasketItems["Socks"]!,
          ],
        ),
      ],
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsGroupedItem<BasketItem>(emission))),
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
            testBasketItems["Earl Grey"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItems["Beans"]!,
            testBasketItems["Kidney Beans"]!,
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItems["Beans"]!,
            testBasketItems["Kidney Beans"]!,
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategories["Alcohol"]!,
          items: [
            testBasketItems["Rum"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Baking Ingredients"]!,
          items: [
            testBasketItems["Baking Soda"]!,
            testBasketItems["Flour"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testBasketItems["Coffee"]!,
            testBasketItems["Earl Grey"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Vegan"]!,
          items: [
            testBasketItems["Schnitzel"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testBasketItems["Beans"]!,
            testBasketItems["Corn"]!,
            testBasketItems["Kidney Beans"]!,
            testBasketItems["Soup"]!,
          ],
        ),
        GroupedItems(
          category: const ItemCategory(id: 0, name: "Without Category"),
          items: [
            testBasketItems["Apple"]!,
            testBasketItems["Orange Juice"]!,
            testBasketItems["Socks"]!,
          ],
        ),
      ]
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsGroupedItem(emission))),
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
