import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/debug/language_debug.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LanguageDebug(),
        ],
      ),
    );
  }
}
