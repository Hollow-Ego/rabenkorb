import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_templates.dart';

part 'item_templates_dao.g.dart';

@DriftAccessor(tables: [ItemTemplates])
class ItemTemplatesDao extends DatabaseAccessor<AppDatabase>
    with _$ItemTemplatesDaoMixin {
  ItemTemplatesDao(super.db);

  Future<int> createItemTemplate(
    String name, {
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    String? imagePath,
  }) {
    final companion = ItemTemplatesCompanion(
        name: Value(name),
        category: Value(categoryId),
        library: Value(libraryId),
        variantKey: Value(variantKeyId),
        imagePath: Value(imagePath));
    return into(itemTemplates).insert(companion);
  }

  Future<void> updateItemTemplate(int id, String name) {
    return update(itemTemplates).replace(ItemTemplate(id: id, name: name));
  }

  Stream<ItemTemplate> watchItemTemplateWithId(int id) {
    return (select(itemTemplates)..where((li) => li.id.equals(id)))
        .watchSingle();
  }

  Future<ItemTemplate?> getItemTemplateWithId(int id) {
    return (select(itemTemplates)..where((li) => li.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> deleteItemTemplateWithId(int id) {
    return (delete(itemTemplates)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ItemTemplate>> watchItemTemplates() {
    return (select(itemTemplates)).watch();
  }
}
