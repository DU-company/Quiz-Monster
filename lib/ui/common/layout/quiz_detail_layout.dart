import 'package:flutter/material.dart';
import 'package:quiz_monster/core/theme/responsive/layout.dart';

class QuizDetailLayout extends StatelessWidget {
  final Widget body;
  final Widget footer;
  const QuizDetailLayout({
    super.key,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return context.layout(
      /// Mobile & Tablet
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: body), footer],
        ),
      ),

      /// Desktop
      desktop: Expanded(
        child: Row(
          children: [
            Expanded(child: body),
            const SizedBox(width: 8),
            Expanded(child: footer),
          ],
        ),
      ),
    );
  }
}
