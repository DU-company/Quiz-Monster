import 'package:json_annotation/json_annotation.dart';
part 'quiz_model.g.dart';

@JsonSerializable()
class NewQuizModel {
  final int id;
  final String title;
  final String desc;
  final bool hasPass;
  final String subTitle;
  final bool isEtc;

  NewQuizModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.desc,
    required this.hasPass,
    required this.isEtc,
  });

  factory NewQuizModel.fromJson(Map<String, dynamic> json) =>
      _$NewQuizModelFromJson(json);
}
