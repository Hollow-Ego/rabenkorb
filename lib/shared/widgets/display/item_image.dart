import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rabenkorb/shared/widgets/display/item_image_view.dart';

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
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return ItemImageView(
              image: imageFile,
            );
          },
        );
      },
    );
  }
}
