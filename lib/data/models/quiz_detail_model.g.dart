// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizDetailModel _$QuizDetailModelFromJson(Map<String, dynamic> json) =>
    QuizDetailModel(
      id: json['id'] as String,
      level: (json['level'] as num).toInt(),
      imgUrl: json['imgUrl'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$QuizDetailModelToJson(QuizDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'imgUrl': instance.imgUrl,
      'question': instance.question,
      'answer': instance.answer,
    };
