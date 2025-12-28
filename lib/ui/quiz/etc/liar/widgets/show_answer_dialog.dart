import 'package:flutter/material.dart';
import 'package:quiz_monster/ui/common/widgets/dialog/base_confirm_dialog.dart';

class ShowAnswerDialog extends StatelessWidget {
  final VoidCallback showAnswer;
  const ShowAnswerDialog({super.key, required this.showAnswer});

  @override
  Widget build(BuildContext context) {
    return BaseConfirmDialog(
      title: '정답확인',
      content:
          '토론이 끝나셨나요?'
          '\n라이어가 지목당하지 않거나'
          '\n지목당한 후 정답을 맞춘다면'
          '\n라이어의 승리!',
      confirmLabel: '정답 확인',
      cancelLabel: '토론을 더 할래요',
      onTapConfirm: showAnswer,
    );
  }
}
