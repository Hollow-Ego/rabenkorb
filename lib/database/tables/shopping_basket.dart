import 'package:drift/drift.dart';

@DataClassName('ShoppingBasket')
class ShoppingBaskets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  BoolColumn get useAsGroup => boolean()();
}
