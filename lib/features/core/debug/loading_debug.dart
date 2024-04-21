import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rabenkorb/features/core/inputs/core_secondary_button.dart';
import 'package:rabenkorb/shared/helper_functions.dart';

class LoadingDebug extends StatefulWidget {
  const LoadingDebug({super.key});

  @override
  State<LoadingDebug> createState() => _LoadingDebugState();
}

class _LoadingDebugState extends State<LoadingDebug> {
  final _secondsControl = TextEditingController(text: "3");

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            const ListTile(
              title: Text("Loading"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: 100,
                child: TextField(
                  decoration: const InputDecoration(suffix: Text('Seconds')),
                  controller: _secondsControl,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Only allows digits to be entered
                  ],
                ),
              ),
            ),
            CoreSecondaryButton(
              child: const Text("Start"),
              onPressed: () {
                doWithLoadingIndicator(() async {
                  await Future.delayed(Duration(seconds: int.tryParse(_secondsControl.value.text) ?? 5));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
