import 'dart:io';

import 'package:rabenkorb/abstracts/image_service.dart';

class MockImageService extends ImageService {
  @override
  Future<void> deleteImage(String? imagePath) {
    // TODO: implement deleteImage
    throw UnimplementedError();
  }

  @override
  String? getAsBase64(String? imagePath) {
    return "Base64ImgData";
  }

  @override
  Future<File?> saveImage(File? image, {String? saveTo}) {
    // TODO: implement saveImage
    throw UnimplementedError();
  }

  @override
  Future<File?> saveBase64Image(String base64Image, String imagePath) {
    // TODO: implement saveBase64Image
    throw UnimplementedError();
  }
}
