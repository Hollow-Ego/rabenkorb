import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_secondary_button.dart';
import 'package:watch_it/watch_it.dart';

class LanguageDebug extends StatelessWidget with WatchItMixin {
  const LanguageDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
            title: Text("Language"),
          ),
          Text(S.of(context).LanguageDisplayName),
          Text(S.of(context).EmptyMessage),
          CorePrimaryButton(
            onPressed: () {
              di<IntlStateService>().setLocale(const Locale('de', 'DE'));
            },
            child: const Text("Deutsch"),
          ),
          CoreSecondaryButton(
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
