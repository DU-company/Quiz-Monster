import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/core/utils/data_utils.dart';

class ReactionAverageBox extends ConsumerWidget {
  final List<int> testResults;
  const ReactionAverageBox({super.key, required this.testResults});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    final int average =
        (testResults.reduce((a, b) => a + b) / testResults.length)
            .toInt();

    final comment = DataUtils.getReactionSpeedMessage(average);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          comment,
          textAlign: TextAlign.center,
          style: theme.typo.headline6.copyWith(
            fontSize: context.layout(32, mobile: 24),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          '평균속도 : ${average.toInt()} ms',
          style: theme.typo.headline4.copyWith(
            fontSize: context.layout(32, mobile: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${testResults.map((e) => '${e}ms').toList()}',
          textAlign: TextAlign.center,
          style: theme.typo.subtitle1.copyWith(
            fontSize: context.layout(28, mobile: 18),
          ),
        ),
      ],
    );
  }
}
