import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';

class SelectedImage extends StatelessWidget {
  final Function() onTap;
  final Function() onClear;
  final File image;

  const SelectedImage({
    super.key,
    required this.onTap,
    required this.image,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            alignment: Alignment.center,
            child: Image.file(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 350,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onClear,
          label: Text(S.of(context).ClearImage),
          icon: const Icon(Icons.clear),
        ),
      ],
    );
  }
}
