import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rabenkorb/main.dart';
import 'package:rabenkorb/routing/router_config.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

import '../../helper/finder_extensions.dart';
import '../../helper/test_helper.dart';
import '../../helper/tester_extensions.dart';

const testTimeout = Timeout(Duration(minutes: 1));

const rumItem = Key('rum-2');
const alcoholHeader = Key('alcohol-1-header');
const bakingIngredientsHeader = Key('baking-ingredients-6-header');
const bakingSodaItem = Key('baking-soda-12');
const flourItem = Key('flour-5');
const coffeeItem = Key('coffee-1');
const beansItem = Key('beans-4');
const peasItem = Key('peas-15');
const appleItem = Key('apple-6');
const itemTemplateList = Key("library-item-template-list");

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final routerConfig = goRouterConfig(initialLocation: Routes.library);

  setUpAll(() async {
    await setupEverything();
    await setupDatabase();
    await resetAppState();
  });

  group('library', () {
    testWidgets('should show item templates in a grouped list', (tester) async {
      await start(tester, routerConfig);

      expect(find.byKey(alcoholHeader), findsOneWidget);
      expect(find.byKey(rumItem), findsOneWidget);
      expect(find.byKey(bakingIngredientsHeader), findsOneWidget);
      expect(find.byKey(bakingSodaItem), findsOneWidget);
      expect(find.byKey(flourItem), findsOneWidget);
    }, timeout: testTimeout);

    testWidgets('should toggle collapse state and remember the state', (tester) async {
      await start(tester, routerConfig);

      final alcoholHeaderWidget = find.byKey(alcoholHeader);
      expect(find.byKey(rumItem).hitTestable(), findsOneWidget);

      // Collapse
      await tester.tap(alcoholHeaderWidget);
      await tester.wait();

      expect(find.byKey(rumItem).hitTestable(), findsNothing);

      // Open
      await tester.tap(alcoholHeaderWidget);
      await tester.wait();

      expect(find.byKey(rumItem).hitTestable(), findsOneWidget);

      // Collapse
      await tester.tap(alcoholHeaderWidget);
      await tester.wait();

      expect(find.byKey(rumItem).hitTestable(), findsNothing);

      await tester.goToViaDrawer(Icons.settings);
      await tester.goToHome();
      await tester.tapOnKey('library-destination');
      expect(find.byKey(rumItem).hitTestable(), findsNothing);
    }, timeout: testTimeout);

    testWidgets('should start with all headers collapsed if this is configured', (tester) async {
      di<LibraryStateService>().setAlwaysCollapseCategories(true);
      await start(tester, routerConfig);

      expect(find.byKey(rumItem).hitTestable(), findsNothing);
      expect(find.byKey(bakingSodaItem).hitTestable(), findsNothing);
      expect(find.byKey(coffeeItem).hitTestable(), findsNothing);
      expect(find.byKey(beansItem).hitTestable(), findsNothing);
      expect(find.byKey(peasItem).hitTestable(), findsNothing);
      expect(find.byKey(appleItem).hitTestable(), findsNothing);
    }, timeout: testTimeout);

    testWidgets('should delete item template', (tester) async {
      await start(tester, routerConfig);
      await tester.tapOnKey('rum-2-popup-menu');
      await tester.tapOnKey('rum-2-popup-menu-delete');

      expect(find.byKey(rumItem).hitTestable(), findsNothing);
    }, timeout: testTimeout);

    testWidgets('should filter items based on search', (tester) async {
      await start(tester, routerConfig);

      await tester.enterInto("library-search-field", "Soda");

      expect(find.byKeyOffstage(rumItem), findsNothing);
      expect(find.byKeyOffstage(bakingSodaItem), findsOneWidget);
      expect(find.byKeyOffstage(coffeeItem), findsNothing);
      expect(find.byKeyOffstage(beansItem), findsNothing);
      expect(find.byKeyOffstage(peasItem), findsNothing);
      expect(find.byKeyOffstage(appleItem), findsNothing);

      await tester.tapOnKey("library-search-clear");

      expect(find.byKeyOffstage(rumItem), findsOneWidget);
      expect(find.byKeyOffstage(bakingSodaItem), findsOneWidget);
      expect(find.byKeyOffstage(beansItem), findsOneWidget);
      expect(find.byKeyOffstage(peasItem), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(appleItem), 100, scrollable: find.getScrollableDescendant(find.byKey(itemTemplateList)));
      expect(find.byKeyOffstage(coffeeItem), findsOneWidget);
      expect(find.byKeyOffstage(appleItem), findsOneWidget);
    }, timeout: testTimeout);
  });

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
