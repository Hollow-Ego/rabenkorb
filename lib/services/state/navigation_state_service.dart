import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';
import 'package:rabenkorb/features/core/structural/navigation/destinations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/main_page_details.dart';

class NavigationStateService implements Disposable {
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<MainPageDetails?> _mainPageDetails = BehaviorSubject<MainPageDetails?>.seeded(null);

  late StreamSubscription _mainPageDetailsSub;

  int get currentPageIndexSync => _currentPageIndex.value;

  Stream<MainPageDetails?> get mainPageDetails => _mainPageDetails.stream;

  void setCurrentPageIndex(int index) {
    _currentPageIndex.add(index);
  }

  final List<DestinationDetails> _destinations = mainDestinations;

  List<NavigationDestination> get destinations => _destinations.map((e) => e.destination).toList();

  NavigationStateService() {
    _destinations.sort((a, b) => a.index.compareTo(b.index));

    _mainPageDetailsSub = _currentPageIndex.distinct().listen((index) {
      final destination = _destinations[index];
      _mainPageDetails.add(MainPageDetails(
        pageIndex: index,
        body: destination.body,
        mainAction: destination.mainAction,
        appBar: destination.appBar,
      ));
    });
  }

  @override
  FutureOr onDispose() {
    _mainPageDetailsSub.cancel();
    _currentPageIndex.close();
    _mainPageDetails.close();
  }
}
