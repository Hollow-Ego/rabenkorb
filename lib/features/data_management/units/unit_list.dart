import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/units/unit_tile.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:watch_it/watch_it.dart';

class UnitList extends StatelessWidget with WatchItMixin {
  const UnitList({super.key});

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<ItemUnitViewModel>> units = watchStream((MetadataService p0) => p0.units, initialValue: []);
    final unitList = units.data ?? [];

    return Expanded(
      child: ListView.builder(
        itemCount: unitList.length,
        prototypeItem: UnitTile(
          unit: ItemUnitViewModel(-1, "Unit Prototype"),
        ),
        itemBuilder: (BuildContext context, int index) {
          return UnitTile(unit: unitList[index]);
        },
      ),
    );
  }
}
