import 'package:codenic_logger/codenic_logger.dart';
import 'package:rabenkorb/abstracts/log_sink.dart';
import 'package:rabenkorb/models/log_data.dart';
import 'package:watch_it/watch_it.dart';

class CoreLogger extends CodenicLogger {
  final LogSink _sink = di<LogSink>();

  @override
  void error(
    MessageLog messageLog, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    super.error(messageLog, error: error, stackTrace: stackTrace);
    var logData = toLogData(messageLog, error: error, stackTrace: stackTrace);
    logToDatabase(logData);
  }

  Future<void> logToDatabase(LogData logData) async {
    _sink.sendLog(logData);
  }

  LogData toLogData(
    MessageLog messageLog, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return LogData.fromLogEvent(messageLog, error: error, stackTrace: stackTrace);
  }
}
