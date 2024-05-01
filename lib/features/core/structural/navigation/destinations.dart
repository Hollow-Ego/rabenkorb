import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';
import 'package:rabenkorb/features/library/library_main_action.dart';
import 'package:rabenkorb/features/library/library_view.dart';
import 'package:rabenkorb/generated/l10n.dart';

final List<DestinationDetails> mainDestinations = [
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.bug_report),
      label: S.current.Debug,
    ),
    body: const Center(
      child: Text("Debug 1"),
    ),
    appBar: AppBar(),
    index: 0,
  ),
  DestinationDetails(
    destination: NavigationDestination(
      key: const Key('library-destination'),
      icon: const Icon(Icons.library_books),
      label: S.current.Library,
    ),
    body: const LibraryView(),
    index: 1,
    mainAction: libraryMainAction,
    appBar: AppBar(),
  )
];
