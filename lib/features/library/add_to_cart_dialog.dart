import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/core/snackbar_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/widgets/constant_widgets.dart';
import 'package:rabenkorb/shared/widgets/form/basket_dropdown.dart';
import 'package:rabenkorb/shared/widgets/form/core_text_form_field.dart';
import 'package:rabenkorb/shared/widgets/form/unit_dropdown.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class AddToCardDialog extends StatefulWidget {
  final ItemTemplateViewModel item;
  final ShoppingBasketViewModel? activeBasket;

  const AddToCardDialog({super.key, required this.item, this.activeBasket});

  @override
  State<AddToCardDialog> createState() => _AddToCardDialogState();
}

class _AddToCardDialogState extends State<AddToCardDialog> {
  final TextEditingController _amountController = TextEditingController();
  late ItemTemplateViewModel _item;
  ItemUnitViewModel? _unit;
  ShoppingBasketViewModel? _basket;

  @override
  void initState() {
    super.initState();
    _basket = widget.activeBasket;
    _item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: Key("${widget.item.key}-dialog"),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BasketDropdown(
              dropdownKey: 'basket-dropdown',
              selectedBasket: _basket,
              onNoSearchResultAction: (String searchValue) async {
                final newId = await di<BasketService>().createShoppingBasket(searchValue);
                _setBasket(ShoppingBasketViewModel(newId, searchValue));
              },
              onChanged: _setBasket,
            ),
            CoreTextFormField(
              labelText: S.of(context).Amount,
              textEditingController: _amountController,
              formFieldKey: "amount-input",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            gap,
            UnitDropdown(
              dropdownKey: 'unit-dropdown',
              selectedUnit: _unit,
              onNoSearchResultAction: (String searchValue) async {
                final newId = await di<MetadataService>().createItemUnit(searchValue);
                _setUnit(ItemUnitViewModel(newId, searchValue));
              },
              onChanged: _setUnit,
            ),
            gap,
            CorePrimaryButton(
              key: const Key('add-to-cart-button'),
              child: Text(S.of(context).Add),
              onPressed: () async {
                try {
                  di<BasketService>().createBasketItem(
                    _item.name,
                    basketId: _basket?.id,
                    categoryId: _item.category?.id,
                    imagePath: _item.imagePath,
                    amount: _amountController.text.toDoubleOrZero(),
                    unitId: _unit?.id,
                  );
                  di<SnackBarService>().show(context: context, text: S.of(context).ItemAddedToCard(_item.name));
                } finally {
                  context.pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _setUnit(ItemUnitViewModel? unit) {
    setState(() {
      _unit = unit;
    });
  }

  void _setBasket(ShoppingBasketViewModel? basket) {
    setState(() {
      _basket = basket;
    });
  }
}
