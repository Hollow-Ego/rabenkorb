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
  });

  group('library', () {
    testWidgets('should start at library', (tester) async {
      await start(tester, routerConfig);

      expect(find.byKey(const Key('library:placeholder')), findsOneWidget);
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
}
