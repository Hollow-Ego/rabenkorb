import 'package:flutter/material.dart';
import 'package:rabenkorb/features/library/add_to_cart_dialog.dart';
import 'package:rabenkorb/features/library/item_template_popup_menu.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/widgets/display/core_icon.dart';
import 'package:rabenkorb/shared/widgets/display/item_image.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_checkbox.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateTile extends StatelessWidget {
  final ItemTemplateViewModel item;
  final double iconSize = 26;
  final bool isMultiSelectMode;
  final bool isSelected;

  const ItemTemplateTile(
    this.item, {
    super.key,
    this.isMultiSelectMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(item.key),
      child: ListTile(
        title: Text(item.name),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.imagePath.isValid())
              ItemImage(
                imagePath: item.imagePath!,
              ),
            CoreIconButton(
              icon: CoreIcon(
                icon: Icons.shopping_basket,
                usePrimaryColor: true,
                iconSize: iconSize,
              ),
              onPressed: () async {
                final activeBasketId = di<BasketStateService>().basketIdSync;
                final activeBasket = await di<BasketService>().getShoppingBasketById(activeBasketId);
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddToCardDialog(
                        item: item,
                        activeBasket: activeBasket,
                      );
                    },
                  );
                }
              },
            ),
            if (!isMultiSelectMode) ItemTemplatePopupMenu(item),
            if (isMultiSelectMode)
              CoreCheckbox(
                value: isSelected,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  di<LibraryStateService>().setSelectionState(item.id, value);
                },
              ),
          ],
        ),
      ),
    );
  }
}
