import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/basket_item_popup_menu.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/widgets/display/item_image.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_checkbox.dart';
import 'package:watch_it/watch_it.dart';

class BasketItemTile extends StatelessWidget {
  final BasketItemViewModel item;
  final double iconSize = 26;
  final bool isMultiSelectMode;
  final bool isSelected;
  final bool isShoppingMode;

  const BasketItemTile(
    this.item, {
    super.key,
    this.isMultiSelectMode = false,
    this.isSelected = false,
    required this.isShoppingMode,
  });

  @override
  Widget build(BuildContext context) {
    final extraWidget = _extra();
    return Card(
      key: Key(item.key),
      color: item.isChecked ? Theme.of(context).colorScheme.surface.withAlpha(220) : null,
      child: ListTile(
        title: Text(
          item.name,
          style: TextStyle(decoration: item.isChecked ? TextDecoration.lineThrough : null),
        ),
        subtitle: _subtitle(),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (extraWidget != null) extraWidget,
            if (item.imagePath.isValid())
              ItemImage(
                imagePath: item.imagePath!,
              ),
            if (!isMultiSelectMode && !isShoppingMode) BasketItemPopupMenu(item),
            if (isMultiSelectMode && !isShoppingMode)
              CoreCheckbox(
                value: isSelected,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  di<BasketStateService>().setSelectionState(item.id, value);
                },
              ),
            if (isShoppingMode)
              CoreCheckbox(
                value: item.isChecked,
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  await di<BasketService>().setBasketItemCheckedState(item.id, value);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget? _amountUnit() {
    final unit = item.unit;
    final amount = item.amount;
    final hasAmount = amount > 0;
    if (unit == null && !hasAmount) {
      return null;
    }
    final subtitle = "${hasAmount ? amount.toFormattedString() : ''} ${unit?.name ?? ''}";
    return Text(subtitle.trim());
  }

  Widget? _note() {
    final note = item.note;
    if (!note.isValid()) {
      return null;
    }
    final subtitle = note!;
    return Text(
      subtitle.trim(),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget? _subtitle() {
    return _amountUnit();
  }

  Widget? _extra() {
    return _note();
  }
}
