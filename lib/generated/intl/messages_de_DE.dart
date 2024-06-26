// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de_DE locale. All the
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
  String get localeName => 'de_DE';

  static String m0(itemName) => "${itemName} hinzugefügt";

  static String m1(direction) => "${Intl.select(direction, {
            'asc': 'Aufsteigend',
            'desc': 'Absteigend',
            'other': 'Unbekannt',
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Add": MessageLookupByLibrary.simpleMessage("Hinzufügen"),
        "AddToCart": MessageLookupByLibrary.simpleMessage("Zum Korb hinzufügen"),
        "AlwaysCollapseCategories": MessageLookupByLibrary.simpleMessage("Kategorien immer zuklappen"),
        "Amount": MessageLookupByLibrary.simpleMessage("Menge"),
        "AppTitle": MessageLookupByLibrary.simpleMessage("Rabenkorb"),
        "Backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "BackupCreate": MessageLookupByLibrary.simpleMessage("Erstellen"),
        "BackupCreated": MessageLookupByLibrary.simpleMessage("Backup erfolgrecih erstellt"),
        "BackupCreationFailed": MessageLookupByLibrary.simpleMessage("Backup Erstellung fehlgeschlagen!"),
        "BackupImport": MessageLookupByLibrary.simpleMessage("Wiederherstellen"),
        "BackupImportFailed": MessageLookupByLibrary.simpleMessage("Import fehlgeschlagen!"),
        "BackupImported": MessageLookupByLibrary.simpleMessage("Backup erfolgreich importiert"),
        "BackupOption": MessageLookupByLibrary.simpleMessage("Backup-Optionen"),
        "BackupOverwriteExisting": MessageLookupByLibrary.simpleMessage("Bestehende Daten überschreiben"),
        "BackupOverwriteWarning": MessageLookupByLibrary.simpleMessage(
            "Wenn du ein Backup importierst wird dein derzeitiger Stand überschrieben! Wähle oben die Option zum Überschreiben alter Data ab, wenn du die importierten Daten zu deiner Bibliothek hinzufügen willst."),
        "Basket": MessageLookupByLibrary.simpleMessage("Korb"),
        "BasketOverview": MessageLookupByLibrary.simpleMessage("Korb Übersicht"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "Categories": MessageLookupByLibrary.simpleMessage("Kategorien"),
        "Category": MessageLookupByLibrary.simpleMessage("Kategorie"),
        "ChooseSource": MessageLookupByLibrary.simpleMessage("Quelle wählen"),
        "ClearImage": MessageLookupByLibrary.simpleMessage("Bild zurücksetzen"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "ConfirmDeleteAllItems": MessageLookupByLibrary.simpleMessage("Bist du sicher, dass du alle Artikel löschen willst?"),
        "ConfirmDeleteBasket": MessageLookupByLibrary.simpleMessage("Bist du sicher, dass du diesen Korb löschen willst?"),
        "ConfirmDeleteCategory": MessageLookupByLibrary.simpleMessage("Bist du sicher, dass du diese Kategorie löschen willst?"),
        "ConfirmDeleteSortRule": MessageLookupByLibrary.simpleMessage("Bist du sicher, dass du diese Sortierregel löschen willst?"),
        "ConfirmDeleteUnit": MessageLookupByLibrary.simpleMessage("Bist du sicher, dass du diese Einheit löschen willst?"),
        "DataManagement": MessageLookupByLibrary.simpleMessage("Datenverwaltung"),
        "Debug": MessageLookupByLibrary.simpleMessage("Debug"),
        "Delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "DeleteAll": MessageLookupByLibrary.simpleMessage("Alle löschen"),
        "DeleteMarked": MessageLookupByLibrary.simpleMessage("Markierte Artikel löschen"),
        "DeleteSelected": MessageLookupByLibrary.simpleMessage("Ausgewählte löschen"),
        "DeselectAll": MessageLookupByLibrary.simpleMessage("Alle abwählen"),
        "Edit": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
        "EmptyMessage": MessageLookupByLibrary.simpleMessage("Nichts zu sehen"),
        "EnterMultiSelect": MessageLookupByLibrary.simpleMessage("Mehrere auswählen"),
        "FromGallery": MessageLookupByLibrary.simpleMessage("Aus Gallerie"),
        "Home": MessageLookupByLibrary.simpleMessage("Home"),
        "Image": MessageLookupByLibrary.simpleMessage("Bild"),
        "Item": MessageLookupByLibrary.simpleMessage("Artikel"),
        "ItemAddedToCard": m0,
        "Items": MessageLookupByLibrary.simpleMessage("Artikel"),
        "Language": MessageLookupByLibrary.simpleMessage("Sprache"),
        "LanguageDisplayName": MessageLookupByLibrary.simpleMessage("Deutsch"),
        "Library": MessageLookupByLibrary.simpleMessage("Bibliothek"),
        "Menu": MessageLookupByLibrary.simpleMessage("Menü"),
        "MessagePermissionRequired": MessageLookupByLibrary.simpleMessage(
            "Um auf Ordner zum Speicher oder Laden von Sicherungen zugreifen zu können, benötigt diese App die Berechtigung auf alle Dateien und Ordner zuzugreifen. Diese wird niemals auf Dateien zugreifen, die nicht zu ihr gehören. \n\nWenn Sie auf \"Berechtigung setzen\" drücken werden Sie zur Berechtigungsverwaltung weitergeleitet. Setzen Sie dort die Berechtigung und kehren zur App zurück, indem Sie auf die Zurück-Taste Ihres Smartphones drücken."),
        "MissingString": MessageLookupByLibrary.simpleMessage("<Leer>"),
        "Move": MessageLookupByLibrary.simpleMessage("Verschieben"),
        "MoveSelected": MessageLookupByLibrary.simpleMessage("Ausgewählte verschieben"),
        "MoveTo": MessageLookupByLibrary.simpleMessage("Verschieben nach"),
        "Name": MessageLookupByLibrary.simpleMessage("Name"),
        "NameMustNotBeEmpty": MessageLookupByLibrary.simpleMessage("Name darf nicht leer sein"),
        "New": MessageLookupByLibrary.simpleMessage("Neu"),
        "NewBasket": MessageLookupByLibrary.simpleMessage("Neuer Korb"),
        "NewItem": MessageLookupByLibrary.simpleMessage("Neuer Artikel"),
        "NoSearchResult": MessageLookupByLibrary.simpleMessage("Keine Ergebnisse"),
        "NoSelection": MessageLookupByLibrary.simpleMessage("Keine Auswahl"),
        "NoShoppingBasketSelected": MessageLookupByLibrary.simpleMessage("Keinen Korb ausgewählt"),
        "Note": MessageLookupByLibrary.simpleMessage("Notiz"),
        "PermissionsRequired": MessageLookupByLibrary.simpleMessage("Berechtigungen erforderlich"),
        "PickImage": MessageLookupByLibrary.simpleMessage("Bild auswählen"),
        "Rename": MessageLookupByLibrary.simpleMessage("Umbenennen"),
        "Save": MessageLookupByLibrary.simpleMessage("Speichern"),
        "SearchLabel": MessageLookupByLibrary.simpleMessage("Suchen..."),
        "SelectAll": MessageLookupByLibrary.simpleMessage("Alle auswählen"),
        "SelectBackup": MessageLookupByLibrary.simpleMessage("Backup-Ort auswählen"),
        "SelectSortRule": MessageLookupByLibrary.simpleMessage("Wähle eine Sortierregel aus"),
        "SetPermission": MessageLookupByLibrary.simpleMessage("Berechtigung erteilen"),
        "Settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "SettingsBasket": MessageLookupByLibrary.simpleMessage("Einkaufskorb Einstellungen"),
        "SettingsGeneral": MessageLookupByLibrary.simpleMessage("Allgemeine Einstellungen"),
        "SettingsLibrary": MessageLookupByLibrary.simpleMessage("Bibliothek Einstellungen"),
        "SortByDatabaseOrder": MessageLookupByLibrary.simpleMessage("Erstellung"),
        "SortByName": MessageLookupByLibrary.simpleMessage("Name"),
        "SortDirection": m1,
        "SortRule": MessageLookupByLibrary.simpleMessage("Sortierregel"),
        "SortRules": MessageLookupByLibrary.simpleMessage("Sortierregeln"),
        "SubCategories": MessageLookupByLibrary.simpleMessage("Unterkategorien"),
        "SubCategory": MessageLookupByLibrary.simpleMessage("Unterkategorie"),
        "TakePicture": MessageLookupByLibrary.simpleMessage("Bild aufnehmen"),
        "Template": MessageLookupByLibrary.simpleMessage("Template"),
        "Unit": MessageLookupByLibrary.simpleMessage("Einheit"),
        "Units": MessageLookupByLibrary.simpleMessage("Einheiten"),
        "Unnamed": MessageLookupByLibrary.simpleMessage("Unbenannt"),
        "Variant": MessageLookupByLibrary.simpleMessage("Variante")
      };
}
