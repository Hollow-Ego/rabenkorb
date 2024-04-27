import 'package:rabenkorb/abstracts/log_sink.dart';
import 'package:rabenkorb/models/app_info.dart';
import 'package:rabenkorb/models/log_data.dart';

class VoidSink implements LogSinks {
  // Sink does nothing

  @override
  Future<void> sendAppInfo(AppInfo appInfo) async {
    return;
  }

  @override
  Future<void> sendLog(LogData logData) async {
    return;
  }
}
