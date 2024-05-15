import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';

class BasketItemDetailsTitle extends StatelessWidget {
  final bool isNewItem;

  const BasketItemDetailsTitle({super.key, required this.isNewItem});

  @override
  Widget build(BuildContext context) {
    return Text(isNewItem ? S.of(context).New : S.of(context).Edit);
  }
}
