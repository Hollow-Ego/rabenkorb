import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:watch_it/watch_it.dart';

class ItemUnitService {
  final _db = di<AppDatabase>();

  Future<int> createItemUnit(String name) {
    return _db.itemUnitsDao.createItemUnit(name);
  }

  Future<void> updateItemUnit(int id, String name) {
    return _db.itemUnitsDao.updateItemUnit(id, name);
  }

  Future<ItemUnitViewModel?> getItemUnitById(int id) {
    return _db.itemUnitsDao.getItemUnitWithId(id);
  }

  Future<int> deleteItemUnitById(int id) {
    return _db.itemUnitsDao.deleteItemUnitWithId(id);
  }

  Stream<List<ItemUnitViewModel>> watchItemUnits() {
    return _db.itemUnitsDao.watchItemUnits();
  }
}
