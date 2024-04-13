import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/app_scaffold.dart';
import 'package:rabenkorb/features/core/structural/navigation/app_navigation.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';
import 'package:rabenkorb/services/state/navigation_state_service.dart';
import 'package:watch_it/watch_it.dart';

class MainPage extends StatelessWidget with WatchItMixin {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = watchStream((NavigationStateService p0) => p0.bodyWidget);
    final mainAction = watchStream((NavigationStateService p0) => p0.mainAction);

    return AppScaffold(
      body: body.data,
      bottomNavigationBar: const AppNavigation(),
      floatingActionButton: toFloatingActionButton(context, mainAction.data),
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
