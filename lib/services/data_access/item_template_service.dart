import 'dart:async';

import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/filter_details.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateService implements Disposable {
  final _db = di<AppDatabase>();
  final _libraryStateService = di<LibraryStateService>();

  late StreamSubscription _templateSub;
  final _itemTemplates = BehaviorSubject<List<GroupedItems<ItemTemplateViewModel>>>.seeded([]);

  Stream<List<GroupedItems<ItemTemplateViewModel>>> get itemTemplates => _itemTemplates.stream;

  List<GroupedItems<ItemTemplateViewModel>> get itemTemplatesSync => _itemTemplates.value;

  ItemTemplateService() {
    _templateSub = Rx.combineLatest4(
      _libraryStateService.sortMode,
      _libraryStateService.sortDirection,
      _libraryStateService.sortRuleId,
      _libraryStateService.search,
      (SortMode sortMode, SortDirection sortDirection, int? sortRuleId, String searchTerm) =>
          ItemTemplateFilterDetails(sortMode: sortMode, sortDirection: sortDirection, searchTerm: searchTerm, sortRuleId: sortRuleId),
    ).switchMap((ItemTemplateFilterDetails details) {
      return _watchItemTemplatesInOrder(
        details.sortMode,
        details.sortDirection,
        sortRuleId: details.sortRuleId,
        searchTerm: details.searchTerm,
      );
    }).listen((templates) {
      _itemTemplates.add(templates);
    });
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

  Future<int> countImagePathUsages(String imagePath) async {
    return (await _db.itemTemplatesDao.countImagePathUsages(imagePath)) ?? 0;
  }

  Stream<List<GroupedItems<ItemTemplateViewModel>>> _watchItemTemplatesInOrder(SortMode sortMode, SortDirection sortDirection,
      {int? sortRuleId, String? searchTerm}) {
    return _db.itemTemplatesDao.watchItemTemplatesInOrder(sortMode, sortDirection, sortRuleId: sortRuleId, searchTerm: searchTerm);
  }

  @override
  FutureOr onDispose() async {
    await _templateSub.cancel();
  }
}
