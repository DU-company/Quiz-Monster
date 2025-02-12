import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz/model/quiz_model.dart';

final selectedQuizProvider = StateProvider<QuizModel?>(
  (ref) => null,
);
