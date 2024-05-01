import 'package:flutter/material.dart';

class CoreCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;

  const CoreCheckbox({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(value: value, onChanged: onChanged);
  }
}
