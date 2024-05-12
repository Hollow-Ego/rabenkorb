import 'package:flutter/material.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/widgets/form/basket_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class BasketTitle extends StatelessWidget with WatchItMixin {
  const BasketTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final activeBasket = watchStream((BasketService p0) => p0.activeBasket, initialValue: null);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: BasketDropdown(
            onChanged: (ShoppingBasketViewModel? basket) async {
              await di<BasketStateService>().setBasketId(basket?.id);
            },
            onNoSearchResultAction: (String searchValue) async {
              final newId = await di<BasketService>().createShoppingBasket(searchValue);
              await di<BasketStateService>().setBasketId(newId);
            },
            selectedBasket: activeBasket.data,
            inputDecoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
