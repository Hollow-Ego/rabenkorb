import 'package:flutter/material.dart';

class CoreIconTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final Widget label;

  const CoreIconTextButton({super.key, this.onPressed, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: label,
      icon: icon,
    );
  }
}
