import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/business/sort_service.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:rabenkorb/services/data_access/sort_order_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:rabenkorb/services/data_access/variant_key_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

void setupDI() {
  _registerDatabase();
  _registerStateServices();
  _registerDataAccessServices();
  _registerBusinessServices();
}

void _registerDatabase() {
  final db = AppDatabase();
  di.registerSingleton<AppDatabase>(db);
}

void _registerDataAccessServices() {
  di.registerSingleton<BasketItemService>(BasketItemService());
  di.registerSingleton<ItemCategoryService>(ItemCategoryService());
  di.registerSingleton<ItemTemplateService>(ItemTemplateService());
  di.registerSingleton<ItemUnitService>(ItemUnitService());
  di.registerSingleton<ShoppingBasketService>(ShoppingBasketService());
  di.registerSingleton<SortOrderService>(SortOrderService());
  di.registerSingleton<SortRuleService>(SortRuleService());
  di.registerSingleton<TemplateLibraryService>(TemplateLibraryService());
  di.registerSingleton<VariantKeyService>(VariantKeyService());
}

void _registerBusinessServices() {
  di.registerSingleton<SortService>(SortService());
  di.registerSingleton<MetadataService>(MetadataService());
  di.registerSingleton<LibraryService>(LibraryService());
}

void _registerStateServices() {
  di.registerSingleton<LibraryStateService>(LibraryStateService());
}
