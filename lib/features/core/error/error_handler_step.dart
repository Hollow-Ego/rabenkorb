import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/error/step_results.enum.dart';

abstract class ErrorHandlerStep {
  abstract int level;

  Future<StepResult> handleError(FlutterErrorDetails exceptionDetails);
}
