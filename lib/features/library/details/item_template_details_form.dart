import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/models/item_category_view_model.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/metadata_service.dart';
import 'package:rabenkorb/shared/extensions.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/form/category_dropdown.dart';
import 'package:rabenkorb/shared/widgets/form/core_image_form_field.dart';
import 'package:rabenkorb/shared/widgets/form/core_text_form_field.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateDetailsForm extends StatefulWidget {
  final ItemTemplateViewModel? itemTemplate;
  final Function(String name, File? image, int? categoryId, int? variantKey) onSubmit;

  const ItemTemplateDetailsForm({super.key, required this.itemTemplate, required this.onSubmit});

  @override
  State<ItemTemplateDetailsForm> createState() => _ItemTemplateDetailsFormState();
}

class _ItemTemplateDetailsFormState extends State<ItemTemplateDetailsForm> {
  final _gap = const SizedBox(height: 10);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  ItemCategoryViewModel? _category;
  int? _variant;
  File? _image;

  void _setupInitialValues() {
    final itemTemplate = widget.itemTemplate;
    if (itemTemplate == null) {
      return;
    }

    _nameController.text = itemTemplate.name;
    _category = itemTemplate.category;
    _variant = itemTemplate.variantKey;

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
      widget.onSubmit(_nameController.text, _image, _category?.id, _variant);
      context.pop();
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
            labelText: S.of(context).Name,
            textEditingController: _nameController,
            validator: (name) {
              if (name.isValid()) {
                return null;
              }
              return S.of(context).NameMustNotBeEmpty;
            },
          ),
          _gap,
          CategoryDropdown(
            onChanged: (category) {
              setState(() {
                _category = category;
              });
            },
            selectedCategory: _category,
            onNoSearchResultAction: (String searchValue) async {
              final newId = await di<MetadataService>().createItemCategory(searchValue);
              setState(() {
                _category = ItemCategoryViewModel(newId, searchValue);
              });
            },
          ),
          _gap,
          ImageFormField(
            initialValue: _image,
            onSaved: (file) => {_image = file},
          ),
          CorePrimaryButton(
            child: Text(S.of(context).Save),
            onPressed: () => _onSubmit(context),
          ),
        ],
      ),
    );
  }
}
