import 'dart:async';

import 'package:rabenkorb/exceptions/missing_category.dart';
import 'package:rabenkorb/exceptions/missing_unit.dart';
import 'package:rabenkorb/exceptions/missing_variant.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/variant_key_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import '../../database/database.dart';

class MetadataService implements Disposable {
  final _itemUnitService = di<ItemUnitService>();
  final _itemCategoryService = di<ItemCategoryService>();
  final _variantKeyService = di<VariantKeyService>();
  final _libraryStateService = di<LibraryStateService>();
  final _basketStateService = di<BasketStateService>();

  late StreamSubscription _categoriesSub;
  final _categories = BehaviorSubject<List<ItemCategoryViewModel>>.seeded([]);
  Stream<List<ItemCategoryViewModel>> get categories => _categories.stream;

  late StreamSubscription _unitsSub;
  final _units = BehaviorSubject<List<ItemUnitViewModel>>.seeded([]);

  Stream<List<ItemUnitViewModel>> get units => _units.stream;

  MetadataService() {
    _categoriesSub = watchItemCategories().listen((categories) {
      _categories.add(categories);
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

  Stream<List<ItemCategoryViewModel>> watchItemCategories() {
    return _itemCategoryService.watchItemCategories();
  }

  Future<int> createVariantKey(String name) {
    return _variantKeyService.createVariantKey(name);
  }

  Future<VariantKey?> getVariantKeyById(int id) {
    return _variantKeyService.getVariantKeyById(id);
  }

  Future<int> deleteVariantKeyById(int id) {
    return _variantKeyService.deleteVariantKeyById(id);
  }

  Future<void> ensureExistingCategory(int? categoryId) async {
    if (categoryId == null) {
      return;
    }
    final category = await getItemCategoryById(categoryId);

    throwIf(category == null, MissingCategoryException(categoryId));
  }

  Future<void> ensureExistingVariantKey(int? variantId) async {
    if (variantId == null) {
      return;
    }
    final variant = await getVariantKeyById(variantId);

    throwIf(variant == null, MissingVariantException(variantId));
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
    _unitsSub.cancel();
  }
}
