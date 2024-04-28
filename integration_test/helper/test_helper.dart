// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const pumpDuration = Duration(milliseconds: 500);

Future<void> openDrawer(WidgetTester tester) async {
  final ScaffoldState state = tester.firstState(find.byType(Scaffold));
  state.openDrawer();
  await tester.pump(pumpDuration);
}

Future<void> goToViaDrawer(WidgetTester tester, IconData iconToTap) async {
  await openDrawer(tester);

  final Finder icon = find.byIcon(iconToTap);
  await tester.ensureVisible(icon);
  await tester.pump(pumpDuration);
  await tester.tap(icon);
  await tester.pump(pumpDuration);
}

Future<void> tapOn(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pump(pumpDuration);
}

Future<void> tapOnKey(WidgetTester tester, String key) async {
  await tapOn(tester, find.byKey(Key(key)));
}

Future<void> tapOnText(WidgetTester tester, String text) async {
  await tapOn(tester, find.text(text));
}

void testErrorHandler(FlutterErrorDetails details) {
  print('Flutter Error: ${details.exception}');
  print('Stack trace: ${details.stack}');
}
