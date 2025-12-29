import 'dart:ui';

class FlyState {
  final int flyCount;
  final List<Offset> flyPositions;
  // final double width;
  // final double height;

  FlyState({
    required this.flyCount,
    required this.flyPositions,
    // required this.width,
    // required this.height,
  });

  copyWith({
    int? flyCount,
    List<Offset>? flyPositions,
    // double? width,
    // double? height,
  }) {
    return FlyState(
      flyCount: flyCount ?? this.flyCount,
      flyPositions: flyPositions ?? this.flyPositions,
      // width: width ?? this.width,
      // height: height ?? this.height,
    );
  }
}
