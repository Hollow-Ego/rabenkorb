import 'package:flutter/material.dart';

class DrawerEntry {
  final String? title;
  final int position;
  final void Function(BuildContext context)? onTap;
  final Widget? leading;
  final Widget? titleWidget;

  DrawerEntry({this.title, required this.position, this.onTap, this.leading, this.titleWidget});
}
