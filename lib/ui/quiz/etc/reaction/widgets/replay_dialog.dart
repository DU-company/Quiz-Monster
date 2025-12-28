import 'package:flutter/material.dart';
import 'package:quiz_monster/ui/common/widgets/dialog/base_confirm_dialog.dart';

class RecationReplayDialog extends StatelessWidget {
  final VoidCallback onTapReplay;
  const RecationReplayDialog({super.key, required this.onTapReplay});

  @override
  Widget build(BuildContext context) {
    return BaseConfirmDialog(
      title: '다시 시작',
      content: '게임을 다시 시작할까요?',
      confirmLabel: '다시하기',
      onTapConfirm: onTapReplay,
      cancelLabel: '뒤로가기',
    );
  }
}
