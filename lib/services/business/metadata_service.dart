import 'dart:async';

import 'package:rabenkorb/exceptions/missing_category.dart';
import 'package:rabenkorb/exceptions/missing_unit.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_sub_category_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_sub_category_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class MetadataService implements Disposable {
  final _itemUnitService = di<ItemUnitService>();
  final _itemCategoryService = di<ItemCategoryService>();
  final _itemSubCategoryService = di<ItemSubCategoryService>();
  final _libraryStateService = di<LibraryStateService>();
  final _basketStateService = di<BasketStateService>();

  late StreamSubscription _categoriesSub;
  final _categories = BehaviorSubject<List<ItemCategoryViewModel>>.seeded([]);
  Stream<List<ItemCategoryViewModel>> get categories => _categories.stream;

  late StreamSubscription _subCategoriesSub;
  final _subCategories = BehaviorSubject<List<ItemSubCategoryViewModel>>.seeded([]);

  Stream<List<ItemSubCategoryViewModel>> get subCategories => _subCategories.stream;

  late StreamSubscription _unitsSub;
  final _units = BehaviorSubject<List<ItemUnitViewModel>>.seeded([]);

  Stream<List<ItemUnitViewModel>> get units => _units.stream;

  MetadataService() {
    _categoriesSub = watchItemCategories().listen((categories) {
      _categories.add(categories);
    });

    _subCategoriesSub = watchItemSubCategories().listen((subCategories) {
      _subCategories.add(subCategories);
    });

    _unitsSub = watchItemUnits().listen((units) {
      _units.add(units);
    });
  }

  Future<int> createItemUnit(String name) {
    return _itemUnitService.createItemUnit(name);
  }

  Future<void> updateItemUnit(int id, String name) {
    return _itemUnitService.updateItemUnit(id, name);
  }

  Future<ItemUnitViewModel?> getItemUnitById(int id) {
    return _itemUnitService.getItemUnitById(id);
  }

  Future<int> deleteItemUnitById(int id) {
    return _itemUnitService.deleteItemUnitById(id);
  }

  Stream<List<ItemUnitViewModel>> watchItemUnits() {
    return _itemUnitService.watchItemUnits();
  }

  Future<int> createItemCategory(String name) {
    return _itemCategoryService.createItemCategory(name);
  }

  Future<void> updateItemCategory(int id, String name) {
    return _itemCategoryService.updateItemCategory(id, name);
  }

  Future<ItemCategoryViewModel?> getItemCategoryById(int id) {
    return _itemCategoryService.getItemCategoryById(id);
  }

  Future<int> deleteItemCategoryById(int id) async {
    final result = await _itemCategoryService.savelyDeleteItemCategoryById(id);
    final category = result.deletedObject;
    if (category != null) {
      await _libraryStateService.removeCollapsedState(category.key);
      await _basketStateService.removeCollapsedState(category.key);
    }
    return result.deletedRows;
  }

  Future<int> createItemSubCategory(String name) {
    return _itemSubCategoryService.createItemSubCategory(name);
  }

  Future<void> updateItemSubCategory(int id, String name) {
    return _itemSubCategoryService.updateItemSubCategory(id, name);
  }

  Future<ItemSubCategoryViewModel?> getItemSubCategoryById(int id) {
    return _itemSubCategoryService.getItemSubCategoryById(id);
  }

  Future<int> deleteItemSubCategoryById(int id) async {
    return _itemSubCategoryService.deleteItemSubCategoryById(id);
  }

  Stream<List<ItemCategoryViewModel>> watchItemCategories() {
    return _itemCategoryService.watchItemCategories();
  }

  Stream<List<ItemSubCategoryViewModel>> watchItemSubCategories() {
    return _itemSubCategoryService.watchItemSubCategories();
  }

  Stream<List<ItemCategoryViewModel>> watchItemCategoriesInOrder(SortMode sortMode, SortDirection sortDirection, {int? sortRuleId}) {
    return _itemCategoryService.watchItemCategoriesInOrder(sortMode, sortDirection, sortRuleId: sortRuleId);
  }

  Future<void> ensureExistingCategory(int? categoryId) async {
    if (categoryId == null) {
      return;
    }
    final category = await getItemCategoryById(categoryId);

    throwIf(category == null, MissingCategoryException(categoryId));
  }

  Future<void> ensureExistingUnit(int? unitId) async {
    if (unitId == null) {
      return;
    }
    final unit = await getItemUnitById(unitId);

    throwIf(unit == null, MissingUnitException(unitId));
  }

  @override
  FutureOr onDispose() {
    _categoriesSub.cancel();
    _subCategoriesSub.cancel();
    _unitsSub.cancel();
  }
}
