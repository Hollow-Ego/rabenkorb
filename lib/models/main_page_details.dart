import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';

class MainPageDetails {
  final int pageIndex;
  final Widget? body;
  final MainAction? mainAction;
  final PreferredSizeWidget? appBar;

  MainPageDetails({required this.pageIndex, this.body, this.mainAction, this.appBar});
}
