import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:rabenkorb/abstracts/image_service.dart';

class LocalImageService extends ImageService {
  final List<String> _supportedFileTypes = [
    '.png',
    '.jpeg',
    '.jpg',
  ];

  @override
  Future<void> copyImagesFromDirectory(Directory directory, {String? saveTo}) async {
    await directory.list().forEach((element) async {
      if (element is! File) return;

      final fileType = path.extension(element.path);

      if (!_supportedFileTypes.contains(fileType)) {
        return;
      }
      final fileExists = await element.exists();
      if (!fileExists) {
        return;
      }
      await saveImage(element, saveTo: saveTo);
    });
  }

  @override
  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null) {
      return;
    }
    final image = File(imagePath);
    await image.delete();
  }

  @override
  Future<File?> saveImage(File? image, {String? saveTo}) async {
    if (image == null) {
      return null;
    }

    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final targetPath = saveTo ?? appDir.path;
    final targetFile = File("$targetPath/$fileName");

    if (await targetFile.exists()) {
      return null;
    }
    return image.copy("$targetPath/$fileName");
  }
}
