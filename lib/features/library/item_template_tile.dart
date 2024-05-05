import 'package:flutter/material.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';

class ItemTemplateTile extends StatelessWidget {
  final ItemTemplateViewModel item;

  const ItemTemplateTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(item.key),
      child: ListTile(
        title: Text(item.name),
      ),
    );
  }
}
