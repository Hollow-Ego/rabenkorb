import 'package:flutter/material.dart';
import 'package:rabenkorb/features/data_management/categories/catgory_management_view.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/destination_details.dart';

final List<DestinationDetails> dataManagementDestinations = [
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.category),
      label: S.current.Categories,
    ),
    body: const CategoryManagementView(),
    mainAction: null,
    appBar: AppBar(
      title: Text(S.current.Categories),
    ),
    index: 0,
  ),
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.square_foot),
      label: S.current.Units,
    ),
    body: const Text("B"),
    index: 1,
    mainAction: null,
    appBar: AppBar(
      title: null,
    ),
  )
];
