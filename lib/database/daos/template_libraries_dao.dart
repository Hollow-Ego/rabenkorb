import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';

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

  Stream<TemplateLibraryViewModel?> watchTemplateLibraryWithId(int id) {
    return (select(templateLibraries)..where((li) => li.id.equals(id))).watchSingle().map((library) => toTemplateLibraryViewModel(library));
  }

  Future<TemplateLibraryViewModel?> getTemplateLibraryWithId(int id) async {
    final library = await (select(templateLibraries)..where((li) => li.id.equals(id))).getSingleOrNull();
    return toTemplateLibraryViewModel(library);
  }

  Future<int> deleteTemplateLibraryWithId(int id) {
    return (delete(templateLibraries)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<TemplateLibraryViewModel>> watchTemplateLibraries() {
    return (select(templateLibraries)).watch().map((libraries) => libraries.map((library) => toTemplateLibraryViewModel(library)!).toList());
  }
}
