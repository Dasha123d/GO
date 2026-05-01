import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_comment_count_dto.g.dart';

@JsonSerializable(createToJson: false)
class ArticleCommentCountDto extends Equatable {
  @JsonKey(name: 'post')
  final int articleId;

  final int count;

  @override
  List<Object> get props => [articleId, count];

  const ArticleCommentCountDto({
    required this.articleId,
    required this.count,
  });

  factory ArticleCommentCountDto.fromJson(dynamic json) =>
    _$ArticleCommentCountDtoFromJson(json as Map<String, dynamic>);
}
