import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/inputs/core_secondary_button.dart';
import 'package:rabenkorb/services/core/dialog_service.dart';
import 'package:rabenkorb/shared/state_types.dart';
import 'package:watch_it/watch_it.dart';

class DialogDebug extends StatefulWidget {
  const DialogDebug({super.key});

  @override
  State<DialogDebug> createState() => _DialogDebugState();
}

class _DialogDebugState extends State<DialogDebug> {
  var _dialogResult = "None";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            const ListTile(
              title: Text("Dialog"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Dialog Result: $_dialogResult"),
            ),
            CoreSecondaryButton(
              child: const Text("Show Success Dialog"),
              onPressed: () {
                di<DialogService>().showSuccess(
                  context: context,
                  text: "This is a success dialog!",
                  title: "Success Dialog",
                );
              },
            ),
            CoreSecondaryButton(
              child: const Text("Show Error Dialog"),
              onPressed: () {
                di<DialogService>().showError(
                  context: context,
                  text: "Some error occurred",
                  title: "Error Dialog",
                );
              },
            ),
            CoreSecondaryButton(
              child: const Text("Show Warning Dialog"),
              onPressed: () {
                di<DialogService>().showWarning(
                  context: context,
                  text: "Warning about the thing",
                  title: "Warning Dialog",
                );
              },
            ),
            CoreSecondaryButton(
              child: const Text("Show Info Dialog"),
              onPressed: () {
                di<DialogService>().showInfo(
                  context: context,
                  text: "Just FYI",
                  title: "Info Dialog",
                );
              },
            ),
            CoreSecondaryButton(
              child: const Text("Show Confirm Dialog"),
              onPressed: () {
                di<DialogService>().showConfirm(
                    context: context,
                    text: "Do you really want to do the thing?",
                    title: "Doing the thing",
                    type: StateType.neutral,
                    onConfirm: () async {
                      setState(() {
                        _dialogResult = "Confirmed";
                      });
                    },
                    onCancel: () async {
                      setState(() {
                        _dialogResult = "Canceled";
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
