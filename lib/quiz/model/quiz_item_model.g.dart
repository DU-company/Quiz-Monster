// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizItemModel _$QuizItemModelFromJson(Map<String, dynamic> json) =>
    QuizItemModel(
      json['imgUrl'] as String?,
      json['question'] as String?,
      id: json['id'] as String,
      answer: json['answer'] as String,
      level: (json['level'] as num).toInt(),
    );

Map<String, dynamic> _$QuizItemModelToJson(QuizItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imgUrl': instance.imgUrl,
      'question': instance.question,
      'answer': instance.answer,
      'level': instance.level,
    };
