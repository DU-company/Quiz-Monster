import 'package:quiz_monster/data/models/quiz_detail_model.dart';
import 'package:quiz_monster/data/models/quiz_model.dart';

abstract class QuizDetailState {}

class QuizDetailLoading extends QuizDetailState {}

class QuizDetailError extends QuizDetailState {
  final String message;
  QuizDetailError(this.message);
}

class QuizDetailSuccess extends QuizDetailState {
  final QuizModel quiz;
  final List<QuizDetailModel> items;

  QuizDetailSuccess({required this.quiz, required this.items});
}
