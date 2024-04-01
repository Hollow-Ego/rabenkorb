import 'package:rabenkorb/services/data_access/item_category_service.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:rabenkorb/services/data_access/variant_key_service.dart';
import 'package:watch_it/watch_it.dart';

import '../../database/database.dart';

class MetadataService {
  final _itemUnitService = di<ItemUnitService>();
  final _itemCategoryService = di<ItemCategoryService>();
  final _variantKeyService = di<VariantKeyService>();

  Future<int> createItemUnit(String name) {
    return _itemUnitService.createItemUnit(name);
  }

  Future<void> updateItemUnit(int id, String name) {
    return _itemUnitService.updateItemUnit(id, name);
  }

  Future<ItemUnit?> getItemUnitById(int id) {
    return _itemUnitService.getItemUnitById(id);
  }

  Future<int> deleteItemUnitById(int id) {
    return _itemUnitService.deleteItemUnitById(id);
  }

  Stream<List<ItemUnit>> watchItemUnits() {
    return _itemUnitService.watchItemUnits();
  }

  Future<int> createItemCategory(String name) {
    return _itemCategoryService.createItemCategory(name);
  }

  Future<void> updateItemCategory(int id, String name) {
    return _itemCategoryService.updateItemCategory(id, name);
  }

  Future<ItemCategory?> getItemCategoryById(int id) {
    return _itemCategoryService.getItemCategoryById(id);
  }

  Future<int> deleteItemCategoryById(int id) {
    return _itemCategoryService.deleteItemCategoryById(id);
  }

  Stream<List<ItemCategory>> watchItemCategoies() {
    return _itemCategoryService.watchItemCategoies();
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
}
