import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/display/loading_overlay.dart';
import 'package:rabenkorb/shared/widgets/display/background_image.dart';

class CoreScaffold extends StatelessWidget {
  final String? titleText;
  final Widget? body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Key? scaffoldKey;

  const CoreScaffold({
    super.key,
    this.titleText,
    this.body,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.appBar,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BackgroundImage(
          image: "assets/images/background.png",
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: appBar,
            body: body != null
                ? SafeArea(
                    child: body!,
                  )
                : null,
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButton: floatingActionButton,
          ),
        ),
      ),
    );
  }
}
