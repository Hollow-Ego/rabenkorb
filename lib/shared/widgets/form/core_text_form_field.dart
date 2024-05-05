import 'package:flutter/material.dart';

class CoreTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final Widget? icon;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? initialValue;
  final Function(String)? onChanged;

  const CoreTextFormField({
    super.key,
    required this.labelText,
    required this.textEditingController,
    this.icon,
    this.textInputAction,
    this.validator,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        icon: icon,
      ),
      controller: textEditingController,
      textInputAction: textInputAction ?? TextInputAction.next,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}
