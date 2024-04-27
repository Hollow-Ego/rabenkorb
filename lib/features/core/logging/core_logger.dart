import 'package:codenic_logger/codenic_logger.dart';
import 'package:rabenkorb/abstracts/log_sink.dart';
import 'package:rabenkorb/models/log_data.dart';
import 'package:watch_it/watch_it.dart';

class CoreLogger extends CodenicLogger {
  final List<LogSinks> _sinks = di<List<LogSinks>>();

  @override
  void error(
    MessageLog messageLog, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    super.error(messageLog, error: error, stackTrace: stackTrace);
    var logData = toLogData(messageLog, error: error.message, stackTrace: stackTrace);
    logToDatabase(logData);
  }

  Future<void> logToDatabase(LogData logData) async {
    for (var sink in _sinks) {
      sink.sendLog(logData);
    }
  }

  LogData toLogData(
    MessageLog messageLog, {
    String? error,
    StackTrace? stackTrace,
  }) {
    return LogData.fromLogEvent(messageLog, error: error, stackTrace: stackTrace);
  }
}
