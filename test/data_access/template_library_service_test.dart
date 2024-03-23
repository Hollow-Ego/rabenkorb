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

  test('template libraries can be created', () async {
    const testName = "Dairy";
    final id = await sut.createTemplateLibrary(testName);
    final library = await sut.getTemplateLibraryById(id);

    expect(library?.name, testName);
  });

  test('template libraries can be updated', () async {
    const testNameOne = "Dairy";
    const testNameTwo = "Fresh Products";
    final id = await sut.createTemplateLibrary(testNameOne);

    var library = await sut.getTemplateLibraryById(id);
    expect(library?.name, testNameOne);

    await sut.updateTemplateLibrary(id, testNameTwo);

    library = await sut.getTemplateLibraryById(id);
    expect(library?.name, testNameTwo);
  });

  test('template libraries can be deleted', () async {
    const testName = "Dairy";
    final id = await sut.createTemplateLibrary(testName);
    final library = await sut.getTemplateLibraryById(id);

    expect(library?.name, testName);
  });

  test('template libraries can be watched', () async {
    const libraryOne = "Dairy";
    const libraryTwo = "Fresh Products";
    const libraryThree = "Pasta";
    const libraryThreeModified = "Spaghetti";
    const libraryFour = "Baked Goods";

    const expectedValues = [
      [],
      [libraryOne],
      [libraryOne, libraryTwo],
      [libraryOne, libraryTwo, libraryThree],
      [libraryOne, libraryTwo, libraryThree, libraryFour],
      [libraryOne, libraryTwo, libraryThreeModified, libraryFour],
    ];

    expectLater(
      sut.watchTemplateLibraries().map((li) => li.map((e) => e.name)),
      emitsInOrder(expectedValues),
    );

    // Delay creation of new items to ensure emissions are happening one by one
    const delay = Duration(milliseconds: 100);
    await sut.createTemplateLibrary(libraryOne);
    await Future.delayed(delay);

    await sut.createTemplateLibrary(libraryTwo);
    await Future.delayed(delay);

    final libraryThreeId = await sut.createTemplateLibrary(libraryThree);
    await Future.delayed(delay);

    await sut.createTemplateLibrary(libraryFour);
    await Future.delayed(delay);

    await sut.updateTemplateLibrary(libraryThreeId, libraryThreeModified);
  });

  tearDown(() async {
    final db = di<AppDatabase>();
    await db.delete(db.templateLibraries).go();
  });

  tearDownAll(() async {
    await di<AppDatabase>().close();
  });
}
