import 'package:flutter/material.dart';
import 'package:rabenkorb/abstracts/navigation_state_service.dart';

class CoreNavigation extends StatelessWidget {
  final int pageIndex;
  final NavigationStateService state;

  const CoreNavigation({super.key, required this.pageIndex, required this.state});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        state.setCurrentPageIndex(index);
      },
      selectedIndex: state.currentPageIndexSync,
      destinations: [...state.destinations],
    );
  }
}
