import 'package:flutter/material.dart';
import 'package:rabenkorb/services/core/snackbar_service.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_secondary_button.dart';
import 'package:watch_it/watch_it.dart';

class MessagingDebug extends StatelessWidget {
  const MessagingDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            const ListTile(
              title: Text("Messaging"),
            ),
            CoreSecondaryButton(
              child: const Text("Show Text Only Snackbar"),
              onPressed: () {
                di<SnackBarService>().show(context: context, text: "Example Message");
              },
            ),
            CoreSecondaryButton(
              child: const Text("Show Text with Action Snackbar"),
              onPressed: () {
                di<SnackBarService>().show(context: context, text: "Some action that can be undone", action: SnackBarAction(label: "Undo", onPressed: () {}));
              },
            ),
          ],
        ),
      ),
    );
  }
}
