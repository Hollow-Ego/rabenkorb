import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/exceptions/missing_category.dart';
import 'package:rabenkorb/exceptions/missing_unit.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:rabenkorb/services/data_access/variant_key_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:watch_it/watch_it.dart';

import '../database_helper.dart';

void main() {
  late BasketService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);
    di.registerSingleton<BasketStateService>(BasketStateService());

    di.registerSingleton<BasketItemService>(BasketItemService());
    di.registerSingleton<ItemUnitService>(ItemUnitService());
    di.registerSingleton<ItemCategoryService>(ItemCategoryService());
    di.registerSingleton<VariantKeyService>(VariantKeyService());

    di.registerSingleton<MetadataService>(MetadataService());
    di.registerSingleton<ShoppingBasketService>(ShoppingBasketService());

    await seedDatabase(database);

    sut = BasketService();
  });

  test("basket items targeting a non-existent basket will create a basket with a default name", () async {
    final expectValues = [
      [...testBaskets.values.map((e) => e.name)],
      [...testBaskets.values.map((e) => e.name), "Unnamed Basket"],
    ];
    expectLater(
      sut.watchShoppingBaskets().map((event) => event.map((e) => e.name)),
      emitsInAnyOrder(expectValues),
    );

    await sut.createBasketItem("Test Item", basketId: 99);
  });

  test("throw an exception if the category doesn't exist", () {
    expectLater(
      sut.createBasketItem("Test Item", basketId: 1, categoryId: 99),
      throwsA(isA<MissingCategoryException>()),
    );
  });

  test("throw an exception if the unit doesn't exist", () {
    expectLater(
      sut.createBasketItem("Test Item", basketId: 1, unitId: 99),
      throwsA(isA<MissingUnitException>()),
    );
  });

  tearDown(() async {
    await database.close();
    await di.reset(dispose: true);
  });
}
