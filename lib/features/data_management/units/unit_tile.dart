import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:watch_it/watch_it.dart';

class UnitTile extends StatelessWidget {
  final ItemUnitViewModel unit;

  const UnitTile({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(unit.name),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CoreIconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await showRenameDialog(
                  context,
                  initialName: unit.name,
                  onConfirm: (String? newName, bool nameChanged) async {
                    if (!nameChanged || newName == null) {
                      return;
                    }
                    await di<MetadataService>().updateItemUnit(unit.id, newName);
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
                  text: S.of(context).ConfirmDeleteUnit,
                  title: S.of(context).Confirm,
                  onConfirm: () async {
                    await di<MetadataService>().deleteItemUnitById(unit.id);
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
