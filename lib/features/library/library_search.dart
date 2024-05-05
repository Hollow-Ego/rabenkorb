import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/services/state/library_state_service.dart';
import 'package:rabenkorb/shared/widgets/form/core_text_form_field.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_button.dart';
import 'package:watch_it/watch_it.dart';

class LibrarySearch extends StatefulWidget {
  const LibrarySearch({super.key});

  @override
  State<LibrarySearch> createState() => _LibrarySearchState();
}

class _LibrarySearchState extends State<LibrarySearch> {
  final TextEditingController _queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _queryController.text = di<LibraryStateService>().currentSearchSync;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: CoreTextFormField(
            labelText: S.of(context).SearchLabel,
            textEditingController: _queryController,
            textInputAction: TextInputAction.send,
            onChanged: (newQuery) async {
              di<LibraryStateService>().setSearchString(newQuery);
              setState(() {});
            },
          ),
        ),
        if (_queryController.text.isNotEmpty)
          CoreIconButton(
            key: const Key("library-search-clear"),
            icon: const Icon(Icons.clear),
            onPressed: () {
              di<LibraryStateService>().setSearchString(null);
              setState(() {});
            },
          ),
      ],
    );
  }
}
