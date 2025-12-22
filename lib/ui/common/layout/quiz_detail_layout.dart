import 'package:flutter/material.dart';
import 'package:quiz/core/theme/responsive/layout.dart';

class ResponsiveQuizScreen extends StatelessWidget {
  final Widget body;
  final Widget footer;
  const ResponsiveQuizScreen({
    super.key,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return context.layout(
      Expanded(child: Column(children: [body, footer])),
      desktop: Expanded(
        child: Row(
          children: [
            body,
            const SizedBox(width: 8),
            Expanded(child: footer),
          ],
        ),
      ),
    );
  }
}
