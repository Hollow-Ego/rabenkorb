import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/features/core/debug/debug_database_helper.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await seedDatabase(database);
  });

  test('item templates can be created', () async {
    const testName = "Milk";
    final id = await database.itemTemplatesDao.createItemTemplate(testName, libraryId: 1);
    final libraryItem = await database.itemTemplatesDao.watchItemTemplateWithId(id).first;

    expect(libraryItem?.name, testName);
  });

  test('stream emits a new item template when the name updates', () async {
    const testNameOne = "Milk";
    const testNameTwo = "Eggs";
    final id = await database.itemTemplatesDao.createItemTemplate(testNameOne, libraryId: 1);

    expectLater(
      database.itemTemplatesDao.watchItemTemplateWithId(id).map((li) => li?.name),
      emitsInOrder([testNameOne, testNameTwo]),
    );

    await database.itemTemplatesDao.updateItemTemplate(id, name: testNameTwo);
  });

  tearDown(() async {
    await database.close();
  });
}
