import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Backup {
  String appVersion;
  String fileName;
  Map<String, String> base64Images;

  Backup({required this.appVersion, required this.fileName, required this.base64Images});
}
