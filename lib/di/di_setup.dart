import 'package:rabenkorb/abstracts/image_service.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/business/sort_service.dart';
import 'package:rabenkorb/services/core/version_service.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:rabenkorb/services/data_access/sort_order_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:rabenkorb/services/data_access/variant_key_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/services/state/shared_preference_service.dart';
import 'package:rabenkorb/services/utility/backup_service.dart';
import 'package:rabenkorb/services/utility/image_service.dart';
import 'package:watch_it/watch_it.dart';

Future<void> setupDI() async {
  await _registerCoreServices();
  _registerUtilityServices();
  _registerDatabase();
  await _registerStateServices();
  _registerDataAccessServices();
  _registerBusinessServices();
  await di.allReady();
}

Future<void> _registerCoreServices() async {
  di.registerSingletonAsync<VersionService>(() async {
    final versionService = VersionService();
    await versionService.init();
    return versionService;
  });

  di.registerSingletonAsync<PreferenceService>(() async {
    final sharedPreferencesService = SharedPreferenceService();
    await sharedPreferencesService.init();
    return sharedPreferencesService;
  });
}

void _registerDatabase() {
  final db = AppDatabase();
  di.registerSingleton<AppDatabase>(db);
}

void _registerDataAccessServices() {
  di.registerSingletonWithDependencies<BasketItemService>(() => BasketItemService(), dependsOn: [BasketStateService]);
  di.registerSingleton<ItemCategoryService>(ItemCategoryService());
  di.registerSingletonWithDependencies<ItemTemplateService>(() => ItemTemplateService(), dependsOn: [LibraryStateService]);
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

  di.registerSingletonWithDependencies<LibraryService>(() => LibraryService(), dependsOn: [ItemTemplateService]);
  di.registerSingletonWithDependencies<BasketService>(() => BasketService(), dependsOn: [BasketItemService]);
}

Future<void> _registerStateServices() async {
  di.registerSingletonWithDependencies<LibraryStateService>(() => LibraryStateService(), dependsOn: [PreferenceService]);
  di.registerSingletonWithDependencies<BasketStateService>(() => BasketStateService(), dependsOn: [PreferenceService]);
  di.registerSingletonAsync<IntlStateService>(() async {
    var intlService = IntlStateService();
    await intlService.init();
    return intlService;
  }, dependsOn: [PreferenceService]);
}

void _registerUtilityServices() {
  di.registerSingleton<ImageService>(LocalImageService());
  di.registerLazySingleton<BackupService>(() => BackupService());
}
