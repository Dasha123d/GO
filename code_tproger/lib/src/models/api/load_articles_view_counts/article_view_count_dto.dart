import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_view_count_dto.g.dart';

@JsonSerializable(createToJson: false)
class ArticleViewCountDto extends Equatable {
  @JsonKey(name: 'post')
  final int articleId;

  final int count;

  @override
  List<Object> get props => [articleId, count];

  const ArticleViewCountDto({
    required this.articleId,
    required this.count,
  });

  factory ArticleViewCountDto.fromJson(Map<String, dynamic> json) =>
    _$ArticleViewCountDtoFromJson(json);
}
