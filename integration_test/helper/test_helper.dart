// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/di/di_setup.dart';
import 'package:rabenkorb/features/debug/debug_database_helper.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

const pumpDuration = Duration(milliseconds: 500);

void testErrorHandler(FlutterErrorDetails details) {
  print('Flutter Error: ${details.exception}');
  print('Stack trace: ${details.stack}');
}

Future<void> resetAppState() async {
  await di<PreferenceService>().clear();
  await di<IntlStateService>().init();
  di<LibraryStateService>().init();
  di<BasketStateService>().init();
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
