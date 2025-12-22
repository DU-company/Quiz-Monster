// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
      p_qid: (json['p_qid'] as num).toInt(),
      p_take: (json['p_take'] as num).toInt(),
      p_level: (json['p_level'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) {
  final val = <String, dynamic>{
    'p_qid': instance.p_qid,
    'p_take': instance.p_take,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('p_level', instance.p_level);
  return val;
}
