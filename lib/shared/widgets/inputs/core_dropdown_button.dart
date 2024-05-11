import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CoreDropdownButton<T> extends StatelessWidget {
  final void Function(T?)? onPressed;
  final Widget? icon;
  final List<DropdownMenuItem<T>>? items;
  final T? selectedItem;
  final bool useArrowIcon;
  final bool isDisabled;

  const CoreDropdownButton({super.key, this.onPressed, this.icon, this.items, this.selectedItem, this.useArrowIcon = false, this.isDisabled = false});

  Widget _dropdown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        items: items,
        onChanged: isDisabled ? null : onPressed,
        value: selectedItem,
        icon: Visibility(visible: useArrowIcon, child: const Icon(Icons.arrow_drop_down)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
      final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[icon!, SizedBox(width: gap), Flexible(child: _dropdown(context))],
      );
    }
    return _dropdown(context);
  }
}
