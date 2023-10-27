import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rabenkorb/database/tables/library-items.dart';

part 'database.g.dart';

@DriftDatabase(tables: [LibraryItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor? e) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> createLibraryItem(String name) {
    return into(libraryItems).insert(LibraryItemsCompanion.insert(name: name));
  }

  Future<void> updateLibraryItem(int id, String name){
    return update(libraryItems).replace(LibraryItem(id: id, name: name));
  }

  Stream<LibraryItem> watchLibraryItemWithId(int id){
    return (select(libraryItems)..where((li) => li.id.equals(id))).watchSingle();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

