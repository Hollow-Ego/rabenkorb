import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/destination_details.dart';

final List<DestinationDetails> dataManagementDestinations = [
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.category),
      label: S.current.Categories,
    ),
    body: const Text("A"),
    mainAction: null,
    appBar: AppBar(
      title: null,
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
