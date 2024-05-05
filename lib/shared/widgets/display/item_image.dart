import 'dart:io';

import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  final String imagePath;

  const ItemImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: FileImage(imageFile),
      ),
      onTap: () async {},
    );
  }
}
