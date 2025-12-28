import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_monster/core/theme/color/app_color.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';
import 'package:quiz_monster/ui/common/widgets/dialog/base_dialog.dart';
import 'package:quiz_monster/ui/common/widgets/primary_button.dart';

class BaseConfirmDialog extends ConsumerWidget {
  final String title;
  final String? content;
  final String confirmLabel;
  final VoidCallback onTapConfirm;
  final String? cancelLabel;
  final VoidCallback? onTapCancel;

  const BaseConfirmDialog({
    super.key,
    required this.title,
    this.content,
    required this.confirmLabel,
    required this.onTapConfirm,
    this.cancelLabel,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return BaseDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          Text(
            title,
            style: theme.typo.headline6.copyWith(
              color: theme.color.secondary,
            ),
          ),
          const SizedBox(height: 8),

          /// Content
          if (content != null)
            Text(
              content!,
              style: theme.typo.subtitle2.copyWith(
                color: theme.color.onHintContainer,
                fontWeight: theme.typo.semiBold,
              ),
            ),
          if (content != null) const SizedBox(height: 12),

          _Buttons(
            onTapConfirm: onTapConfirm,
            cancelLabel: cancelLabel,
            onTapCancel: onTapCancel ?? () => context.pop(),
            confirmLabel: confirmLabel,
          ),
        ],
      ),
    );
  }
}

class _Buttons extends ConsumerWidget {
  final VoidCallback onTapConfirm;
  final String? cancelLabel;
  final String confirmLabel;
  final VoidCallback onTapCancel;
  const _Buttons({
    required this.onTapConfirm,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onTapCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.read(themeServiceProvider).color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        renderConfirmButton(),
        if (cancelLabel != null) const SizedBox(height: 8),
        if (cancelLabel != null) renderCancelButton(color),
      ],
    );
  }

  Widget renderConfirmButton() {
    return PrimaryButton(
      onPressed: onTapConfirm,
      label: confirmLabel,
    );
  }

  Widget renderCancelButton(AppColor color) {
    return PrimaryButton(
      onPressed: onTapCancel,
      label: cancelLabel ?? '',
      backgroundColor: color.onSecondary,
      foregroundColor: color.subtext,
      borderColor: color.subtext,
    );
  }
}
