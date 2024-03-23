import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_units.dart';

part 'item_units_dao.g.dart';

@DriftAccessor(tables: [ItemUnits])
class ItemUnitsDao extends DatabaseAccessor<AppDatabase>
    with _$ItemUnitsDaoMixin {
  ItemUnitsDao(super.db);

  Future<int> createItemUnit(String name) {
    return into(itemUnits).insert(ItemUnitsCompanion(name: Value(name)));
  }

  Future<void> updateItemUnit(int id, String name) {
    return update(itemUnits).replace(ItemUnit(id: id, name: name));
  }

  Stream<ItemUnit> watchItemUnitWithId(int id) {
    return (select(itemUnits)..where((li) => li.id.equals(id))).watchSingle();
  }

  Future<ItemUnit?> getItemUnitWithId(int id) {
    return (select(itemUnits)..where((li) => li.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> deleteItemUnitWithId(int id) {
    return (delete(itemUnits)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ItemUnit>> watchItemUnits() {
    return (select(itemUnits)).watch();
  }
}
