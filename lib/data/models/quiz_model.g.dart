// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizModel _$QuizModelFromJson(Map<String, dynamic> json) => QuizModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      desc: json['desc'] as String,
      hasPass: json['hasPass'] as bool,
      isEtc: json['isEtc'] as bool,
    );

Map<String, dynamic> _$QuizModelToJson(QuizModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'hasPass': instance.hasPass,
      'subTitle': instance.subTitle,
      'isEtc': instance.isEtc,
    };
