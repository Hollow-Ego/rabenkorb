import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rabenkorb/di/di_setup.dart';
import 'package:rabenkorb/features/core/error/error_handler.dart';
import 'package:rabenkorb/routing/router_config.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:watch_it/watch_it.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  FlutterError.onError = di<ErrorHandler>().handleError;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget with WatchItMixin {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    final locale = watchStream((IntlStateService p0) => p0.locale);

    return MaterialApp.router(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: locale.data,
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: routerConfig,
    );
  }
}
