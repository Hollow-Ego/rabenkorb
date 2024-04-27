import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/inputs/core_primary_button.dart';
import 'package:rabenkorb/features/core/inputs/core_secondary_button.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/state_types.dart';

class DialogService {
  Future<dynamic> showSuccess({required BuildContext context, required String text, String? title}) {
    return _show(
      context: context,
      type: StateType.success,
      title: title,
      text: text,
    );
  }

  Future<dynamic> showError({required BuildContext context, required String text, String? title}) {
    return _show(
      context: context,
      type: StateType.error,
      title: title,
      text: text,
    );
  }

  Future<dynamic> showWarning({required BuildContext context, required String text, String? title}) {
    return _show(
      context: context,
      type: StateType.warning,
      title: title,
      text: text,
    );
  }

  Future<dynamic> showInfo({required BuildContext context, required String text, String? title}) {
    return _show(
      context: context,
      type: StateType.info,
      title: title,
      text: text,
    );
  }

  Future<dynamic> showConfirm({
    required BuildContext context,
    required String text,
    required StateType type,
    String? title,
    String? confirmBtnText,
    String? cancelBtnText,
    Future<void> Function()? onConfirm,
    Future<void> Function()? onCancel,
    bool showCancelBtn = true,
  }) {
    return _show(
      context: context,
      type: type,
      title: title,
      text: text,
      confirmBtnText: confirmBtnText,
      cancelBtnText: cancelBtnText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      showCancelBtn: showCancelBtn,
      isConfirmDialog: true,
    );
  }

  Future<dynamic> showLoading({required BuildContext context, required String text, String? title}) {
    return _show(
      context: context,
      type: StateType.loading,
      title: title,
      text: text,
    );
  }

  Future<dynamic> _show({
    required BuildContext context,
    required StateType type,
    required String text,
    String? title,
    String? confirmBtnText,
    String? cancelBtnText,
    Future<void> Function()? onConfirm,
    Future<void> Function()? onCancel,
    bool showCancelBtn = false,
    bool isConfirmDialog = false,
  }) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(text),
            actions: [
              if (isConfirmDialog)
                CorePrimaryButton(
                  onPressed: () async => await _confirm(context, onConfirm),
                  child: Text(confirmBtnText ?? S.of(context).Confirm),
                ),
              if (isConfirmDialog)
                CoreSecondaryButton(
                  onPressed: () async => await _cancel(context, onCancel),
                  child: Text(cancelBtnText ?? S.of(context).Cancel),
                )
            ],
          );
        });
  }

  Future<void> _confirm(BuildContext context, Future<void> Function()? onConfirm) async {
    Navigator.pop(context);
    if (onConfirm == null) {
      return;
    }
    await onConfirm();
  }

  Future<void> _cancel(BuildContext context, Future<void> Function()? onCancel) async {
    Navigator.pop(context);
    if (onCancel == null) {
      return;
    }
    await onCancel();
  }
}
