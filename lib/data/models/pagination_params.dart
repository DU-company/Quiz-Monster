import 'package:json_annotation/json_annotation.dart';
part 'pagination_params.g.dart';

@JsonSerializable(includeIfNull: false)
class PaginationParams {
  final int p_qid;
  final int p_take;
  final int? p_level;

  PaginationParams({
    required this.p_qid,
    required this.p_take,
    required this.p_level,
  });

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
