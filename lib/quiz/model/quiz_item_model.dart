import 'package:json_annotation/json_annotation.dart';

part 'quiz_item_model.g.dart';

@JsonSerializable()
class QuizItemModel {
  final String id;
  final String? imgUrl;
  final String? question;
  final String answer;
  final int level;

  QuizItemModel(
    this.imgUrl,
    this.question, {
    required this.id,
    required this.answer,
    required this.level,
  });
  
  factory QuizItemModel.fromJson(Map<String, dynamic>json)
  => _$QuizItemModelFromJson(json);
}
