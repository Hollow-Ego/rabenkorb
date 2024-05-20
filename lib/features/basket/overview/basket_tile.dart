import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:watch_it/watch_it.dart';

class BasketTile extends StatelessWidget {
  final ShoppingBasketViewModel basket;

  const BasketTile({super.key, required this.basket});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: di<BasketService>().countItemsInBasket(basket.id),
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> itemsInBasketSnapshot) {
        final itemsInBasketCount = itemsInBasketSnapshot.data ?? 0;
        return Card(
          child: ListTile(
            title: Text(basket.name),
            subtitle: Text("${S.of(context).Items}: $itemsInBasketCount"),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                CoreIconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await showRenameDialog(
                      context,
                      initialName: basket.name,
                      onConfirm: (String? newName, bool nameChanged) async {
                        if (!nameChanged || newName == null) {
                          return;
                        }
                        await di<BasketService>().updateShoppingBasket(basket.id, newName);
                      },
                    );
                  },
                ),
                CoreIconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await doWithConfirmation(
                      context,
                      text: S.of(context).ConfirmDeleteBasket,
                      title: S.of(context).Confirm,
                      onConfirm: () async {
                        await di<BasketService>().deleteShoppingBasketById(basket.id);
                        di<BasketService>().setFirstShoppingBasketActive();
                      },
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
