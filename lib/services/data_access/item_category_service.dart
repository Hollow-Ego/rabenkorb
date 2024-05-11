import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/save_delete_result.dart';
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

  Future<SaveDeleteResult<ItemCategoryViewModel>> savelyDeleteItemCategoryById(int id) async {
    final itemCategoryToDelete = await _db.itemCategoriesDao.getItemCategoryWithId(id);
    final deletedRows = await _db.itemCategoriesDao.deleteItemCategoryWithId(id);
    return SaveDeleteResult(
      deletedObject: itemCategoryToDelete,
      deletedRows: deletedRows,
    );
  }

  Stream<List<ItemCategoryViewModel>> watchItemCategories() {
    return _db.itemCategoriesDao.watchItemCategories();
  }
}
