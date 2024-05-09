import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:watch_it/watch_it.dart';

enum ItemTemplatePopupMenuActions {
  edit,
  delete,
}

class ItemTemplatePopupMenu extends StatelessWidget {
  final ItemTemplateViewModel item;

  const ItemTemplatePopupMenu(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ItemTemplatePopupMenuActions>(
      key: Key("${item.key}-popup-menu"),
      itemBuilder: (context) {
        return <PopupMenuEntry<ItemTemplatePopupMenuActions>>[
          PopupMenuItem<ItemTemplatePopupMenuActions>(
            key: Key("${item.key}-popup-menu-edit"),
            value: ItemTemplatePopupMenuActions.edit,
            child: Text(S.of(context).Edit),
          ),
          PopupMenuItem<ItemTemplatePopupMenuActions>(
            key: Key("${item.key}-popup-menu-delete"),
            value: ItemTemplatePopupMenuActions.delete,
            child: Text(S.of(context).Delete),
          ),
        ];
      },
      onSelected: (ItemTemplatePopupMenuActions action) async {
        switch (action) {
          case ItemTemplatePopupMenuActions.edit:
            context.push(Routes.libraryItemTemplateDetails, extra: item);
            break;
          case ItemTemplatePopupMenuActions.delete:
            await di<LibraryService>().deleteItemTemplateById(item.id);
            break;
        }
      },
    );
  }
}
