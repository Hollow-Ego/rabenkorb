import 'package:flutter/material.dart';

class CoreTextIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final String label;

  const CoreTextIconButton({super.key, this.onPressed, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(label),
      icon: icon,
      onPressed: onPressed,
    );
  }
}
