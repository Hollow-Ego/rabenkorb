import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rabenkorb/abstracts/navigation_state_service.dart';
import 'package:rabenkorb/features/data_management/navigation/destinations.dart';
import 'package:rabenkorb/shared/destination_details.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/main_page_details.dart';

class DataManagementNavigationStateService implements Disposable, NavigationStateService {
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<NavigationPageDetails?> _dataManagementPageDetails = BehaviorSubject<NavigationPageDetails?>.seeded(null);

  late StreamSubscription _dataManagementPageDetailsSub;

  int get currentPageIndexSync => _currentPageIndex.value;

  Stream<NavigationPageDetails?> get dataManagementPageDetails => _dataManagementPageDetails.stream;

  void setCurrentPageIndex(int index) {
    _currentPageIndex.add(index);
  }

  final List<DestinationDetails> _destinations = dataManagementDestinations;

  List<NavigationDestination> get destinations => _destinations.map((e) => e.destination).toList();

  DataManagementNavigationStateService() {
    _destinations.sort((a, b) => a.index.compareTo(b.index));

    _dataManagementPageDetailsSub = _currentPageIndex.distinct().listen((index) {
      final destination = _destinations[index];
      _dataManagementPageDetails.add(NavigationPageDetails(
        pageIndex: index,
        body: destination.body,
        mainAction: destination.mainAction,
        appBar: destination.appBar,
        hideFabInShoppingMode: destination.hideFabInShoppingMode,
      ));
    });
  }

  @override
  FutureOr onDispose() {
    _dataManagementPageDetailsSub.cancel();
    _currentPageIndex.close();
    _dataManagementPageDetails.close();
  }
}
