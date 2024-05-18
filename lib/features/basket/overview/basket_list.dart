import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/overview/basket_tile.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:watch_it/watch_it.dart';

class BasketList extends StatelessWidget with WatchItMixin {
  const BasketList({super.key});

  @override
  Widget build(BuildContext context) {
    final baskets = watchStream((BasketService p0) => p0.baskets, initialValue: []);
    final basketList = baskets.data ?? [];
    return Expanded(
      child: ListView.builder(
        prototypeItem: BasketTile(
          basket: ShoppingBasketViewModel(-1, "Prototyp"),
        ),
        itemCount: basketList.length,
        itemBuilder: (BuildContext context, int index) {
          return BasketTile(
            basket: basketList[index],
          );
        },
      ),
    );
  }
}
