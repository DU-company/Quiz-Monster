abstract class QuizPaginationBase {}

class QuizPaginationLoading extends QuizPaginationBase {}

class QuizPaginationError extends QuizPaginationBase {
  final String message;

  QuizPaginationError({
    required this.message,
  });
}

class QuizPagination<T> extends QuizPaginationBase {
  final List<T> models;

  QuizPagination({
    required this.models,
  });

  QuizPagination<T> copyWith({List<T>? models}) {
    return QuizPagination(
      models: models ?? this.models,
    );
  }
}
