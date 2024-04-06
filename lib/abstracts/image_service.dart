import 'dart:io';

abstract class ImageService {
  Future<File?> saveImage(File? image, {String? saveTo});

  Future<File?> saveBase64Image(String base64Image, String imagePath);

  Future<void> deleteImage(String? imagePath);

  String? getAsBase64(String? imagePath);
}
