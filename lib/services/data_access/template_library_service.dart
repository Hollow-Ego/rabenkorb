import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';
import 'package:watch_it/watch_it.dart';

class TemplateLibraryService {
  final _db = di<AppDatabase>();

  Future<int> createTemplateLibrary(String name) {
    return _db.templateLibrariesDao.createTemplateLibrary(name);
  }

  Future<void> updateTemplateLibrary(int id, String name) {
    return _db.templateLibrariesDao.updateTemplateLibrary(id, name);
  }

  Future<TemplateLibraryViewModel?> getTemplateLibraryById(int id) {
    return _db.templateLibrariesDao.getTemplateLibraryWithId(id);
  }

  Future<int?> getFirstTemplateLibraryId() {
    return _db.templateLibrariesDao.getFirstTemplateLibraryId();
  }

  Future<int> deleteTemplateLibraryById(int id) {
    return _db.templateLibrariesDao.deleteTemplateLibraryWithId(id);
  }

  Stream<List<TemplateLibraryViewModel>> watchTemplateLibraries() {
    return _db.templateLibrariesDao.watchTemplateLibraries();
  }
}
