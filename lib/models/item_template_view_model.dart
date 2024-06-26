import 'package:rabenkorb/abstracts/data_item.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/template_library_view_model.dart';
import 'package:rabenkorb/shared/extensions.dart';

class ItemTemplateViewModel extends DataItem {
  final int id;
  final String name;
  final String? imagePath;
  final ItemCategoryViewModel? category;
  final TemplateLibraryViewModel library;

  @override
  String get key => "${name.toLowerSpaceless()}-$id";

  ItemTemplateViewModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.library,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imagePath": imagePath,
      "category": category?.toJson(),
      "library": library.toJson(),
    };
  }
}
