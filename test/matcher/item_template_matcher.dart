import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';

class IsEqualToItemTemplate extends Matcher {
  late final ItemTemplate expectedItem;

  IsEqualToItemTemplate(this.expectedItem);

  @override
  Description describe(Description description) {
    return description.add('ItemTemplate:<${expectedItem.toString()}>');
  }

  @override
  bool matches(item, Map matchState) {
    final actualItem = item as ItemTemplate;
    final nameMatches = actualItem.name == expectedItem.name;
    final categoryMatches = actualItem.category == expectedItem.category;
    final variantMatches = actualItem.variantKey == expectedItem.variantKey;
    final imagePathMatches = actualItem.imagePath == expectedItem.imagePath;

    return nameMatches && categoryMatches && variantMatches && imagePathMatches;
  }
}
