import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:watch_it/watch_it.dart';

class CategoryTile extends StatelessWidget {
  final ItemCategoryViewModel category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(category.name),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CoreIconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await showRenameDialog(
                  context,
                  initialName: category.name,
                  onConfirm: (String? newName, bool nameChanged) async {
                    if (!nameChanged || newName == null) {
                      return;
                    }
                    await di<MetadataService>().updateItemCategory(category.id, newName);
                  },
                );
              },
            ),
            CoreIconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              onPressed: () async {
                await doWithConfirmation(
                  context,
                  text: S.of(context).ConfirmDeleteCategory,
                  title: S.of(context).Confirm,
                  onConfirm: () async {
                    await di<MetadataService>().deleteItemCategoryById(category.id);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
