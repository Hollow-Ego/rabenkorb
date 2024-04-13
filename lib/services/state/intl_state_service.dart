import 'package:flutter/cupertino.dart';
import 'package:rabenkorb/abstracts/preference_service.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/preference_keys.dart';
import 'package:watch_it/watch_it.dart';

class IntlStateService extends ChangeNotifier {
  final _prefs = di<PreferenceService>();

  Locale get locale => _locale;
  late Locale _locale;

  Future<void> setLocale(Locale locale) async {
    await S.load(locale);
    await _prefs.setString(PreferenceKeys.intlLocale, locale.toLanguageTag());
    _locale = locale;
    notifyListeners();
  }

  Future<void> init() async {
    final languageTag = _prefs.getString(PreferenceKeys.intlLocale);
    final locale = S.delegate.supportedLocales.firstWhere(
      (l) => l.toLanguageTag() == languageTag,
      orElse: () => S.delegate.supportedLocales.first,
    );

    await setLocale(locale);
  }
}
