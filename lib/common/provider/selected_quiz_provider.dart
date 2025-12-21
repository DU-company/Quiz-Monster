import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/quiz/model/quiz_model.dart';

final selectedQuizProvider = StateProvider<QuizModel?>(
  (ref) => null,
);
