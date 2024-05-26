import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/categories/catgory_management_view.dart';
import 'package:rabenkorb/features/data_management/sort_rules/sort_rule_management_title.dart';
import 'package:rabenkorb/features/data_management/sort_rules/sort_rule_management_view.dart';
import 'package:rabenkorb/features/data_management/sub_categories/sub_catgory_management_view.dart';
import 'package:rabenkorb/features/data_management/units/unit_management_view.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/services/data_access/sort_rule_service.dart';
import 'package:rabenkorb/services/state/data_management_state_service.dart';
import 'package:rabenkorb/shared/destination_details.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/sort_mode.dart';
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
      icon: const Icon(Icons.label),
      label: S.current.SubCategories,
    ),
    body: const SubCategoryManagementView(),
    mainAction: MainAction(
      onPressed: (BuildContext context) async {
        await showRenameDialog(
          context,
          onConfirm: (String? newName, bool _) async {
            if (newName == null) {
              return;
            }
            await di<MetadataService>().createItemSubCategory(newName);
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
  ),
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.sort),
      label: S.current.SortRules,
    ),
    body: const SortRuleManagementView(),
    mainAction: MainAction(
      onPressed: (BuildContext context) async {
        await showRenameDialog(
          context,
          onConfirm: (String? newName, bool _) async {
            if (newName == null) {
              return;
            }
            final newId = await di<SortRuleService>().createSortRule(newName);
            await di<DataManagementStateService>().setSortMode(SortMode.custom);
            await di<DataManagementStateService>().setSortRuleId(newId);
          },
        );
      },
    ),
    appBar: AppBar(
      title: const SortRuleManagementTitle(),
    ),
    index: 2,
  ),
];
