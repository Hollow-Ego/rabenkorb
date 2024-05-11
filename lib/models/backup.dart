import 'package:json_annotation/json_annotation.dart';

part 'backup.g.dart';

@JsonSerializable(explicitToJson: true)
class Backup {
  String appVersion;
  String fileName;
  Map<String, String> base64Images;

  Backup({required this.appVersion, required this.fileName, required this.base64Images});

  factory Backup.fromJson(Map<String, dynamic> json) => _$BackupFromJson(json);

  Map<String, dynamic> toJson() => _$BackupToJson(this);
}
