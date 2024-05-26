import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/move_to_basket_dialog.dart';
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
  createBasket,
  deleteBasket,
  move,
}

class BasketPopupMenu extends StatelessWidget with WatchItMixin {
  final bool isShoppingMode;
  final bool isMultiSelectMode;
  final bool disabled;

  const BasketPopupMenu({super.key, required this.isShoppingMode, required this.isMultiSelectMode, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BasketPopupMenuActions>(
      key: const Key("basket-popup-menu"),
      enabled: !disabled,
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
          case BasketPopupMenuActions.createBasket:
            await showRenameDialog(
              context,
              onConfirm: (String? newName, bool _) async {
                final newId = await basketService.createShoppingBasket(newName);
                await basketStateService.setBasketId(newId);
              },
            );
            return;
          case BasketPopupMenuActions.deleteBasket:
            if (basketId == null) {
              return;
            }
            await doWithConfirmation(
              context,
              text: S.of(context).ConfirmDeleteBasket,
              title: S.of(context).Confirm,
              onConfirm: () async {
                await basketService.deleteShoppingBasketById(basketId);
                basketService.setFirstShoppingBasketActive();
              },
            );
            return;
          case BasketPopupMenuActions.move:
            if (basketId == null) {
              return;
            }
            await showDialog<int?>(
              context: context,
              builder: (BuildContext context) {
                return MoveToBasketDialog(
                  initialBasket: basketService.activeBasketSync,
                  onConfirm: (int? targetBasketId) async {
                    if (targetBasketId == null || targetBasketId == basketId) {
                      return;
                    }
                    final templateIds = basketStateService.selectedItemsSync;
                    basketStateService.deselectAll();
                    await basketService.moveItemsToBasket(targetBasketId, templateIds);
                    basketStateService.leaveMultiSelectMode();
                  },
                );
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
        key: const Key("basket-popup-menu-move-selected"),
        value: BasketPopupMenuActions.move,
        child: Text(S.of(context).MoveSelected),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-delete-selected"),
        value: BasketPopupMenuActions.deleteSelected,
        child: Text(S.of(context).DeleteSelected),
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
        key: const Key("basket-popup-menu-create-basket"),
        value: BasketPopupMenuActions.createBasket,
        child: Text(S.of(context).NewBasket),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-rename-basket"),
        value: BasketPopupMenuActions.renameBasket,
        child: Text(S.of(context).Rename),
      ),
      PopupMenuItem<BasketPopupMenuActions>(
        key: const Key("basket-popup-menu-delete-basket"),
        value: BasketPopupMenuActions.deleteBasket,
        child: Text(S.of(context).Delete),
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
