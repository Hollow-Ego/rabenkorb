import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/item_templates.dart';
import 'package:rabenkorb/mappers/to_view_model.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';

part 'item_templates_dao.g.dart';

@DriftAccessor(tables: [ItemTemplates])
class ItemTemplatesDao extends DatabaseAccessor<AppDatabase> with _$ItemTemplatesDaoMixin {
  ItemTemplatesDao(super.db);

  Future<int> createItemTemplate(
    String name, {
    int? categoryId,
    required int libraryId,
    String? imagePath,
  }) {
    final companion = ItemTemplatesCompanion(
      name: Value(name),
      category: Value(categoryId),
      library: Value(libraryId),
      imagePath: Value(imagePath),
    );
    return into(itemTemplates).insert(companion);
  }

  Future<void> updateItemTemplate(
    int id, {
    String? name,
    int? categoryId,
    int? libraryId,
    String? imagePath,
  }) {
    final companion = ItemTemplatesCompanion(
        name: Value.absentIfNull(name),
        category: Value.absentIfNull(categoryId),
        library: Value.absentIfNull(libraryId),
        imagePath: Value.absentIfNull(imagePath));
    return (update(itemTemplates)..where((li) => li.id.equals(id))).write(companion);
  }

  Future<void> replaceItemTemplate(
    int id, {
    required String name,
    int? categoryId,
    required int libraryId,
    String? imagePath,
  }) {
    final newItemTemplate = ItemTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(categoryId),
      library: Value(libraryId),
      imagePath: Value(imagePath),
    );
    return update(itemTemplates).replace(newItemTemplate);
  }

  Stream<ItemTemplateViewModel?> watchItemTemplateWithId(int id) {
    return _joinValues(select(itemTemplates)..where((li) => li.id.equals(id))).watchSingle().map((row) => _rowToViewModel(row));
  }

  Future<ItemTemplateViewModel?> getItemTemplateWithId(int id) async {
    final row = await _joinValues(select(itemTemplates)..where((li) => li.id.equals(id))).getSingleOrNull();
    return _rowToViewModel(row);
  }

  Future<int> deleteItemTemplateWithId(int id) {
    return (delete(itemTemplates)..where((li) => li.id.equals(id))).go();
  }

  Stream<List<ItemTemplateViewModel>> watchItemTemplates() {
    return _joinValues(select(itemTemplates)).watch().map((rows) => _rowsToViewModels(rows));
  }

  Stream<List<GroupedItems<ItemTemplateViewModel>>> watchItemTemplatesInOrder(
    SortMode sortMode,
    SortDirection sortDirection, {
    int? sortRuleId,
    String? searchTerm,
  }) {
    final sourceQuery = select(itemTemplates);

    if (searchTerm != null && searchTerm.isNotEmpty) {
      sourceQuery.where((tbl) => tbl.name.like('%$searchTerm%'));
    }

    final query = _joinValues(
      sourceQuery,
      includeJoins: [
        leftOuterJoin(attachedDatabase.sortOrders,
            itemTemplates.category.equalsExp(attachedDatabase.sortOrders.categoryId) & attachedDatabase.sortOrders.ruleId.equalsNullable(sortRuleId)),
      ],
    );
    query.orderBy([
      OrderingTerm(expression: itemCategories.id.isNull(), mode: toOrderingMode(sortDirection)),
      OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder.isNull(), mode: toOrderingMode(sortDirection)),
      ..._getOrderingTerms(sortMode),
    ]);

    // Mapping the query result to a stream of grouped items
    return query.watch().map((rows) {
      // A map to hold categories and their corresponding items
      final Map<int, GroupedItems<ItemTemplateViewModel>> groupedItems = {};
      for (final row in rows) {
        final viewModel = _rowToViewModel(row)!;
        final category = viewModel.category ?? ItemCategoryViewModel(withoutCategoryId, "Without Category");
        groupedItems.putIfAbsent(category.id, () => GroupedItems(category: category, items: []));
        groupedItems[category.id]!.items.add(viewModel);
      }

      // Convert the map to a list of GroupedItems
      return groupedItems.values.toList();
    });
  }

  Future<List<String>> getImagePaths() {
    final query = select(itemTemplates)..where((t) => t.imagePath.isNotNull());
    return query.map((row) => row.imagePath!).get();
  }

  List<OrderingTerm> _getOrderingTerms<T>(
    SortMode sortMode,
  ) {
    switch (sortMode) {
      case SortMode.databaseOrder:
        return [_byId()];
      case SortMode.name:
        return [_byCategoryName(), _byItemTemplateName()];
      case SortMode.custom:
        return [_bySortOrder(), _byItemTemplateName()];
    }
  }

  OrderingTerm _byCategoryName() {
    return OrderingTerm(expression: itemCategories.name);
  }

  OrderingTerm _byItemTemplateName() {
    return OrderingTerm(expression: itemTemplates.name);
  }

  OrderingTerm _byId() {
    return OrderingTerm(expression: itemTemplates.id);
  }

  OrderingTerm _bySortOrder() {
    return OrderingTerm(expression: attachedDatabase.sortOrders.sortOrder);
  }

  JoinedSelectStatement<HasResultSet, dynamic> _joinValues(
    SimpleSelectStatement<$ItemTemplatesTable, ItemTemplate> sourceQuery, {
    List<Join<HasResultSet, dynamic>> includeJoins = const [],
  }) {
    return sourceQuery.join([
      leftOuterJoin(itemCategories, itemTemplates.category.equalsExp(itemCategories.id)),
      leftOuterJoin(templateLibraries, itemTemplates.library.equalsExp(templateLibraries.id)),
      ...includeJoins,
    ]);
  }

  List<ItemTemplateViewModel> _rowsToViewModels(List<TypedResult> rows) {
    return rows.map((row) => _rowToViewModel(row)!).toList();
  }

  ItemTemplateViewModel? _rowToViewModel(TypedResult? row) {
    if (row == null) {
      return null;
    }
    final item = row.readTable(itemTemplates);
    final category = row.readTableOrNull(itemCategories);
    final library = row.readTable(templateLibraries);
    return toItemTemplateViewModel(item, category, library);
  }
}
