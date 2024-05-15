import 'package:flutter/material.dart';
import 'package:rabenkorb/features/main/navigation/destination_details.dart';

class MainPageDetails {
  final int pageIndex;
  final Widget? body;
  final MainAction? mainAction;
  final PreferredSizeWidget? appBar;
  final bool hideFabInShoppingMode;

  MainPageDetails({required this.pageIndex, this.body, this.mainAction, this.appBar, this.hideFabInShoppingMode = false});
}
