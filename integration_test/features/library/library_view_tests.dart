import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rabenkorb/main.dart';
import 'package:rabenkorb/routing/router_config.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

import '../../helper/test_helper.dart';
import '../../helper/tester_extensions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final routerConfig = goRouterConfig(initialLocation: Routes.library);

  setUpAll(() async {
    await setupEverything();
    await setupDatabase();
  });

  group('library', () {
    testWidgets('should show item templates in a grouped list', (tester) async {
      await start(tester, routerConfig);

      expect(find.byKey(const Key('alcohol-1-header')), findsOneWidget);
      expect(find.byKey(const Key('rum-2')), findsOneWidget);
      expect(find.byKey(const Key('baking-ingredients-6-header')), findsOneWidget);
      expect(find.byKey(const Key('baking-soda-12')), findsOneWidget);
      expect(find.byKey(const Key('flour-5')), findsOneWidget);
    }, timeout: const Timeout(Duration(minutes: 1)));

    testWidgets('should toggle collapse state', (tester) async {
      await start(tester, routerConfig);

      final alcoholHeader = find.byKey(const Key('alcohol-1-header'));
      expect(find.byKey(const Key('rum-2')).hitTestable(), findsOneWidget);

      // Collapse
      await tester.tap(alcoholHeader);
      await tester.wait();

      expect(find.byKey(const Key('rum-2')).hitTestable(), findsNothing);

      // Open
      await tester.tap(alcoholHeader);
      await tester.wait();

      expect(find.byKey(const Key('rum-2')).hitTestable(), findsOneWidget);

      // Collapse
      await tester.tap(alcoholHeader);
      await tester.wait();

      expect(find.byKey(const Key('rum-2')).hitTestable(), findsNothing);
    }, timeout: const Timeout(Duration(minutes: 1)));
  });

  testWidgets('should start with all headers collapsed if this is configured', (tester) async {
    di<LibraryStateService>().setAlwaysCollapseCategories(true);
    await start(tester, routerConfig);

    expect(find.byKey(const Key('rum-2')).hitTestable(), findsNothing);
    expect(find.byKey(const Key('baking-soda-12')).hitTestable(), findsNothing);
    expect(find.byKey(const Key('coffee-1')).hitTestable(), findsNothing);
    expect(find.byKey(const Key('beans-4')).hitTestable(), findsNothing);
    expect(find.byKey(const Key('peas-15')).hitTestable(), findsNothing);
    expect(find.byKey(const Key('apple-6')).hitTestable(), findsNothing);
  }, timeout: const Timeout(Duration(minutes: 1)));

  tearDown(() async {
    await resetAppState();
  });

  tearDownAll(() async {
    await tearDownEverything();
  });
}

Future<void> start(WidgetTester tester, RouterConfig<Object> routerConfig) async {
  await tester.pumpWidget(MainApp(routerConfig: routerConfig));
  await tester.wait();
  await waitForDatabase(tester);
}

Future<void> waitForDatabase(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
}
