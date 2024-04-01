import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:watch_it/watch_it.dart';

class LibraryService {
  static const defaultLibraryName = "Unnamed Library";
  final _templateLibraryService = di<TemplateLibraryService>();
  final _itemTemplateService = di<ItemTemplateService>();
  final _metadataService = di<MetadataService>();

  Stream<List<GroupedItems<ItemTemplate>>> get itemTemplates => _itemTemplateService.itemTemplates;

  Future<int> createLibrary(String name) {
    return _templateLibraryService.createTemplateLibrary(name);
  }

  Future<void> updateLibrary(int id, String name) {
    return _templateLibraryService.updateTemplateLibrary(id, name);
  }

  Future<TemplateLibrary?> getTemplateLibraryById(int id) {
    return _templateLibraryService.getTemplateLibraryById(id);
  }

  Future<int> deleteLibrary(int id) {
    return _templateLibraryService.deleteTemplateLibraryById(id);
  }

  Stream<List<TemplateLibrary>> watchTemplateLibraries() {
    return _templateLibraryService.watchTemplateLibraries();
  }

  Future<int> createItemTemplate(
    String name, {
    int? categoryId,
    required int libraryId,
    int? variantKeyId,
    String? imagePath,
  }) async {
    libraryId = await _ensureExistingLibrary(libraryId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingVariantKey(variantKeyId);

    return _itemTemplateService.createItemTemplate(name, libraryId: libraryId);
  }

  Future<void> updateItemTemplate(
    int id, {
    String? name,
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    String? imagePath,
  }) async {
    if (libraryId != null) {
      libraryId = await _ensureExistingLibrary(libraryId);
    }
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingVariantKey(variantKeyId);

    return _itemTemplateService.updateItemTemplate(
      id,
      name: name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );
  }

  Future<ItemTemplate?> getItemTemplateById(int id) {
    return _itemTemplateService.getItemTemplateById(id);
  }

  Future<int> deleteItemTemplateById(int id) {
    return _itemTemplateService.deleteItemTemplateById(id);
  }

  Future<int> _ensureExistingLibrary(int libraryId) async {
    final targetLibrary = await _templateLibraryService.getTemplateLibraryById(libraryId);
    if (targetLibrary == null) {
      return await _templateLibraryService.createTemplateLibrary(defaultLibraryName);
    }
    return libraryId;
  }
}
