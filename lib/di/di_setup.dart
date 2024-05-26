import 'package:rabenkorb/abstracts/image_service.dart';
import 'package:rabenkorb/abstracts/log_sink.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/features/core/error/error_handler.dart';
import 'package:rabenkorb/features/core/error/error_handler_step.dart';
import 'package:rabenkorb/features/core/error/steps/log_step.dart';
import 'package:rabenkorb/features/core/logging/core_logger.dart';
import 'package:rabenkorb/features/core/logging/sinks/void_sink.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/business/data_management_service.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/business/sort_service.dart';
import 'package:rabenkorb/services/core/device_info_service.dart';
import 'package:rabenkorb/services/core/dialog_service.dart';
import 'package:rabenkorb/services/core/environment_service.dart';
import 'package:rabenkorb/services/core/snackbar_service.dart';
import 'package:rabenkorb/services/core/version_service.dart';
import 'package:rabenkorb/services/data_access/basket_item_service.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_sub_category_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:rabenkorb/services/data_access/sort_order_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/data_management_navigation_state_service.dart';
import 'package:rabenkorb/services/state/data_management_state_service.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/services/state/loading_state.dart';
import 'package:rabenkorb/services/state/main_navigation_state_service.dart';
import 'package:rabenkorb/services/state/shared_preference_service.dart';
import 'package:rabenkorb/services/utility/backup_service.dart';
import 'package:rabenkorb/services/utility/image_service.dart';
import 'package:watch_it/watch_it.dart';

Future<void> setupDI() async {
  _addEnvironment();
  _addLogging();
  _registerErrorHandling();
  await _registerCoreServices();
  _registerUtilityServices();
  _registerDatabase();
  await _registerStateServices();
  _registerDataAccessServices();
  _registerBusinessServices();
  await di.allReady();
}

Future<void> reinitializeDataRegistrations() async {
  await _unregisterBusinessServices();
  await _unregisterDataAccessServices();
  await _unregisterDatabase();

  di<LibraryStateService>().reset();
  di<BasketStateService>().reset();

  _registerDatabase();
  _registerDataAccessServices();
  _registerBusinessServices();
  await di.allReady();

  await di<BasketService>().setFirstShoppingBasketActive();
}

void _addEnvironment() {
  di.registerSingleton<EnvironmentService>(EnvironmentService());
}

Future<void> _registerCoreServices() async {
  di.registerSingleton<SnackBarService>(SnackBarService());
  di.registerSingleton<DialogService>(DialogService());

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

  di.registerSingletonAsync<DeviceInfoService>(() async {
    final deviceInfoService = DeviceInfoService();
    await deviceInfoService.init();
    return deviceInfoService;
  });
}

void _registerDatabase() {
  final db = AppDatabase();
  di.registerSingleton<AppDatabase>(db);
}

void _registerDataAccessServices() {
  di.registerSingletonWithDependencies<BasketItemService>(() => BasketItemService(), dependsOn: [BasketStateService]);
  di.registerSingleton<ItemCategoryService>(ItemCategoryService());
  di.registerSingleton<ItemSubCategoryService>(ItemSubCategoryService());
  di.registerSingletonWithDependencies<ItemTemplateService>(() => ItemTemplateService(), dependsOn: [LibraryStateService]);
  di.registerSingleton<ItemUnitService>(ItemUnitService());
  di.registerSingleton<ShoppingBasketService>(ShoppingBasketService());
  di.registerSingleton<SortOrderService>(SortOrderService());
  di.registerSingleton<SortRuleService>(SortRuleService());
  di.registerSingleton<TemplateLibraryService>(TemplateLibraryService());
}

void _registerBusinessServices() {
  di.registerSingleton<SortService>(SortService());
  di.registerSingletonWithDependencies<MetadataService>(() => MetadataService(), dependsOn: [LibraryStateService, BasketStateService]);

  di.registerSingletonWithDependencies<LibraryService>(() => LibraryService(), dependsOn: [ItemTemplateService, MetadataService]);
  di.registerSingletonWithDependencies<BasketService>(() => BasketService(), dependsOn: [BasketItemService, MetadataService]);
  di.registerSingletonWithDependencies<DataManagementService>(() => DataManagementService(), dependsOn: [MetadataService]);
}

Future<void> _registerStateServices() async {
  di.registerSingleton<LoadingIndicatorState>(LoadingIndicatorState());
  di.registerSingletonWithDependencies<LibraryStateService>(() => LibraryStateService(), dependsOn: [PreferenceService]);
  di.registerSingletonWithDependencies<BasketStateService>(() => BasketStateService(), dependsOn: [PreferenceService]);
  di.registerSingletonAsync<IntlStateService>(() async {
    var intlService = IntlStateService();
    await intlService.init();
    return intlService;
  }, dependsOn: [PreferenceService]);
  di.registerSingletonWithDependencies<MainNavigationStateService>(() => MainNavigationStateService(), dependsOn: [IntlStateService]);
  di.registerSingletonWithDependencies<DataManagementNavigationStateService>(() => DataManagementNavigationStateService(), dependsOn: [IntlStateService]);
  di.registerLazySingleton<DataManagementStateService>(() => DataManagementStateService());
}

void _registerUtilityServices() {
  di.registerSingleton<ImageService>(LocalImageService());
  di.registerFactory<BackupService>(() => BackupService());
}

void _addLogging() {
  di.registerLazySingleton<List<LogSinks>>(() => [
        VoidSink(),
      ]);
  di.registerLazySingleton<CoreLogger>(() => CoreLogger());
}

void _registerErrorHandling() {
  di.registerSingleton<List<ErrorHandlerStep>>([
    LogStep(),
  ]);

  di.registerSingleton<ErrorHandler>(ErrorHandler());
}

Future<void> _unregisterBusinessServices() async {
  await di.unregister<BasketService>();
  await di.unregister<LibraryService>();
  await di.unregister<MetadataService>();
  await di.unregister<SortService>();
}

Future<void> _unregisterDataAccessServices() async {
  await di.unregister<BasketItemService>();
  await di.unregister<ItemCategoryService>();
  await di.unregister<ItemTemplateService>();
  await di.unregister<ItemUnitService>();
  await di.unregister<ShoppingBasketService>();
  await di.unregister<SortOrderService>();
  await di.unregister<SortRuleService>();
  await di.unregister<TemplateLibraryService>();
  await di.unregister<DataManagementService>();
}

Future<void> _unregisterDatabase() async {
  await di.unregister<AppDatabase>();
}
