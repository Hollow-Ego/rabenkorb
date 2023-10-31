import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';


void main() {
  AppDatabase? database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });


  test('library items can be created', () async {
    const testName = "Milk";
    final id = await database!.itemTemplatesDao.createItemTemplate(testName);
    final libraryItem = await database!.itemTemplatesDao.watchItemTemplateWithId(id).first;

    expect(libraryItem.name, testName);
  });

  test('stream emits a new libary item when the name updates', () async {
    const testNameOne = "Milk";
    const testNameTwo = "Eggs";
    final id = await database!.itemTemplatesDao.createItemTemplate(testNameOne);

    final expectation = expectLater(
      database!.itemTemplatesDao.watchItemTemplateWithId(id).map((li) => li.name),
      emitsInOrder([testNameOne, testNameTwo]),
    );

    await database!.itemTemplatesDao.updateItemTemplate(id, testNameTwo);
  });

  tearDown(() async {
    await database!.close();
  });
}