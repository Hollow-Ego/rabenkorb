import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/exceptions/missing_category.dart';
import 'package:rabenkorb/exceptions/missing_variant.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:rabenkorb/services/data_access/variant_key_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';
import '../mock_preferences_service.dart';

void main() {
  late LibraryService sut;
  late MetadataService metadataService;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<PreferenceService>(MockPreferenceService());
    di.registerSingleton<AppDatabase>(database);
    di.registerSingleton<LibraryStateService>(LibraryStateService());

    di.registerSingleton<ItemTemplateService>(ItemTemplateService());
    di.registerSingleton<ItemUnitService>(ItemUnitService());
    di.registerSingleton<ItemCategoryService>(ItemCategoryService());
    di.registerSingleton<VariantKeyService>(VariantKeyService());

    metadataService = MetadataService();
    di.registerSingleton<MetadataService>(metadataService);
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

  test("throw an exception if the category doesn't exist", () {
    expectLater(
      sut.createItemTemplate("Test Item", libraryId: 1, categoryId: 99),
      throwsA(isA<MissingCategoryException>()),
    );
  });

  test("throw an exception if the variant key doesn't exist", () {
    expectLater(
      sut.createItemTemplate("Test Item", libraryId: 1, variantKeyId: 99),
      throwsA(isA<MissingVariantException>()),
    );
  });

  test("remove no longer needed variant keys after removing it for one template", () async {
    final itemTemplateId = testItemTemplates["Peas - Frozen"]!.id;
    final connectedItemTemplateId = testItemTemplates["Peas - Canned"]!.id;
    await sut.removeItemTemplateVariant(itemTemplateId);

    final previouslyConnectedItem = await sut.getItemTemplateById(connectedItemTemplateId);
    expect(previouslyConnectedItem!.variantKey, null);

    final variant = await metadataService.getVariantKeyById(testVariantKeys["Key 1"]!.id);
    expect(variant, null);
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
