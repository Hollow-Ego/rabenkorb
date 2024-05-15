import 'package:flutter/material.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:watch_it/watch_it.dart';

class ShoppingModeToggle extends StatelessWidget with WatchItMixin {
  final bool disabled;

  const ShoppingModeToggle({super.key, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final isShoppingModeStream = watchStream((BasketStateService p0) => p0.isShoppingMode, initialValue: false);
    final isShoppingMode = isShoppingModeStream.data ?? false;
    return CoreIconButton(
      icon: isShoppingMode ? const Icon(Icons.shopping_basket) : const Icon(Icons.edit),
      onPressed: disabled
          ? null
          : () async {
              await di<BasketStateService>().toggleShoppingMode();
            },
    );
  }
}
