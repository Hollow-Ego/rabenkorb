import 'package:go_router/go_router.dart';
import 'package:rabenkorb/features/core/main_page.dart';
import 'package:rabenkorb/routing/routes.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => MainPage(),
    ),
  ],
);
