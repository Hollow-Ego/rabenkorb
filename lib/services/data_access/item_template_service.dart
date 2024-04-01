import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateService {
  final _db = di<AppDatabase>();
  final _libraryStateService = di<LibraryStateService>();

  late Stream<List<GroupedItems<ItemTemplateViewModel>>> _itemTemplatesStream;

  Stream<List<GroupedItems<ItemTemplateViewModel>>> get itemTemplates => _itemTemplatesStream;

  ItemTemplateService() {
    _itemTemplatesStream = Rx.combineLatest3(
      _libraryStateService.sortMode,
      _libraryStateService.sortRuleId,
      _libraryStateService.search,
      (SortMode sortMode, int? sortRuleId, String searchTerm) => _watchItemTemplatesInOrder(
        sortMode,
        sortRuleId: sortRuleId,
        searchTerm: searchTerm,
      ),
    ).debounceTime(const Duration(milliseconds: 300)).switchMap((stream) => stream);
  }

  Future<int> createItemTemplate(
    String name, {
    int? categoryId,
    required int libraryId,
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

  Future<void> replaceItemTemplate(
    int id, {
    required String name,
    int? categoryId,
    required int libraryId,
    int? variantKeyId,
    String? imagePath,
  }) {
    return _db.itemTemplatesDao.replaceItemTemplate(
      id,
      name: name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );
  }

  Future<ItemTemplateViewModel?> getItemTemplateById(int id) {
    return _db.itemTemplatesDao.getItemTemplateWithId(id);
  }

  Future<List<ItemTemplateViewModel>> getItemTemplatesByVariantKey(int variantKeyId) {
    return _db.itemTemplatesDao.getItemTemplatesByVariantKey(variantKeyId);
  }

  Future<int> deleteItemTemplateById(int id) {
    return _db.itemTemplatesDao.deleteItemTemplateWithId(id);
  }

  Stream<List<ItemTemplateViewModel>> watchItemTemplates() {
    return _db.itemTemplatesDao.watchItemTemplates();
  }

  Stream<List<GroupedItems<ItemTemplateViewModel>>> _watchItemTemplatesInOrder(SortMode sortMode, {int? sortRuleId, String? searchTerm}) {
    return _db.itemTemplatesDao.watchItemTemplatesInOrder(sortMode, sortRuleId: sortRuleId, searchTerm: searchTerm);
  }
}
