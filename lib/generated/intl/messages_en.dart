// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(itemName) => "${itemName} added";

  static String m1(direction) => "${Intl.select(direction, {
            'asc': 'Ascending',
            'desc': 'Descending',
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Add": MessageLookupByLibrary.simpleMessage("Add"),
        "AlwaysCollapseCategories": MessageLookupByLibrary.simpleMessage("Always Collapse Headers"),
        "Amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "AppTitle": MessageLookupByLibrary.simpleMessage("Rabenkorb"),
        "Backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "BackupCreate": MessageLookupByLibrary.simpleMessage("Create Backup"),
        "Basket": MessageLookupByLibrary.simpleMessage("Basket"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "Category": MessageLookupByLibrary.simpleMessage("Category"),
        "ChooseSource": MessageLookupByLibrary.simpleMessage("Choose the source"),
        "ClearImage": MessageLookupByLibrary.simpleMessage("Clear image"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "ConfirmDeleteAllItems": MessageLookupByLibrary.simpleMessage("Are you sure you want to delete all items?"),
        "Debug": MessageLookupByLibrary.simpleMessage("Debug"),
        "Delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "DeleteAll": MessageLookupByLibrary.simpleMessage("Delete all"),
        "DeleteMarked": MessageLookupByLibrary.simpleMessage("Delete marked items"),
        "DeleteSelected": MessageLookupByLibrary.simpleMessage("Delete selected"),
        "DeselectAll": MessageLookupByLibrary.simpleMessage("Deselect all"),
        "Edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "EmptyMessage": MessageLookupByLibrary.simpleMessage("Nothing to see"),
        "EnterMultiSelect": MessageLookupByLibrary.simpleMessage("Select multiple"),
        "FromGallery": MessageLookupByLibrary.simpleMessage("From Gallery"),
        "Home": MessageLookupByLibrary.simpleMessage("Home"),
        "Image": MessageLookupByLibrary.simpleMessage("Image"),
        "Item": MessageLookupByLibrary.simpleMessage("Item"),
        "ItemAddedToCard": m0,
        "Language": MessageLookupByLibrary.simpleMessage("Language"),
        "LanguageDisplayName": MessageLookupByLibrary.simpleMessage("English"),
        "Library": MessageLookupByLibrary.simpleMessage("Library"),
        "Menu": MessageLookupByLibrary.simpleMessage("Menu"),
        "MessagePermissionRequired": MessageLookupByLibrary.simpleMessage(
            "To access folders for saving or loading backup this app the permission to access files and folders. This app will never access any files that are not related to it. \n\nIf you click on \"Set Permission\" you will be redirect to the permission screen of your phone. Please set the permission and return to this app by pressing the Back Button of your Smartphone."),
        "MissingString": MessageLookupByLibrary.simpleMessage("<Empty>"),
        "Name": MessageLookupByLibrary.simpleMessage("Name"),
        "NameMustNotBeEmpty": MessageLookupByLibrary.simpleMessage("Name must not be empty"),
        "New": MessageLookupByLibrary.simpleMessage("New"),
        "NewItem": MessageLookupByLibrary.simpleMessage("New Item"),
        "NoSearchResult": MessageLookupByLibrary.simpleMessage("No results"),
        "NoShoppingBasketSelected": MessageLookupByLibrary.simpleMessage("No basket selected"),
        "PermissionsRequired": MessageLookupByLibrary.simpleMessage("Permissions required"),
        "PickImage": MessageLookupByLibrary.simpleMessage("Pick an image"),
        "Save": MessageLookupByLibrary.simpleMessage("Save"),
        "SearchLabel": MessageLookupByLibrary.simpleMessage("Search..."),
        "SelectAll": MessageLookupByLibrary.simpleMessage("Select all"),
        "SetPermission": MessageLookupByLibrary.simpleMessage("Set Permission"),
        "Settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "SettingsBasket": MessageLookupByLibrary.simpleMessage("Basket Settings"),
        "SettingsGeneral": MessageLookupByLibrary.simpleMessage("General Settings"),
        "SettingsLibrary": MessageLookupByLibrary.simpleMessage("Library Settings"),
        "SortByDatabaseOrder": MessageLookupByLibrary.simpleMessage("Creation"),
        "SortByName": MessageLookupByLibrary.simpleMessage("Name"),
        "SortDirection": m1,
        "TakePicture": MessageLookupByLibrary.simpleMessage("Take Picture"),
        "Template": MessageLookupByLibrary.simpleMessage("Template"),
        "Unit": MessageLookupByLibrary.simpleMessage("Unit"),
        "Unnamed": MessageLookupByLibrary.simpleMessage("Unnamed"),
        "Variant": MessageLookupByLibrary.simpleMessage("Variant")
      };
}
