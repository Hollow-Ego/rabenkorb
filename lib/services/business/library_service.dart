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

  Future<void> updateLibrary(int libraryId, String name) {
    return _templateLibraryService.updateTemplateLibrary(libraryId, name);
  }

  Future<TemplateLibrary?> getTemplateLibraryById(int libraryId) {
    return _templateLibraryService.getTemplateLibraryById(libraryId);
  }

  Future<int> deleteLibrary(int libraryId) {
    return _templateLibraryService.deleteTemplateLibraryById(libraryId);
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

  Future<void> removeItemTemplateCategory(int templateId) async {
    final originalItemTemplate = await _itemTemplateService.getItemTemplateById(templateId);
    if (originalItemTemplate == null) {
      return;
    }
    return _itemTemplateService.replaceItemTemplate(
      templateId,
      name: originalItemTemplate.name,
      categoryId: null,
      libraryId: originalItemTemplate.library,
      imagePath: originalItemTemplate.imagePath,
      variantKeyId: originalItemTemplate.variantKey,
    );
  }

  Future<void> removeItemTemplateVariant(int templateId) async {
    final originalItemTemplate = await _itemTemplateService.getItemTemplateById(templateId);
    if (originalItemTemplate == null) {
      return;
    }
    final variantKeyId = originalItemTemplate.variantKey;
    if (variantKeyId == null) {
      return;
    }
    await _itemTemplateService.replaceItemTemplate(
      templateId,
      name: originalItemTemplate.name,
      categoryId: originalItemTemplate.category,
      libraryId: originalItemTemplate.library,
      imagePath: originalItemTemplate.imagePath,
      variantKeyId: null,
    );

    final remainingItemTemplatesWithVariantKey = await _itemTemplateService.getItemTemplatesByVariantKey(variantKeyId);
    if (remainingItemTemplatesWithVariantKey.length > 1) {
      return;
    }

    await _metadataService.deleteVariantKeyById(variantKeyId);
  }

  // ToDo: Add methods to delete images

  Future<void> updateItemTemplate(
    int templateId, {
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
      templateId,
      name: name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: imagePath,
    );
  }

  Future<ItemTemplate?> getItemTemplateById(int templateId) {
    return _itemTemplateService.getItemTemplateById(templateId);
  }

  Future<int> deleteItemTemplateById(int templateId) {
    return _itemTemplateService.deleteItemTemplateById(templateId);
  }

  Future<int> _ensureExistingLibrary(int libraryId) async {
    final targetLibrary = await _templateLibraryService.getTemplateLibraryById(libraryId);
    if (targetLibrary == null) {
      return await _templateLibraryService.createTemplateLibrary(defaultLibraryName);
    }
    return libraryId;
  }
}
