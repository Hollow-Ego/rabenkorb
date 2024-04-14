import 'package:rabenkorb/models/app_info.dart';
import 'package:rabenkorb/models/log_data.dart';

abstract class LogSink {
  Future<void> sendLog(LogData logData);

  Future<void> sendAppInfo(AppInfo appInfo);
}
