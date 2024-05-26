import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:watch_it/watch_it.dart';

class BasketFloatingActionButton extends StatelessWidget with WatchItMixin {
  const BasketFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isShoppingModeStream = watchStream((BasketStateService p0) => p0.isShoppingMode, initialValue: false);
    final isShoppingMode = isShoppingModeStream.data ?? false;
    return FloatingActionButton(
      onPressed: () {
        if (isShoppingMode) {
          final basketService = di<BasketService>();
          final activeBasketId = basketService.activeBasketSync?.id;
          if (activeBasketId == null) {
            return;
          }
          basketService.removeCheckedItemsFromBasket(activeBasketId);
          return;
        }
        context.push(Routes.basketItemDetails);
      },
      child: isShoppingMode ? const Icon(Icons.done_all) : const Icon(Icons.add),
    );
  }
}
