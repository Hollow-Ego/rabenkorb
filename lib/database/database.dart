import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rabenkorb/database/daos/basket_items_dao.dart';
import 'package:rabenkorb/database/daos/item_categories_dao.dart';
import 'package:rabenkorb/database/daos/item_sub_categories_dao.dart';
import 'package:rabenkorb/database/daos/item_templates_dao.dart';
import 'package:rabenkorb/database/daos/item_units_dao.dart';
import 'package:rabenkorb/database/daos/shopping_baskets_dao.dart';
import 'package:rabenkorb/database/daos/sort_orders_dao.dart';
import 'package:rabenkorb/database/daos/sort_rules_dao.dart';
import 'package:rabenkorb/database/daos/template_libraries_dao.dart';
import 'package:rabenkorb/database/tables/basket_items.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/item_sub_category.dart';
import 'package:rabenkorb/database/tables/item_templates.dart';
import 'package:rabenkorb/database/tables/item_units.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';
import 'package:rabenkorb/database/tables/sort_orders.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    ItemCategories,
    ItemTemplates,
    ItemUnits,
    BasketItems,
    ShoppingBaskets,
    SortOrders,
    SortRules,
    TemplateLibraries,
    ItemSubCategories,
  ],
  daos: [
    ItemCategoriesDao,
    ItemSubCategoriesDao,
    ItemTemplatesDao,
    ItemUnitsDao,
    BasketItemsDao,
    ShoppingBasketsDao,
    SortOrdersDao,
    SortRulesDao,
    TemplateLibrariesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const databaseFileName = 'db.sqlite';

  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  AppDatabase.forImport(String path, String fileName) : super(_openImportDatabase(path, fileName));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          m.deleteTable("variant_keys");
          await m.addColumn(basketItems, basketItems.note);
          await m.alterTable(TableMigration(basketItems));
          await m.alterTable(TableMigration(itemTemplates));
        }
        if (from < 3) {
          m.createTable(itemSubCategories);
          await m.addColumn(basketItems, basketItems.subCategory);
          await m.alterTable(TableMigration(basketItems));
        }
      },
    );
  }

  Future<void> exportInto(File file) async {
    await file.parent.create(recursive: true);

    if (file.existsSync()) {
      file.deleteSync();
    }

    await customStatement('VACUUM INTO ?', [file.path]);
  }

  Future<int?> countImagePathUsages(String imagePath) async {
    // Count usages in basketItems
    final amountOfUsagesInBasketItems = basketItems.imagePath.count(filter: basketItems.imagePath.equals(imagePath));
    final basketItemsQuery = selectOnly(basketItems)..addColumns([amountOfUsagesInBasketItems]);

    // Count usages in itemTemplates
    final amountOfUsagesInItemTemplates = itemTemplates.imagePath.count(filter: itemTemplates.imagePath.equals(imagePath));
    final itemTemplatesQuery = selectOnly(itemTemplates)..addColumns([amountOfUsagesInItemTemplates]);

    // Execute queries
    final basketItemsCount = await basketItemsQuery.map((row) => row.read(amountOfUsagesInBasketItems)).getSingle() ?? 0;
    final itemTemplatesCount = await itemTemplatesQuery.map((row) => row.read(amountOfUsagesInItemTemplates)).getSingle() ?? 0;

    // Return the sum of both counts
    return basketItemsCount + itemTemplatesCount;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppDatabase.databaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}

LazyDatabase _openImportDatabase(String path, String filename) {
  return LazyDatabase(() async {
    final file = File(p.join(path, filename));
    return NativeDatabase.createInBackground(file);
  });
}
