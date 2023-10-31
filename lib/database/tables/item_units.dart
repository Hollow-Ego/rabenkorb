import 'package:drift/drift.dart';

@DataClassName('ItemUnit')
class ItemUnits extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();
}