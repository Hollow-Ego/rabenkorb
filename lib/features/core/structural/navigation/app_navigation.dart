import 'package:flutter/material.dart';
import 'package:rabenkorb/services/state/navigation_state_service.dart';
import 'package:watch_it/watch_it.dart';

class AppNavigation extends StatelessWidget with WatchItMixin {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final state = di<NavigationStateService>();
    final currentPageIndex = watchStream((NavigationStateService p0) => p0.currentPageIndex, initialValue: 0);

    return NavigationBar(
      onDestinationSelected: (int index) {
        state.setCurrentPageIndex(index);
      },
      selectedIndex: currentPageIndex.data!,
      destinations: [...state.destinations],
    );
  }
}
