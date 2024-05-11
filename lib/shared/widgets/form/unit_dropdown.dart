import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/widgets/form/core_searchable_dropdown.dart';
import 'package:watch_it/watch_it.dart';

class UnitDropdown extends StatelessWidget with WatchItMixin {
  final ItemUnitViewModel? selectedUnit;
  final Function(ItemUnitViewModel? unit) onChanged;
  final Function(String)? onNoSearchResultAction;
  final String? dropdownKey;

  const UnitDropdown({super.key, this.selectedUnit, required this.onChanged, this.onNoSearchResultAction, this.dropdownKey});

  @override
  Widget build(BuildContext context) {
    final units = watchStream((MetadataService p0) => p0.units, initialValue: List<ItemUnitViewModel>.empty());
    final unitList = units.data ?? List<ItemUnitViewModel>.empty();

    return CoreSearchableDropdown<ItemUnitViewModel>(
      key: dropdownKey != null ? Key(dropdownKey!) : null,
      items: unitList,
      selectedItem: selectedUnit,
      itemAsString: (unit) => unit.name,
      displayString: (unit) => unit?.name ?? "",
      compareFn: (a, b) => a.id == b.id,
      onChanged: onChanged,
      onNoSearchResultAction: onNoSearchResultAction,
      inputDecoration: InputDecoration(
        labelText: S.of(context).Unit,
      ),
    );
  }
}
