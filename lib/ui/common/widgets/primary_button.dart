import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/const/data.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/core/theme/theme_provider.dart';

class PrimaryButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Widget? child;
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),

        /// Color
        backgroundColor: backgroundColor ?? theme.color.secondary,
        foregroundColor: foregroundColor ?? theme.color.onSecondary,
        disabledBackgroundColor: theme.color.inactiveContainer,
        disabledForegroundColor: theme.color.onInactiveContainer,
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: 0.5,
        ),
        splashFactory: InkSparkle.splashFactory,
      ),
      child:
          child ??
          Text(
            label,
            style: theme.typo.subtitle1.copyWith(
              color: foregroundColor,
              fontWeight: theme.typo.semiBold,
            ),
          ),
    );
  }
}
