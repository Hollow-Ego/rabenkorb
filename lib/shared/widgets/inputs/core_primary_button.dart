import 'package:flutter/material.dart';

class CorePrimaryButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const CorePrimaryButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            }
            return Theme.of(context).colorScheme.primary;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
          (Set<MaterialState> states) {
            return TextStyle(color: Theme.of(context).colorScheme.onPrimary);
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return Theme.of(context).colorScheme.onPrimary;
          },
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
