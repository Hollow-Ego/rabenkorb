import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:watch_it/watch_it.dart';

void main() {
  late TemplateLibraryService sut;

  setUpAll(() {
    var database = AppDatabase(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
  });

  setUp(() {
    sut = TemplateLibraryService();
  });

  test('item templates can be created', () async {
    const testName = "Milk";
    final id = await sut.createItemTemplate(testName);
    final libraryItem = await sut.getItemTemplateById(id);

    expect(libraryItem?.name, testName);
  });

  test('item templates can be updated', () async {
    const testNameOne = "Milk";
    const testNameTwo = "Eggs";
    final id = await sut.createItemTemplate(testNameOne);

    var libraryItem = await sut.getItemTemplateById(id);
    expect(libraryItem?.name, testNameOne);

    await sut.updateItemTemplate(id, testNameTwo);

    libraryItem = await sut.getItemTemplateById(id);
    expect(libraryItem?.name, testNameTwo);
  });

  test('item templates can be deleted', () async {
    const testName = "Milk";
    final id = await sut.createItemTemplate(testName);
    final libraryItem = await sut.getItemTemplateById(id);

    expect(libraryItem?.name, testName);
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
