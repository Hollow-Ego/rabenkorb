import 'package:flutter/material.dart';
import 'package:rabenkorb/features/basket/basket_view.dart';
import 'package:rabenkorb/features/library/library_main_action.dart';
import 'package:rabenkorb/features/library/library_search.dart';
import 'package:rabenkorb/features/library/library_view.dart';
import 'package:rabenkorb/features/main/navigation/destination_details.dart';
import 'package:rabenkorb/generated/l10n.dart';

final List<DestinationDetails> mainDestinations = [
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.shopping_basket),
      label: S.current.Basket,
    ),
    body: const BasketView(),
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
    appBar: AppBar(
      title: const LibrarySearch(),
    ),
  )
];
