import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/widgets/form/core_text_form_field.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_secondary_button.dart';

class RenameDialog extends StatefulWidget {
  final String? initialName;
  final Future<void> Function(String?) onConfirm;
  final Future<void> Function()? onCancel;

  const RenameDialog({super.key, this.initialName, required this.onConfirm, this.onCancel});

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CoreTextFormField(
        textEditingController: _nameController,
        labelText: S.of(context).Name,
      ),
      actions: [
        CorePrimaryButton(
          onPressed: () async => await _confirm(context, widget.onConfirm),
          child: Text(S.of(context).Save),
        ),
        CoreSecondaryButton(
          onPressed: () async => await _cancel(context, widget.onCancel),
          child: Text(S.of(context).Cancel),
        )
      ],
    );
  }

  Future<void> _confirm(BuildContext context, Future<void> Function(String) onConfirm) async {
    Navigator.pop(context);

    await onConfirm(_nameController.text);
  }

  Future<void> _cancel(BuildContext context, Future<void> Function()? onCancel) async {
    Navigator.pop(context);
    if (onCancel == null) {
      return;
    }
    await onCancel();
  }
}
