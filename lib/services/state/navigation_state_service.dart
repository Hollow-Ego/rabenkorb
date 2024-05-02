import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';
import 'package:rabenkorb/features/core/structural/navigation/destinations.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/main_page_details.dart';

class NavigationStateService {
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject<int>.seeded(0);

  int get currentPageIndexSync => _currentPageIndex.value;

  Stream<MainPageDetails?> get mainPageDetails => _currentPageIndex.distinct().map((index) {
        final destination = _destinations[index];
        return MainPageDetails(
          body: destination.body,
          mainAction: destination.mainAction,
          appBar: destination.appBar,
        );
      });

  setCurrentPageIndex(int index) {
    _currentPageIndex.add(index);
  }

  final List<DestinationDetails> _destinations = mainDestinations;

  List<NavigationDestination> get destinations => _destinations.map((e) => e.destination).toList();

  NavigationStateService() {
    _destinations.sort((a, b) => a.index.compareTo(b.index));
  }
}
