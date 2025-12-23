import 'package:json_annotation/json_annotation.dart';
part 'quiz_detail_entity.g.dart';

@JsonSerializable()
class QuizDetailEntity {
  final String id;
  final int level;
  final String? imgUrl;
  final String? question;
  final String answer;

  QuizDetailEntity({
    required this.id,
    required this.level,
    required this.imgUrl,
    required this.question,
    required this.answer,
  });

  factory QuizDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$QuizDetailEntityFromJson(json);
}
