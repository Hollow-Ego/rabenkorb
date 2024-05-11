import 'package:flutter/material.dart';

class CoreCard extends StatelessWidget {
  final Widget child;

  const CoreCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
