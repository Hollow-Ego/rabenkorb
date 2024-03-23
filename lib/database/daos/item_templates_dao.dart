import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_templates.dart';
import 'package:rabenkorb/shared/sort_mode.dart';

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

  Future<void> updateItemTemplate(
    int id, {
    String? name,
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    String? imagePath,
  }) {
    final companion = ItemTemplatesCompanion(
        name: Value.absentIfNull(name),
        category: Value.absentIfNull(categoryId),
        library: Value.absentIfNull(libraryId),
        variantKey: Value.absentIfNull(variantKeyId),
        imagePath: Value.absentIfNull(imagePath));
    return (update(itemTemplates)..where((li) => li.id.equals(id)))
        .write(companion);
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

  Stream<List<ItemTemplate>> watchItemTemplatesInOrder(SortMode sortMode) {
    final query = (select(itemTemplates)..orderBy(_getOrderingTerms(sortMode)));
    return query.watch();
  }

  List<OrderingTerm Function($ItemTemplatesTable)> _getOrderingTerms<T>(
      SortMode sortMode) {
    switch (sortMode) {
      case SortMode.databaseOrder:
        return [_byId];
      case SortMode.name:
        return [_byName];
      case SortMode.custom:
        return [];
    }
  }

  OrderingTerm _byName($ItemTemplatesTable t) {
    return OrderingTerm(expression: t.name);
  }

  OrderingTerm _byId($ItemTemplatesTable t) {
    return OrderingTerm(expression: t.id);
  }
}
