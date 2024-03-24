import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';

void main() {
  late ItemTemplateService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
    await seedDatabase(database);
    sut = ItemTemplateService();
  });

  test('item templates can be created', () async {
    const name = "Milk";

    final id = await sut.createItemTemplate(name);

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
    final id = await sut.createItemTemplate(nameOne);

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

    final id = await sut.createItemTemplate(nameOne);

    var itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameOne);

    await sut.updateItemTemplate(
      id,
      categoryId: categoryId,
      libraryId: libraryId,
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
    final id = await sut.createItemTemplate(name);
    final itemTemplate = await sut.getItemTemplateById(id);

    expect(itemTemplate?.name, name);
  });

  test(
      'item templates can be watched in custom order with missing category and order',
      () async {
    final expectedValues = [
      [
        testCategories["Alcohol"]!.name,
        testCategories["Baking Ingredients"]!.name,
        testCategories["Hot Drinks"]!.name,
        testCategories["Vegan"]!.name,
        testCategories["Canned Food"]!.name,
        "Without Category",
      ],
    ];

    expectLater(
      sut.watchItemTemplatesInOrder(SortMode.custom, sortRuleId: 1).map(
          (groupedItems) =>
              groupedItems.map((group) => group.category.name).toList()),
      emitsInOrder(expectedValues),
    );
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
