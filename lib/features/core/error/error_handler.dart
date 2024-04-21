import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/error/error_handler_step.dart';
import 'package:rabenkorb/features/core/error/step_results.enum.dart';
import 'package:watch_it/watch_it.dart';

class ErrorHandler {
  final List<ErrorHandlerStep> _errorHandlerSteps = [];

  ErrorHandler() {
    var steps = di<List<ErrorHandlerStep>>();
    _errorHandlerSteps.addAll(steps);
    _errorHandlerSteps.sort((a, b) => a.level.compareTo(b.level));
  }

  Future<void> handleError(FlutterErrorDetails error) async {
    _handleDefault(error);
    for (final errorHandlerStep in _errorHandlerSteps) {
      var result = await errorHandlerStep.handleError(error);
      if (result == StepResult.stopHandling) {
        break;
      }
    }
  }

  void _handleDefault(FlutterErrorDetails error) {
    FlutterError.presentError(error);
  }
}
