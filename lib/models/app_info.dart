import 'package:json_annotation/json_annotation.dart';

part 'app_info.g.dart';

@JsonSerializable(explicitToJson: true)
class AppInfo {
  String internalAppVersion;
  String publicAppVersion;
  Map<String, dynamic> deviceInfo;
  DateTime creationTime;

  AppInfo(
    this.publicAppVersion,
    this.internalAppVersion,
    this.deviceInfo,
    this.creationTime,
  );

  factory AppInfo.fromJson(Map<String, dynamic> json) => _$AppInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AppInfoToJson(this);
}
