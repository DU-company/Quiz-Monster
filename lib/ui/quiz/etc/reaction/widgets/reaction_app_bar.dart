import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';

class ReactionAppBar extends ConsumerWidget {
  final VoidCallback onTapBack;
  final int step;
  const ReactionAppBar({
    super.key,
    required this.onTapBack,
    required this.step,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    return AppBar(
      leading: IconButton(
        onPressed: onTapBack,
        icon: Icon(Icons.arrow_back_ios),
      ),
      actions: [Text('$step/5 회', style: theme.typo.headline6)],
    );
  }
}
