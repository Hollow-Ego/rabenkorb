import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/categories/catgory_management_view.dart';
import 'package:rabenkorb/features/data_management/units/unit_management_view.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/destination_details.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:watch_it/watch_it.dart';

final List<DestinationDetails> dataManagementDestinations = [
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.category),
      label: S.current.Categories,
    ),
    body: const CategoryManagementView(),
    mainAction: MainAction(
      onPressed: (BuildContext context) async {
        await showRenameDialog(
          context,
          onConfirm: (String? newName, bool _) async {
            if (newName == null) {
              return;
            }
            await di<MetadataService>().createItemCategory(newName);
          },
        );
      },
    ),
    appBar: AppBar(
      title: Text(S.current.Categories),
    ),
    index: 0,
  ),
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.square_foot),
      label: S.current.Units,
    ),
    body: const UnitManagementView(),
    index: 1,
    mainAction: MainAction(
      onPressed: (BuildContext context) async {
        await showRenameDialog(
          context,
          onConfirm: (String? newName, bool _) async {
            if (newName == null) {
              return;
            }
            await di<MetadataService>().createItemUnit(newName);
          },
        );
      },
    ),
    appBar: AppBar(
      title: Text(S.current.Units),
    ),
  )
];
