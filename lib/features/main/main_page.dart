import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/services/state/main_navigation_state_service.dart';
import 'package:rabenkorb/shared/destination_details.dart';
import 'package:rabenkorb/shared/widgets/core_navigation.dart';
import 'package:watch_it/watch_it.dart';

class MainPage extends StatelessWidget with WatchItMixin {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final details = watchStream((MainNavigationStateService p0) => p0.mainPageDetails);

    final isShoppingModeStream = watchStream((BasketStateService p0) => p0.isShoppingMode, initialValue: false);
    final isShoppingMode = isShoppingModeStream.data ?? false;
    final hideFab = isShoppingMode && details.data?.hideFabInShoppingMode == true;

    final pageIndex = details.data?.pageIndex ?? 0;
    final body = details.data?.body;
    final mainAction = hideFab ? null : details.data?.mainAction;
    final appBar = details.data?.appBar;
    final state = di<MainNavigationStateService>();

    return CoreScaffold(
      body: body,
      bottomNavigationBar: CoreNavigation(
        pageIndex: pageIndex,
        state: state,
      ),
      floatingActionButton: toFloatingActionButton(context, mainAction),
      drawer: const CoreDrawer(),
      appBar: appBar,
    );
  }

  Widget? toFloatingActionButton(BuildContext context, MainAction? mainAction) {
    if (mainAction?.onPressed == null) {
      return null;
    }
    return FloatingActionButton(
      key: const Key("main-page-fab"),
      onPressed: () {
        mainAction.onPressed!(context);
      },
      child: mainAction!.icon ?? const Icon(Icons.add),
    );
  }
}
