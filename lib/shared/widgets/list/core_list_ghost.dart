import 'package:flutter/material.dart';

class CoreListGhost extends StatelessWidget {
  const CoreListGhost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 100.0),
          child: const Icon(Icons.add_box),
        ),
      ),
    );
  }
}
