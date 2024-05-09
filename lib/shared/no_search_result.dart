import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_text_icon_button.dart';

class NoSearchResult extends StatelessWidget {
  final void Function()? onNoResultAction;
  final String? actionLabel;
  final Widget? icon;
  final String searchTerm;

  const NoSearchResult({super.key, this.onNoResultAction, this.actionLabel, this.icon, required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(S.of(context).NoSearchResult),
          if (onNoResultAction != null)
            CoreTextIconButton(
              label: actionLabel ?? S.of(context).Add,
              icon: icon ?? const Icon(Icons.add),
              onPressed: onNoResultAction,
            )
        ],
      ),
    );
  }
}
