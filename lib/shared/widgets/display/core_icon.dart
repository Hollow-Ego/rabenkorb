import 'package:flutter/material.dart';

class CoreIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final bool usePrimaryColor;
  final double? iconSize;

  const CoreIcon({
    super.key,
    required this.icon,
    this.color,
    this.usePrimaryColor = false,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Icon(
      icon,
      color: usePrimaryColor ? primaryColor : color,
      size: iconSize,
    );
  }
}
