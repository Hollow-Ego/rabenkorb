import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/inputs/image/no_selected_image.dart';
import 'package:rabenkorb/shared/widgets/inputs/image/selected_image.dart';

class ImageInputWidget extends StatefulWidget {
  final Function(File?) onChanged;
  final File? initialImage;

  const ImageInputWidget({
    super.key,
    required this.onChanged,
    this.initialImage,
  });

  @override
  ImageInputWidgetState createState() => ImageInputWidgetState();
}

class ImageInputWidgetState extends State<ImageInputWidget> {
  File? _selectedImage;

  bool get hasImage {
    return _selectedImage != null;
  }

  Future<void> _pickImage() async {
    final source = await pickImageSource(context);
    if (source == null) {
      return;
    }
    final image = await pickImage(source);
    if (image == null) {
      return;
    }
    setState(() {
      _selectedImage = File(image.path);
    });

    widget.onChanged(_selectedImage);
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onChanged(null);
  }

  @override
  void initState() {
    super.initState();
    final initialImage = widget.initialImage;
    if (initialImage == null) return;
    _selectedImage = initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return hasImage
        ? SelectedImage(
            onTap: _pickImage,
            image: _selectedImage!,
            onClear: _clearImage,
          )
        : NoSelectedImage(
            onPick: _pickImage,
          );
  }
}
