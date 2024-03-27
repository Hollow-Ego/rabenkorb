import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';

part 'template_libraries_dao.g.dart';

@DriftAccessor(tables: [TemplateLibraries])
class TemplateLibrariesDao extends DatabaseAccessor<AppDatabase> with _$TemplateLibrariesDaoMixin {
  TemplateLibrariesDao(super.db);

  Future<int> createTemplateLibrary(String name) {
    return into(templateLibraries).insert(TemplateLibrariesCompanion(name: Value(name)));
  }

  Future<void> updateTemplateLibrary(int id, String name) {
    return update(templateLibraries).replace(TemplateLibrary(id: id, name: name));
  }

  Stream<TemplateLibrary> watchTemplateLibraryWithId(int id) {
    return (select(templateLibraries)..where((li) => li.id.equals(id))).watchSingle();
  }

  Future<TemplateLibrary?> getTemplateLibraryWithId(int id) {
    return (select(templateLibraries)..where((li) => li.id.equals(id))).getSingleOrNull();
  }

  Future<int> deleteTemplateLibraryWithId(int id) {
    return (delete(templateLibraries)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<TemplateLibrary>> watchTemplateLibraries() {
    return (select(templateLibraries)).watch();
  }
}
