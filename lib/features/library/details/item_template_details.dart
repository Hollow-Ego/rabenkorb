import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/library/details/item_template_details_app_bar.dart';
import 'package:rabenkorb/features/library/details/item_template_details_form.dart';
import 'package:rabenkorb/models/item_template_view_model.dart';
import 'package:rabenkorb/services/business/library_service.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/widgets/display/core_card.dart';
import 'package:watch_it/watch_it.dart';

class ItemTemplateDetails extends StatelessWidget {
  final ItemTemplateViewModel? itemTemplate;

  const ItemTemplateDetails({super.key, this.itemTemplate});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CoreCard(
            child: ItemTemplateDetailsForm(
              itemTemplate: itemTemplate,
              onSubmit: _onSubmit,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const ItemTemplateDetailsTitle(),
      ),
    );
  }

  Future<void> _onSubmit(String name, File? image, int? categoryId, int? variantKey) async {
    final libraryService = di<LibraryService>();
    final libraryStateService = di<LibraryStateService>();
    if (itemTemplate == null) {
      await libraryService.createItemTemplate(
        name,
        libraryId: libraryStateService.libraryIdSync,
        categoryId: categoryId,
        image: image,
        variantKeyId: variantKey,
      );
      return;
    }
    final updateImage = image?.path != itemTemplate!.imagePath;
    await libraryService.updateItemTemplate(
      itemTemplate!.id,
      name: name,
      libraryId: libraryStateService.libraryIdSync,
      categoryId: categoryId,
      image: updateImage ? image : null,
      variantKeyId: variantKey,
    );
  }
}
