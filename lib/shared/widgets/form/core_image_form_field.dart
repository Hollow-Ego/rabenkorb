import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rabenkorb/shared/widgets/inputs/image/image_input.dart';

class ImageFormField extends FormField<File> {
  final InputDecoration decoration;

  ImageFormField({
    super.key,
    this.decoration = const InputDecoration(),
    super.initialValue,
    super.onSaved,
    super.validator,
  }) : super(
          builder: (FormFieldState<File> field) {
            final InputDecoration effectiveDecoration = decoration.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
                border: InputBorder.none,
              ),
              isEmpty: field.value?.path.isEmpty ?? true,
              child: ImageInputWidget(
                onChanged: field.didChange,
                initialImage: field.value,
              ),
            );
          },
        );
}
