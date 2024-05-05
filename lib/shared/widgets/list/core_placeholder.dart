import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';

class CorePlaceholder extends StatelessWidget {
  const CorePlaceholder({super.key, this.text, this.textOnly = false});

  final String? text;
  final bool textOnly;

  @override
  Widget build(BuildContext context) {
    final String defaultText = S.of(context).EmptyMessage;
    final displayText = text ?? defaultText;
    if (textOnly) {
      return Text(displayText);
    }
    return Center(
      child: Text(displayText),
    );
  }
}
