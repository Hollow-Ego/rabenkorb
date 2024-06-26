import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_units.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';

part 'item_units_dao.g.dart';

@DriftAccessor(tables: [ItemUnits])
class ItemUnitsDao extends DatabaseAccessor<AppDatabase> with _$ItemUnitsDaoMixin {
  ItemUnitsDao(super.db);

  Future<int> createItemUnit(String name) {
    return into(itemUnits).insert(ItemUnitsCompanion(name: Value(name)));
  }

  Future<void> updateItemUnit(int id, String name) {
    return update(itemUnits).replace(ItemUnit(id: id, name: name));
  }

  Stream<ItemUnitViewModel?> watchItemUnitWithId(int id) {
    return (select(itemUnits)..where((li) => li.id.equals(id))).watchSingle().map((unit) => toItemUnitViewModel(unit));
  }

  Future<ItemUnitViewModel?> getItemUnitWithId(int id) async {
    final unit = await (select(itemUnits)..where((li) => li.id.equals(id))).getSingleOrNull();
    return toItemUnitViewModel(unit);
  }

  Future<int> deleteItemUnitWithId(int id) {
    return (delete(itemUnits)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ItemUnitViewModel>> watchItemUnits() {
    return (select(itemUnits)..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
        .watch()
        .map((units) => units.map((unit) => toItemUnitViewModel(unit)!).toList());
  }
}
