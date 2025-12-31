/// State로 만들기
abstract class PaginationState {}

class PaginationLoading extends PaginationState {}

class PaginationError extends PaginationState {
  final String message;

  PaginationError({required this.message});
}

class PaginationSuccess<T> extends PaginationState {
  final List<T> items;

  PaginationSuccess({required this.items});

  PaginationSuccess<T> copyWith({List<T>? items}) {
    return PaginationSuccess(items: items ?? this.items);
  }
}
