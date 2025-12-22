import 'package:flutter/material.dart';
import 'package:quiz/core/theme/responsive/layout.dart';

class ConstrainedScreen extends StatelessWidget {
  final Widget child;
  const ConstrainedScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Breakpoints.desktop,
        ),
        child: child,
      ),
    );
  }
}
