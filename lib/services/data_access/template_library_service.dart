import 'package:rabenkorb/database/database.dart';
import 'package:watch_it/watch_it.dart';

class TemplateLibraryService {
  static final _db = di<AppDatabase>();

  Future<int> createItemTemplate(String name) {
    return _db.itemTemplatesDao.createItemTemplate(name);
  }

  Future<void> updateItemTemplate(int id, String name) {
    return _db.itemTemplatesDao.updateItemTemplate(id, name);
  }

  Future<ItemTemplate?> getItemTemplateById(int id) {
    return _db.itemTemplatesDao.getItemTemplateWithId(id);
  }
}
