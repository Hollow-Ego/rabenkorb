import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rabenkorb/shared/extensions.dart';

class CoreTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final Widget? icon;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? initialValue;
  final String? formFieldKey;
  final Function(String)? onChanged;
  final TextInputType keyboardType;

  const CoreTextFormField({
    super.key,
    required this.labelText,
    required this.textEditingController,
    this.icon,
    this.textInputAction,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.formFieldKey,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final localeDecimalPoint = NumberFormat.decimalPattern().symbols.DECIMAL_SEP;
    return TextFormField(
      key: formFieldKey.isValid() ? Key(formFieldKey!) : null,
      decoration: InputDecoration(
        labelText: labelText,
        icon: icon,
      ),
      controller: textEditingController,
      textInputAction: textInputAction ?? TextInputAction.next,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: [
        if (keyboardType.decimal == true) FilteringTextInputFormatter.allow(RegExp('[0-9$localeDecimalPoint]')),
        if (keyboardType.decimal == true)
          TextInputFormatter.withFunction(
            (oldValue, newValue) {
              // Ensures there's only one decimal point
              if (newValue.text.split(localeDecimalPoint).length > 2) {
                return oldValue;
              }
              return newValue;
            },
          ),
      ],
    );
  }
}
