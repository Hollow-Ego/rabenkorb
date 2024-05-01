import 'package:rabenkorb/shared/extensions.dart';

class ItemCategoryViewModel {
  final int id;
  final String name;

  String get key => "${name.toLowerSpaceless()}-$id";

  ItemCategoryViewModel(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
