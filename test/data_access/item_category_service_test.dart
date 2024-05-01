import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:watch_it/watch_it.dart';

void main() {
  late ItemCategoryService sut;
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);

    di.registerSingleton<ItemCategoryService>(ItemCategoryService());
    sut = di<ItemCategoryService>();
  });

  test('item categories can be created', () async {
    const testName = "Dairy";
    final id = await sut.createItemCategory(testName);
    final category = await sut.getItemCategoryById(id);

    expect(category?.name, testName);
  });

  test('item categories can be updated', () async {
    const testNameOne = "Dairy";
    const testNameTwo = "Fresh Products";
    final id = await sut.createItemCategory(testNameOne);

    var category = await sut.getItemCategoryById(id);
    expect(category?.name, testNameOne);

    await sut.updateItemCategory(id, testNameTwo);

    category = await sut.getItemCategoryById(id);
    expect(category?.name, testNameTwo);
  });

  test('item categories can be deleted', () async {
    const testName = "Dairy";
    final id = await sut.createItemCategory(testName);
    final category = await sut.getItemCategoryById(id);

    expect(category?.name, testName);
  });

  test('item categories can be watched', () async {
    const categoryOne = "Dairy";
    const categoryTwo = "Fresh Products";
    const categoryThree = "Pasta";
    const categoryThreeModified = "Spaghetti";
    const categoryFour = "Baked Goods";

    const expectedValues = [
      [],
      [categoryOne],
      [categoryOne, categoryTwo],
      [categoryOne, categoryTwo, categoryThree],
      [categoryOne, categoryTwo, categoryThree, categoryFour],
      [categoryOne, categoryTwo, categoryThreeModified, categoryFour],
    ];

    expectLater(
      sut.watchItemCategories().map((li) => li.map((e) => e.name)),
      emitsInOrder(expectedValues),
    );

    // Delay creation of new items to ensure emissions are happening one by one
    const delay = Duration(milliseconds: 100);
    await sut.createItemCategory(categoryOne);
    await Future.delayed(delay);

    await sut.createItemCategory(categoryTwo);
    await Future.delayed(delay);

    final categoryThreeId = await sut.createItemCategory(categoryThree);
    await Future.delayed(delay);

    await sut.createItemCategory(categoryFour);
    await Future.delayed(delay);

    await sut.updateItemCategory(categoryThreeId, categoryThreeModified);
  });

  tearDown(() async {
    await database.close();
    di.reset(dispose: true);
  });
}
