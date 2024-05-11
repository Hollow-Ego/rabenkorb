import 'package:flutter/material.dart';

class CoreSecondaryButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const CoreSecondaryButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
