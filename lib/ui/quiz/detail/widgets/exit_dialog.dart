import 'package:flutter/material.dart';
import 'package:quiz_monster/ui/common/widgets/dialog/base_confirm_dialog.dart';

class ExitDialog extends StatelessWidget {
  final VoidCallback onTapConfirm;
  const ExitDialog({super.key, required this.onTapConfirm});

  @override
  Widget build(BuildContext context) {
    return BaseConfirmDialog(
      title: '게임 종료',
      content: '게임을 종료하시겠습니까?',
      confirmLabel: '종료하기',
      onTapConfirm: onTapConfirm,
      cancelLabel: '게임 계속하기',
    );
  }
}
