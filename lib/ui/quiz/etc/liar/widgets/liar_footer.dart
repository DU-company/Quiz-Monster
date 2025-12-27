import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';

class LiarFooter extends ConsumerWidget {
  final bool isBeforeLastPage;
  final VoidCallback? onNext;

  const LiarFooter({
    super.key,
    required this.isBeforeLastPage,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isBeforeLastPage ? "" : '⬇누르고 옆 사람에게 전달⬇',
          textAlign: TextAlign.center,
          style: theme.typo.headline6,
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: isBeforeLastPage ? '게임 시작' : '다음 사람',
          onPressed: onNext,
        ),
      ],
    );
  }
}
