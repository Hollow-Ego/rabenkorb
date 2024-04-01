import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:watch_it/watch_it.dart';

class ItemCategoryService {
  final _db = di<AppDatabase>();

  Future<int> createItemCategory(String name) {
    return _db.itemCategoriesDao.createItemCategory(name);
  }

  Future<void> updateItemCategory(int id, String name) {
    return _db.itemCategoriesDao.updateItemCategory(id, name);
  }

  Future<ItemCategoryViewModel?> getItemCategoryById(int id) {
    return _db.itemCategoriesDao.getItemCategoryWithId(id);
  }

  Future<int> deleteItemCategoryById(int id) {
    return _db.itemCategoriesDao.deleteItemCategoryWithId(id);
  }

  Stream<List<ItemCategoryViewModel>> watchItemCategories() {
    return _db.itemCategoriesDao.watchItemCategories();
  }
}
