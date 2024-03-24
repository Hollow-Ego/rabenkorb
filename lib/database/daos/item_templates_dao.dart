import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_templates.dart';
import 'package:rabenkorb/models/grouped_items.dart';
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

  Stream<List<GroupedItems>> watchItemTemplatesInOrder(
    SortMode sortMode, {
    int? sortRuleId,
  }) {
    final otherQuery = select(itemTemplates).join([
      leftOuterJoin(
          itemCategories, itemTemplates.category.equalsExp(itemCategories.id)),
      leftOuterJoin(
          attachedDatabase.sortOrders,
          itemTemplates.category
                  .equalsExp(attachedDatabase.sortOrders.categoryId) &
              attachedDatabase.sortOrders.ruleId.equalsNullable(sortRuleId)),
    ]);
    otherQuery.orderBy([
      OrderingTerm(
          expression: itemCategories.id.isNull(), mode: OrderingMode.asc),
      OrderingTerm(
          expression: attachedDatabase.sortOrders.sortOrder.isNull(),
          mode: OrderingMode.asc),
      ..._getOrderingTerms(sortMode),
    ]);

    // Mapping the query result to a stream of grouped items
    return otherQuery.watch().map((rows) {
      // A map to hold categories and their corresponding items
      final Map<int, GroupedItems> groupedItems = {};
      for (final row in rows) {
        final template = row.readTable(itemTemplates);
        final category = row.readTableOrNull(itemCategories) ??
            const ItemCategory(id: 0, name: "Without Category");
        groupedItems.putIfAbsent(
            category.id, () => GroupedItems(category: category, items: []));
        groupedItems[category.id]!.items.add(template);
      }

      // Convert the map to a list of GroupedItems
      return groupedItems.values.toList();
    });
  }

  List<OrderingTerm> _getOrderingTerms<T>(
    SortMode sortMode,
  ) {
    switch (sortMode) {
      case SortMode.databaseOrder:
        return [_byId()];
      case SortMode.name:
        return [_byCategoryName()];
      case SortMode.custom:
        return [_bySortOrder()];
    }
  }

  OrderingTerm _byCategoryName() {
    return OrderingTerm(expression: itemCategories.name);
  }

  OrderingTerm _byId() {
    return OrderingTerm(expression: itemTemplates.id);
  }

  OrderingTerm _bySortOrder() {
    return OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder);
  }
}
