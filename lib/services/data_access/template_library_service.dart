import 'package:rabenkorb/database/database.dart';
import 'package:watch_it/watch_it.dart';

class TemplateLibraryService {
  static final _db = di<AppDatabase>();

  Future<int> createTemplateLibrary(String name) {
    return _db.templateLibrariesDao.createTemplateLibrary(name);
  }

  Future<void> updateTemplateLibrary(int id, String name) {
    return _db.templateLibrariesDao.updateTemplateLibrary(id, name);
  }

  Future<TemplateLibrary?> getTemplateLibraryById(int id) {
    return _db.templateLibrariesDao.getTemplateLibraryWithId(id);
  }

  Future<int> deleteTemplateLibraryById(int id) {
    return _db.templateLibrariesDao.deleteTemplateLibraryWithId(id);
  }

  Stream<List<TemplateLibrary>> watchTemplateLibraries() {
    return _db.templateLibrariesDao.watchTemplateLibraries();
  }
}
