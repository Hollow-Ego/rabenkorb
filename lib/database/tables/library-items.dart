import 'package:drift/drift.dart';

class LibraryItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 6, max: 32)();
}