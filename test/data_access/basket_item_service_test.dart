import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/abstracts/PreferenceService.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';
import '../matcher/grouped_items_matcher.dart';
import '../mock_preferences_service.dart';

void main() {
  late BasketItemService sut;
  late AppDatabase database;
  late BasketStateService basketStateService;

  setUp(() async {
    di.registerSingleton<PreferenceService>(MockPreferenceService());
    basketStateService = BasketStateService.withValue(
      basketId: 1,
      sortMode: SortMode.custom,
      sortRuleId: 1,
    );
    di.registerSingleton<BasketStateService>(basketStateService);

    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);

    await seedDatabase(database);
    sut = BasketItemService();
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
    expect(basketItem?.category?.id, categoryId);
    expect(basketItem?.basket.id, basketId);
    expect(basketItem?.imagePath, imagePath);
    expect(basketItem?.unit?.id, unitId);
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
    expect(basketItem?.isChecked, false);

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
    expect(basketItem?.category?.id, categoryId);
    expect(basketItem?.basket.id, basketId);
    expect(basketItem?.imagePath, imagePath);
    expect(basketItem?.unit?.id, unitId);

    const modifiedCategory = 2;
    const checkedState = true;
    await sut.updateBasketItem(
      id,
      categoryId: modifiedCategory,
      isChecked: checkedState,
    );

    basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, nameOne);
    expect(basketItem?.amount, amount);
    expect(basketItem?.category?.id, modifiedCategory);
    expect(basketItem?.basket.id, basketId);
    expect(basketItem?.imagePath, imagePath);
    expect(basketItem?.unit?.id, unitId);
    expect(basketItem?.isChecked, checkedState);
  });

  test('all optional properties can be removed', () async {
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

    var basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, name);
    expect(basketItem?.amount, amount);
    expect(basketItem?.category?.id, categoryId);
    expect(basketItem?.basket.id, basketId);
    expect(basketItem?.imagePath, imagePath);
    expect(basketItem?.unit?.id, unitId);

    await sut.replaceBasketItem(id, name: name, basketId: basketId);

    basketItem = await sut.getBasketItemById(id);
    expect(basketItem?.name, name);
    expect(basketItem?.amount, 0);
    expect(basketItem?.category?.id, null);
    expect(basketItem?.basket.id, basketId);
    expect(basketItem?.imagePath, null);
    expect(basketItem?.unit?.id, null);
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
          category: testCategory("Alcohol"),
          items: [
            testBasketItem("Rum - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testBasketItem("Baking Soda - Aldi", "Aldi"),
            testBasketItem("Flour - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Coffee - Aldi", "Aldi"),
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testBasketItem("Schnitzel - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Corn - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
            testBasketItem("Soup - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testBasketItem("Apple - Aldi", "Aldi"),
            testBasketItem("Orange Juice - Aldi", "Aldi"),
            testBasketItem("Socks - Aldi", "Aldi"),
          ],
        ),
      ],
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem<BasketItemViewModel>(emission))),
    );
  });

  test('basket items can be filtered case insensitive and debounced', () async {
    const searchStringOne = "e";
    const searchStringTwo = "ea";
    const searchStringThree = "EANS";
    final expectedValues = [
      [
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategory("Alcohol"),
          items: [
            testBasketItem("Rum - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testBasketItem("Baking Soda - Aldi", "Aldi"),
            testBasketItem("Flour - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Coffee - Aldi", "Aldi"),
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testBasketItem("Schnitzel - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Corn - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
            testBasketItem("Soup - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testBasketItem("Apple - Aldi", "Aldi"),
            testBasketItem("Orange Juice - Aldi", "Aldi"),
            testBasketItem("Socks - Aldi", "Aldi"),
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
    basketStateService.setSearchString(searchStringOne);
    basketStateService.setSearchString(searchStringTwo);
    await Future.delayed(delay);
    basketStateService.setSearchString(searchStringThree);
    await Future.delayed(delay);
    basketStateService.setSearchString(null);
  });

  test('basket items can be moved to a different basket', () async {
    final expectedValues = [
      [
        GroupedItems(
          category: testCategory("Alcohol"),
          items: [
            testBasketItem("Rum - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testBasketItem("Baking Soda - Aldi", "Aldi"),
            testBasketItem("Flour - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Coffee - Aldi", "Aldi"),
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testBasketItem("Schnitzel - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Corn - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
            testBasketItem("Soup - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testBasketItem("Apple - Aldi", "Aldi"),
            testBasketItem("Orange Juice - Aldi", "Aldi"),
            testBasketItem("Socks - Aldi", "Aldi"),
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategory("Alcohol"),
          items: [
            testBasketItem("Rum - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testBasketItem("Baking Soda - Aldi", "Aldi"),
            testBasketItem("Flour - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testBasketItem("Schnitzel - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Corn - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
            testBasketItem("Soup - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testBasketItem("Apple - Aldi", "Aldi"),
            testBasketItem("Orange Juice - Aldi", "Aldi"),
            testBasketItem("Socks - Aldi", "Aldi"),
          ],
        ),
      ],
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem<BasketItemViewModel>(emission))),
    );
    const delay = Duration(milliseconds: 350);
    await Future.delayed(delay);
    final itemToMove = testBasketItem("Coffee - Aldi", "Aldi");
    sut.updateBasketItem(itemToMove.id, basketId: testBaskets["Lidl"]!.id);
  });

  test('checked basket items can be removed from a basket', () async {
    final expectedValues = [
      [
        GroupedItems(
          category: testCategory("Alcohol"),
          items: [
            testBasketItem("Rum - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testBasketItem("Baking Soda - Aldi", "Aldi"),
            testBasketItem("Flour - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Coffee - Aldi", "Aldi"),
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testBasketItem("Schnitzel - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Corn - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
            testBasketItem("Soup - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testBasketItem("Apple - Aldi", "Aldi"),
            testBasketItem("Orange Juice - Aldi", "Aldi"),
            testBasketItem("Socks - Aldi", "Aldi"),
          ],
        ),
      ],
      [
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Coffee - Aldi", "Aldi"),
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testBasketItem("Schnitzel - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Soup - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testBasketItem("Apple - Aldi", "Aldi"),
            testBasketItem("Orange Juice - Aldi", "Aldi"),
            testBasketItem("Socks - Aldi", "Aldi"),
          ],
        ),
      ],
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem<BasketItemViewModel>(emission))),
    );
    const delay = Duration(milliseconds: 350);
    await Future.delayed(delay);

    final rum = testBasketItem("Rum - Aldi", "Aldi");
    final baking = testBasketItem("Baking Soda - Aldi", "Aldi");
    final flour = testBasketItem("Flour - Aldi", "Aldi");
    final corn = testBasketItem("Corn - Aldi", "Aldi");
    final kidneyBeans = testBasketItem("Kidney Beans - Aldi", "Aldi");

    sut.updateBasketItem(rum.id, isChecked: true);
    sut.updateBasketItem(baking.id, isChecked: true);
    sut.updateBasketItem(flour.id, isChecked: true);
    sut.updateBasketItem(corn.id, isChecked: true);
    sut.updateBasketItem(kidneyBeans.id, isChecked: true);

    sut.removeCheckedItemsFromBasket(testBaskets["Aldi"]!.id);
  });

  test('all basket items can be removed from a basket', () async {
    final List<List<GroupedItems<BasketItemViewModel>>> expectedValues = [
      [
        GroupedItems(
          category: testCategory("Alcohol"),
          items: [
            testBasketItem("Rum - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testBasketItem("Baking Soda - Aldi", "Aldi"),
            testBasketItem("Flour - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testBasketItem("Coffee - Aldi", "Aldi"),
            testBasketItem("Earl Grey - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testBasketItem("Schnitzel - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testBasketItem("Beans - Aldi", "Aldi"),
            testBasketItem("Corn - Aldi", "Aldi"),
            testBasketItem("Kidney Beans - Aldi", "Aldi"),
            testBasketItem("Soup - Aldi", "Aldi"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testBasketItem("Apple - Aldi", "Aldi"),
            testBasketItem("Orange Juice - Aldi", "Aldi"),
            testBasketItem("Socks - Aldi", "Aldi"),
          ],
        ),
      ],
      [],
    ];

    expectLater(
      sut.basketItems,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem<BasketItemViewModel>(emission))),
    );
    const delay = Duration(milliseconds: 350);
    await Future.delayed(delay);

    final rum = testBasketItem("Rum - Aldi", "Aldi");
    final baking = testBasketItem("Baking Soda - Aldi", "Aldi");
    final flour = testBasketItem("Flour - Aldi", "Aldi");
    final corn = testBasketItem("Corn - Aldi", "Aldi");
    final kidneyBeans = testBasketItem("Kidney Beans - Aldi", "Aldi");

    sut.updateBasketItem(rum.id, isChecked: true);
    sut.updateBasketItem(baking.id, isChecked: true);
    sut.updateBasketItem(flour.id, isChecked: true);
    sut.updateBasketItem(corn.id, isChecked: true);
    sut.updateBasketItem(kidneyBeans.id, isChecked: true);

    sut.removeAllItemsFromBasket(testBaskets["Aldi"]!.id);
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
