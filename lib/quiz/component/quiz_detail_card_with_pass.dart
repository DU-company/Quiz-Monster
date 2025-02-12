import 'package:flutter/material.dart';

import '../model/quiz_item_model.dart';

class QuizDetailCardWithPass extends StatelessWidget {
  final String id;
  final String answer;
  final String? imgUrl;
  final String? question;
  final int level;
  final bool showAnswer;
  const QuizDetailCardWithPass({
    super.key,
    required this.id,
    required this.answer,
    required this.level,
    required this.showAnswer,
    this.question,
    this.imgUrl,
  });

  factory QuizDetailCardWithPass.fromModel({
    required QuizItemModel model,
    required bool showAnswer,
  }) {
    return QuizDetailCardWithPass(
      id: model.id,
      answer: model.answer,
      imgUrl: model.imgUrl,
      question: model.question,
      level: model.level,
      showAnswer: showAnswer,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // renderStars(),
            const SizedBox(height: 16),

            /// 이미지 링크가 있으면 이미지를 보여준다
            // if (imgUrl != null && imgUrl!.isNotEmpty) _ImageBox(imgUrl: imgUrl!),

            /// 질문이 있다면 질문을 UI에 보여준다
            // if (question != null) _QuestionBox(question: question!),
            const SizedBox(height: 16),
            // _AnswerBox(showAnswer: showAnswer, answer: answer),
          ],
        ),
      ),
    );
  }
}
