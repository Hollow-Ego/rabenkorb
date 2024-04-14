import 'package:flutter/material.dart';

class DrawerEntry {
  final String title;
  final int index;
  final void Function(BuildContext context) onTap;
  final Widget leading;

  DrawerEntry({required this.title, required this.index, required this.onTap, required this.leading});
}
