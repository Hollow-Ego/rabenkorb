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

  tearDownAll(() async {
    await di<AppDatabase>().close();
  });
}
