import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_checkbox.dart';
import 'package:watch_it/watch_it.dart';

class BasketSettings extends StatelessWidget with WatchItMixin {
  const BasketSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final alwaysCollapseCategories = watchStream((BasketStateService p0) => p0.alwaysCollapseCategories, initialValue: false);

    return Card(
        child: Column(
      children: [
        ListTile(
          title: Text(S.of(context).SettingsBasket),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).AlwaysCollapseCategories),
              CoreCheckbox(
                value: alwaysCollapseCategories.data ?? false,
                onChanged: (bool? isChecked) async {
                  await di<BasketStateService>().setAlwaysCollapseCategories(isChecked ?? false);
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}
