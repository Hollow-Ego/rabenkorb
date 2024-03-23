import 'package:drift/native.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:watch_it/watch_it.dart';

void setupDI() {
  _registerDatabase();
  _registerServices();
}

void _registerDatabase() {
  final db = AppDatabase(NativeDatabase.memory());
  di.registerSingleton<AppDatabase>(db);
}

void _registerServices() {
  di.registerSingleton<TemplateLibraryService>(TemplateLibraryService());
}
