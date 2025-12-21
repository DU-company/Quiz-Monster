import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/common/provider/selected_quiz_provider.dart';
import 'package:quiz/common/theme/layout.dart';

import '../../common/screen/default_layout.dart';

class ResponsiveSettingScreen extends ConsumerWidget {
  final String label;
  final Widget body;
  final Widget footer;
  const ResponsiveSettingScreen({
    super.key,
    required this.label,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedQuiz = ref.watch(selectedQuizProvider);

    return DefaultLayout(
      title: selectedQuiz!.title,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: context.layout(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                _Top(label: label),
                Spacer(),
                body,
                Spacer(),
                footer,
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: _Top(label: label),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(),
                      body,
                      Spacer(),
                      footer,
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Top extends StatelessWidget {
  final String label;
  const _Top({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/img/eyes.png',
          height: 100,
          fit: BoxFit.cover,
          // scale: 0.5,
        ),
        Text(
          style: TextStyle(
            color: Colors.white,
            fontSize: context.layout(32, mobile: 24),
          ),
          textAlign: TextAlign.center,
          label,
        ),
      ],
    );
  }
}
