import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';
import '../matcher/grouped_items_matcher.dart';

void main() {
  late ItemTemplateService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
    await seedDatabase(database);
    sut = ItemTemplateService.withValue(
      sortMode: SortMode.custom,
      sortRuleId: 1,
    );
  });

  test('item templates can be created', () async {
    const name = "Milk";

    final id = await sut.createItemTemplate(name, libraryId: 1);

    final itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, name);
  });

  test('item templates can be created with all properties', () async {
    const name = "Milk";
    const categoryId = 1;
    const libraryId = 1;
    const variantKeyId = 1;
    const imagePath = "/img.png";

    final id = await sut.createItemTemplate(
      name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );

    final itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, name);
    expect(itemTemplate?.category, categoryId);
    expect(itemTemplate?.library, libraryId);
    expect(itemTemplate?.variantKey, variantKeyId);
    expect(itemTemplate?.imagePath, imagePath);
  });

  test('item templates can be updated', () async {
    const nameOne = "Milk";
    const nameTwo = "Eggs";
    final id = await sut.createItemTemplate(nameOne, libraryId: 1);

    var itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameOne);

    await sut.updateItemTemplate(id, name: nameTwo);

    itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameTwo);
  });

  test('item templates can be updated partially', () async {
    const nameOne = "Milk";
    const categoryId = 1;
    const libraryId = 1;
    const variantKeyId = 1;
    const imagePath = "/img.png";

    final id = await sut.createItemTemplate(nameOne, libraryId: libraryId);

    var itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameOne);

    await sut.updateItemTemplate(
      id,
      categoryId: categoryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );

    itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameOne);
    expect(itemTemplate?.category, categoryId);
    expect(itemTemplate?.library, libraryId);
    expect(itemTemplate?.variantKey, variantKeyId);
    expect(itemTemplate?.imagePath, imagePath);

    const modifiedCategory = 2;
    await sut.updateItemTemplate(
      id,
      categoryId: modifiedCategory,
    );

    itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameOne);
    expect(itemTemplate?.category, modifiedCategory);
    expect(itemTemplate?.library, libraryId);
    expect(itemTemplate?.variantKey, variantKeyId);
    expect(itemTemplate?.imagePath, imagePath);
  });

  test('item templates can be deleted', () async {
    const name = "Milk";
    final id = await sut.createItemTemplate(name, libraryId: 1);
    final itemTemplate = await sut.getItemTemplateById(id);

    expect(itemTemplate?.name, name);
  });

  test('item templates can be watched in custom order with missing category and order and without empty categories', () async {
    final expectedValues = [
      [
        GroupedItems(
          category: testCategories["Alcohol"]!,
          items: [
            testItemTemplates["Rum"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Baking Ingredients"]!,
          items: [
            testItemTemplates["Baking Soda"]!,
            testItemTemplates["Flour"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testItemTemplates["Coffee"]!,
            testItemTemplates["Earl Grey"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Vegan"]!,
          items: [
            testItemTemplates["Schnitzel"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testItemTemplates["Beans"]!,
            testItemTemplates["Corn"]!,
            testItemTemplates["Kidney Beans"]!,
            testItemTemplates["Peas - Canned"]!,
            testItemTemplates["Soup"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Frozen Food"]!,
          items: [
            testItemTemplates["Peas - Frozen"]!,
          ],
        ),
        GroupedItems(
          category: const ItemCategory(id: 0, name: "Without Category"),
          items: [
            testItemTemplates["Apple"]!,
            testItemTemplates["Orange Juice"]!,
            testItemTemplates["Socks"]!,
          ],
        ),
      ],
    ];

    expectLater(
      sut.itemTemplates,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem<ItemTemplate>(emission))),
    );
  });

  test('item templates can be filtered case insensitive and debounced', () async {
    const searchStringOne = "e";
    const searchStringTwo = "ea";
    const searchStringThree = "EANS";
    final expectedValues = [
      // Filter: ea
      [
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testItemTemplates["Earl Grey"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testItemTemplates["Beans"]!,
            testItemTemplates["Kidney Beans"]!,
            testItemTemplates["Peas - Canned"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Frozen Food"]!,
          items: [
            testItemTemplates["Peas - Frozen"]!,
          ],
        ),
      ],
      // Filter: EANS
      [
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testItemTemplates["Beans"]!,
            testItemTemplates["Kidney Beans"]!,
          ],
        ),
      ],
      // Without filter
      [
        GroupedItems(
          category: testCategories["Alcohol"]!,
          items: [
            testItemTemplates["Rum"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Baking Ingredients"]!,
          items: [
            testItemTemplates["Baking Soda"]!,
            testItemTemplates["Flour"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Hot Drinks"]!,
          items: [
            testItemTemplates["Coffee"]!,
            testItemTemplates["Earl Grey"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Vegan"]!,
          items: [
            testItemTemplates["Schnitzel"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Canned Food"]!,
          items: [
            testItemTemplates["Beans"]!,
            testItemTemplates["Corn"]!,
            testItemTemplates["Kidney Beans"]!,
            testItemTemplates["Peas - Canned"]!,
            testItemTemplates["Soup"]!,
          ],
        ),
        GroupedItems(
          category: testCategories["Frozen Food"]!,
          items: [
            testItemTemplates["Peas - Frozen"]!,
          ],
        ),
        GroupedItems(
          category: const ItemCategory(id: 0, name: "Without Category"),
          items: [
            testItemTemplates["Apple"]!,
            testItemTemplates["Orange Juice"]!,
            testItemTemplates["Socks"]!,
          ],
        ),
      ]
    ];

    expectLater(
      sut.itemTemplates,
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
