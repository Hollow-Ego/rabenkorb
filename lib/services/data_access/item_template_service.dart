import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateService {
  static final _db = di<AppDatabase>();

  Future<int> createItemTemplate(
    String name, {
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    String? imagePath,
  }) {
    return _db.itemTemplatesDao.createItemTemplate(
      name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );
  }

  Future<void> updateItemTemplate(
    int id, {
    String? name,
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    String? imagePath,
  }) {
    return _db.itemTemplatesDao.updateItemTemplate(
      id,
      name: name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );
  }

  Future<ItemTemplate?> getItemTemplateById(int id) {
    return _db.itemTemplatesDao.getItemTemplateWithId(id);
  }

  Future<int> deleteItemTemplateById(int id) {
    return _db.itemTemplatesDao.deleteItemTemplateWithId(id);
  }

  Stream<List<ItemTemplate>> watchItemTemplates() {
    return _db.itemTemplatesDao.watchItemTemplates();
  }

  Stream<List<GroupedItems>> watchItemTemplatesInOrder(
    SortMode sortMode, {
    int? sortRuleId,
  }) {
    return _db.itemTemplatesDao
        .watchItemTemplatesInOrder(sortMode, sortRuleId: sortRuleId);
  }
}
