import 'package:flutter/material.dart';

class SnackBarService {
  final Duration _defaultDuration = const Duration(seconds: 4);

  void show({
    required BuildContext context,
    required String text,
    Duration? duration,
    SnackBarAction? action,
  }) {
    final snackBar = _createSnackBar(text, duration, action);
    _show(context, snackBar);
  }

  void _show(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar _createSnackBar(String text, Duration? duration, SnackBarAction? action) {
    final content = Text(text);
    return SnackBar(
      content: content,
      duration: duration ?? _defaultDuration,
      showCloseIcon: true,
      action: action,
    );
  }
}
