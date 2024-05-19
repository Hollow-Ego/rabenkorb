import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:watch_it/watch_it.dart';

class SortOrderService {
  final _db = di<AppDatabase>();

  Future<int> removeSortOrder(int id) {
    return _db.sortOrdersDao.removeOrders(id);
  }

  Future<void> setOrder(int id, List<int> categoryIds) {
    return _db.sortOrdersDao.setOrder(id, categoryIds);
  }

  Future<void> updateOrderSingle(int sortRuleId, List<ItemCategoryViewModel> visibleCategories, int oldIndex, int newIndex) {
    return _db.sortOrdersDao.updateOrderSingle(sortRuleId, visibleCategories, oldIndex, newIndex);
  }
}
