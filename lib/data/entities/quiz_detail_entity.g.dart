// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_detail_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizDetailEntity _$QuizDetailEntityFromJson(Map<String, dynamic> json) =>
    QuizDetailEntity(
      id: json['id'] as String,
      level: (json['level'] as num).toInt(),
      imgUrl: json['imgUrl'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$QuizDetailEntityToJson(QuizDetailEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'imgUrl': instance.imgUrl,
      'question': instance.question,
      'answer': instance.answer,
    };
