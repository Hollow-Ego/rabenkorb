import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';

class ItemTemplateFilterDetails {
  SortMode sortMode;
  String searchTerm;
  SortDirection sortDirection;
  int? sortRuleId;

  ItemTemplateFilterDetails({
    required this.sortMode,
    required this.searchTerm,
    required this.sortDirection,
    this.sortRuleId,
  });
}

class BasketItemFilterDetails {
  SortMode sortMode;
  String searchTerm;
  SortDirection sortDirection;
  int? sortRuleId;
  int? basketId;

  BasketItemFilterDetails({
    required this.sortMode,
    required this.searchTerm,
    required this.sortDirection,
    this.sortRuleId,
    this.basketId,
  });
}
