class PassState {
  final int passCount;
  final List<String> passedWords;
  final List<String> correctWords;

  PassState({
    this.passCount = 3,
    this.passedWords = const [],
    this.correctWords = const [],
  });

  copyWith({
    int? passCount,
    List<String>? passedWords,
    List<String>? correctWords,
  }) {
    return PassState(
      passCount: passCount ?? this.passCount,
      passedWords: passedWords ?? this.passedWords,
      correctWords: correctWords ?? this.correctWords,
    );
  }
}
