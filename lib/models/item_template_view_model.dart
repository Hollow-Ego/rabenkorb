import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';

class ItemTemplateViewModel {
  final int id;
  final String name;
  final String? imagePath;
  final int? variantKey;
  final ItemCategoryViewModel? category;
  final TemplateLibraryViewModel library;

  ItemTemplateViewModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.variantKey,
    required this.category,
    required this.library,
  });
}
