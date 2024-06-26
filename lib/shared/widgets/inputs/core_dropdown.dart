import 'package:flutter/material.dart';

class CoreDropdown<T> extends StatelessWidget {
  final Key dropdownKey;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String label;

  const CoreDropdown({
    super.key,
    required this.dropdownKey,
    required this.items,
    required this.label,
    this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          DropdownButton<T>(
            key: dropdownKey,
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
