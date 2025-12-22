// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
      qid: (json['qid'] as num).toInt(),
      take: (json['take'] as num).toInt(),
      level: (json['level'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) =>
    <String, dynamic>{
      'qid': instance.qid,
      'take': instance.take,
      'level': instance.level,
    };
