import 'dart:io';

abstract class ImageService {
  Future<File?> saveImage(File? image, {String? saveTo});

  Future<void> deleteImage(String? imagePath);

  Future<void> copyImagesFromDirectory(Directory directory, {String? saveTo});
}
