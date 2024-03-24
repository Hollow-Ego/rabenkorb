import 'package:rabenkorb/database/database.dart';
import 'package:watch_it/watch_it.dart';

class ItemUnitService {
  final _db = di<AppDatabase>();

  Future<int> createItemUnit(String name) {
    return _db.itemUnitsDao.createItemUnit(name);
  }

  Future<void> updateItemUnit(int id, String name) {
    return _db.itemUnitsDao.updateItemUnit(id, name);
  }

  Future<ItemUnit?> getItemUnitById(int id) {
    return _db.itemUnitsDao.getItemUnitWithId(id);
  }

  Future<int> deleteItemUnitById(int id) {
    return _db.itemUnitsDao.deleteItemUnitWithId(id);
  }

  Stream<List<ItemUnit>> watchItemUnits() {
    return _db.itemUnitsDao.watchItemUnits();
  }
}
