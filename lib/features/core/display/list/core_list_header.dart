import 'package:flutter/material.dart';
import 'package:rabenkorb/shared/extensions.dart';

class CoreListHeader extends StatelessWidget {
  final String header;

  const CoreListHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    final subKey = header.toLowerSpaceless();
    return Chip(
      key: Key("$subKey-header"),
      label: Text(
        header,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.white12,
    );
  }
}
