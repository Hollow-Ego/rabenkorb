import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/overview/basket_list.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:watch_it/watch_it.dart';

class BasketOverviewPage extends StatelessWidget {
  const BasketOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [BasketList()],
          ),
        ),
      ),
      drawer: const CoreDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).BasketOverview),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key("basket-overview-page-fab"),
        onPressed: () async {
          await showRenameDialog(
            context,
            onConfirm: (String? newName, bool _) async {
              await di<BasketService>().createShoppingBasket(newName);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
