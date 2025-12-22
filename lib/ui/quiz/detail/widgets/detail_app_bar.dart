import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/core/utils/data_utils.dart';
import 'package:quiz/ui/quiz/detail/widgets/exit_dialog.dart';

class DetailAppBar extends ConsumerWidget {
  final int length;
  final AnimationController animationController;
  final int remainingSeconds;
  final int currentIndex;
  final VoidCallback onTapComfrim;
  const DetailAppBar({
    super.key,
    required this.length,
    required this.currentIndex,
    required this.animationController,
    required this.remainingSeconds,
    required this.onTapComfrim,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => onPop(context),
          style: IconButton.styleFrom(foregroundColor: Colors.white),
          icon: Icon(Icons.arrow_back_ios),
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Stack(
              children: [
                SizedBox(
                  height: 52,
                  width: 52,
                  child: CircularProgressIndicator(
                    value: animationController.value,
                    strokeWidth: 4.5,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Text(
                      DataUtils.formatTime(remainingSeconds),
                      style: theme.typo.headline5,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        if (length == 0) SizedBox(width: 32),
        if (length != 0)
          Text(
            currentIndex == length
                ? '$length/$length'
                : '${currentIndex + 1}/$length',
            style: theme.typo.headline6,
          ),
      ],
    );
  }

  void onPop(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExitDialog(onTapConfirm: onTapComfrim),
    );
  }
}
