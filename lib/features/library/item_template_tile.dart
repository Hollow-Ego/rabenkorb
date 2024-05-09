import 'package:flutter/material.dart';
import 'package:rabenkorb/features/library/item_template_popup_menu.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/widgets/display/core_icon.dart';
import 'package:rabenkorb/shared/widgets/display/item_image.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';

class ItemTemplateTile extends StatelessWidget {
  final ItemTemplateViewModel item;
  final double iconSize = 26;

  const ItemTemplateTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(item.key),
      child: ListTile(
        title: Text(item.name),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.imagePath.isValid())
              ItemImage(
                imagePath: item.imagePath!,
              ),
            CoreIconButton(
              icon: CoreIcon(
                icon: Icons.shopping_basket,
                usePrimaryColor: true,
                iconSize: iconSize,
              ),
              onPressed: () {},
            ),
            ItemTemplatePopupMenu(item),
          ],
        ),
      ),
    );
  }
}
