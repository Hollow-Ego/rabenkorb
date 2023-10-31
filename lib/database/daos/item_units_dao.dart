import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_units.dart';

part 'item_units_dao.g.dart';

@DriftAccessor(tables: [ItemUnits])
class ItemUnitsDao extends DatabaseAccessor<AppDatabase> with _$ItemUnitsDaoMixin {
  ItemUnitsDao(super.db);
}
