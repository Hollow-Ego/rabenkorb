import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/sort_rule_view_model.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/default_sort_rules.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_dropdown_button.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_text_button.dart';
import 'package:watch_it/watch_it.dart';

class LibrarySortControl extends StatelessWidget with WatchItMixin {
  const LibrarySortControl({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryStateService = di<LibraryStateService>();

    final sortRules = defaultSortRules();
    final AsyncSnapshot<List<SortRuleViewModel>> availableSortRules = watchStream((LibraryService p0) => p0.sortRules, initialValue: []);
    final sortOrder = watchStream((LibraryStateService p0) => p0.sortRuleId, initialValue: libraryStateService.sortRuleIdSync);
    final sortMode = watchStream((LibraryStateService p0) => p0.sortMode, initialValue: libraryStateService.sortModeSync);
    final sortDirection = watchStream((LibraryStateService p0) => p0.sortDirection, initialValue: libraryStateService.sortDirectionSync);
    final selectedItem = sortOrder.hasData && (availableSortRules.data?.length ?? 0) > 0
        ? sortOrder.data!
        : (sortMode.data == SortMode.databaseOrder ? sortByDatabasePseudoId : sortByNamePseudoId);
    sortRules.addAll(availableSortRules.data ?? []);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CoreDropdownButton<int>(
          icon: const Icon(
            Icons.sort_by_alpha,
          ),
          onPressed: _updateSortDetails,
          selectedItem: selectedItem,
          items: _toDropdownMenuItem(sortRules),
        ),
        CoreIconTextButton(
          icon: const Icon(Icons.sort),
          label: Text(S.of(context).SortDirection(sortDirection.data?.name ?? "")),
          onPressed: () async {
            await libraryStateService.switchSortDirection();
          },
        ),
      ],
    );
  }

  Future<void> _updateSortDetails(int? id) async {
    if (id == null) {
      return;
    }
    final libraryStateService = di<LibraryStateService>();
    if (id == sortByNamePseudoId) {
      await libraryStateService.setSortMode(SortMode.name);
      await libraryStateService.setSortRuleId(null);
      return;
    }
    if (id == sortByDatabasePseudoId) {
      await libraryStateService.setSortMode(SortMode.databaseOrder);
      await libraryStateService.setSortRuleId(null);
      return;
    }

    await libraryStateService.setSortMode(SortMode.custom);
    await libraryStateService.setSortRuleId(id);
  }

  List<DropdownMenuItem<int>> _toDropdownMenuItem(List<SortRuleViewModel> sortRules) {
    return sortRules
        .map(
          (sortRule) => DropdownMenuItem<int>(
            value: sortRule.id,
            child: Text(sortRule.name),
          ),
        )
        .toList();
  }
}
