import 'package:json_annotation/json_annotation.dart';
part 'quiz_model.g.dart';

@JsonSerializable()
class QuizModel {
  final int id;
  final String title;
  final String desc;
  final bool hasPass;
  final String subTitle;
  final bool isEtc;

  QuizModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.desc,
    required this.hasPass,
    required this.isEtc,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
}
