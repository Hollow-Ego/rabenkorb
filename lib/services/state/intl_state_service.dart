import 'package:flutter/cupertino.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class IntlStateService {
  final _prefs = di<PreferenceService>();

  Stream<Locale?> get locale => _locale.stream.distinct();

  Locale? get localeSync => _locale.value;

  final BehaviorSubject<Locale?> _locale = BehaviorSubject<Locale?>();

  Future<void> setLocale(Locale locale) async {
    await S.load(locale);
    await _prefs.setString(PreferenceKeys.intlLocale, locale.toLanguageTag());
    _locale.add(locale);
  }

  Future<void> init() async {
    final languageTag = _prefs.getString(PreferenceKeys.intlLocale);
    final locale = S.delegate.supportedLocales.firstWhere(
      (l) => l.toLanguageTag() == languageTag,
      orElse: () => S.delegate.supportedLocales.first,
    );
    await setLocale(locale);
  }

  String getDisplayName(Locale? locale) {
    if (locale == null) {
      return S.current.MissingString;
    }
    switch (locale.toString()) {
      case 'de_DE':
        return 'Deutsch';
      case 'en':
      case 'en_GB':
      case 'en_US':
        return 'English';
      default:
        return S.current.MissingString;
    }
  }
}
