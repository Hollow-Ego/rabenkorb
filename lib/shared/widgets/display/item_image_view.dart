import 'dart:io';

import 'package:flutter/material.dart';

class ItemImageView extends StatelessWidget {
  final File image;

  const ItemImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        height: 350,
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
