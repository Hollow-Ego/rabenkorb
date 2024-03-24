import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:watch_it/watch_it.dart';

void setupDI() {
  _registerDatabase();
  _registerServices();
}

void _registerDatabase() {
  final db = AppDatabase();
  di.registerSingleton<AppDatabase>(db);
}

void _registerServices() {
  di.registerSingleton<ItemTemplateService>(ItemTemplateService());
}
