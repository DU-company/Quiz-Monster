import 'package:quiz/data/entities/quiz_detail_entity.dart';
import 'package:quiz/data/models/quiz_model.dart';

class QuizDetailModel {
  final QuizModel quiz;
  final String id;
  final int level;
  final String? imgUrl;
  final String? question;
  final String answer;

  QuizDetailModel({
    required this.quiz,
    required this.id,
    required this.level,
    required this.imgUrl,
    required this.question,
    required this.answer,
  });

  factory QuizDetailModel.fromEntity(
    QuizModel quiz,
    QuizDetailEntity entity,
  ) {
    return QuizDetailModel(
      quiz: quiz,
      id: entity.id,
      level: entity.level,
      imgUrl: entity.imgUrl,
      question: entity.question,
      answer: entity.answer,
    );
  }
}
