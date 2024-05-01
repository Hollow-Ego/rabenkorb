// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/di/di_setup.dart';
import 'package:rabenkorb/features/core/debug/debug_database_helper.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

const pumpDuration = Duration(milliseconds: 500);

void testErrorHandler(FlutterErrorDetails details) {
  print('Flutter Error: ${details.exception}');
  print('Stack trace: ${details.stack}');
}

Future<void> resetAppState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  di<IntlStateService>().init();
}

Future<void> setupEverything() async {
  await setupDI();
  FlutterError.onError = testErrorHandler;
}

Future<void> tearDownEverything() async {
  await resetAppState();
  await di<AppDatabase>().close();
  await di.reset(dispose: true);
}

Future<void> setupDatabase() async {
  final db = di<AppDatabase>();
  await clearDatabase(db);
  await seedDatabase(db);
}
