import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/basket_item_view_model.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_unit_view_model.dart';
import 'package:rabenkorb/models/shopping_basket_view_model.dart';
import 'package:rabenkorb/services/business/basket_service.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/constant_widgets.dart';
import 'package:rabenkorb/shared/widgets/form/basket_dropdown.dart';
import 'package:rabenkorb/shared/widgets/form/category_dropdown.dart';
import 'package:rabenkorb/shared/widgets/form/core_image_form_field.dart';
import 'package:rabenkorb/shared/widgets/form/core_text_form_field.dart';
import 'package:rabenkorb/shared/widgets/form/unit_dropdown.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class BasketItemDetailsForm extends StatefulWidget {
  final BasketItemViewModel? basketItem;
  final String? tempItemName;
  final Function(String name, double amount, File? image, String? note, int? categoryId, int? unitId, int? basketId) onSubmit;

  const BasketItemDetailsForm({super.key, required this.basketItem, required this.onSubmit, this.tempItemName});

  @override
  State<BasketItemDetailsForm> createState() => _BasketItemDetailsFormState();
}

class _BasketItemDetailsFormState extends State<BasketItemDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  ShoppingBasketViewModel? _basket;
  ItemCategoryViewModel? _category;
  ItemUnitViewModel? _unit;
  File? _image;

  void _setupInitialValues() {
    final basketItem = widget.basketItem;
    _basket = basketItem?.basket ?? di<BasketService>().activeBasketSync;

    if (basketItem == null) {
      _nameController.text = widget.tempItemName ?? "";
      return;
    }

    _nameController.text = basketItem.name;
    _category = basketItem.category;
    _unit = basketItem.unit;
    _amountController.text = basketItem.amount.toFormattedString();
    _noteController.text = basketItem.note ?? "";

    final imagePath = basketItem.imagePath;
    if (imagePath != null) {
      _image = File(imagePath);
    }
  }

  void _onSubmit(BuildContext context) {
    doWithLoadingIndicator(() async {
      final state = _formKey.currentState;
      if (state == null) {
        return;
      }
      final isValid = state.validate();
      if (!isValid) {
        return;
      }
      state.save();
      final note = _noteController.text.isEmpty ? null : _noteController.text;
      widget.onSubmit(
        _nameController.text,
        _amountController.text.toDoubleOrZero(),
        _image,
        note,
        _category?.id,
        _unit?.id,
        _basket?.id,
      );
      context.pop("saved");
    });
  }

  @override
  void initState() {
    super.initState();
    _setupInitialValues();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BasketDropdown(
            dropdownKey: 'basket-dropdown',
            selectedBasket: _basket,
            onNoSearchResultAction: (String searchValue) async {
              await showRenameDialog(
                context,
                initialName: searchValue,
                onConfirm: (newName, nameChanged) async {
                  if (!newName.isValid()) {
                    return;
                  }
                  final newId = await di<BasketService>().createShoppingBasket(newName!);
                  _setBasket(ShoppingBasketViewModel(newId, newName));
                },
              );
            },
            onChanged: _setBasket,
          ),
          CoreTextFormField(
            formFieldKey: "basket-item-name-input",
            labelText: S.of(context).Name,
            textEditingController: _nameController,
            textInputAction: TextInputAction.next,
            validator: (name) {
              if (name.isValid()) {
                return null;
              }
              return S.of(context).NameMustNotBeEmpty;
            },
          ),
          gap,
          CategoryDropdown(
            dropdownKey: "basket-item-category-dropdown",
            onChanged: (category) {
              setState(() {
                _category = category;
              });
            },
            selectedCategory: _category,
            onNoSearchResultAction: (String searchValue) async {
              await showRenameDialog(
                context,
                initialName: searchValue,
                onConfirm: (newName, nameChanged) async {
                  if (!newName.isValid()) {
                    return;
                  }
                  final newId = await di<MetadataService>().createItemCategory(newName!);
                  setState(() {
                    _category = ItemCategoryViewModel(newId, newName);
                  });
                },
              );
            },
          ),
          gap,
          CoreTextFormField(
            labelText: S.of(context).Note,
            textEditingController: _noteController,
            formFieldKey: "note-input",
            textInputAction: TextInputAction.next,
          ),
          gap,
          CoreTextFormField(
            labelText: S.of(context).Amount,
            textEditingController: _amountController,
            formFieldKey: "amount-input",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
          ),
          gap,
          UnitDropdown(
            dropdownKey: 'unit-dropdown',
            selectedUnit: _unit,
            onNoSearchResultAction: (String searchValue) async {
              await showRenameDialog(
                context,
                initialName: searchValue,
                onConfirm: (newName, nameChanged) async {
                  if (!newName.isValid()) {
                    return;
                  }
                  final newId = await di<MetadataService>().createItemUnit(newName!);
                  _setUnit(ItemUnitViewModel(newId, newName));
                },
              );
            },
            onChanged: _setUnit,
          ),
          gap,
          ImageFormField(
            initialValue: _image,
            onSaved: (file) => {_image = file},
          ),
          CorePrimaryButton(
            key: const Key("basket-item-save-button"),
            child: Text(S.of(context).Save),
            onPressed: () => _onSubmit(context),
          ),
        ],
      ),
    );
  }

  void _setUnit(ItemUnitViewModel? unit) {
    setState(() {
      _unit = unit;
    });
  }

  void _setBasket(ShoppingBasketViewModel? basket) {
    setState(() {
      _basket = basket;
    });
  }
}
