import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/abstracts/image_service.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/exceptions/missing_category.dart';
import 'package:rabenkorb/features/debug/debug_database_helper.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_sub_category_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

import '../mock_image_service.dart';
import '../mock_preferences_service.dart';

void main() {
  late LibraryService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<PreferenceService>(MockPreferenceService());
    di.registerSingleton<ImageService>(MockImageService());
    di.registerSingleton<AppDatabase>(database);
    di.registerSingleton<SortRuleService>(SortRuleService());
    di.registerSingleton<LibraryStateService>(LibraryStateService());
    di.registerSingleton<BasketStateService>(BasketStateService());

    di.registerSingleton<ItemTemplateService>(ItemTemplateService());
    di.registerSingleton<ItemUnitService>(ItemUnitService());
    di.registerSingleton<ItemCategoryService>(ItemCategoryService());
    di.registerSingleton<ItemSubCategoryService>(ItemSubCategoryService());

    di.registerSingleton<MetadataService>(MetadataService());
    di.registerSingleton<TemplateLibraryService>(TemplateLibraryService());

    await seedDatabase(database);

    di.registerSingleton<LibraryService>(LibraryService());
    sut = di<LibraryService>();
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

  test("throw an exception if the category doesn't exist", () {
    expectLater(
      sut.createItemTemplate("Test Item", libraryId: 1, categoryId: 99),
      throwsA(isA<MissingCategoryException>()),
    );
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
