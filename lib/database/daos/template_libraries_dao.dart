import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/template_libraries.dart';

part 'template_libraries_dao.g.dart';

@DriftAccessor(tables: [TemplateLibraries])
class TemplateLibrariesDao extends DatabaseAccessor<AppDatabase> with _$TemplateLibrariesDaoMixin {
  TemplateLibrariesDao(super.db);
}
