import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';

class ItemTemplateViewModel extends DataItem {
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

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imagePath": imagePath,
      "variantKey": variantKey,
      "category": category?.toJson(),
      "library": library.toJson(),
    };
  }
}
