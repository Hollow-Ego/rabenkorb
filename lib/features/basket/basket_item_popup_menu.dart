import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:watch_it/watch_it.dart';

enum BasketItemPopupMenuActions {
  edit,
  delete,
}

class BasketItemPopupMenu extends StatelessWidget {
  final BasketItemViewModel item;

  const BasketItemPopupMenu(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BasketItemPopupMenuActions>(
      key: Key("${item.key}-popup-menu"),
      itemBuilder: (context) {
        return <PopupMenuEntry<BasketItemPopupMenuActions>>[
          PopupMenuItem<BasketItemPopupMenuActions>(
            key: Key("${item.key}-popup-menu-edit"),
            value: BasketItemPopupMenuActions.edit,
            child: Text(S.of(context).Edit),
          ),
          PopupMenuItem<BasketItemPopupMenuActions>(
            key: Key("${item.key}-popup-menu-delete"),
            value: BasketItemPopupMenuActions.delete,
            child: Text(S.of(context).Delete),
          ),
        ];
      },
      onSelected: (BasketItemPopupMenuActions action) async {
        switch (action) {
          case BasketItemPopupMenuActions.edit:
            context.push(Routes.basketItemDetails, extra: item);
            break;
          case BasketItemPopupMenuActions.delete:
            await di<BasketService>().deleteBasketItemById(item.id);
            break;
        }
      },
    );
  }
}
