import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/display/loading_indicator.dart';
import 'package:rabenkorb/services/state/loading_state.dart';
import 'package:watch_it/watch_it.dart';

class LoadingOverlay extends StatelessWidget with WatchItMixin {
  final Widget child;

  const LoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isLoading = watchStream((LoadingIndicatorState p0) => p0.isLoading, initialValue: false);

    return Stack(
      children: [
        child,
        AnimatedSwitcher(
          duration: Duration.zero,
          child: Stack(children: _loading(isLoading.data ?? false)),
        )
      ],
    );
  }

  List<Widget> _loading(bool isLoading) {
    if (!isLoading) {
      return [const SizedBox.shrink()];
    }
    return [
      PopScope(
        canPop: false,
        child: SizedBox.expand(
          child: ColoredBox(
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
      ),
      const Center(child: LoadingIndicator())
    ];
  }
}
