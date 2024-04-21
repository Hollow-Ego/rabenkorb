import 'package:drift/drift.dart';

@DataClassName('ItemCategory')
class ItemCategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();
}
