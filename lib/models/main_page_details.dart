import 'package:flutter/material.dart';
import 'package:rabenkorb/shared/destination_details.dart';

class NavigationPageDetails {
  final int pageIndex;
  final Widget? body;
  final MainAction? mainAction;
  final PreferredSizeWidget? appBar;
  final bool hideFabInShoppingMode;

  NavigationPageDetails({required this.pageIndex, this.body, this.mainAction, this.appBar, this.hideFabInShoppingMode = false});
}
