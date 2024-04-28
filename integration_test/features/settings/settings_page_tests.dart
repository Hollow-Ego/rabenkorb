import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rabenkorb/di/di_setup.dart';
import 'package:rabenkorb/main.dart';

import '../../helper/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupDI();
    FlutterError.onError = testErrorHandler;
  });

  group('general settings', () {
    testWidgets('should change language', (tester) async {
      await tester.pumpWidget(const MainApp());
      await goToViaDrawer(tester, Icons.settings);

      expect(find.text("General Settings"), findsOneWidget);
      await tapOnKey(tester, "language-dropdown");
      await tapOnKey(tester, "de-DE");
      expect(find.text("Allgemeine Einstellungen"), findsOneWidget);
    }, timeout: const Timeout(Duration(minutes: 1)));
  });
}
