// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get LanguageDisplayName {
    return Intl.message(
      'English',
      name: 'LanguageDisplayName',
      desc: '',
      args: [],
    );
  }

  /// `Rabenkorb`
  String get AppTitle {
    return Intl.message(
      'Rabenkorb',
      name: 'AppTitle',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get Menu {
    return Intl.message(
      'Menu',
      name: 'Menu',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `General Settings`
  String get SettingsGeneral {
    return Intl.message(
      'General Settings',
      name: 'SettingsGeneral',
      desc: '',
      args: [],
    );
  }

  /// `Library Settings`
  String get SettingsLibrary {
    return Intl.message(
      'Library Settings',
      name: 'SettingsLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Basket Settings`
  String get SettingsBasket {
    return Intl.message(
      'Basket Settings',
      name: 'SettingsBasket',
      desc: '',
      args: [],
    );
  }

  /// `Always Collapse Headers`
  String get AlwaysCollapseCategories {
    return Intl.message(
      'Always Collapse Headers',
      name: 'AlwaysCollapseCategories',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to see`
  String get EmptyMessage {
    return Intl.message(
      'Nothing to see',
      name: 'EmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Basket`
  String get Basket {
    return Intl.message(
      'Basket',
      name: 'Basket',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get Library {
    return Intl.message(
      'Library',
      name: 'Library',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get Item {
    return Intl.message(
      'Item',
      name: 'Item',
      desc: '',
      args: [],
    );
  }

  /// `Template`
  String get Template {
    return Intl.message(
      'Template',
      name: 'Template',
      desc: '',
      args: [],
    );
  }

  /// `Unnamed`
  String get Unnamed {
    return Intl.message(
      'Unnamed',
      name: 'Unnamed',
      desc: '',
      args: [],
    );
  }

  /// `<Empty>`
  String get MissingString {
    return Intl.message(
      '<Empty>',
      name: 'MissingString',
      desc: '',
      args: [],
    );
  }

  /// `Debug`
  String get Debug {
    return Intl.message(
      'Debug',
      name: 'Debug',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get Backup {
    return Intl.message(
      'Backup',
      name: 'Backup',
      desc: '',
      args: [],
    );
  }

  /// `Create Backup`
  String get BackupCreate {
    return Intl.message(
      'Create Backup',
      name: 'BackupCreate',
      desc: '',
      args: [],
    );
  }

  /// `Set Permission`
  String get SetPermission {
    return Intl.message(
      'Set Permission',
      name: 'SetPermission',
      desc: '',
      args: [],
    );
  }

  /// `Permissions required`
  String get PermissionsRequired {
    return Intl.message(
      'Permissions required',
      name: 'PermissionsRequired',
      desc: '',
      args: [],
    );
  }

  /// `To access folders for saving or loading backup this app the permission to access files and folders. This app will never access any files that are not related to it. \n\nIf you click on "Set Permission" you will be redirect to the permission screen of your phone. Please set the permission and return to this app by pressing the Back Button of your Smartphone.`
  String get MessagePermissionRequired {
    return Intl.message(
      'To access folders for saving or loading backup this app the permission to access files and folders. This app will never access any files that are not related to it. \n\nIf you click on "Set Permission" you will be redirect to the permission screen of your phone. Please set the permission and return to this app by pressing the Back Button of your Smartphone.',
      name: 'MessagePermissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message(
      'Confirm',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de', countryCode: 'DE'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
