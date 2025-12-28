class ReactionState {
  final int? startTime;
  final int currentStep;
  final String result;
  final List<int> resultList;
  final bool isGreen;

  ReactionState({
    this.startTime = null,
    this.currentStep = 1,
    this.result = '',
    this.resultList = const [],
    this.isGreen = false,
  });

  ReactionState copyWith({
    required int? startTime,
    int? currentStep,
    String? result,
    List<int>? resultList,
    bool? isGreen,
  }) {
    return ReactionState(
      startTime: startTime,
      currentStep: currentStep ?? this.currentStep,
      result: result ?? this.result,
      resultList: resultList ?? this.resultList,
      isGreen: isGreen ?? this.isGreen,
    );
  }
}
