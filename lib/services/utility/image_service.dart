import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:rabenkorb/abstracts/image_service.dart';

class LocalImageService extends ImageService {
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

  @override
  String? getAsBase64(String? imagePath) {
    if (imagePath == null) {
      return null;
    }

    final image = File(imagePath);
    if (!image.existsSync()) {
      return null;
    }
    final bytes = image.readAsBytesSync();
    return base64Encode(bytes);
  }

  @override
  Future<File?> saveBase64Image(String base64Image, String imagePath) async {
    final bytes = base64Decode(base64Image);
    final image = File(imagePath);
    await image.writeAsBytes(bytes);
    return saveImage(image);
  }
}
