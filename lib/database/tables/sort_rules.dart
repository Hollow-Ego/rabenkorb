import 'package:drift/drift.dart';

enum GroupMode {
  name,
  category,
  unit,
  amount,
  amountAndUnit,
  without,
  external,
  variant
}

@DataClassName('SortRule')
class SortRules extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 32)();

  IntColumn get groupMode => intEnum<GroupMode>()();
}