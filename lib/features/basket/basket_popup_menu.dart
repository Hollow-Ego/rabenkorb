import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:watch_it/watch_it.dart';

enum BasketPopupMenuActions {
  deleteSelected,
  selectAll,
  deselectAll,
  cancel,
  enterMultiSelect,
  deleteMarked,
  deleteAll,
  renameBasket,
}

class BasketPopupMenu extends StatelessWidget with WatchItMixin {
  final bool isShoppingMode;
  final bool isMultiSelectMode;

  const BasketPopupMenu({super.key, required this.isShoppingMode, required this.isMultiSelectMode});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BasketPopupMenuActions>(
      key: const Key("basket-popup-menu"),
      itemBuilder: isShoppingMode
          ? _shoppingModeItems
          : isMultiSelectMode
              ? _multiSelectItems
              : _normalItems,
      onSelected: (BasketPopupMenuActions action) async {
        final basketStateService = di<BasketStateService>();
        final basketService = di<BasketService>();
        final basketId = basketStateService.basketIdSync;
        switch (action) {
          case BasketPopupMenuActions.deleteSelected:
            final templateIds = basketStateService.selectedItemsSync;
            basketService.deleteBasketItems(templateIds);
            break;
          case BasketPopupMenuActions.selectAll:
            final itemIds = basketService.shownItemIds;
            basketStateService.selectAll(itemIds);
            break;
          case BasketPopupMenuActions.deselectAll:
            basketStateService.deselectAll();
            break;
          case BasketPopupMenuActions.cancel:
            basketStateService.leaveMultiSelectMode();
            return;
          case BasketPopupMenuActions.enterMultiSelect:
            basketStateService.enterMultiSelectMode();
            return;
          case BasketPopupMenuActions.deleteMarked:
            if (basketId == null) {
              return;
            }
            basketService.removeCheckedItemsFromBasket(basketId);
            return;
          case BasketPopupMenuActions.deleteAll:
            if (basketId == null) {
              return;
            }
            await doWithConfirmation(
              context,
              text: S.of(context).ConfirmDeleteAllItems,
              title: S.of(context).Confirm,
              onConfirm: () async {
                basketService.removeAllItemsFromBasket(basketId);
              },
            );

            return;
          case BasketPopupMenuActions.renameBasket:
            final activeBasket = basketService.activeBasketSync;
            if (activeBasket == null) {
              return;
            }
            final initialName = activeBasket.name;
            final id = activeBasket.id;

            await showRenameDialog(
              context,
              initialName: initialName,
              onConfirm: (String? newName, bool nameChanged) async {
                if (!nameChanged || newName == null) {
                  return;
                }
                await basketService.updateShoppingBasket(id, newName);
              },
            );
            return;
        }
      },
    );
  }

  List<PopupMenuEntry<BasketPopupMenuActions>> _shoppingModeItems(BuildContext context) {
    return <PopupMenuEntry<BasketPopupMenuActions>>[
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-delete-marked"),
        value: BasketPopupMenuActions.deleteMarked,
        child: Text(S.of(context).DeleteMarked),
      ),
    ];
  }

  List<PopupMenuEntry<BasketPopupMenuActions>> _multiSelectItems(BuildContext context) {
    return <PopupMenuEntry<BasketPopupMenuActions>>[
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-delete-selected"),
        value: BasketPopupMenuActions.deleteSelected,
        child: Text(S.of(context).DeleteSelected),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-select-all"),
        value: BasketPopupMenuActions.selectAll,
        child: Text(S.of(context).SelectAll),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-deselect-all"),
        value: BasketPopupMenuActions.deselectAll,
        child: Text(S.of(context).DeselectAll),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-cancel"),
        value: BasketPopupMenuActions.cancel,
        child: Text(S.of(context).Cancel),
      ),
    ];
  }

  List<PopupMenuEntry<BasketPopupMenuActions>> _normalItems(BuildContext context) {
    return <PopupMenuEntry<BasketPopupMenuActions>>[
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-rename-basket"),
        value: BasketPopupMenuActions.renameBasket,
        child: Text(S.of(context).Rename),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-enter-multiselect"),
        value: BasketPopupMenuActions.enterMultiSelect,
        child: Text(S.of(context).EnterMultiSelect),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-delete-all"),
        value: BasketPopupMenuActions.deleteAll,
        child: Text(S.of(context).DeleteAll),
      ),
    ];
  }
}
