import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateService {
  final _db = di<AppDatabase>();
  final BehaviorSubject<String> _searchSubject =
      BehaviorSubject<String>.seeded("");

  final BehaviorSubject<int?> _sortRuleIdSubject =
      BehaviorSubject<int?>.seeded(null);

  final BehaviorSubject<SortMode> _sortModeSubject =
      BehaviorSubject<SortMode>.seeded(SortMode.name);

  late Stream<List<GroupedItems>> _itemTemplatesStream;

  Stream<List<GroupedItems>> get itemTemplates => _itemTemplatesStream;

  ItemTemplateService() {
    _itemTemplatesStream = Rx.combineLatest3(
      _sortModeSubject.stream.distinct(),
      _sortRuleIdSubject.stream.distinct(),
      _searchSubject.stream.distinct(),
      (SortMode sortMode, int? sortRuleId, String searchTerm) =>
          _watchItemTemplatesInOrder(
        sortMode,
        sortRuleId: sortRuleId,
        searchTerm: searchTerm,
      ),
    )
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((stream) => stream);
  }

  factory ItemTemplateService.withValue({
    SortMode? sortMode,
    int? sortRuleId,
    String? searchString,
  }) {
    final service = ItemTemplateService();

    service.setSortMode(sortMode);
    service.setSearchString(searchString);
    service.setSortRuleId(sortRuleId);

    return service;
  }

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

  void setSortMode(SortMode? sortMode) {
    if (sortMode == null) {
      return;
    }
    _sortModeSubject.add(sortMode);
  }

  void setSortRuleId(int? sortRuleId) {
    _sortRuleIdSubject.add(sortRuleId);
  }

  void setSearchString(String? searchString) {
    searchString = searchString ?? "";
    _searchSubject.add(searchString);
  }

  Stream<List<GroupedItems>> _watchItemTemplatesInOrder(SortMode sortMode,
      {int? sortRuleId, String? searchTerm}) {
    return _db.itemTemplatesDao.watchItemTemplatesInOrder(sortMode,
        sortRuleId: sortRuleId, searchTerm: searchTerm);
  }
}
