import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/data_access/sort_order_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:watch_it/watch_it.dart';

class SortService {
  final _sortRuleService = di<SortRuleService>();
  final _sortOrderService = di<SortOrderService>();

  Future<int> createSortRule(String name) {
    return _sortRuleService.createSortRule(name);
  }

  Future<void> updateSortRule(int id, String name) {
    return _sortRuleService.updateSortRule(id, name);
  }

  Future<SortRuleViewModel?> getSortRuleById(int id) {
    return _sortRuleService.getSortRuleById(id);
  }

  Future<int> deleteSortRuleById(int id) {
    return _sortRuleService.deleteSortRuleById(id);
  }

  Stream<List<SortRuleViewModel>> watchSortRules() {
    return _sortRuleService.watchSortRules();
  }

  Stream<SortRuleViewModel?> watchSortRuleWithId(int id) {
    return _sortRuleService.watchSortRuleWithId(id);
  }

  Future<int> removeSortOrder(int id) {
    return _sortOrderService.removeSortOrder(id);
  }

  Future<void> setOrder(int id, List<int> categoryIds) {
    return _sortOrderService.setOrder(id, categoryIds);
  }

  Future<void> updateOrderSingle(int sortRuleId, List<ItemCategoryViewModel> visibleCategories, int oldIndex, int newIndex) {
    return _sortOrderService.updateOrderSingle(sortRuleId, visibleCategories, oldIndex, newIndex);
  }
}
