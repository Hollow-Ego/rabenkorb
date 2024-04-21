import 'dart:io';

import 'package:rabenkorb/abstracts/image_service.dart';

class MockImageService extends ImageService {
  @override
  Future<void> deleteImage(String? imagePath) async {}

  @override
  String? getAsBase64(String? imagePath) {
    return "Base64ImgData";
  }

  @override
  Future<File?> saveImage(File? image, {String? saveTo}) async {
    return image;
  }

  @override
  Future<File?> saveBase64Image(String base64Image, String imagePath) async {
    return File(imagePath);
  }
}
