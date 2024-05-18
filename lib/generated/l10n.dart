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

  /// `Basket Overview`
  String get BasketOverview {
    return Intl.message(
      'Basket Overview',
      name: 'BasketOverview',
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

  /// `Data Management`
  String get DataManagement {
    return Intl.message(
      'Data Management',
      name: 'DataManagement',
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

  /// `Items`
  String get Items {
    return Intl.message(
      'Items',
      name: 'Items',
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

  /// `Create`
  String get BackupCreate {
    return Intl.message(
      'Create',
      name: 'BackupCreate',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get BackupImport {
    return Intl.message(
      'Restore',
      name: 'BackupImport',
      desc: '',
      args: [],
    );
  }

  /// `Backup Options`
  String get BackupOption {
    return Intl.message(
      'Backup Options',
      name: 'BackupOption',
      desc: '',
      args: [],
    );
  }

  /// `Overwrite existing data`
  String get BackupOverwriteExisting {
    return Intl.message(
      'Overwrite existing data',
      name: 'BackupOverwriteExisting',
      desc: '',
      args: [],
    );
  }

  /// `By importing a backup your current state will be overwritten! Uncheck the option for overwriting data above, if you want to add the imported data to your library.`
  String get BackupOverwriteWarning {
    return Intl.message(
      'By importing a backup your current state will be overwritten! Uncheck the option for overwriting data above, if you want to add the imported data to your library.',
      name: 'BackupOverwriteWarning',
      desc: '',
      args: [],
    );
  }

  /// `Import failed!`
  String get BackupImportFailed {
    return Intl.message(
      'Import failed!',
      name: 'BackupImportFailed',
      desc: '',
      args: [],
    );
  }

  /// `Backup created successfully`
  String get BackupCreated {
    return Intl.message(
      'Backup created successfully',
      name: 'BackupCreated',
      desc: '',
      args: [],
    );
  }

  /// `Backup imported successfully`
  String get BackupImported {
    return Intl.message(
      'Backup imported successfully',
      name: 'BackupImported',
      desc: '',
      args: [],
    );
  }

  /// `Select backup location`
  String get SelectBackup {
    return Intl.message(
      'Select backup location',
      name: 'SelectBackup',
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

  /// `Search...`
  String get SearchLabel {
    return Intl.message(
      'Search...',
      name: 'SearchLabel',
      desc: '',
      args: [],
    );
  }

  /// `{direction, select, asc{Ascending} desc{Descending}}`
  String SortDirection(String direction) {
    return Intl.select(
      direction,
      {
        'asc': 'Ascending',
        'desc': 'Descending',
      },
      name: 'SortDirection',
      desc: 'The human readable sort direction',
      args: [direction],
    );
  }

  /// `Name`
  String get SortByName {
    return Intl.message(
      'Name',
      name: 'SortByName',
      desc: '',
      args: [],
    );
  }

  /// `Creation`
  String get SortByDatabaseOrder {
    return Intl.message(
      'Creation',
      name: 'SortByDatabaseOrder',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get Category {
    return Intl.message(
      'Category',
      name: 'Category',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get Categories {
    return Intl.message(
      'Categories',
      name: 'Categories',
      desc: '',
      args: [],
    );
  }

  /// `Variant`
  String get Variant {
    return Intl.message(
      'Variant',
      name: 'Variant',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get Image {
    return Intl.message(
      'Image',
      name: 'Image',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get Amount {
    return Intl.message(
      'Amount',
      name: 'Amount',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get Unit {
    return Intl.message(
      'Unit',
      name: 'Unit',
      desc: '',
      args: [],
    );
  }

  /// `Units`
  String get Units {
    return Intl.message(
      'Units',
      name: 'Units',
      desc: '',
      args: [],
    );
  }

  /// `New Item`
  String get NewItem {
    return Intl.message(
      'New Item',
      name: 'NewItem',
      desc: '',
      args: [],
    );
  }

  /// `No results`
  String get NoSearchResult {
    return Intl.message(
      'No results',
      name: 'NoSearchResult',
      desc: '',
      args: [],
    );
  }

  /// `Name must not be empty`
  String get NameMustNotBeEmpty {
    return Intl.message(
      'Name must not be empty',
      name: 'NameMustNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Choose the source`
  String get ChooseSource {
    return Intl.message(
      'Choose the source',
      name: 'ChooseSource',
      desc: '',
      args: [],
    );
  }

  /// `Take Picture`
  String get TakePicture {
    return Intl.message(
      'Take Picture',
      name: 'TakePicture',
      desc: '',
      args: [],
    );
  }

  /// `From Gallery`
  String get FromGallery {
    return Intl.message(
      'From Gallery',
      name: 'FromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Clear image`
  String get ClearImage {
    return Intl.message(
      'Clear image',
      name: 'ClearImage',
      desc: '',
      args: [],
    );
  }

  /// `Pick an image`
  String get PickImage {
    return Intl.message(
      'Pick an image',
      name: 'PickImage',
      desc: '',
      args: [],
    );
  }

  /// `{itemName} added`
  String ItemAddedToCard(String itemName) {
    return Intl.message(
      '$itemName added',
      name: 'ItemAddedToCard',
      desc: 'Item added to card snackbar message',
      args: [itemName],
    );
  }

  /// `Select all`
  String get SelectAll {
    return Intl.message(
      'Select all',
      name: 'SelectAll',
      desc: '',
      args: [],
    );
  }

  /// `Deselect all`
  String get DeselectAll {
    return Intl.message(
      'Deselect all',
      name: 'DeselectAll',
      desc: '',
      args: [],
    );
  }

  /// `Delete selected`
  String get DeleteSelected {
    return Intl.message(
      'Delete selected',
      name: 'DeleteSelected',
      desc: '',
      args: [],
    );
  }

  /// `Select multiple`
  String get EnterMultiSelect {
    return Intl.message(
      'Select multiple',
      name: 'EnterMultiSelect',
      desc: '',
      args: [],
    );
  }

  /// `No basket selected`
  String get NoShoppingBasketSelected {
    return Intl.message(
      'No basket selected',
      name: 'NoShoppingBasketSelected',
      desc: '',
      args: [],
    );
  }

  /// `Delete marked items`
  String get DeleteMarked {
    return Intl.message(
      'Delete marked items',
      name: 'DeleteMarked',
      desc: '',
      args: [],
    );
  }

  /// `Delete all`
  String get DeleteAll {
    return Intl.message(
      'Delete all',
      name: 'DeleteAll',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete all items?`
  String get ConfirmDeleteAllItems {
    return Intl.message(
      'Are you sure you want to delete all items?',
      name: 'ConfirmDeleteAllItems',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this basket?`
  String get ConfirmDeleteBasket {
    return Intl.message(
      'Are you sure you want to delete this basket?',
      name: 'ConfirmDeleteBasket',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get Rename {
    return Intl.message(
      'Rename',
      name: 'Rename',
      desc: '',
      args: [],
    );
  }

  /// `New Basket`
  String get NewBasket {
    return Intl.message(
      'New Basket',
      name: 'NewBasket',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get New {
    return Intl.message(
      'New',
      name: 'New',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get Add {
    return Intl.message(
      'Add',
      name: 'Add',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get Edit {
    return Intl.message(
      'Edit',
      name: 'Edit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message(
      'Save',
      name: 'Save',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message(
      'Delete',
      name: 'Delete',
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
