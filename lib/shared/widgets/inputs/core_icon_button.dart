import 'package:flutter/material.dart';

class CoreIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final double? iconSize;

  const CoreIconButton({super.key, this.onPressed, required this.icon, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      iconSize: iconSize,
      onPressed: onPressed,
    );
  }
}
