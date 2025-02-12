import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class QuizModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String desc;
  @HiveField(3)
  final bool pass;
  @HiveField(4)
  final String subTitle;

  QuizModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.desc,
    required this.pass,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
}
