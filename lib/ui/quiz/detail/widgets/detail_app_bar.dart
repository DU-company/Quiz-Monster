import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';
import 'package:quiz_monster/core/utils/data_utils.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/exit_dialog.dart';

class DetailAppBar extends ConsumerWidget {
  final int itemLength;
  final AnimationController animationController;
  final int remainingSeconds;
  final int currentIndex;
  final VoidCallback onTapConfirm;
  const DetailAppBar({
    super.key,
    required this.itemLength,
    required this.currentIndex,
    required this.animationController,
    required this.remainingSeconds,
    required this.onTapConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: theme.color.onPrimary,
        ),
        onPressed: () => onPop(context),
      ),
      centerTitle: true,
      title: AnimatedBuilder(
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
                    style: theme.typo.headline6,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        SizedBox(
          child: itemLength == 0
              ? null
              : Text(
                  currentIndex == itemLength
                      ? '$itemLength/$itemLength'
                      : '${currentIndex + 1}/$itemLength',
                  style: theme.typo.headline6,
                ),
        ),
      ],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 48,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.color.onPrimary,
            ),
            onPressed: () => onPop(context),
          ),
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
                      style: theme.typo.headline6,
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        SizedBox(
          width: 56,
          child: itemLength == 0
              ? null
              : Text(
                  currentIndex == itemLength
                      ? '$itemLength/$itemLength'
                      : '${currentIndex + 1}/$itemLength',
                  style: theme.typo.headline6,
                ),
        ),
      ],
    );
  }

  void onPop(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExitDialog(onTapConfirm: onTapConfirm),
    );
  }
}
