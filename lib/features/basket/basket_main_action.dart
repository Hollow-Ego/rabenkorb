import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabenkorb/features/main/navigation/destination_details.dart';
import 'package:rabenkorb/routing/routes.dart';

final basketMainAction = MainAction(
  onPressed: (BuildContext context) {
    context.push(Routes.basketItemDetails);
  },
);
