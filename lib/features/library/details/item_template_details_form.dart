import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/constant_widgets.dart';
import 'package:rabenkorb/shared/widgets/form/category_dropdown.dart';
import 'package:rabenkorb/shared/widgets/form/core_image_form_field.dart';
import 'package:rabenkorb/shared/widgets/form/core_text_form_field.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_checkbox.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateDetailsForm extends StatefulWidget {
  final ItemTemplateViewModel? itemTemplate;
  final String? tempItemName;
  final Function(String name, File? image, int? categoryId, bool addToCart) onSubmit;

  const ItemTemplateDetailsForm({super.key, required this.itemTemplate, required this.onSubmit, this.tempItemName});

  @override
  State<ItemTemplateDetailsForm> createState() => _ItemTemplateDetailsFormState();
}

class _ItemTemplateDetailsFormState extends State<ItemTemplateDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  ItemCategoryViewModel? _category;
  File? _image;
  bool addToCart = false;

  void _setupInitialValues() {
    final itemTemplate = widget.itemTemplate;
    if (itemTemplate == null) {
      _nameController.text = widget.tempItemName ?? "";
      return;
    }

    _nameController.text = itemTemplate.name;
    _category = itemTemplate.category;

    final imagePath = itemTemplate.imagePath;
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
      widget.onSubmit(_nameController.text, _image, _category?.id, addToCart);
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
          CoreTextFormField(
            formFieldKey: "item-template-name-input",
            labelText: S.of(context).Name,
            textEditingController: _nameController,
            validator: (name) {
              if (name.isValid()) {
                return null;
              }
              return S.of(context).NameMustNotBeEmpty;
            },
          ),
          gap,
          CategoryDropdown(
            dropdownKey: "item-template-category-dropdown",
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
          ImageFormField(
            initialValue: _image,
            onSaved: (file) => {_image = file},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.of(context).AddToCart),
              CoreCheckbox(
                value: addToCart,
                onChanged: (value) {
                  setState(() {
                    addToCart = value ?? false;
                  });
                },
              ),
            ],
          ),
          gap,
          CorePrimaryButton(
            key: const Key("item-template-save-button"),
            child: Text(S.of(context).Save),
            onPressed: () => _onSubmit(context),
          ),
        ],
      ),
    );
  }
}
