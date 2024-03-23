import 'package:rabenkorb/database/database.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateService {
  static final _db = di<AppDatabase>();

  Future<int> createItemTemplate(
    String name, {
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    String? imagePath,
  }) {
    return _db.itemTemplatesDao.createItemTemplate(
      name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );
  }

  Future<void> updateItemTemplate(int id, String name) {
    return _db.itemTemplatesDao.updateItemTemplate(id, name);
  }

  Future<ItemTemplate?> getItemTemplateById(int id) {
    return _db.itemTemplatesDao.getItemTemplateWithId(id);
  }

  Future<int> deleteItemTemplateById(int id) {
    return _db.itemTemplatesDao.deleteItemTemplateWithId(id);
  }

  Stream<List<ItemTemplate>> watchItemTemplates() {
    return _db.itemTemplatesDao.watchItemTemplates();
  }
}
