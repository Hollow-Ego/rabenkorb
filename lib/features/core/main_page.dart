import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/features/core/structural/navigation/core_navigation.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';
import 'package:rabenkorb/services/state/navigation_state_service.dart';
import 'package:watch_it/watch_it.dart';

class MainPage extends StatelessWidget with WatchItMixin {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = watchStream((NavigationStateService p0) => p0.bodyWidget);
    final mainAction = watchStream((NavigationStateService p0) => p0.mainAction);
    final appBar = watchStream((NavigationStateService p0) => p0.appBar);

    return CoreScaffold(
      body: body.data,
      bottomNavigationBar: const CoreNavigation(),
      floatingActionButton: toFloatingActionButton(context, mainAction.data),
      drawer: const CoreDrawer(),
      appBar: appBar.data,
    );
  }

  Widget? toFloatingActionButton(BuildContext context, MainAction? mainAction) {
    if (mainAction?.onPressed == null) {
      return null;
    }
    return FloatingActionButton(
      onPressed: () {
        mainAction.onPressed!(context);
      },
      child: mainAction!.icon ?? const Icon(Icons.add),
    );
  }
}
