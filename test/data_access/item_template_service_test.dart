import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';

void main() {
  late ItemTemplateService sut;

  setUpAll(() async {
    var database = AppDatabase(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
    await seedDatabase(database);
  });

  setUp(() {
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

    await sut.updateItemTemplate(id, nameTwo);

    itemTemplate = await sut.getItemTemplateById(id);
    expect(itemTemplate?.name, nameTwo);
  });

  test('item templates can be deleted', () async {
    const name = "Milk";
    final id = await sut.createItemTemplate(name);
    final itemTemplate = await sut.getItemTemplateById(id);

    expect(itemTemplate?.name, name);
  });

  test('item templates can be watched', () async {
    const itemOne = "Milk";
    const itemTwo = "Eggs";
    const itemThree = "Pasta";
    const itemThreeModified = "Spaghetti";
    const itemFour = "Bread";

    const expectedValues = [
      [],
      [itemOne],
      [itemOne, itemTwo],
      [itemOne, itemTwo, itemThree],
      [itemOne, itemTwo, itemThree, itemFour],
      [itemOne, itemTwo, itemThreeModified, itemFour],
    ];

    expectLater(
      sut.watchItemTemplates().map((li) => li.map((e) => e.name)),
      emitsInOrder(expectedValues),
    );

    // Delay creation of new items to ensure emissions are happening one by one
    const delay = Duration(milliseconds: 100);
    await sut.createItemTemplate(itemOne);
    await Future.delayed(delay);
    await sut.createItemTemplate(itemTwo);
    await Future.delayed(delay);
    final itemThreeId = await sut.createItemTemplate(itemThree);
    await Future.delayed(delay);
    await sut.createItemTemplate(itemFour);
    await Future.delayed(delay);
    await sut.updateItemTemplate(itemThreeId, itemThreeModified);
  });

  tearDown(() async {
    final db = di<AppDatabase>();
    await db.delete(db.itemTemplates).go();
  });

  tearDownAll(() async {
    await di<AppDatabase>().close();
  });
}
