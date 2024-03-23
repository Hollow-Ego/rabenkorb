import 'package:rabenkorb/database/database.dart';
import 'package:watch_it/watch_it.dart';

class ItemCategoryService {
  static final _db = di<AppDatabase>();

  Future<int> createItemCategory(String name) {
    return _db.itemCategoriesDao.createItemCategory(name);
  }

  Future<void> updateItemCategory(int id, String name) {
    return _db.itemCategoriesDao.updateItemCategory(id, name);
  }

  Future<ItemCategory?> getItemCategoryById(int id) {
    return _db.itemCategoriesDao.getItemCategoryWithId(id);
  }

  Future<int> deleteItemCategoryById(int id) {
    return _db.itemCategoriesDao.deleteItemCategoryWithId(id);
  }

  Stream<List<ItemCategory>> watchItemCategoies() {
    return _db.itemCategoriesDao.watchItemCategories();
  }
}
