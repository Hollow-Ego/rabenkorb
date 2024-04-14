import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/inputs/core_secondary_button.dart';

class LoggingDebug extends StatelessWidget {
  const LoggingDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            CoreSecondaryButton(
              child: const Text("Cause Error"),
              onPressed: () => throw Exception("Test Exception"),
            ),
          ],
        ),
      ),
    );
  }
}
