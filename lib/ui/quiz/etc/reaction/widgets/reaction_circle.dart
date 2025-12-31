import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_monster/core/theme/responsive/layout.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';

class ReactionCircle extends ConsumerWidget {
  final VoidCallback onTapCircle;
  final bool isGreen;
  final String label;
  const ReactionCircle({
    super.key,
    required this.onTapCircle,
    required this.isGreen,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '원이 초록색이 되면\n원을 클릭해 주세요',
          textAlign: TextAlign.center,
          style: theme.typo.headline6.copyWith(
            fontSize: context.layout(32, mobile: 24),
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: onTapCircle,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isGreen ? Colors.lightGreen : Colors.white,
            ),
            height: context.layout(350, mobile: 250),
            child: Center(
              child: Text(
                isGreen ? 'CLICK HERE!' : 'Wait...',
                style: theme.typo.headline1.copyWith(
                  fontFamily: 'Roboto',
                  color: theme.color.secondary,
                  fontSize: context.layout(32, mobile: 20),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.typo.headline6.copyWith(
              fontSize: context.layout(28, mobile: 20),
            ),
          ),
        ),
      ],
    );
  }
}
