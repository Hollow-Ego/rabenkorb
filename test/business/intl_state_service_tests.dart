import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:watch_it/watch_it.dart';

import '../mock_preferences_service.dart';

void main() {
  late IntlStateService sut;

  setUp(() async {
    di.registerSingleton<PreferenceService>(MockPreferenceService());
    di<PreferenceService>().setString(PreferenceKeys.intlLocale, "de-DE");

    di.registerSingletonAsync<IntlStateService>(() async {
      var intlService = IntlStateService();
      await intlService.init();
      return intlService;
    });
    await di.allReady();
    sut = di<IntlStateService>();
  });

  test("should initialize with locale from shared preferences", () async {
    expect(sut.localeSync?.toLanguageTag(), equals("de-DE"));
  });

  test("should emit each value once per change", () async {
    expectLater(
      sut.locale.map((l) => l?.toLanguageTag()),
      emitsInOrder([
        "de-DE",
        "en-US",
      ]),
    );
    sut.setLocale(const Locale("en", "US"));
    sut.setLocale(const Locale("en", "US"));
  });

  tearDown(() async {
    await di.reset(dispose: true);
  });
}
