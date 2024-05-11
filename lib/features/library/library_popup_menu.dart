import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:watch_it/watch_it.dart';

enum LibraryPopupMenuActions {
  deleteSelected,
  selectAll,
  deselectAll,
  cancel,
  enterMultiSelect,
}

class LibraryPopupMenu extends StatelessWidget with WatchItMixin {
  const LibraryPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final multiSelectMode = watchStream((LibraryStateService p0) => p0.isMultiSelectMode, initialValue: false);
    return PopupMenuButton<LibraryPopupMenuActions>(
      key: const Key("library-popup-menu"),
      itemBuilder: multiSelectMode.data == true ? _multiSelectItems : _normalItems,
      onSelected: (LibraryPopupMenuActions action) async {
        final libraryStateService = di<LibraryStateService>();
        final libraryService = di<LibraryService>();
        switch (action) {
          case LibraryPopupMenuActions.deleteSelected:
            final templateIds = libraryStateService.selectedItemsSync;
            libraryService.deleteItemTemplates(templateIds);
            break;
          case LibraryPopupMenuActions.selectAll:
            final itemIds = libraryService.shownItemIds;
            libraryStateService.selectAll(itemIds);
            break;
          case LibraryPopupMenuActions.deselectAll:
            libraryStateService.deselectAll();
            break;
          case LibraryPopupMenuActions.cancel:
            libraryStateService.leaveMultiSelectMode();
            return;
          case LibraryPopupMenuActions.enterMultiSelect:
            libraryStateService.enterMultiSelectMode();
            return;
        }
      },
    );
  }

  List<PopupMenuEntry<LibraryPopupMenuActions>> _multiSelectItems(BuildContext context) {
    return <PopupMenuEntry<LibraryPopupMenuActions>>[
      PopupMenuItem<LibraryPopupMenuActions>(
        key: const Key("library-popup-menu-delete-selected"),
        value: LibraryPopupMenuActions.deleteSelected,
        child: Text(S.of(context).DeleteSelected),
      ),
      PopupMenuItem<LibraryPopupMenuActions>(
        key: const Key("library-popup-menu-select-all"),
        value: LibraryPopupMenuActions.selectAll,
        child: Text(S.of(context).SelectAll),
      ),
      PopupMenuItem<LibraryPopupMenuActions>(
        key: const Key("library-popup-menu-deselect-all"),
        value: LibraryPopupMenuActions.deselectAll,
        child: Text(S.of(context).DeselectAll),
      ),
      PopupMenuItem<LibraryPopupMenuActions>(
        key: const Key("library-popup-menu-cancel"),
        value: LibraryPopupMenuActions.cancel,
        child: Text(S.of(context).Cancel),
      ),
    ];
  }

  List<PopupMenuEntry<LibraryPopupMenuActions>> _normalItems(BuildContext context) {
    return <PopupMenuEntry<LibraryPopupMenuActions>>[
      PopupMenuItem<LibraryPopupMenuActions>(
        key: const Key("library-popup-menu-enter-multiselect"),
        value: LibraryPopupMenuActions.enterMultiSelect,
        child: Text(S.of(context).EnterMultiSelect),
      ),
    ];
  }
}
