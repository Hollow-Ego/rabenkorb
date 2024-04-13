import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';
import 'package:rabenkorb/features/core/structural/navigation/destinations.dart';
import 'package:rxdart/rxdart.dart';

class NavigationStateService {
  final BehaviorSubject<int> _currentPageIndex = BehaviorSubject<int>.seeded(0);

  Stream<int> get currentPageIndex => _currentPageIndex.stream.distinct();

  Stream<Widget?> get bodyWidget => _currentPageIndex.switchMap((index) => Stream<Widget?>.value(_destinations[index].body));

  Stream<MainAction?> get mainAction => _currentPageIndex.switchMap((index) => Stream<MainAction?>.value(_destinations[index].mainAction));

  setCurrentPageIndex(int index) {
    _currentPageIndex.add(index);
  }

  final List<DestinationDetails> _destinations = mainDestinations;

  List<NavigationDestination> get destinations => _destinations.map((e) => e.destination).toList();

  NavigationStateService() {
    _destinations.sort((a, b) => a.index.compareTo(b.index));
  }
}
