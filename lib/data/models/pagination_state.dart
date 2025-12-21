/// State로 만들기
abstract class PaginationState {}

class PaginationLoading extends PaginationState {}

class PaginationError extends PaginationState {
  final String message;

  PaginationError({required this.message});
}

class PaginationSuccess<T> extends PaginationState {
  final List<T> models;

  PaginationSuccess({required this.models});

  PaginationSuccess<T> copyWith({List<T>? models}) {
    return PaginationSuccess(models: models ?? this.models);
  }
}
