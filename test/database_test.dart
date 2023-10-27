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
    final id = await database!.createLibraryItem(testName);
    final libraryItem = await database!.watchLibraryItemWithId(id).first;

    expect(libraryItem.name, testName);
  });

  test('stream emits a new libary item when the name updates', () async {
    const testNameOne = "Milk";
    const testNameTwo = "Eggs";
    final id = await database!.createLibraryItem(testNameOne);

    final expectation = expectLater(
      database!.watchLibraryItemWithId(id).map((li) => li.name),
      emitsInOrder([testNameOne, testNameTwo]),
    );

    await database!.updateLibraryItem(id, testNameTwo);
    await expectation;
  });

  tearDown(() async {
    await database!.close();
  });
}