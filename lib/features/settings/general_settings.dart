import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/inputs/core_dropdown.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/state/intl_state_service.dart';
import 'package:watch_it/watch_it.dart';

class GeneralSettings extends StatelessWidget with WatchItMixin {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final intlStateService = di<IntlStateService>();

    final supportedLocales = S.delegate.supportedLocales
        .map((locale) => DropdownMenuItem(
              value: locale,
              child: Text(intlStateService.getDisplayName(locale)),
            ))
        .toList();

    return Card(
        child: Column(
      children: [
        ListTile(
          title: Text(S.of(context).SettingsGeneral),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CoreDropdown(
            value: intlStateService.localeSync,
            items: supportedLocales,
            label: S.of(context).Language,
            onChanged: (locale) async {
              if (locale == null) {
                return;
              }
              await intlStateService.setLocale(locale);
            },
          ),
        )
      ],
    ));
  }
}
