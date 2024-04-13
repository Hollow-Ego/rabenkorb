import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:watch_it/watch_it.dart';

class LanguageDebug extends StatelessWidget with WatchItMixin {
  const LanguageDebug({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = watchStream((IntlStateService p0) => p0.locale);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).LanguageDisplayName),
          Text(S.of(context).EmptyMessage),
          ElevatedButton(
            onPressed: () {
              di<IntlStateService>().setLocale(const Locale('de', 'DE'));
            },
            child: const Text("Deutsch"),
          ),
          ElevatedButton(
            onPressed: () {
              di<IntlStateService>().setLocale(const Locale('en'));
            },
            child: const Text("English"),
          )
        ],
      ),
    );
  }
}
