import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/error/error_handler_step.dart';
import 'package:rabenkorb/features/core/error/step_results.enum.dart';
import 'package:rabenkorb/features/core/logging/core_logger.dart';
import 'package:rabenkorb/features/core/logging/enricher/enricher_extension.dart';
import 'package:watch_it/watch_it.dart';

class LogStep extends ErrorHandlerStep {
  late CoreLogger _logger;

  @override
  int level = 10;

  LogStep() {
    _logger = di<CoreLogger>();
  }

  @override
  Future<StepResult> handleError(FlutterErrorDetails exceptionDetails) async {
    var messageLog = EnrichedMessageLog(id: "log-step", message: "An unexpected error occurred");
    _logger.error(messageLog, error: exceptionDetails.exception, stackTrace: exceptionDetails.stack);
    return StepResult.success;
  }
}
