import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/basket_popup_menu.dart';
import 'package:rabenkorb/features/basket/shopping_mode_toggle.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/form/basket_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class BasketTitle extends StatelessWidget with WatchItMixin {
  const BasketTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final activeBasket = watchStream((BasketService p0) => p0.activeBasket, initialValue: null);

    final isShoppingModeStream = watchStream((BasketStateService p0) => p0.isShoppingMode, initialValue: false);
    final isShoppingMode = isShoppingModeStream.data ?? false;

    final isMultiSelectModeStream = watchStream((BasketStateService p0) => p0.isMultiSelectMode, initialValue: false);
    final isMultiSelectMode = isMultiSelectModeStream.data ?? false;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: BasketDropdown(
            onChanged: (ShoppingBasketViewModel? basket) async {
              await di<BasketStateService>().setBasketId(basket?.id);
            },
            onNoSearchResultAction: (String searchValue) async {
              await showRenameDialog(
                context,
                initialName: searchValue,
                onConfirm: (newName, nameChanged) async {
                  if (!newName.isValid()) {
                    return;
                  }
                  final newId = await di<BasketService>().createShoppingBasket(newName);
                  await di<BasketStateService>().setBasketId(newId);
                },
              );
            },
            selectedBasket: activeBasket.data,
            inputDecoration: const InputDecoration(
              border: InputBorder.none,
            ),
            disabled: isMultiSelectMode || isShoppingMode,
          ),
        ),
        ShoppingModeToggle(disabled: isMultiSelectMode || !activeBasket.hasData),
        BasketPopupMenu(
          isShoppingMode: isShoppingMode,
          isMultiSelectMode: isMultiSelectMode,
          disabled: !activeBasket.hasData,
        ),
      ],
    );
  }
}
