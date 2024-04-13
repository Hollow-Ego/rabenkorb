import 'package:flutter/material.dart';

class DestinationDetails {
  final NavigationDestination destination;
  final Widget body;
  final Widget? title;
  final int index;
  final MainAction? mainAction;

  const DestinationDetails({
    required this.destination,
    required this.body,
    required this.index,
    this.title,
    this.mainAction,
  });
}

class MainAction {
  final void Function(BuildContext context)? onPressed;
  final Widget? icon;

  MainAction({this.onPressed, this.icon});
}
