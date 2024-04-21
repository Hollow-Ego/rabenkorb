import 'package:rabenkorb/database/tables/sort_rules.dart';

class SortRuleViewModel {
  final int id;
  final String name;
  final GroupMode groupMode;

  SortRuleViewModel(this.id, this.name, this.groupMode);
}
