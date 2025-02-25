import 'package:flutter/material.dart';
import 'package:quiz/common/data/colors.dart';
import 'package:quiz/common/theme/layout.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? fontColor;
  final Widget? child;
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = SUB_COLOR,
    this.fontColor = Colors.white,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: backgroundColor,
        foregroundColor: fontColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: child ?? Text(
              label,
              style: TextStyle(
                fontSize: context.layout(18, tablet: 20, desktop: 24),
              ),
            ),
    );
  }
}
