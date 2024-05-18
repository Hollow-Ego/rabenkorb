import 'package:flutter/material.dart';

abstract class NavigationStateService {
  void setCurrentPageIndex(int index);

  int get currentPageIndexSync;

  List<NavigationDestination> get destinations;
}
