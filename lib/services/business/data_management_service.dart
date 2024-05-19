import 'dart:async';

import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/state/data_management_state_service.dart';
import 'package:rabenkorb/shared/filter_details.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

class DataManagementService implements Disposable {
  final _dataManagementStateService = di<DataManagementStateService>();
  final _metadataService = di<MetadataService>();

  late StreamSubscription _templateSub;
  final _itemCategories = BehaviorSubject<List<ItemCategoryViewModel>>.seeded([]);

  Stream<List<ItemCategoryViewModel>> get itemCategories => _itemCategories.stream;

  DataManagementService() {
    _templateSub = Rx.combineLatest3(
            _dataManagementStateService.sortMode,
            _dataManagementStateService.sortDirection,
            _dataManagementStateService.sortRuleId,
            (SortMode sortMode, SortDirection sortDirection, int? sortRuleId) =>
                ItemCategoryFilterDetails(sortMode: sortMode, sortDirection: sortDirection, sortRuleId: sortRuleId))
        .switchMap((details) => _metadataService.watchItemCategoriesInOrder(
              details.sortMode,
              details.sortDirection,
              sortRuleId: details.sortRuleId,
            ))
        .listen((categories) {
      _itemCategories.add(categories);
    });
  }

  @override
  FutureOr onDispose() {
    _templateSub.cancel();
  }
}
