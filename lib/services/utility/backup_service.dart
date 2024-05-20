import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rabenkorb/abstracts/image_service.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/di/di_setup.dart';
import 'package:rabenkorb/exceptions/incompatible_app_version.dart';
import 'package:rabenkorb/models/backup.dart';
import 'package:rabenkorb/services/core/version_service.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:watch_it/watch_it.dart';

// ToDo: Write integration test
class BackupService {
  final String _backupBasename = "rabenkorb_backup";
  final DateTime _exportTime = DateTime.now();

  final _imageService = di<ImageService>();
  final _database = di<AppDatabase>();
  final _versionService = di<VersionService>();

  final List<String> _incompatibleVersions = [];

  Future<bool> backup(String exportPath) async {
    try {
      final base64Images = await _encodeImages();
      final backupName = _getBackupName(_exportTime);
      final backup = Backup(
        appVersion: _versionService.publicAppVersion,
        fileName: "$backupName.sqlite",
        base64Images: base64Images,
      );

      _saveBackup(exportPath, backup);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restore(String importPath) async {
    try {
      final directory = Directory(importPath);
      final backupJson = _getBackupJson(directory);
      if (backupJson == null) {
        return false;
      }
      final backup = Backup.fromJson(backupJson);
      String appVersion = backup.appVersion;

      throwIf(_incompatibleVersions.contains(appVersion), IncompatibleAppVersionException(appVersion));

      String fileName = backup.fileName;
      Map<String, String> base64Images = backup.base64Images;
      await _decodeImages(base64Images);
      await _importFrom(importPath, fileName);
      return true;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic>? _getBackupJson(Directory directory) {
    try {
      var fileList = directory.listSync();
      var fileEntity = fileList.firstWhere((element) {
        return p.extension(element.path).toLowerCase().contains(".json");
      });
      return jsonDecode(File(fileEntity.path).readAsStringSync());
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveBackup(String exportPath, Backup backup) async {
    final backupDetails = await _createBackupDetailsFile(exportPath, backup.fileName);
    final backupDb = _createBackupDbFile(exportPath, backup.fileName);

    final serializedData = jsonEncode(backup);
    await backupDetails.writeAsString(serializedData);

    await _database.exportInto(backupDb);
  }

  Future<File> _createBackupDetailsFile(String exportPath, String backupName) async {
    await Directory("$exportPath/$backupName").create();
    return File("$exportPath/$backupName/$backupName.json");
  }

  File _createBackupDbFile(String exportPath, String backupName) {
    return File("$exportPath/$backupName/$backupName");
  }

  String _getBackupName(DateTime exportTime) {
    String timeStamp = DateFormat('H_m_s-d-M-y').format(exportTime);
    return "${_backupBasename}_$timeStamp";
  }

  Future<Map<String, String>> _encodeImages() async {
    Map<String, String> imageMap = {};

    final templateImages = await _database.itemTemplatesDao.getImagePaths();
    final basketImages = await _database.basketItemsDao.getImagePaths();

    final uniqueImages = <String>{...templateImages, ...basketImages};
    for (var img in uniqueImages) {
      final base64String = _imageService.getAsBase64(img);
      if (base64String == null) {
        continue;
      }
      imageMap[img] = base64String;
    }
    return imageMap;
  }

  Future<void> _decodeImages(Map<String, String> base64Images) async {
    base64Images.forEach((key, value) async {
      await _imageService.saveBase64Image(value, key);
    });
  }

  Future<void> _importFrom(String importPath, String fileName) async {
    await _database.close();

    final backupDbPath = p.join(importPath, fileName);
    final backupDb = sqlite3.open(backupDbPath);

    // Vacuum it into a temporary location first to make sure it's working.
    final tempPath = await getTemporaryDirectory();
    final tempDb = p.join(tempPath.path, 'import.db');
    backupDb
      ..execute('VACUUM INTO ?', [tempDb])
      ..dispose();

    // Then replace the existing database file with it.
    final tempDbFile = File(tempDb);
    final dbFolder = await getApplicationDocumentsDirectory();
    final appDbFile = File(p.join(dbFolder.path, AppDatabase.databaseFileName));
    await tempDbFile.copy(appDbFile.path);
    await tempDbFile.delete();

    await reinitializeDataRegistrations();
  }
}
