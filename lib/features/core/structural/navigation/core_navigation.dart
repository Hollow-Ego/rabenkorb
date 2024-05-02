import 'package:flutter/material.dart';
import 'package:rabenkorb/services/state/navigation_state_service.dart';
import 'package:watch_it/watch_it.dart';

class CoreNavigation extends StatelessWidget {
  const CoreNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final state = di<NavigationStateService>();

    return NavigationBar(
      onDestinationSelected: (int index) {
        state.setCurrentPageIndex(index);
      },
      selectedIndex: state.currentPageIndexSync,
      destinations: [...state.destinations],
    );
  }
}
