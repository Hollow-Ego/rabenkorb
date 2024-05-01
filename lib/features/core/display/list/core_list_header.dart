import 'package:flutter/material.dart';

class CoreListHeader extends StatelessWidget {
  final String header;
  final String subKey;

  const CoreListHeader({super.key, required this.header, required this.subKey});

  @override
  Widget build(BuildContext context) {
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
