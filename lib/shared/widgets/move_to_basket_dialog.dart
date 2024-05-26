import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/shared/widgets/form/basket_dropdown.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_secondary_button.dart';

class MoveToBasketDialog extends StatefulWidget {
  final ShoppingBasketViewModel? initialBasket;
  final Future<void> Function(int?) onConfirm;
  final Future<void> Function()? onCancel;

  const MoveToBasketDialog({super.key, this.initialBasket, required this.onConfirm, this.onCancel});

  @override
  State<MoveToBasketDialog> createState() => _MoveToBasketDialogState();
}

class _MoveToBasketDialogState extends State<MoveToBasketDialog> {
  int? basketId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).MoveTo),
      content: BasketDropdown(
        selectedBasket: widget.initialBasket,
        onChanged: (basket) {
          setState(() {
            basketId = basket?.id;
          });
        },
      ),
      actions: [
        CorePrimaryButton(
          onPressed: () async => await _confirm(context, widget.onConfirm),
          child: Text(S.of(context).Move),
        ),
        CoreSecondaryButton(
          onPressed: () async => await _cancel(context, widget.onCancel),
          child: Text(S.of(context).Cancel),
        )
      ],
    );
  }

  Future<void> _confirm(BuildContext context, Future<void> Function(int?) onConfirm) async {
    Navigator.pop(context);

    await onConfirm(basketId);
  }

  Future<void> _cancel(BuildContext context, Future<void> Function()? onCancel) async {
    Navigator.pop(context);
    if (onCancel == null) {
      return;
    }
    await onCancel();
  }
}
