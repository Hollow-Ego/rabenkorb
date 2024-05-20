import 'package:flutter/material.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_direction.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/core_sort_control.dart';
import 'package:watch_it/watch_it.dart';

class LibrarySortControl extends StatelessWidget with WatchItMixin {
  const LibrarySortControl({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryStateService = di<LibraryStateService>();
    final AsyncSnapshot<List<SortRuleViewModel>> availableSortRules = watchStream((LibraryService p0) => p0.sortRules, initialValue: []);
    final sortRuleId = watchStream((LibraryStateService p0) => p0.sortRuleId, initialValue: libraryStateService.sortRuleIdSync);
    final sortMode = watchStream((LibraryStateService p0) => p0.sortMode, initialValue: libraryStateService.sortModeSync);
    final sortDirection = watchStream((LibraryStateService p0) => p0.sortDirection, initialValue: libraryStateService.sortDirectionSync);

    return CoreSortControl(
      sortRuleId: sortRuleId.data,
      sortMode: sortMode.data,
      sortDirection: sortDirection.data ?? SortDirection.asc,
      onNewSortRule: (int newId) async {
        await di<LibraryStateService>().setSortRuleId(newId);
      },
      updateSortRuleDetails: _updateSortDetails,
      availableSortRules: availableSortRules.data ?? [],
      onSwitchSortDirection: () async {
        await libraryStateService.switchSortDirection();
      },
    );
  }

  Future<void> _updateSortDetails(SortRuleViewModel? rule) async {
    final ruleId = rule?.id;
    if (ruleId == null) {
      return;
    }
    final libraryStateService = di<LibraryStateService>();
    if (ruleId == sortByNamePseudoId) {
      await libraryStateService.setSortMode(SortMode.name);
      await libraryStateService.setSortRuleId(null);
      return;
    }
    if (ruleId == sortByDatabasePseudoId) {
      await libraryStateService.setSortMode(SortMode.databaseOrder);
      await libraryStateService.setSortRuleId(null);
      return;
    }

    await libraryStateService.setSortMode(SortMode.custom);
    await libraryStateService.setSortRuleId(ruleId);
  }
}
