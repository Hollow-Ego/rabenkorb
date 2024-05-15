import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/shared/widgets/form/core_searchable_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class BasketDropdown extends StatelessWidget with WatchItMixin {
  final ShoppingBasketViewModel? selectedBasket;
  final Function(ShoppingBasketViewModel? basket) onChanged;
  final Function(String)? onNoSearchResultAction;
  final String? dropdownKey;
  final InputDecoration? inputDecoration;
  final bool disabled;

  const BasketDropdown({
    super.key,
    this.selectedBasket,
    required this.onChanged,
    this.onNoSearchResultAction,
    this.dropdownKey,
    this.inputDecoration,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final baskets = watchStream((BasketService p0) => p0.baskets, initialValue: List<ShoppingBasketViewModel>.empty());
    final basketList = baskets.data ?? List<ShoppingBasketViewModel>.empty();

    return CoreSearchableDropdown<ShoppingBasketViewModel>(
      key: dropdownKey != null ? Key(dropdownKey!) : null,
      items: basketList,
      selectedItem: selectedBasket,
      itemAsString: (basket) => basket.name,
      displayString: (basket) => basket?.name ?? S.of(context).NoShoppingBasketSelected,
      compareFn: (a, b) => a.id == b.id,
      onChanged: onChanged,
      onNoSearchResultAction: onNoSearchResultAction,
      inputDecoration: inputDecoration ??
          InputDecoration(
            labelText: S.of(context).Basket,
          ),
      allowEmptyValue: false,
      disabled: disabled,
    );
  }
}
