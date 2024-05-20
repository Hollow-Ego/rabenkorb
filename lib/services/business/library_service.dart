import 'dart:io';

import 'package:rabenkorb/abstracts/image_service.dart';
import 'package:rabenkorb/models/grouped_items.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/data_access/item_template_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/data_access/template_library_service.dart';
import 'package:watch_it/watch_it.dart';

class LibraryService {
  static const defaultLibraryName = "Unnamed Library";
  final _templateLibraryService = di<TemplateLibraryService>();
  final _itemTemplateService = di<ItemTemplateService>();
  final _metadataService = di<MetadataService>();
  final _sortRuleService = di<SortRuleService>();
  final _imageService = di<ImageService>();

  Stream<List<GroupedItems<ItemTemplateViewModel>>> get itemTemplates => _itemTemplateService.itemTemplates;

  List<int> get shownItemIds => _itemTemplateService.itemTemplatesSync.expand((group) => group.items.map((item) => item.id)).toList();

  Stream<List<SortRuleViewModel>> get sortRules => _sortRuleService.sortRules;

  Future<int> createLibrary(String name) {
    return _templateLibraryService.createTemplateLibrary(name);
  }

  Future<void> updateLibrary(int libraryId, String name) {
    return _templateLibraryService.updateTemplateLibrary(libraryId, name);
  }

  Future<TemplateLibraryViewModel?> getTemplateLibraryById(int libraryId) {
    return _templateLibraryService.getTemplateLibraryById(libraryId);
  }

  Future<int> deleteLibrary(int libraryId) {
    return _templateLibraryService.deleteTemplateLibraryById(libraryId);
  }

  Stream<List<TemplateLibraryViewModel>> watchTemplateLibraries() {
    return _templateLibraryService.watchTemplateLibraries();
  }

  Future<int> createItemTemplate(
    String name, {
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    File? image,
  }) async {
    libraryId = await _ensureExistingLibrary(libraryId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingVariantKey(variantKeyId);

    if (image != null) {
      image = await _imageService.saveImage(image);
    }

    return _itemTemplateService.createItemTemplate(
      name,
      libraryId: libraryId,
      imagePath: image?.path,
      variantKeyId: variantKeyId,
      categoryId: categoryId,
    );
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
      libraryId: originalItemTemplate.library.id,
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
      categoryId: originalItemTemplate.category?.id,
      libraryId: originalItemTemplate.library.id,
      imagePath: originalItemTemplate.imagePath,
      variantKeyId: null,
    );

    final remainingItemTemplatesWithVariantKey = await _itemTemplateService.getItemTemplatesByVariantKey(variantKeyId);
    if (remainingItemTemplatesWithVariantKey.length > 1) {
      return;
    }

    await _metadataService.deleteVariantKeyById(variantKeyId);
  }

  Future<void> removeItemTemplateImage(int templateId) async {
    final originalItemTemplate = await _itemTemplateService.getItemTemplateById(templateId);
    if (originalItemTemplate == null) {
      return;
    }
    final imagePath = originalItemTemplate.imagePath;
    if (imagePath == null) {
      return;
    }
    await _itemTemplateService.replaceItemTemplate(
      templateId,
      name: originalItemTemplate.name,
      categoryId: originalItemTemplate.category?.id,
      libraryId: originalItemTemplate.library.id,
      imagePath: null,
      variantKeyId: originalItemTemplate.variantKey,
    );
    // Check if the same image is used by other items;
    final usageCount = await _itemTemplateService.countImagePathUsages(imagePath);
    if (usageCount > 0) {
      return;
    }
    await _imageService.deleteImage(imagePath);
  }

  Future<void> updateItemTemplate(
    int templateId, {
    String? name,
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    File? image,
  }) async {
    libraryId = await _ensureExistingLibrary(libraryId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingVariantKey(variantKeyId);

    // Delete old image if new one was provided
    if (image != null) {
      await removeItemTemplateImage(templateId);
      // Save new image
      image = await _imageService.saveImage(image);
    }

    return _itemTemplateService.updateItemTemplate(
      templateId,
      name: name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: image?.path,
    );
  }

  Future<void> replaceItemTemplate(
    int templateId, {
    required String name,
    int? categoryId,
    int? libraryId,
    int? variantKeyId,
    File? image,
    bool imageChanged = false,
  }) async {
    libraryId = await _ensureExistingLibrary(libraryId);
    await _metadataService.ensureExistingCategory(categoryId);
    await _metadataService.ensureExistingVariantKey(variantKeyId);

    if (imageChanged) {
      await removeItemTemplateImage(templateId);
    }
    if (image != null && imageChanged) {
      // Save new image
      image = await _imageService.saveImage(image);
    }

    return _itemTemplateService.replaceItemTemplate(
      templateId,
      name: name,
      categoryId: categoryId,
      libraryId: libraryId,
      variantKeyId: variantKeyId,
      imagePath: image?.path,
    );
  }

  Future<ItemTemplateViewModel?> getItemTemplateById(int templateId) {
    return _itemTemplateService.getItemTemplateById(templateId);
  }

  Future<int> deleteItemTemplateById(int templateId) async {
    await removeItemTemplateImage(templateId);
    return _itemTemplateService.deleteItemTemplateById(templateId);
  }

  Future<int> deleteItemTemplates(List<int> templateIds) async {
    int deletedItems = 0;
    for (var templateId in templateIds) {
      await removeItemTemplateImage(templateId);
      deletedItems += await _itemTemplateService.deleteItemTemplateById(templateId);
    }
    return deletedItems;
  }

  Future<int> _ensureExistingLibrary(int? libraryId) async {
    libraryId ??= await _templateLibraryService.getFirstTemplateLibraryId();

    if (libraryId == null) {
      return _createDefaultLibrary();
    }

    final targetLibrary = await _templateLibraryService.getTemplateLibraryById(libraryId);
    if (targetLibrary == null) {
      return _createDefaultLibrary();
    }
    return libraryId;
  }

  Future<int> _createDefaultLibrary() async {
    return await _templateLibraryService.createTemplateLibrary(defaultLibraryName);
  }
}
