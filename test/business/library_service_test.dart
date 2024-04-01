import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';

void main() {
  late LibraryService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
    di.registerSingleton<LibraryStateService>(LibraryStateService());

    di.registerSingleton<ItemTemplateService>(ItemTemplateService());
    di.registerSingleton<TemplateLibraryService>(TemplateLibraryService());

    await seedDatabase(database);

    sut = LibraryService();
  });

  test("item templates targeting a non-existent library will create a library with a default name", () async {
    final expectValues = [
      [...testLibraries.values.map((e) => e.name)],
      [...testLibraries.values.map((e) => e.name), "Unnamed Library"],
    ];
    expectLater(
      sut.watchTemplateLibraries().map((event) => event.map((e) => e.name)),
      emitsInAnyOrder(expectValues),
    );

    await sut.createItemTemplate("Test Item", libraryId: 99);
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
