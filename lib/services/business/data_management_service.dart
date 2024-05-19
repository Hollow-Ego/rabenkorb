import 'dart:async';

import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/state/data_management_state_service.dart';
import 'package:rabenkorb/shared/filter_details.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class DataManagementService implements Disposable {
  final _dataManagementStateService = di<DataManagementStateService>();
  final _metadataService = di<MetadataService>();
  final _sortRuleService = di<SortRuleService>();

  late StreamSubscription _templateSub;
  final _itemCategories = BehaviorSubject<List<ItemCategoryViewModel>>.seeded(List<ItemCategoryViewModel>.empty());

  late StreamSubscription _activeSortRuleSub;
  final BehaviorSubject<SortRuleViewModel?> _activeSortRule = BehaviorSubject<SortRuleViewModel?>.seeded(null);

  Stream<SortRuleViewModel?> get activeSortRule => _activeSortRule.stream;

  Stream<List<ItemCategoryViewModel>> get categories => _itemCategories.stream;

  DataManagementService() {
    _templateSub = Rx.combineLatest3(
        _dataManagementStateService.sortMode,
        _dataManagementStateService.sortDirection,
        _dataManagementStateService.sortRuleId,
        (SortMode sortMode, SortDirection sortDirection, int? sortRuleId) =>
            ItemCategoryFilterDetails(sortMode: sortMode, sortDirection: sortDirection, sortRuleId: sortRuleId)).switchMap((details) {
      if (details.sortRuleId == null) {
        return Stream.value(List<ItemCategoryViewModel>.empty());
      }
      return _metadataService.watchItemCategoriesInOrder(
        details.sortMode,
        details.sortDirection,
        sortRuleId: details.sortRuleId,
      );
    }).listen((categories) {
      _itemCategories.add(categories);
    });
    _activeSortRuleSub = _dataManagementStateService.sortRuleId.switchMap((sortRuleId) => _sortRuleService.watchSortRuleWithId(sortRuleId)).listen((sortRule) {
      _activeSortRule.add(sortRule);
    });
  }

  @override
  FutureOr onDispose() {
    _templateSub.cancel();
    _activeSortRuleSub.cancel();
  }
}
