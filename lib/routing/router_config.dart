import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/features/backup/backup_page.dart';
import 'package:rabenkorb/features/backup/backup_restore_screen.dart';
import 'package:rabenkorb/features/basket/details/basket_item_details.dart';
import 'package:rabenkorb/features/basket/overview/basket_overview_page.dart';
import 'package:rabenkorb/features/data_management/data_management_page.dart';
import 'package:rabenkorb/features/debug/debug_page.dart';
import 'package:rabenkorb/features/library/details/item_template_details.dart';
import 'package:rabenkorb/features/main/main_page.dart';
import 'package:rabenkorb/features/settings/settings_page.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/state/data_management_navigation_state_service.dart';
import 'package:rabenkorb/services/state/main_navigation_state_service.dart';
import 'package:watch_it/watch_it.dart';

// GoRouter configuration
RouterConfig<Object> goRouterConfig({String initialLocation = Routes.home}) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => MainPage(),
        ),
        GoRoute(
          path: Routes.libraryItemTemplateDetails,
          builder: (context, state) {
            final itemTemplate = state.extra as ItemTemplateViewModel?;
            final tempItemName = state.uri.queryParameters['tempItemName'];
            return ItemTemplateDetails(
              itemTemplate: itemTemplate,
              tempItemName: tempItemName,
            );
          },
        ),
        GoRoute(
          path: Routes.library,
          redirect: (context, state) {
            di<MainNavigationStateService>().setCurrentPageIndex(1);
            return Routes.home;
          },
        ),
        GoRoute(
          path: Routes.basketItemDetails,
          builder: (context, state) {
            final itemTemplate = state.extra as BasketItemViewModel?;
            final tempItemName = state.uri.queryParameters['tempItemName'];
            return BasketItemDetails(
              basketItem: itemTemplate,
              tempItemName: tempItemName,
            );
          },
        ),
        GoRoute(
          path: Routes.basketOverview,
          builder: (context, state) {
            return const BasketOverviewPage();
          },
        ),
        GoRoute(
          path: Routes.basket,
          redirect: (context, state) {
            di<MainNavigationStateService>().setCurrentPageIndex(0);
            return Routes.home;
          },
        ),
        GoRoute(
          path: Routes.backupRestore,
          builder: (context, state) => const BackupRestoreScreen(),
        ),
        GoRoute(
          path: Routes.backup,
          builder: (context, state) => const BackupPage(),
        ),
        GoRoute(
          path: Routes.settings,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: Routes.debug,
          builder: (context, state) => const DebugPage(),
        ),
        GoRoute(
          path: Routes.dataManagementCategory,
          redirect: (context, state) {
            di<DataManagementNavigationStateService>().setCurrentPageIndex(0);
            return Routes.dataManagement;
          },
        ),
        GoRoute(
          path: Routes.dataManagementUnit,
          redirect: (context, state) {
            di<DataManagementNavigationStateService>().setCurrentPageIndex(1);
            return Routes.dataManagement;
          },
        ),
        GoRoute(
          path: Routes.dataManagement,
          builder: (context, state) => const DataManagementPage(),
        ),
      ],
    );
