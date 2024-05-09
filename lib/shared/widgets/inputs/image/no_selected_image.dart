import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/widgets/display/core_icon.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_icon_text_button.dart';

class NoSelectedImage extends StatelessWidget {
  final Function() onPick;

  const NoSelectedImage({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return CoreIconTextButton(
      onPressed: onPick,
      label: Text(S.of(context).PickImage),
      icon: const CoreIcon(icon: Icons.camera),
    );
  }
}
