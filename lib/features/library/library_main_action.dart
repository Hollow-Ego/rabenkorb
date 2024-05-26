import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/routing/routes.dart';
import 'package:rabenkorb/shared/destination_details.dart';

final libraryMainAction = MainAction(
  onPressed: (BuildContext context) async {
    final item = await context.push(Routes.libraryItemTemplateDetails);
  },
);
