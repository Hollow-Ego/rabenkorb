import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rabenkorb/database/daos/basket_items_dao.dart';
import 'package:rabenkorb/database/daos/item_categories_dao.dart';
import 'package:rabenkorb/database/daos/item_templates_dao.dart';
import 'package:rabenkorb/database/daos/item_units_dao.dart';
import 'package:rabenkorb/database/daos/shopping_baskets_dao.dart';
import 'package:rabenkorb/database/daos/sort_orders_dao.dart';
import 'package:rabenkorb/database/daos/sort_rules_dao.dart';
import 'package:rabenkorb/database/daos/template_libraries_dao.dart';
import 'package:rabenkorb/database/daos/variant_keys_dao.dart';
import 'package:rabenkorb/database/tables/basket_items.dart';
import 'package:rabenkorb/database/tables/item_categories.dart';
import 'package:rabenkorb/database/tables/item_templates.dart';
import 'package:rabenkorb/database/tables/item_units.dart';
import 'package:rabenkorb/database/tables/shopping_basket.dart';
import 'package:rabenkorb/database/tables/sort_orders.dart';
import 'package:rabenkorb/database/tables/sort_rules.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';
import 'package:rabenkorb/database/tables/variant_keys.dart';

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
    VariantKeys,
  ],
  daos: [
    ItemCategoriesDao,
    ItemTemplatesDao,
    ItemUnitsDao,
    BasketItemsDao,
    ShoppingBasketsDao,
    SortOrdersDao,
    SortRulesDao,
    TemplateLibrariesDao,
    VariantKeysDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  AppDatabase.forImport(String path) : super(_openImportDatabase(path));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      });

  Future<void> exportInto(File file) async {
    await file.parent.create(recursive: true);

    if (file.existsSync()) {
      file.deleteSync();
    }

    await customStatement('VACUUM INTO ?', [file.path]);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

LazyDatabase _openImportDatabase(String path) {
  return LazyDatabase(() async {
    final file = File(p.join(path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
