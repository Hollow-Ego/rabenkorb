import 'package:rabenkorb/shared/extensions.dart';

class ItemSubCategoryViewModel {
  final int id;
  final String name;

  String get key => "${name.toLowerSpaceless()}-$id";

  ItemSubCategoryViewModel(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
