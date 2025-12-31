import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseDialog extends ConsumerWidget {
  final Widget child;
  const BaseDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      constraints: BoxConstraints(maxWidth: 500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24,
        ),
        child: child,
      ),
    );
  }
}
