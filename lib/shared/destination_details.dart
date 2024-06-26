import 'package:flutter/material.dart';

class DestinationDetails {
  final NavigationDestination destination;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final int index;
  final MainAction? mainAction;
  final Widget? floatingActionButton;
  final bool hideFabInShoppingMode;

  const DestinationDetails({
    required this.destination,
    required this.body,
    required this.index,
    this.appBar,
    this.mainAction,
    this.floatingActionButton,
    this.hideFabInShoppingMode = false,
  });
}

class MainAction {
  final void Function(BuildContext context)? onPressed;
  final Widget? icon;

  MainAction({this.onPressed, this.icon});
}
