import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

extension TesterExtensions on WidgetTester {
  Future<void> openDrawer() async {
    final ScaffoldState state = firstState(find.byType(Scaffold));
    state.openDrawer();
    await pumpAndSettle(pumpDuration);
  }

  Future<void> goToViaDrawer(IconData iconToTap) async {
    await openDrawer();

    final Finder icon = find.byIcon(iconToTap);
    await ensureVisible(icon);
    await pumpAndSettle(pumpDuration);
    await tap(icon);
    await pumpAndSettle(pumpDuration);
  }

  Future<void> tapOn(Finder finder) async {
    await tap(finder);
    await pumpAndSettle(pumpDuration);
  }

  Future<void> tapOnKey(String key) async {
    await tapOn(find.byKey(Key(key)));
  }

  Future<void> tapOnText(String text) async {
    await tapOn(find.text(text));
  }

  Future<void> goToHome() async {
    await goToViaDrawer(Icons.home);
  }

  Future<void> wait() async {
    await pumpAndSettle(pumpDuration);
  }
}
