import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/core/provider/selected_quiz_provider.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/core/theme/theme_provider.dart';

import 'default_layout.dart';

class SettingLayout extends ConsumerWidget {
  final String label;
  final Widget body;
  final Widget footer;
  const SettingLayout({
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

          /// Mobile & Tablet
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

            /// Desktop
            desktop: Row(
              children: [
                Expanded(child: _Top(label: label)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [Spacer(), body, Spacer(), footer],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Top extends ConsumerWidget {
  final String label;
  const _Top({super.key, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/img/eyes1.svg',
          height: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        Text(
          style: theme.typo.headline6,
          textAlign: TextAlign.center,
          label,
        ),
      ],
    );
  }
}
