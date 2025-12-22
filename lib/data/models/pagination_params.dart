import 'package:json_annotation/json_annotation.dart';
part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final int qid;
  final int take;
  final int? level;

  PaginationParams({
    required this.qid,
    required this.take,
    required this.level,
  });

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
