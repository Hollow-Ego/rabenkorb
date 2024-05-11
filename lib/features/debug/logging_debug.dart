import 'package:flutter/material.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_secondary_button.dart';

class LoggingDebug extends StatelessWidget {
  const LoggingDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            const ListTile(
              title: Text("Logging"),
            ),
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
