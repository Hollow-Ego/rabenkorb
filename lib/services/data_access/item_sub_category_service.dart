import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/item_sub_category_view_model.dart';
import 'package:watch_it/watch_it.dart';

class ItemSubCategoryService {
  final _db = di<AppDatabase>();

  Future<int> createItemSubCategory(String name) {
    return _db.itemSubCategoriesDao.createItemSubCategory(name);
  }

  Future<void> updateItemSubCategory(int id, String name) {
    return _db.itemSubCategoriesDao.updateItemSubCategory(id, name);
  }

  Future<ItemSubCategoryViewModel?> getItemSubCategoryById(int id) {
    return _db.itemSubCategoriesDao.getItemSubCategoryWithId(id);
  }

  Future<int> deleteItemSubCategoryById(int id) {
    return _db.itemSubCategoriesDao.deleteItemSubCategoryWithId(id);
  }

  Stream<List<ItemSubCategoryViewModel>> watchItemSubCategories() {
    return _db.itemSubCategoriesDao.watchItemSubCategories();
  }
}
