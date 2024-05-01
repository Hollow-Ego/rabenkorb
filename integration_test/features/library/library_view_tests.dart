import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rabenkorb/main.dart';
import 'package:rabenkorb/routing/router_config.dart';
import 'package:rabenkorb/routing/routes.dart';

import '../../helper/test_helper.dart';

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

      expect(find.byKey(const Key('alcohol-header')), findsOneWidget);
      expect(find.byKey(const Key('rum-2')), findsOneWidget);
      expect(find.byKey(const Key('baking-ingredients-header')), findsOneWidget);
      expect(find.byKey(const Key('baking-soda-12')), findsOneWidget);
      expect(find.byKey(const Key('flour-5')), findsOneWidget);
    }, timeout: const Timeout(Duration(minutes: 1)));
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
  await tester.pump();
  await waitForDatabase(tester);
}

Future<void> waitForDatabase(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
}
