import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';
import '../matcher/grouped_items_matcher.dart';
import '../mock_preferences_service.dart';

void main() {
  late ItemTemplateService sut;
  late AppDatabase database;
  late LibraryStateService libraryStateService;

  setUp(() async {
    di.registerSingleton<PreferenceService>(MockPreferenceService());
    libraryStateService = LibraryStateService.withValue(
      sortMode: SortMode.custom,
      sortRuleId: 1,
    );
    di.registerSingleton<LibraryStateService>(libraryStateService);

    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
    await seedDatabase(database);

    sut = ItemTemplateService();
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
    expect(itemTemplate?.category?.id, categoryId);
    expect(itemTemplate?.library.id, libraryId);
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
    expect(itemTemplate?.category?.id, categoryId);
    expect(itemTemplate?.library.id, libraryId);
    expect(itemTemplate?.variantKey, variantKeyId);
    expect(itemTemplate?.imagePath, imagePath);

    const modifiedCategory = 2;
    await sut.updateItemTemplate(
      id,
      categoryId: modifiedCategory,
    );

    itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameOne);
    expect(itemTemplate?.category?.id, modifiedCategory);
    expect(itemTemplate?.library.id, libraryId);
    expect(itemTemplate?.variantKey, variantKeyId);
    expect(itemTemplate?.imagePath, imagePath);
  });

  test('all optional properties can be removed', () async {
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

    var itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, name);
    expect(itemTemplate?.category?.id, categoryId);
    expect(itemTemplate?.library.id, libraryId);
    expect(itemTemplate?.variantKey, variantKeyId);
    expect(itemTemplate?.imagePath, imagePath);

    await sut.replaceItemTemplate(
      id,
      name: name,
      libraryId: libraryId,
    );

    itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, name);
    expect(itemTemplate?.category?.id, null);
    expect(itemTemplate?.library.id, libraryId);
    expect(itemTemplate?.variantKey, null);
    expect(itemTemplate?.imagePath, null);
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
          category: testCategory("Alcohol"),
          items: [
            testItemTemplate("Rum"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testItemTemplate("Baking Soda"),
            testItemTemplate("Flour"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testItemTemplate("Coffee"),
            testItemTemplate("Earl Grey"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testItemTemplate("Schnitzel"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testItemTemplate("Beans"),
            testItemTemplate("Corn"),
            testItemTemplate("Kidney Beans"),
            testItemTemplate("Peas - Canned"),
            testItemTemplate("Soup"),
          ],
        ),
        GroupedItems(
          category: testCategory("Frozen Food"),
          items: [
            testItemTemplate("Peas - Frozen"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testItemTemplate("Apple"),
            testItemTemplate("Orange Juice"),
            testItemTemplate("Socks"),
          ],
        ),
      ],
    ];

    expectLater(
      sut.itemTemplates,
      emitsInOrder(expectedValues.map((emission) => IsEqualToGroupedItem<ItemTemplateViewModel>(emission))),
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
          category: testCategory("Hot Drinks"),
          items: [
            testItemTemplate("Earl Grey"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testItemTemplate("Beans"),
            testItemTemplate("Kidney Beans"),
            testItemTemplate("Peas - Canned"),
          ],
        ),
        GroupedItems(
          category: testCategory("Frozen Food"),
          items: [
            testItemTemplate("Peas - Frozen"),
          ],
        ),
      ],
      // Filter: EANS
      [
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testItemTemplate("Beans"),
            testItemTemplate("Kidney Beans"),
          ],
        ),
      ],
      // Without filter
      [
        GroupedItems(
          category: testCategory("Alcohol"),
          items: [
            testItemTemplate("Rum"),
          ],
        ),
        GroupedItems(
          category: testCategory("Baking Ingredients"),
          items: [
            testItemTemplate("Baking Soda"),
            testItemTemplate("Flour"),
          ],
        ),
        GroupedItems(
          category: testCategory("Hot Drinks"),
          items: [
            testItemTemplate("Coffee"),
            testItemTemplate("Earl Grey"),
          ],
        ),
        GroupedItems(
          category: testCategory("Vegan"),
          items: [
            testItemTemplate("Schnitzel"),
          ],
        ),
        GroupedItems(
          category: testCategory("Canned Food"),
          items: [
            testItemTemplate("Beans"),
            testItemTemplate("Corn"),
            testItemTemplate("Kidney Beans"),
            testItemTemplate("Peas - Canned"),
            testItemTemplate("Soup"),
          ],
        ),
        GroupedItems(
          category: testCategory("Frozen Food"),
          items: [
            testItemTemplate("Peas - Frozen"),
          ],
        ),
        GroupedItems(
          category: ItemCategoryViewModel(0, "Without Category"),
          items: [
            testItemTemplate("Apple"),
            testItemTemplate("Orange Juice"),
            testItemTemplate("Socks"),
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
    libraryStateService.setSearchString(searchStringOne);
    libraryStateService.setSearchString(searchStringTwo);
    await Future.delayed(delay);
    libraryStateService.setSearchString(searchStringThree);
    await Future.delayed(delay);
    libraryStateService.setSearchString(null);
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
