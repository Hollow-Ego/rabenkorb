import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rabenkorb/main.dart';
import 'package:rabenkorb/routing/router_config.dart';
import 'package:rabenkorb/routing/routes.dart';

import '../../helper/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final routerConfig = goRouterConfig(initialLocation: Routes.settings);

  setUpAll(() async {
    await setupEverything();
  });

  group('general settings', () {
    testWidgets('should change language', (tester) async {
      await tester.pumpWidget(MainApp(routerConfig: routerConfig));

      expect(find.text("General Settings"), findsOneWidget);
      await tapOnKey(tester, "settings:language-dropdown");
      await tapOnKey(tester, "settings:de-DE");
      expect(find.text("Allgemeine Einstellungen"), findsOneWidget);
    }, timeout: const Timeout(Duration(minutes: 1)));
  });

  tearDown(() async {
    await resetAppState();
  });

  tearDownAll(() async {
    await tearDownEverything();
  });
}
