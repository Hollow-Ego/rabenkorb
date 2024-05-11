// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';

class IsEqualToItemTemplate extends Matcher {
  late final ItemTemplateViewModel expectedItem;

  IsEqualToItemTemplate(this.expectedItem);

  @override
  Description describe(Description description) {
    return description.add('ItemTemplate:<${expectedItem.toJson()}>');
  }

  @override
  bool matches(item, Map matchState) {
    final actualItem = item as ItemTemplateViewModel;

    final nameMatches = actualItem.name == expectedItem.name;
    final categoryMatches = actualItem.category?.id == expectedItem.category?.id;
    final variantMatches = actualItem.variantKey == expectedItem.variantKey;
    final imagePathMatches = actualItem.imagePath == expectedItem.imagePath;

    final matches = nameMatches && categoryMatches && variantMatches && imagePathMatches;

    if (!matches) {
      print("Expected Item: ${expectedItem.toJson()}");
      print("Actual Item: ${actualItem.toJson()}");
    }

    return matches;
  }
}
