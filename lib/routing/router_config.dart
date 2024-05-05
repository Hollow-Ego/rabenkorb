import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/features/backup/backup_page.dart';
import 'package:rabenkorb/features/core/debug/debug_page.dart';
import 'package:rabenkorb/features/core/main_page.dart';
import 'package:rabenkorb/features/settings/settings_page.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/state/navigation_state_service.dart';
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
          path: Routes.library,
          redirect: (context, state) {
            di<NavigationStateService>().setCurrentPageIndex(1);
            return Routes.home;
          },
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
      ],
    );
