import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rabenkorb/abstracts/navigation_state_service.dart';
import 'package:rabenkorb/features/main/navigation/destinations.dart';
import 'package:rabenkorb/shared/destination_details.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/main_page_details.dart';

class MainNavigationStateService implements Disposable, NavigationStateService {
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<NavigationPageDetails?> _mainPageDetails = BehaviorSubject<NavigationPageDetails?>.seeded(null);

  late StreamSubscription _mainPageDetailsSub;

  @override
  int get currentPageIndexSync => _currentPageIndex.value;

  Stream<NavigationPageDetails?> get mainPageDetails => _mainPageDetails.stream;

  @override
  void setCurrentPageIndex(int index) {
    _currentPageIndex.add(index);
  }

  final List<DestinationDetails> _destinations = mainDestinations;

  @override
  List<NavigationDestination> get destinations => _destinations.map((e) => e.destination).toList();

  MainNavigationStateService() {
    _destinations.sort((a, b) => a.index.compareTo(b.index));

    _mainPageDetailsSub = _currentPageIndex.distinct().listen((index) {
      final destination = _destinations[index];
      _mainPageDetails.add(NavigationPageDetails(
        pageIndex: index,
        body: destination.body,
        mainAction: destination.mainAction,
        fab: destination.floatingActionButton,
        appBar: destination.appBar,
        hideFabInShoppingMode: destination.hideFabInShoppingMode,
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
