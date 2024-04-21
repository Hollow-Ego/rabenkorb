import 'package:codenic_logger/codenic_logger.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log_data.g.dart';

@JsonSerializable(explicitToJson: true)
class LogData {
  late String id;
  String? message;
  late Map<String, dynamic> context;
  dynamic error;
  String? stackTrace;

  LogData(
    this.id,
    this.message,
    this.context,
    this.error,
    this.stackTrace,
  );

  factory LogData.fromLogEvent(
    MessageLog messageLog, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final id = messageLog.id;
    final message = messageLog.message;
    final context = messageLog.data;
    final stackTraceString = stackTrace?.toString();
    return LogData(id, message, context, error, stackTraceString);
  }

  factory LogData.fromJson(Map<String, dynamic> json) => _$LogDataFromJson(json);

  Map<String, dynamic> toJson() => _$LogDataToJson(this);
}
