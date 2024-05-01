import 'package:rabenkorb/shared/sort_mode.dart';

class ItemTemplateFilterDetails {
  SortMode sortMode;
  String searchTerm;
  int? sortRuleId;

  ItemTemplateFilterDetails({
    required this.sortMode,
    required this.searchTerm,
    this.sortRuleId,
  });
}

class BasketItemFilterDetails {
  SortMode sortMode;
  String searchTerm;
  int? sortRuleId;
  int? basketId;

  BasketItemFilterDetails({
    required this.sortMode,
    required this.searchTerm,
    this.sortRuleId,
    this.basketId,
  });
}
