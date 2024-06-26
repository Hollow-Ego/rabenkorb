import 'package:flutter/material.dart';
import 'package:rabenkorb/features/library/library_item_template_list.dart';
import 'package:rabenkorb/features/library/library_sort_control.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LibrarySortControl(),
        LibraryItemTemplateList(),
      ],
    );
  }
}
