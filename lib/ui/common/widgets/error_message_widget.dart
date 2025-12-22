import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/core/theme/theme_provider.dart';

import 'package:quiz/ui/common/screens/home_screen.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';

class ErrorMessageWidget extends ConsumerWidget {
  final String message;
  final String label;
  final VoidCallback onTap;
  const ErrorMessageWidget({
    super.key,
    required this.message,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/img/eyes1.svg'),
        const SizedBox(height: 32),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: theme.typo.subtitle1,
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(label: label, onPressed: onTap),
      ],
    );
  }
}
