import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/details/basket_item_details_app_bar.dart';
import 'package:rabenkorb/features/basket/details/basket_item_details_form.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/state/basket_state_service.dart';
import 'package:rabenkorb/shared/widgets/display/core_card.dart';
import 'package:watch_it/watch_it.dart';

class BasketItemDetails extends StatelessWidget {
  final BasketItemViewModel? basketItem;
  final String? tempItemName;

  const BasketItemDetails({super.key, this.basketItem, this.tempItemName});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CoreCard(
            child: BasketItemDetailsForm(
              basketItem: basketItem,
              onSubmit: _onSubmit,
              tempItemName: tempItemName,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: BasketItemDetailsTitle(
          isNewItem: basketItem == null,
        ),
      ),
    );
  }

  Future<void> _onSubmit(String name, double amount, File? image, String? note, int? categoryId, int? subCategoryId, int? unitId, int? basketId) async {
    final basketService = di<BasketService>();
    final basketStateService = di<BasketStateService>();
    if (basketItem == null) {
      await basketService.createBasketItem(name,
          basketId: basketStateService.basketIdSync,
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          image: image,
          unitId: unitId,
          amount: amount,
          note: note);
      return;
    }
    final imageChanged = image?.path != basketItem!.imagePath;
    await basketService.replaceBasketItem(
      basketItem!.id,
      name: name,
      basketId: basketId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      image: image,
      note: note,
      imageChanged: imageChanged,
      amount: amount,
      unitId: unitId,
      isChecked: basketItem!.isChecked,
    );
  }
}
