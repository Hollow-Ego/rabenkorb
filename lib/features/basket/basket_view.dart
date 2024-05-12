import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/basket_item_list.dart';

class BasketView extends StatelessWidget {
  const BasketView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BasketItemList(),
      ],
    );
  }
}
