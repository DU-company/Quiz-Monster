import 'package:json_annotation/json_annotation.dart';
part 'quiz_detail_model.g.dart';

@JsonSerializable()
class QuizDetailModel {
  final String id;
  final int level;
  final String? imgUrl;
  final String? question;
  final String answer;

  QuizDetailModel({
    required this.id,
    required this.level,
    required this.imgUrl,
    required this.question,
    required this.answer,
  });

  factory QuizDetailModel.fromJson(Map<String, dynamic> json) =>
      _$QuizDetailModelFromJson(json);
}
