import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';

class ItemTemplateDetailsTitle extends StatelessWidget {
  final bool isNewItem;

  const ItemTemplateDetailsTitle({super.key, required this.isNewItem});

  @override
  Widget build(BuildContext context) {
    return Text(isNewItem ? S.of(context).New : S.of(context).Edit);
  }
}
